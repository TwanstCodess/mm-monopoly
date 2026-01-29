import 'player.dart';
import 'tile.dart';
import 'board_theme.dart';
import 'power_up_card.dart';
import 'event_card.dart';
import 'spin_prize.dart';

/// Game mode
enum GameMode {
  passAndPlay,
  vsAI,
}

/// Overall game status
enum GameStatus {
  setup,
  inProgress,
  paused,
  finished,
}

/// Win condition types
enum WinCondition {
  lastStanding, // Bankruptcy elimination
  targetWealth, // First to $X wins
  turnLimit, // Highest net worth after N rounds
}

/// Logic phase of a turn (what decision is pending)
enum TurnLogicPhase {
  preRoll, // Waiting for player to roll
  rolled, // Dice rolled, determining movement
  tileResolution, // Processing tile effects
  awaitingDecision, // Waiting for player input (buy/auction)
  turnComplete, // Turn is done, ready for next player
}

/// Animation state (what's visually happening)
enum TurnAnimationState {
  idle,
  rollingDice,
  movingToken,
  showingDialog,
  processingEffect,
}

/// Represents the current state of the game
class GameState {
  final String id;
  final DateTime createdAt;
  DateTime updatedAt;

  final GameMode mode;
  final WinCondition winCondition;
  final int targetWealth; // For targetWealth win condition
  final int maxRounds; // For turnLimit win condition

  List<Player> players;
  List<TileData> tiles;

  int currentPlayerIndex;
  int roundNumber;

  // Separated state concerns (addressing design concern #3)
  TurnLogicPhase logicPhase;
  TurnAnimationState animationState;

  // Dice state
  int lastDiceRoll;
  int die1Value;
  int die2Value;
  int doublesCount; // Track consecutive doubles

  // For card effects
  // List<GameCard> chanceDeck;
  // List<GameCard> communityChestDeck;

  GameStatus status;
  String? winnerId;

  // Highlighted tile (for UI feedback)
  int? highlightedTileIndex;

  // Phase 3: Board theme
  BoardTheme boardTheme;

  // Phase 3: Power-up cards per player
  Map<String, List<PowerUpCard>> playerPowerUps;

  // Phase 3: Active power-up effects
  List<ActivePowerUp> activePowerUps;

  // Phase 3: Active events
  List<ActiveEvent> activeEvents;

  // Phase 3: Spin prizes held by players (from Free Parking)
  Map<String, List<SpinPrize>> playerSpinPrizes;

  // Phase 3: Turns since last event (for guaranteed event every 10 rounds)
  int turnsSinceLastEvent;

  // Phase 3: Shield active (blocks next rent payment)
  Map<String, bool> playerShields;

  // Phase 3: Double rent active (next rent collection doubled)
  Map<String, bool> playerDoubleRent;

  // Phase 3: Extra turn flag
  bool hasExtraTurn;

  // Phase 3: Dice stats for leaderboard
  int totalDiceRolls;
  int totalDiceSum;
  int doublesRolledTotal;

  // Number of dice to use (1 or 2)
  int diceCount;

  GameState({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.mode = GameMode.passAndPlay,
    this.winCondition = WinCondition.lastStanding,
    this.targetWealth = 3000,
    this.maxRounds = 30,
    required this.players,
    required this.tiles,
    this.currentPlayerIndex = 0,
    this.roundNumber = 1,
    this.logicPhase = TurnLogicPhase.preRoll,
    this.animationState = TurnAnimationState.idle,
    this.lastDiceRoll = 0,
    this.die1Value = 6,
    this.die2Value = 6,
    this.doublesCount = 0,
    this.status = GameStatus.inProgress,
    this.winnerId,
    this.highlightedTileIndex,
    BoardTheme? boardTheme,
    Map<String, List<PowerUpCard>>? playerPowerUps,
    List<ActivePowerUp>? activePowerUps,
    List<ActiveEvent>? activeEvents,
    Map<String, List<SpinPrize>>? playerSpinPrizes,
    this.turnsSinceLastEvent = 0,
    Map<String, bool>? playerShields,
    Map<String, bool>? playerDoubleRent,
    this.hasExtraTurn = false,
    this.totalDiceRolls = 0,
    this.totalDiceSum = 0,
    this.doublesRolledTotal = 0,
    this.diceCount = 2,
  })  : boardTheme = boardTheme ?? BoardThemes.classic,
        playerPowerUps = playerPowerUps ?? {},
        activePowerUps = activePowerUps ?? [],
        activeEvents = activeEvents ?? [],
        playerSpinPrizes = playerSpinPrizes ?? {},
        playerShields = playerShields ?? {},
        playerDoubleRent = playerDoubleRent ?? {};

  /// Get current player
  Player get currentPlayer => players[currentPlayerIndex];

  /// Check if game is over
  bool get isGameOver => status == GameStatus.finished;

  /// Check if it's currently rolling/moving (for button state)
  bool get isBusy =>
      animationState == TurnAnimationState.rollingDice ||
      animationState == TurnAnimationState.movingToken;

  /// Check if player can roll
  bool get canRoll =>
      logicPhase == TurnLogicPhase.preRoll &&
      animationState == TurnAnimationState.idle;

  /// Get active players (not bankrupt)
  List<Player> get activePlayers =>
      players.where((p) => p.status == PlayerStatus.active).toList();

  /// Check win conditions
  String? checkWinCondition() {
    switch (winCondition) {
      case WinCondition.lastStanding:
        final active = activePlayers;
        if (active.length == 1) {
          return active.first.id;
        }
        break;

      case WinCondition.targetWealth:
        for (final player in activePlayers) {
          if (player.netWorth >= targetWealth) {
            return player.id;
          }
        }
        break;

      case WinCondition.turnLimit:
        if (roundNumber > maxRounds) {
          // Find player with highest net worth
          final sorted = List<Player>.from(activePlayers)
            ..sort((a, b) => b.netWorth.compareTo(a.netWorth));
          if (sorted.isNotEmpty) {
            return sorted.first.id;
          }
        }
        break;
    }
    return null;
  }

  /// Move to next player
  void nextPlayer() {
    // Find next active player
    int nextIndex = (currentPlayerIndex + 1) % players.length;
    int attempts = 0;

    while (!players[nextIndex].canTakeTurn && attempts < players.length) {
      // Handle skip turns
      if (players[nextIndex].skipTurnsRemaining > 0) {
        players[nextIndex].skipTurnsRemaining--;
      }
      nextIndex = (nextIndex + 1) % players.length;
      attempts++;
    }

    // Check if we've completed a round
    if (nextIndex <= currentPlayerIndex) {
      roundNumber++;
    }

    currentPlayerIndex = nextIndex;
    logicPhase = TurnLogicPhase.preRoll;
    animationState = TurnAnimationState.idle;
    doublesCount = 0;
    updatedAt = DateTime.now();
  }

  /// Create initial game state
  factory GameState.initial({
    required List<Player> players,
    required List<TileData> tiles,
    GameMode mode = GameMode.passAndPlay,
    WinCondition winCondition = WinCondition.lastStanding,
    int startingCash = 1500,
    int diceCount = 2,
  }) {
    // Set starting cash for all players
    for (final player in players) {
      player.cash = startingCash;
    }

    return GameState(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      mode: mode,
      winCondition: winCondition,
      players: players,
      tiles: tiles,
      diceCount: diceCount,
    );
  }

  /// Create a copy with updated fields
  GameState copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    GameMode? mode,
    WinCondition? winCondition,
    int? targetWealth,
    int? maxRounds,
    List<Player>? players,
    List<TileData>? tiles,
    int? currentPlayerIndex,
    int? roundNumber,
    TurnLogicPhase? logicPhase,
    TurnAnimationState? animationState,
    int? lastDiceRoll,
    int? die1Value,
    int? die2Value,
    int? doublesCount,
    GameStatus? status,
    String? winnerId,
    int? highlightedTileIndex,
    BoardTheme? boardTheme,
    Map<String, List<PowerUpCard>>? playerPowerUps,
    List<ActivePowerUp>? activePowerUps,
    List<ActiveEvent>? activeEvents,
    Map<String, List<SpinPrize>>? playerSpinPrizes,
    int? turnsSinceLastEvent,
    Map<String, bool>? playerShields,
    Map<String, bool>? playerDoubleRent,
    bool? hasExtraTurn,
    int? totalDiceRolls,
    int? totalDiceSum,
    int? doublesRolledTotal,
    int? diceCount,
  }) {
    return GameState(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      mode: mode ?? this.mode,
      winCondition: winCondition ?? this.winCondition,
      targetWealth: targetWealth ?? this.targetWealth,
      maxRounds: maxRounds ?? this.maxRounds,
      players: players ?? this.players,
      tiles: tiles ?? this.tiles,
      currentPlayerIndex: currentPlayerIndex ?? this.currentPlayerIndex,
      roundNumber: roundNumber ?? this.roundNumber,
      logicPhase: logicPhase ?? this.logicPhase,
      animationState: animationState ?? this.animationState,
      lastDiceRoll: lastDiceRoll ?? this.lastDiceRoll,
      die1Value: die1Value ?? this.die1Value,
      die2Value: die2Value ?? this.die2Value,
      doublesCount: doublesCount ?? this.doublesCount,
      status: status ?? this.status,
      winnerId: winnerId ?? this.winnerId,
      highlightedTileIndex: highlightedTileIndex ?? this.highlightedTileIndex,
      boardTheme: boardTheme ?? this.boardTheme,
      playerPowerUps: playerPowerUps ?? this.playerPowerUps,
      activePowerUps: activePowerUps ?? this.activePowerUps,
      activeEvents: activeEvents ?? this.activeEvents,
      playerSpinPrizes: playerSpinPrizes ?? this.playerSpinPrizes,
      turnsSinceLastEvent: turnsSinceLastEvent ?? this.turnsSinceLastEvent,
      playerShields: playerShields ?? this.playerShields,
      playerDoubleRent: playerDoubleRent ?? this.playerDoubleRent,
      hasExtraTurn: hasExtraTurn ?? this.hasExtraTurn,
      totalDiceRolls: totalDiceRolls ?? this.totalDiceRolls,
      totalDiceSum: totalDiceSum ?? this.totalDiceSum,
      doublesRolledTotal: doublesRolledTotal ?? this.doublesRolledTotal,
      diceCount: diceCount ?? this.diceCount,
    );
  }

  /// Check if player has a shield active
  bool hasShield(String playerId) => playerShields[playerId] ?? false;

  /// Check if player has double rent active
  bool hasDoubleRent(String playerId) => playerDoubleRent[playerId] ?? false;

  /// Get power-up cards for a player
  List<PowerUpCard> getPowerUps(String playerId) => playerPowerUps[playerId] ?? [];

  /// Add a power-up card to a player
  void addPowerUp(String playerId, PowerUpCard card) {
    playerPowerUps[playerId] ??= [];
    playerPowerUps[playerId]!.add(card);
  }

  /// Remove a power-up card from a player
  void removePowerUp(String playerId, String cardId) {
    playerPowerUps[playerId]?.removeWhere((c) => c.id == cardId);
  }

  /// Check if there's an active event of a specific type
  bool hasActiveEvent(EventEffectType type) {
    return activeEvents.any((e) => e.event.effectType == type && !e.isExpired);
  }

  /// Get active event modifier for rent (e.g., rent strike reduces rent)
  double getRentModifier() {
    if (hasActiveEvent(EventEffectType.rentStrike)) {
      return 0.5; // 50% rent
    }
    if (hasActiveEvent(EventEffectType.marketBoom)) {
      return 1.2; // 20% more
    }
    return 1.0;
  }

  /// Get GO bonus with event modifiers
  int getGoBonus() {
    int bonus = 200;
    if (hasActiveEvent(EventEffectType.goldRush)) {
      bonus = 300;
    }
    return bonus;
  }

  /// Get property price modifier
  double getPropertyPriceModifier() {
    if (hasActiveEvent(EventEffectType.propertySale)) {
      return 0.75; // 25% off
    }
    return 1.0;
  }

  /// Should skip taxes?
  bool get isTaxHoliday => hasActiveEvent(EventEffectType.taxHoliday);

  /// Decrement active events at end of round
  void tickActiveEvents() {
    for (final event in activeEvents) {
      event.decrementRound();
    }
    activeEvents.removeWhere((e) => e.isExpired);
  }

  /// Decrement active power-ups at end of turn
  void tickActivePowerUps() {
    for (final powerUp in activePowerUps) {
      powerUp.decrementTurn();
    }
    activePowerUps.removeWhere((p) => p.isExpired);
  }
}

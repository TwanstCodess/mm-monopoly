import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../models/player.dart';
import '../models/game_state.dart';
import '../models/board_theme.dart';
import '../models/player_stats.dart';
import '../config/theme.dart';
import '../config/constants.dart';
import '../services/audio_service.dart';
import '../services/save_service.dart';
import '../services/stats_service.dart';
import '../widgets/achievements/achievement_notification.dart';
import '../widgets/board/game_board.dart';
import '../widgets/player/player_card.dart';
import '../widgets/dice/dice_widget.dart';
import '../widgets/dialogs/buy_property_dialog.dart';
import '../widgets/dialogs/rent_payment_dialog.dart';
import '../widgets/dialogs/tax_payment_dialog.dart';
import '../widgets/dialogs/game_menu_dialog.dart';
import '../widgets/dialogs/jail_dialog.dart';
import '../widgets/dialogs/property_upgrade_dialog.dart';
import '../widgets/dialogs/spin_wheel_dialog.dart';
import '../widgets/dialogs/event_dialog.dart';
import '../widgets/dialogs/ai_action_dialog.dart';
import '../widgets/dialogs/auction_dialog.dart';
import '../widgets/dialogs/trade_dialog.dart';
import '../widgets/dialogs/property_management_dialog.dart';
import '../widgets/dialogs/tile_info_dialog.dart';
import '../widgets/dialogs/card_pick_dialog.dart';
import '../widgets/dialogs/free_house_dialog.dart';
import '../widgets/dialogs/teleport_dialog.dart';
import '../widgets/cards/power_up_card_widget.dart';
import '../engine/game_engine.dart';
import '../models/tile.dart';
import '../models/spin_prize.dart';
import '../models/event_card.dart';
import '../models/power_up_card.dart';
import '../models/trade.dart';
import '../models/ai_player.dart';
import 'mini_games/memory_match_game.dart';
import 'mini_games/quick_tap_game.dart';
import 'victory_screen.dart';

/// Main game board screen
class GameBoardScreen extends StatefulWidget {
  final GameState gameState;
  final VoidCallback onQuit;
  final VoidCallback onRestart;
  final VoidCallback? onHowToPlay;
  final bool tradingEnabled;
  final bool bankEnabled;
  final bool auctionEnabled;
  final BoardTheme? boardTheme;

  const GameBoardScreen({super.key, required this.gameState, required this.onQuit, required this.onRestart, this.onHowToPlay, this.tradingEnabled = false, this.bankEnabled = false, this.auctionEnabled = false, this.boardTheme});

  @override
  State<GameBoardScreen> createState() => _GameBoardScreenState();
}

class _GameBoardScreenState extends State<GameBoardScreen> with TickerProviderStateMixin {
  late GameState gameState;
  late GameEngine engine;
  late AnimationController _diceController;
  late AnimationController _bounceController;
  late AnimationController _glowController;
  late Animation<double> _bounceAnimation;

  final Random _random = Random.secure();
  int _totalRounds = 1;
  bool _isPaused = false; // Track if game menu is open
  bool _isMusicPlaying = true; // Track music state
  bool _isProcessingTurn = false; // Prevent dice rolls while processing

  // Phase 4: AI Decision Engines per AI player
  final Map<String, AIDecisionEngine> _aiEngines = {};

  // Card picking state
  bool _waitingForCardPick = false;
  bool _isChanceCard = false;
  Player? _cardPickPlayer;
  Completer<void>? _cardPickCompleter;

  @override
  void initState() {
    super.initState();
    gameState = widget.gameState;
    engine = GameEngine(gameState);
    _initializeAnimations();
    _initializeAIEngines();
    _isMusicPlaying = AudioService.instance.musicEnabled;
  }

  void _initializeAIEngines() {
    for (final player in gameState.players) {
      if (player.isAI) {
        // Create AI engine with random personality for variety
        final personalities = AIPersonality.values;
        final personality = personalities[_random.nextInt(personalities.length)];
        _aiEngines[player.id] = AIDecisionEngine(
          config: AIConfig(difficulty: AIDifficulty.medium, personality: personality),
        );
      }
    }
  }

  @override
  void didUpdateWidget(GameBoardScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Detect when the game state has been reset (restart game)
    if (widget.gameState != oldWidget.gameState) {
      setState(() {
        gameState = widget.gameState;
        engine = GameEngine(gameState);
        _totalRounds = 1;
        _isPaused = false;
      });
    }
  }

  void _initializeAnimations() {
    _diceController = AnimationController(duration: AnimationDurations.diceRoll, vsync: this);

    _bounceController = AnimationController(duration: AnimationDurations.bounce, vsync: this);

    _bounceAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _bounceController, curve: Curves.elasticOut));

    _glowController = AnimationController(duration: AnimationDurations.glow, vsync: this)..repeat(reverse: true);
  }

  @override
  void dispose() {
    _diceController.dispose();
    _bounceController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  void _showTileInfo(TileData tile) {
    showTileInfoDialog(context: context, tile: tile);
  }

  void _toggleMusic() {
    setState(() {
      _isMusicPlaying = !_isMusicPlaying;
    });
    AudioService.instance.setMusicEnabled(_isMusicPlaying);
  }

  void _showGameMenu() {
    _isPaused = true;
    showGameMenuDialog(
      context: context,
      onClose: () {
        _isPaused = false;
        // Resume AI if it's their turn
        if (gameState.currentPlayer.isAI && gameState.canRoll) {
          Future.delayed(const Duration(milliseconds: 500), () {
            if (mounted && !_isPaused && gameState.canRoll) {
              _rollDice();
            }
          });
        }
      },
      onRestart: () {
        _isPaused = false;
        widget.onRestart();
      },
      onQuit: () {
        _isPaused = false;
        widget.onQuit();
      },
      onRules: widget.onHowToPlay,
      onSave: _saveGame,
      onLoad: SaveService.instance.hasSavedGame() ? _loadGame : null,
    );
  }

  Future<void> _saveGame() async {
    final success = await SaveService.instance.saveGame(gameState);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                success ? Icons.check_circle : Icons.error,
                color: Colors.white,
              ),
              const SizedBox(width: 12),
              Text(
                success ? 'Game saved successfully!' : 'Failed to save game',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          backgroundColor: success ? const Color(0xFF4CAF50) : const Color(0xFFFF5252),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _loadGame() async {
    final loadedState = await SaveService.instance.loadGame();

    if (loadedState != null && mounted) {
      setState(() {
        gameState = loadedState;
        engine = GameEngine(gameState);
        _isPaused = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 12),
              Text(
                'Game loaded! Round ${gameState.roundNumber}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          backgroundColor: const Color(0xFF2196F3),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          duration: const Duration(seconds: 2),
        ),
      );

      // Delete the save after successful load
      await SaveService.instance.deleteSave();

      // If it's AI turn, trigger their action
      if (gameState.currentPlayer.isAI && gameState.canRoll) {
        Future.delayed(const Duration(milliseconds: 1000), () {
          if (mounted && !_isPaused && gameState.canRoll) {
            _rollDice();
          }
        });
      }
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.error, color: Colors.white),
              SizedBox(width: 12),
              Text(
                'Failed to load game',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          backgroundColor: Color(0xFFFF5252),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(16),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.boardTheme;
    final backgroundGradient = theme != null
        ? LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.boardColor,
              theme.centerBackground,
            ],
          )
        : AppTheme.backgroundGradient;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: backgroundGradient),
        child: SafeArea(
          child: Stack(
            children: [
              OrientationBuilder(
                builder: (context, orientation) {
                  final isPortrait = orientation == Orientation.portrait;
                  return isPortrait ? _buildPortraitLayout() : _buildLandscapeLayout();
                },
              ),
              // Power-up cards button (if has cards) - top left overlay
              if (!gameState.currentPlayer.isAI && gameState.getPowerUps(gameState.currentPlayer.id).isNotEmpty)
                Positioned(
                  top: 8,
                  left: 8,
                  child: _buildActionButton(icon: Icons.style, label: '${gameState.getPowerUps(gameState.currentPlayer.id).length}', color: Colors.amber, onTap: _showPowerUpHand),
                ),
              // Phase 3: Active event indicators
              if (gameState.activeEvents.isNotEmpty)
                Positioned(
                  bottom: 8,
                  left: 8,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: gameState.activeEvents
                        .where((e) => !e.isExpired)
                        .map(
                          (event) => Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: ActiveEventIndicator(activeEvent: event),
                          ),
                        )
                        .toList(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLandscapeLayout() {
    final activePlayers = gameState.players.where((p) => p.status == PlayerStatus.active).toList();
    final halfCount = (activePlayers.length / 2).ceil();

    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate board size to maximize it (use full height)
        final boardSize = constraints.maxHeight - 16; // 8px padding each side
        final remainingWidth = constraints.maxWidth - boardSize;
        final playerPanelWidth = remainingWidth / 2;

        return Row(
          children: [
            // Left player panel - fixed width based on remaining space
            if (activePlayers.isNotEmpty) SizedBox(width: playerPanelWidth, child: _buildVerticalPlayerPanel(activePlayers.take(halfCount).toList())),
            // Game board - maximized square
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: SizedBox(
                width: boardSize,
                height: boardSize,
                child: GameBoard(
                  players: gameState.players,
                  currentPlayerIndex: gameState.currentPlayerIndex,
                  highlightedTile: gameState.highlightedTileIndex,
                  bounceAnimation: _bounceAnimation,
                  glowController: _glowController,
                  tiles: gameState.tiles,
                  boardTheme: widget.boardTheme,
                  centerControls: _buildCenterControls(),
                  onMenuTap: _showGameMenu,
                  onTradeTap: widget.tradingEnabled ? _showTradeDialog : null,
                  onBankTap: widget.bankEnabled ? _showMortgageDialog : null,
                  showActionButtons: !gameState.currentPlayer.isAI && (widget.tradingEnabled || widget.bankEnabled),
                  onTileTap: _showTileInfo,
                  isChanceHighlighted: _waitingForCardPick && _isChanceCard,
                  isChestHighlighted: _waitingForCardPick && !_isChanceCard,
                  onChanceTap: () => _onCardDeckTap(true),
                  onChestTap: () => _onCardDeckTap(false),
                  onMusicToggle: _toggleMusic,
                  isMusicPlaying: _isMusicPlaying,
                ),
              ),
            ),
            // Right player panel - fixed width based on remaining space
            if (activePlayers.length > halfCount) SizedBox(width: playerPanelWidth, child: _buildVerticalPlayerPanel(activePlayers.skip(halfCount).toList())),
          ],
        );
      },
    );
  }

  Widget _buildPortraitLayout() {
    final activePlayers = gameState.players.where((p) => p.status == PlayerStatus.active).toList();
    final halfCount = (activePlayers.length / 2).ceil();

    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate board size to maximize it (use full width)
        final boardSize = constraints.maxWidth - 16; // 8px padding each side
        final remainingHeight = constraints.maxHeight - boardSize;
        final playerPanelHeight = remainingHeight / 2;

        return Column(
          children: [
            // Top player panel - fixed height based on remaining space
            if (activePlayers.isNotEmpty) SizedBox(height: playerPanelHeight, child: _buildHorizontalPlayerPanel(activePlayers.take(halfCount).toList())),
            // Game board - maximized square
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: SizedBox(
                width: boardSize,
                height: boardSize,
                child: GameBoard(
                  players: gameState.players,
                  currentPlayerIndex: gameState.currentPlayerIndex,
                  highlightedTile: gameState.highlightedTileIndex,
                  bounceAnimation: _bounceAnimation,
                  glowController: _glowController,
                  tiles: gameState.tiles,
                  boardTheme: widget.boardTheme,
                  centerControls: _buildCenterControls(),
                  onMenuTap: _showGameMenu,
                  onTradeTap: widget.tradingEnabled ? _showTradeDialog : null,
                  onBankTap: widget.bankEnabled ? _showMortgageDialog : null,
                  showActionButtons: !gameState.currentPlayer.isAI && (widget.tradingEnabled || widget.bankEnabled),
                  onTileTap: _showTileInfo,
                  isChanceHighlighted: _waitingForCardPick && _isChanceCard,
                  isChestHighlighted: _waitingForCardPick && !_isChanceCard,
                  onChanceTap: () => _onCardDeckTap(true),
                  onChestTap: () => _onCardDeckTap(false),
                  onMusicToggle: _toggleMusic,
                  isMusicPlaying: _isMusicPlaying,
                ),
              ),
            ),
            // Bottom player panel - fixed height based on remaining space
            if (activePlayers.length > halfCount) SizedBox(height: playerPanelHeight, child: _buildHorizontalPlayerPanel(activePlayers.skip(halfCount).toList())),
          ],
        );
      },
    );
  }

  Widget _buildVerticalPlayerPanel(List<Player> players) {
    return Container(
      margin: const EdgeInsets.all(8),
      child: Column(
        children: players.map((player) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: PlayerCard(
                player: player,
                isCurrentPlayer: player.id == gameState.currentPlayer.id,
                tiles: gameState.tiles,
                gameState: gameState,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildHorizontalPlayerPanel(List<Player> players) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: players.map((player) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: PlayerCardCompact(player: player, isCurrentPlayer: player.id == gameState.currentPlayer.id, tiles: gameState.tiles),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCenterControls() {
    // Only allow roll if game state allows AND we're not processing a turn
    final canRoll = gameState.canRoll && !_isProcessingTurn;

    return CenterControls(
      die1: gameState.die1Value,
      die2: gameState.die2Value,
      isRolling: gameState.animationState == TurnAnimationState.rollingDice,
      isMoving: gameState.animationState == TurnAnimationState.movingToken,
      onRoll: canRoll ? _rollDice : null,
      diceController: _diceController,
      glowController: _glowController,
      diceCount: gameState.diceCount,
    );
  }

  Future<void> _rollDice() async {
    // Prevent double-tap exploits
    if (_isProcessingTurn) return;

    // Lock turn processing
    setState(() {
      _isProcessingTurn = true;
      gameState = gameState.copyWith(animationState: TurnAnimationState.rollingDice);
    });
    _diceController.forward(from: 0);
    
    // Play dice roll sound
    AudioService.instance.onDiceRoll();

    // Generate dice values
    final die1 = _random.nextInt(6) + 1;
    final die2 = _random.nextInt(6) + 1;
    final roll = die1 + die2;
    final isDoubles = die1 == die2;

    await Future.delayed(AnimationDurations.diceRoll);
    
    // Play dice land sound
    AudioService.instance.onDiceLand();

    // Phase 3: Track dice stats
    final newTotalRolls = gameState.totalDiceRolls + 1;
    final newTotalSum = gameState.totalDiceSum + roll;
    final newDoublesTotal = gameState.doublesRolledTotal + (isDoubles ? 1 : 0);

    // Update dice values and start moving
    setState(() {
      gameState = gameState.copyWith(die1Value: die1, die2Value: die2, lastDiceRoll: roll, animationState: TurnAnimationState.movingToken, logicPhase: TurnLogicPhase.rolled, totalDiceRolls: newTotalRolls, totalDiceSum: newTotalSum, doublesRolledTotal: newDoublesTotal);
    });

    // Move current player tile by tile
    final player = gameState.currentPlayer;
    final startPosition = player.position;
    final endPosition = (startPosition + roll) % 40;

    for (int i = 0; i < roll; i++) {
      await Future.delayed(AnimationDurations.tokenHop);
      
      // Play token step sound
      AudioService.instance.onTokenStep();
      
      setState(() {
        player.position = (player.position + 1) % 40;
        // Check for passing GO (Phase 3: use event-modified bonus)
        if (player.position == 0 && i < roll - 1) {
          player.cash += gameState.getGoBonus();
          // Play pass GO sound
          AudioService.instance.onPassGo();
          // Check for mid-game achievements (like Cash King)
          _checkMidGameAchievements(player);
        }
      });
      _bounceController.forward(from: 0);
    }
    
    // Play token land sound
    AudioService.instance.onTokenLand();

    // Highlight landing tile
    setState(() {
      gameState = gameState.copyWith(highlightedTileIndex: endPosition, animationState: TurnAnimationState.idle, logicPhase: TurnLogicPhase.tileResolution);
    });

    // Wait for the bounce animation to complete before showing dialogs
    await Future.delayed(const Duration(milliseconds: 600));

    // Resolve the tile landing
    await _resolveTileLanding(player, endPosition);
  }

  Future<void> _resolveTileLanding(Player player, int tileIndex) async {
    final result = engine.resolveTileLanding(player, tileIndex);

    switch (result.actionType) {
      case TileActionType.buyProperty:
        await _handleBuyOption(player, result.tile!);
        break;

      case TileActionType.payRent:
        await _handlePayRent(player, result.tile!, result.amount!, result.targetPlayerId!);
        break;

      case TileActionType.payTax:
        await _handlePayTax(player, result.tile!.name, result.amount!);
        break;

      case TileActionType.goToJail:
        _handleGoToJail(player);
        break;

      case TileActionType.drawCard:
        await _handleDrawCard(player, result.tile!);
        break;

      case TileActionType.upgradeProperty:
        await _handleUpgradeOption(player, result.tile! as PropertyTileData);
        break;

      case TileActionType.spinWheel:
        await _handleSpinWheel(player);
        break;

      case TileActionType.miniGame:
        await _handleMiniGame(player);
        break;

      case TileActionType.nothing:
      case TileActionType.collectGo:
        // Nothing happens on GO, Free Parking, Jail (visiting), etc.
        break;
    }

    // Check win condition
    if (_checkWinCondition()) {
      return;
    }

    // End turn
    await Future.delayed(const Duration(milliseconds: 500));
    _endTurn();
  }

  // Show centered AI action notification popup (kid-friendly)
  Future<void> _showAIActionNotification(String playerName, String message, IconData icon, Color color) async {
    if (!mounted) return;
    await showAIActionDialog(context: context, playerName: playerName, message: message, icon: icon, color: color);
  }

  Future<void> _handleBuyOption(Player player, TileData tile) async {
    // AI automatically decides whether to buy using enhanced AI engine
    if (player.isAI) {
      await Future.delayed(const Duration(milliseconds: 300));

      final aiEngine = _aiEngines[player.id];
      final shouldBuy = aiEngine?.shouldBuyProperty(player, tile, gameState) ?? _defaultAIShouldBuy(player, tile);

      if (shouldBuy) {
        int? price;
        if (tile is PropertyTileData)
          price = tile.price;
        else if (tile is RailroadTileData)
          price = tile.price;
        else if (tile is UtilityTileData)
          price = tile.price;

        await _showAIActionNotification(player.name, 'Bought ${tile.name} for \$$price!', Icons.home, Colors.green);
        if (engine.buyProperty(player, tile)) {
          AudioService.instance.onBuyProperty();
          setState(() {});
        }
      } else {
        // AI declined - start auction for all players
        await _startAuction(tile);
      }
      return;
    }

    // Human player gets dialog
    await showBuyPropertyDialog(
      context: context,
      tile: tile,
      playerCash: player.cash,
      onBuy: () {
        if (engine.buyProperty(player, tile)) {
          AudioService.instance.onBuyProperty();
          setState(() {});
        }
      },
      onSkip: () async {
        // Player chose not to buy - start auction
        await _startAuction(tile);
      },
    );
  }

  bool _defaultAIShouldBuy(Player player, TileData tile) {
    int? price;
    if (tile is PropertyTileData)
      price = tile.price;
    else if (tile is RailroadTileData)
      price = tile.price;
    else if (tile is UtilityTileData)
      price = tile.price;
    return price != null && player.cash >= price + 100;
  }

  Future<void> _startAuction(TileData tile) async {
    if (!mounted) return;
    
    // Skip auction if disabled - property stays unowned
    if (!widget.auctionEnabled) return;

    final activePlayers = gameState.players.where((p) => p.status == PlayerStatus.active).toList();

    if (activePlayers.length < 2) return;

    await showAuctionDialog(
      context: context,
      property: tile,
      participants: activePlayers,
      onAuctionComplete: (winner, amount) {
        // Winner pays and gets property
        winner.cash -= amount;
        if (tile is PropertyTileData) {
          tile.ownerId = winner.id;
          winner.propertyIds.add(tile.index.toString());
        } else if (tile is RailroadTileData) {
          tile.ownerId = winner.id;
          winner.propertyIds.add(tile.index.toString());
        } else if (tile is UtilityTileData) {
          tile.ownerId = winner.id;
          winner.propertyIds.add(tile.index.toString());
        }
        setState(() {});
      },
      onNoWinner: () {
        // Property goes back to bank (no change needed)
      },
    );
  }

  Future<void> _handleUpgradeOption(Player player, PropertyTileData property) async {
    // AI automatically decides whether to upgrade using enhanced AI engine
    if (player.isAI) {
      await Future.delayed(const Duration(milliseconds: 300));

      final aiEngine = _aiEngines[player.id];
      final shouldUpgrade = aiEngine?.shouldUpgradeProperty(player, property, gameState) ?? (player.cash >= property.upgradeCost + 200);

      if (shouldUpgrade) {
        final levelName = property.upgradeLevel < 4 ? 'house' : 'hotel';
        await _showAIActionNotification(player.name, 'Built a $levelName on ${property.name}!', Icons.construction, Colors.green);
        if (engine.upgradeProperty(player, property)) {
          AudioService.instance.onUpgrade();
          setState(() {});
        }
      }
      return;
    }

    // Human player gets dialog
    await showPropertyUpgradeDialog(
      context: context,
      property: property,
      playerCash: player.cash,
      onUpgrade: () {
        if (engine.upgradeProperty(player, property)) {
          AudioService.instance.onUpgrade();
          setState(() {});
        }
      },
      onSkip: () {
        // Player chose not to upgrade
      },
    );
  }

  Future<void> _handlePayRent(Player player, TileData tile, int amount, String ownerId) async {
    final owner = gameState.players.firstWhere((p) => p.id == ownerId);
    final isBankruptcy = player.cash < amount;

    // Determine rent type and additional info for display
    RentType rentType = RentType.property;
    int? diceRoll;
    int? ownedCount;

    if (tile is UtilityTileData) {
      rentType = RentType.utility;
      diceRoll = gameState.lastDiceRoll;
      ownedCount = gameState.tiles
          .whereType<UtilityTileData>()
          .where((u) => u.ownerId == ownerId)
          .length;
    } else if (tile is RailroadTileData) {
      rentType = RentType.railroad;
      ownedCount = gameState.tiles
          .whereType<RailroadTileData>()
          .where((r) => r.ownerId == ownerId)
          .length;
    }

    // AI automatically pays rent with notification
    if (player.isAI) {
      await _showAIActionNotification(player.name, 'Paid \$$amount rent to ${owner.name}', Icons.payments, Colors.red);
      AudioService.instance.onPayMoney();
      final result = engine.payRent(player, ownerId, amount);
      if (!result.bankruptcy) {
        AudioService.instance.onCollectMoney(); // Owner collects
      }
      setState(() {
        if (result.bankruptcy) {
          AudioService.instance.onDefeat();
          player.status = PlayerStatus.bankrupt;
          // Transfer all properties to owner
          for (final propId in player.propertyIds) {
            owner.propertyIds.add(propId);
          }
          player.propertyIds.clear();
        }
      });
      return;
    }

    // Human player gets dialog
    await showRentPaymentDialog(
      context: context,
      propertyName: tile.name,
      amount: amount,
      owner: owner,
      payer: player,
      isBankruptcy: isBankruptcy,
      rentType: rentType,
      diceRoll: diceRoll,
      ownedCount: ownedCount,
      onConfirm: () {
        AudioService.instance.onPayMoney();
        final result = engine.payRent(player, ownerId, amount);
        setState(() {
          if (result.bankruptcy) {
            AudioService.instance.onDefeat();
            player.status = PlayerStatus.bankrupt;
            // Transfer all properties to owner
            for (final propId in player.propertyIds) {
              owner.propertyIds.add(propId);
            }
            player.propertyIds.clear();
          } else {
            AudioService.instance.onCollectMoney(); // Owner collects
          }
        });
      },
    );
  }

  Future<void> _handlePayTax(Player player, String taxName, int amount) async {
    final isBankruptcy = player.cash < amount;

    // AI automatically pays tax with notification
    if (player.isAI) {
      await _showAIActionNotification(player.name, 'Paid \$$amount $taxName', Icons.account_balance, Colors.amber.shade700);
      AudioService.instance.onPayMoney();
      final result = engine.payTax(player, amount);
      setState(() {
        if (result.bankruptcy) {
          AudioService.instance.onDefeat();
          player.status = PlayerStatus.bankrupt;
          player.propertyIds.clear();
        }
      });
      return;
    }

    // Human player gets dialog
    await showTaxPaymentDialog(
      context: context,
      taxName: taxName,
      amount: amount,
      playerCash: player.cash,
      isBankruptcy: isBankruptcy,
      onConfirm: () {
        AudioService.instance.onPayMoney();
        final result = engine.payTax(player, amount);
        setState(() {
          if (result.bankruptcy) {
            AudioService.instance.onDefeat();
            player.status = PlayerStatus.bankrupt;
            player.propertyIds.clear();
          }
        });
      },
    );
  }

  Future<void> _handleGoToJail(Player player) async {
    AudioService.instance.onJail();
    engine.sendToJail(player);
    setState(() {});

    if (!mounted) return;

    // Show notification for both AI and human players
    if (player.isAI) {
      await _showAIActionNotification(player.name, 'Going to jail!', Icons.gavel, Colors.grey.shade700);
    } else {
      // Show a brief dialog for human players so they know what happened
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 300),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF2D2D44),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.orange, width: 2),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('🚔', style: TextStyle(fontSize: 64)),
                const SizedBox(height: 16),
                const Text(
                  'Go to Jail!',
                  style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'You landed on Go to Jail!\nGo directly to jail, do not pass GO.',
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('OK', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  // ==========================================================================
  // Phase 3: Spin Wheel Handler
  // ==========================================================================
  Future<void> _handleSpinWheel(Player player) async {
    // AI gets automatic random prize with notification
    if (player.isAI) {
      AudioService.instance.onSpinWheel();
      final prize = SpinPrizes.getRandomPrize();
      final prizeText = prize.value != null ? '\$${prize.value}' : prize.name;
      AudioService.instance.onSpinResult();
      await _showAIActionNotification(player.name, 'Spun the wheel and won $prizeText!', Icons.casino, Colors.purple);
      await _applySpinPrizeWithUI(player, prize);
      setState(() {});
      return;
    }

    // Human player gets spin wheel dialog
    if (!mounted) return;

    await showSpinWheelDialog(
      context: context,
      playerName: player.name,
      onPrizeWon: (prize) async {
        await _applySpinPrizeWithUI(player, prize);
        setState(() {});
      },
    );
  }

  /// Apply spin prize with UI dialogs for interactive prizes (Free House, Teleport)
  Future<void> _applySpinPrizeWithUI(Player player, SpinPrize prize) async {
    switch (prize.type) {
      case SpinPrizeType.cash:
      case SpinPrizeType.jackpot:
        player.cash += prize.value ?? 0;
        break;

      case SpinPrizeType.freeHouse:
        // Show property selection dialog for human players
        if (!player.isAI && mounted) {
          // Get all upgradable properties owned by the player
          final ownedProperties = gameState.tiles.whereType<PropertyTileData>().where((p) => p.ownerId == player.id && p.canUpgrade).toList();

          if (ownedProperties.isNotEmpty) {
            await showFreeHouseDialog(
              context: context,
              properties: ownedProperties,
              onPropertySelected: (property) {
                property.upgradeLevel++;
                setState(() {});
              },
            );
          } else {
            // Store for later if no properties available
            gameState.playerSpinPrizes[player.id] ??= [];
            gameState.playerSpinPrizes[player.id]!.add(prize);
          }
        } else {
          // AI: automatically upgrade first available property
          final ownedProperties = gameState.tiles.whereType<PropertyTileData>().where((p) => p.ownerId == player.id && p.canUpgrade).toList();
          if (ownedProperties.isNotEmpty) {
            ownedProperties.first.upgradeLevel++;
          }
        }
        break;

      case SpinPrizeType.doubleRent:
        gameState.playerDoubleRent[player.id] = true;
        break;

      case SpinPrizeType.shield:
        gameState.playerShields[player.id] = true;
        break;

      case SpinPrizeType.teleport:
        // Show teleport dialog for human players
        if (!player.isAI && mounted) {
          await showTeleportDialog(
            context: context,
            tiles: gameState.tiles,
            currentPosition: player.position,
            onTileSelected: (tileIndex) {
              player.position = tileIndex;
              setState(() {});
            },
          );
        } else {
          // AI: teleport to a random unowned property if available
          final unownedProperties = gameState.tiles.whereType<PropertyTileData>().where((p) => p.ownerId == null).toList();
          if (unownedProperties.isNotEmpty) {
            final randomProperty = unownedProperties[_random.nextInt(unownedProperties.length)];
            player.position = randomProperty.index;
          }
        }
        break;

      case SpinPrizeType.extraTurn:
        gameState.hasExtraTurn = true;
        break;

      case SpinPrizeType.rentDiscount:
        gameState.activePowerUps.add(ActivePowerUp(card: PowerUpCards.rentReducer.createInstance(), playerId: player.id, remainingTurns: 1));
        break;
    }
  }

  // ==========================================================================
  // Phase 3: Mini-Game Handler (on Chance/Community Chest)
  // ==========================================================================
  Future<void> _handleMiniGame(Player player) async {
    // AI doesn't play mini-games, just gets standard card effect
    if (player.isAI) {
      // Give AI a random power-up card instead
      awardPowerUpCard(player, gameState);
      setState(() {});
      return;
    }

    // 50% chance for mini-game, 50% chance for standard card
    final playMiniGame = _random.nextBool();

    if (!playMiniGame || !mounted) {
      // Standard card draw
      await _handleDrawCard(player, gameState.tiles[player.position]);
      return;
    }

    // Choose random mini-game
    final isMemorayMatch = _random.nextBool();
    int earnedScore = 0;

    if (isMemorayMatch) {
      // Memory Match Game
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => MemoryMatchGame(
            onComplete: () => Navigator.pop(context),
            onScoreEarned: (score) {
              earnedScore = score;
            },
          ),
        ),
      );
    } else {
      // Quick Tap Game
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => QuickTapGame(
            onComplete: () => Navigator.pop(context),
            onScoreEarned: (score) {
              earnedScore = score;
            },
          ),
        ),
      );
    }

    // Award prize based on score
    if (earnedScore > 0) {
      player.cash += earnedScore;
      awardPowerUpCard(player, gameState, guaranteeRare: earnedScore >= 100);
      setState(() {});
    }
  }

  // ==========================================================================
  // Phase 3: Event Trigger Check
  // ==========================================================================
  void _checkEventTrigger() {
    gameState.turnsSinceLastEvent++;

    // 10% chance each round, guaranteed every 10 rounds
    final shouldTrigger = EventCards.shouldTriggerEvent(_totalRounds) || gameState.turnsSinceLastEvent >= 10;

    if (shouldTrigger) {
      gameState.turnsSinceLastEvent = 0;
      final event = EventCards.getRandomEvent();

      // Apply event effect
      applyEventEffect(event, gameState);

      // Show event dialog for human players
      if (!gameState.currentPlayer.isAI && mounted) {
        Future.delayed(const Duration(milliseconds: 300), () {
          if (mounted) {
            showEventDialog(context: context, event: event, onDismiss: () {});
          }
        });
      }

      setState(() {});
    }
  }

  // ==========================================================================
  // Phase 3: Power-Up Card Usage
  // ==========================================================================
  void _usePowerUpCard(PowerUpCard card) {
    final player = gameState.currentPlayer;
    applyPowerUpCard(player, card, gameState);
    setState(() {});
  }

  // ==========================================================================
  // Phase 3: Show Power-Up Hand (for human players)
  // ==========================================================================
  void _showPowerUpHand() {
    final player = gameState.currentPlayer;
    final cards = gameState.getPowerUps(player.id);

    if (cards.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No power-up cards! Win mini-games to collect them.'), duration: Duration(seconds: 2)));
      return;
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 280,
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Your Power-Up Cards',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: PowerUpHand(
                cards: cards,
                onCardTap: (card) {
                  Navigator.pop(context);
                  _usePowerUpCard(card);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Card definitions with text and effects - Fun kid-friendly wording!
  static const List<Map<String, String>> _chanceCards = [
    // Classic cards with fun twists
    {'text': 'Bank says "Here\'s some extra cash!"', 'effect': '+\$50', 'action': 'collect50'},
    {'text': 'Oops! Caught going too fast on your scooter!', 'effect': '-\$15', 'action': 'pay15'},
    {'text': 'Race to GO! Zoom zoom!', 'effect': 'Collect \$200', 'action': 'advanceGo'},
    {'text': 'Wrong turn! Go back 3 spaces. Oopsie!', 'effect': 'Move back', 'action': 'back3'},
    {'text': 'Your piggy bank is overflowing!', 'effect': '+\$150', 'action': 'collect150'},
    // Fun new cards
    {'text': 'Found \$25 in your old jeans pocket!', 'effect': '+\$25', 'action': 'collect25'},
    {'text': 'Won the school talent show! Star power!', 'effect': '+\$100', 'action': 'collect100'},
    {'text': 'Your lemonade stand was a HUGE hit!', 'effect': '+\$50', 'action': 'collect50'},
    {'text': 'Pizza party for everyone! Worth every penny!', 'effect': '-\$50', 'action': 'pay50'},
    {'text': 'Dug up pirate treasure in the backyard!', 'effect': '+\$150', 'action': 'collect150'},
    {'text': 'Your cat video went VIRAL! Fame and fortune!', 'effect': '+\$200', 'action': 'collect200'},
    {'text': 'Garage sale champion! Sold all your old toys!', 'effect': '+\$25', 'action': 'collect25'},
    {'text': 'Spelling bee winner! B-R-I-L-L-I-A-N-T!', 'effect': '+\$100', 'action': 'collect100'},
    {'text': 'Baseball went through the neighbor\'s window...', 'effect': '-\$50', 'action': 'pay50'},
    {'text': 'Grandma\'s surprise birthday money arrived!', 'effect': '+\$100', 'action': 'collect100'},
    {'text': 'Your goldfish won "Best Pet" at the fair!', 'effect': '+\$150', 'action': 'collect150'},
    {'text': 'Ice cream truck! You HAVE to get some!', 'effect': '-\$15', 'action': 'pay15'},
    {'text': 'Found a four-leaf clover... and \$100!', 'effect': '+\$100', 'action': 'collect100'},
    {'text': 'Your cookies sold out at the bake sale!', 'effect': '+\$50', 'action': 'collect50'},
    {'text': 'Video game tournament CHAMPION!', 'effect': '+\$200', 'action': 'collect200'},
  ];

  static const List<Map<String, String>> _chestCards = [
    // Classic cards with fun twists
    {'text': 'Your savings account grew! Cha-ching!', 'effect': '+\$100', 'action': 'collect100'},
    {'text': 'Uh oh, time for a check-up at the doctor.', 'effect': '-\$50', 'action': 'pay50'},
    {'text': 'HAPPY BIRTHDAY TO YOU! Party time!', 'effect': '+\$25', 'action': 'collect25'},
    {'text': 'The bank made a mistake... in YOUR favor!', 'effect': '+\$200', 'action': 'collect200'},
    {'text': 'New school supplies needed!', 'effect': '-\$50', 'action': 'pay50'},
    // Fun new cards
    {'text': 'Great-aunt Mildred left you her fortune!', 'effect': '+\$100', 'action': 'collect100'},
    {'text': 'Summer vacation fund is ready!', 'effect': '+\$100', 'action': 'collect100'},
    {'text': 'Helped the neighbor rake leaves! Good job!', 'effect': '+\$25', 'action': 'collect25'},
    {'text': 'Won "Best Smile" at picture day!', 'effect': '+\$50', 'action': 'collect50'},
    {'text': 'Tax refund time! Money back!', 'effect': '+\$100', 'action': 'collect100'},
    {'text': 'Your art project sold at the school auction!', 'effect': '+\$150', 'action': 'collect150'},
    {'text': 'Dog walking business is booming!', 'effect': '+\$50', 'action': 'collect50'},
    {'text': 'Mom found your report card... A+ means \$\$!', 'effect': '+\$100', 'action': 'collect100'},
    {'text': 'Oops! Forgot to return library books!', 'effect': '-\$15', 'action': 'pay15'},
    {'text': 'Anonymous donor sends you a gift!', 'effect': '+\$200', 'action': 'collect200'},
    {'text': 'Your team won the science fair!', 'effect': '+\$100', 'action': 'collect100'},
    {'text': 'Tooth fairy came... for ALL your baby teeth!', 'effect': '+\$50', 'action': 'collect50'},
    {'text': 'Recycling paid off! Save the planet AND get \$!', 'effect': '+\$25', 'action': 'collect25'},
    {'text': 'Your handmade bracelet sold on Etsy!', 'effect': '+\$50', 'action': 'collect50'},
    {'text': 'Community hero award! You\'re awesome!', 'effect': '+\$150', 'action': 'collect150'},
  ];

  void _applyCardEffect(Player player, String action) {
    setState(() {
      switch (action) {
        case 'collect25':
          player.cash += 25;
          break;
        case 'collect50':
          player.cash += 50;
          break;
        case 'collect100':
          player.cash += 100;
          break;
        case 'collect150':
          player.cash += 150;
          break;
        case 'collect200':
          player.cash += 200;
          break;
        case 'pay15':
          player.cash -= 15;
          break;
        case 'pay50':
          player.cash -= 50;
          break;
        case 'advanceGo':
          player.position = 0;
          player.cash += 200;
          break;
        case 'back3':
          player.position = (player.position - 3 + 40) % 40;
          break;
      }
    });
  }

  void _onCardDeckTap(bool isChance) {
    if (!_waitingForCardPick) return;
    if (isChance != _isChanceCard) return; // Wrong deck tapped
    if (_cardPickPlayer == null) return;

    final cards = isChance ? _chanceCards : _chestCards;

    // Shuffle and pick 5 random cards for the player to choose from
    final shuffledCards = List<Map<String, String>>.from(cards)..shuffle(_random);
    final pickableCards = shuffledCards.take(5).map((c) => PickableCard(text: c['text']!, effect: c['effect']!, action: c['action']!)).toList();

    AudioService.instance.onDrawCard();
    showCardPickDialog(
      context: context,
      isChance: isChance,
      cards: pickableCards,
      onCardPicked: (pickedCard) {
        AudioService.instance.onFlipCard();
        _applyCardEffect(_cardPickPlayer!, pickedCard.action);

        // Reset card picking state
        setState(() {
          _waitingForCardPick = false;
          _isChanceCard = false;
          _cardPickPlayer = null;
        });

        // Complete the future to continue game flow
        _cardPickCompleter?.complete();
        _cardPickCompleter = null;
      },
    );
  }

  Future<void> _handleDrawCard(Player player, TileData tile) async {
    final isChance = tile.type == TileType.chance;

    final cards = isChance ? _chanceCards : _chestCards;

    // AI automatically handles card effect with notification
    if (player.isAI) {
      AudioService.instance.onDrawCard();
      final card = cards[_random.nextInt(cards.length)];
      AudioService.instance.onFlipCard();
      await _showAIActionNotification(player.name, '${card['text']}\n${card['effect']}', isChance ? Icons.help_outline : Icons.inventory_2, isChance ? Colors.orange : Colors.blue);
      _applyCardEffect(player, card['action']!);
      return;
    }

    // Human player - highlight the deck and wait for them to tap it
    _cardPickCompleter = Completer<void>();
    setState(() {
      _waitingForCardPick = true;
      _isChanceCard = isChance;
      _cardPickPlayer = player;
    });

    // Wait for the card to be picked
    await _cardPickCompleter!.future;
  }

  bool _checkWinCondition() {
    final activePlayers = gameState.players.where((p) => p.status == PlayerStatus.active).toList();

    if (activePlayers.length == 1) {
      _showGameOverDialog(activePlayers.first);
      return true;
    }
    return false;
  }

  /// Check for mid-game achievements (like Cash King)
  void _checkMidGameAchievements(Player player) async {
    // Skip AI players
    if (player.isAI) return;

    final stats = StatsService.instance.getOrCreateStats(
      player.name,
      avatarId: player.avatar?.id,
    );

    // Check for Cash King (have $5000+ at once)
    if (player.cash >= 5000 && stats.highestCash < player.cash) {
      stats.highestCash = player.cash;

      // Check if this unlocks any achievements
      final achievements = Achievements.checkNewAchievements(stats);

      // Show notifications for newly unlocked achievements
      if (achievements.isNotEmpty && mounted) {
        for (final achievement in achievements) {
          if (!mounted) break;
          AchievementNotificationManager.show(context, achievement);
          await Future.delayed(const Duration(milliseconds: 3500));
        }
      }
    }
  }

  void _showGameOverDialog(Player winner) async {
    // Record stats and check for achievements
    final achievements = await StatsService.instance.recordGameResult(
      players: gameState.players,
      winner: winner,
      gameState: gameState,
      totalRounds: _totalRounds,
    );

    // Show achievement notifications
    if (achievements.isNotEmpty && mounted) {
      for (final achievement in achievements) {
        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted) {
          AchievementNotificationManager.show(context, achievement);
        }
        // Wait for notification to be visible before showing next
        await Future.delayed(const Duration(milliseconds: 3500));
      }
    }

    // Phase 3: Use Victory Screen instead of simple dialog
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => VictoryScreen(
            winner: winner,
            allPlayers: gameState.players,
            gameTurns: _totalRounds,
            onPlayAgain: widget.onRestart,
            onGoHome: widget.onQuit,
          ),
        ),
      );
    }
  }

  void _endTurn() {
    // Phase 3: Check for extra turn
    if (gameState.hasExtraTurn) {
      setState(() {
        _isProcessingTurn = false; // Unlock for next roll
        gameState = gameState.copyWith(hasExtraTurn: false, highlightedTileIndex: null, logicPhase: TurnLogicPhase.preRoll);
      });

      // Continue with same player
      if (gameState.currentPlayer.isAI) {
        Future.delayed(const Duration(milliseconds: 1500), () {
          if (mounted && !_isPaused && gameState.canRoll && !_isProcessingTurn) {
            _rollDice();
          }
        });
      }
      return;
    }

    setState(() {
      // Find next active player
      int nextIndex = gameState.currentPlayerIndex;
      bool crossedRound = false;
      do {
        nextIndex = (nextIndex + 1) % gameState.players.length;
        if (nextIndex == 0) {
          _totalRounds++;
          crossedRound = true;
          // Tick active events at round end
          gameState.tickActiveEvents();
        }
      } while (gameState.players[nextIndex].status != PlayerStatus.active);

      // Tick active power-ups
      gameState.tickActivePowerUps();

      _isProcessingTurn = false; // Unlock for next player's turn
      gameState = gameState.copyWith(currentPlayerIndex: nextIndex, highlightedTileIndex: null, logicPhase: TurnLogicPhase.preRoll);

      // Phase 3: Check for random event trigger at new round
      if (crossedRound) {
        _checkEventTrigger();
      }
    });

    // Check if next player is in jail
    final nextPlayer = gameState.currentPlayer;
    if (nextPlayer.jailTurnsRemaining > 0) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted && !_isPaused) {
          _handleJailTurn(nextPlayer);
        }
      });
      return;
    }

    // If next player is AI, auto-roll after a delay
    if (gameState.currentPlayer.isAI) {
      Future.delayed(const Duration(milliseconds: 1500), () {
        if (mounted && !_isPaused && gameState.canRoll && !_isProcessingTurn) {
          _rollDice();
        }
      });
    }
  }

  Future<void> _handleJailTurn(Player player) async {
    // AI automatically decides
    if (player.isAI) {
      await Future.delayed(const Duration(milliseconds: 800));

      // AI pays fine if they can afford it, otherwise stays
      if (player.cash >= GameConstants.jailBailAmount) {
        engine.payJailBail(player);
        setState(() {});
        // Now AI can roll
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted && !_isPaused && gameState.canRoll) {
            _rollDice();
          }
        });
      } else {
        // AI stays in jail
        setState(() {
          player.jailTurnsRemaining--;
        });
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            _endTurn();
          }
        });
      }
      return;
    }

    // Human player gets dialog
    await showJailDialog(
      context: context,
      playerCash: player.cash,
      turnsRemaining: player.jailTurnsRemaining,
      onPayFine: () {
        // Pay fine and allow normal turn
        if (engine.payJailBail(player)) {
          setState(() {});
        }
      },
      onStay: () {
        // Stay in jail, decrement turns and end turn
        setState(() {
          player.jailTurnsRemaining--;
        });
        // End turn immediately
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            _endTurn();
          }
        });
      },
    );
  }

  // ==========================================================================
  // Phase 4: Action Button Widget Builder
  // ==========================================================================
  Widget _buildActionButton({required IconData icon, required String label, required Color color, required VoidCallback onTap}) {
    return Material(
      color: color.withOpacity(0.9),
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white, size: 18),
              const SizedBox(width: 4),
              Text(
                label,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================================================
  // Phase 4: Trade Dialog
  // ==========================================================================
  void _showTradeDialog() {
    final currentPlayer = gameState.currentPlayer;
    final otherPlayers = gameState.players.where((p) => p.id != currentPlayer.id && p.status == PlayerStatus.active).toList();

    if (otherPlayers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No other players to trade with!'), duration: Duration(seconds: 2)));
      return;
    }

    showTradeDialog(context: context, currentPlayer: currentPlayer, otherPlayers: otherPlayers, tiles: gameState.tiles, onTradeProposed: _handleTradeProposal);
  }

  Future<void> _handleTradeProposal(TradeOffer offer) async {
    final recipient = offer.recipient;

    // AI evaluates trade
    if (recipient.isAI) {
      await Future.delayed(const Duration(milliseconds: 500));

      final aiEngine = _aiEngines[recipient.id];
      final shouldAccept = aiEngine?.shouldAcceptTrade(offer, recipient, gameState) ?? AITradeStrategy.shouldAcceptTrade(offer, recipient);

      if (shouldAccept) {
        await _showAIActionNotification(recipient.name, 'Accepted the trade!', Icons.handshake, Colors.green);
        offer.execute();
        setState(() {});
      } else {
        await _showAIActionNotification(recipient.name, 'Rejected the trade.', Icons.cancel, Colors.red);
      }
      return;
    }

    // Human recipient sees trade response dialog
    if (!mounted) return;
    await showTradeResponseDialog(
      context: context,
      offer: offer,
      onAccept: () {
        offer.execute();
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Trade completed!'), backgroundColor: Colors.green, duration: Duration(seconds: 2)));
      },
      onReject: () {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Trade rejected.'), backgroundColor: Colors.red, duration: Duration(seconds: 2)));
      },
    );
  }

  // ==========================================================================
  // Phase 4: Mortgage Dialog
  // ==========================================================================
  void _showMortgageDialog() {
    final currentPlayer = gameState.currentPlayer;

    showPropertyManagementDialog(
      context: context,
      player: currentPlayer,
      tiles: gameState.tiles,
      onMortgage: (tile) {
        if (engine.mortgageProperty(currentPlayer, tile)) {
          setState(() {});
        }
      },
      onUnmortgage: (tile) {
        if (engine.unmortgageProperty(currentPlayer, tile)) {
          setState(() {});
        }
      },
    );
  }
}

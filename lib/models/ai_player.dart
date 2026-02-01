import 'dart:math';
import 'tile.dart';
import 'player.dart';
import 'game_state.dart';
import 'trade.dart';

/// AI difficulty levels
enum AIDifficulty {
  easy,
  medium,
  hard,
}

/// AI personality types
enum AIPersonality {
  aggressive,   // Buys everything, upgrades quickly
  conservative, // Keeps cash reserves, cautious
  balanced,     // Mix of both strategies
  collector,    // Focuses on completing color sets
  riskTaker,    // High risk/reward, expensive properties
  defensive,    // Blocks opponents, strategic
  trader,       // Actively seeks trades
  flipper,      // Buys cheap, mortgages for cash
}

/// Enhanced AI player configuration
class AIConfig {
  final AIDifficulty difficulty;
  final AIPersonality personality;

  const AIConfig({
    this.difficulty = AIDifficulty.medium,
    this.personality = AIPersonality.balanced,
  });

  /// Get cash reserve target based on difficulty and personality
  int get cashReserveTarget {
    switch (difficulty) {
      case AIDifficulty.easy:
        return personality == AIPersonality.conservative ? 300 : 100;
      case AIDifficulty.medium:
        return personality == AIPersonality.conservative ? 400 : 200;
      case AIDifficulty.hard:
        return personality == AIPersonality.conservative ? 500 : 250;
    }
  }

  /// Get property buy threshold (multiplier of property price)
  double get buyThreshold {
    switch (personality) {
      case AIPersonality.aggressive:
        return 1.0; // Will buy if has exactly enough
      case AIPersonality.conservative:
        return 1.5; // Needs 50% more than price
      case AIPersonality.balanced:
        return 1.2; // Needs 20% more than price
      case AIPersonality.collector:
        return 1.3; // Moderate threshold, focuses on sets
      case AIPersonality.riskTaker:
        return 0.8; // Very aggressive, buys expensive properties
      case AIPersonality.defensive:
        return 1.4; // Cautious, strategic purchases
      case AIPersonality.trader:
        return 1.1; // Moderate, saves for trades
      case AIPersonality.flipper:
        return 0.9; // Low threshold, buys cheap properties
    }
  }

  /// Get upgrade priority score modifier
  double get upgradeModifier {
    switch (personality) {
      case AIPersonality.aggressive:
        return 1.5; // More likely to upgrade
      case AIPersonality.conservative:
        return 0.7; // Less likely to upgrade
      case AIPersonality.balanced:
        return 1.0;
      case AIPersonality.collector:
        return 1.2; // Upgrades completed sets
      case AIPersonality.riskTaker:
        return 1.6; // Very likely to upgrade expensive properties
      case AIPersonality.defensive:
        return 0.9; // Moderate upgrades
      case AIPersonality.trader:
        return 0.8; // Saves cash for trades
      case AIPersonality.flipper:
        return 0.5; // Rarely upgrades, prefers quick cash
    }
  }
}

/// Enhanced AI decision engine
class AIDecisionEngine {
  final Random _random = Random();
  final AIConfig config;

  AIDecisionEngine({this.config = const AIConfig()});

  /// Decide whether to buy a property
  bool shouldBuyProperty(Player aiPlayer, TileData tile, GameState state) {
    final price = _getPropertyPrice(tile);
    if (price == null || aiPlayer.cash < price) return false;

    final reserveNeeded = config.cashReserveTarget;
    final cashAfterPurchase = aiPlayer.cash - price;

    // Easy AI makes random mistakes
    if (config.difficulty == AIDifficulty.easy && _random.nextDouble() < 0.2) {
      return _random.nextBool();
    }

    // Check if this completes a color set
    final completesSet = _wouldCompleteColorSet(tile, aiPlayer, state);

    // Collector personality prioritizes completing sets
    if (config.personality == AIPersonality.collector && completesSet) {
      return cashAfterPurchase >= reserveNeeded * 0.5; // Lower threshold for sets
    }

    // Aggressive buys almost everything
    if (config.personality == AIPersonality.aggressive) {
      return cashAfterPurchase >= reserveNeeded * 0.5;
    }

    // Conservative needs more buffer
    if (config.personality == AIPersonality.conservative) {
      return cashAfterPurchase >= reserveNeeded * 1.5;
    }

    // Risk Taker: Prioritizes expensive properties
    if (config.personality == AIPersonality.riskTaker) {
      if (price > 300) {
        return cashAfterPurchase >= reserveNeeded * 0.3; // Very aggressive on expensive
      }
      // Less interested in cheap properties
      return cashAfterPurchase >= reserveNeeded * 1.2;
    }

    // Defensive: Blocks opponent sets
    if (config.personality == AIPersonality.defensive) {
      if (_wouldBlockOpponent(tile, aiPlayer, state)) {
        return cashAfterPurchase >= reserveNeeded * 0.7; // Lower threshold to block
      }
      // Otherwise more cautious
      return cashAfterPurchase >= reserveNeeded * 1.3;
    }

    // Trader: Saves cash for trading
    if (config.personality == AIPersonality.trader) {
      // Only buy if can maintain good cash reserve for trades
      return cashAfterPurchase >= reserveNeeded * 1.5 && aiPlayer.cash - price >= 200;
    }

    // Flipper: Targets cheap properties
    if (config.personality == AIPersonality.flipper) {
      if (price < 200) {
        return cashAfterPurchase >= reserveNeeded * 0.5; // Aggressive on cheap properties
      }
      // Avoids expensive properties
      return false;
    }

    // Balanced approach
    final threshold = price * config.buyThreshold;
    return aiPlayer.cash >= threshold + reserveNeeded;
  }

  /// Decide whether to upgrade a property
  bool shouldUpgradeProperty(Player aiPlayer, PropertyTileData property, GameState state) {
    if (!property.canUpgrade) return false;

    final cost = property.upgradeCost;
    if (aiPlayer.cash < cost) return false;

    final reserveNeeded = config.cashReserveTarget;
    final cashAfterUpgrade = aiPlayer.cash - cost;

    // Easy AI upgrades randomly
    if (config.difficulty == AIDifficulty.easy) {
      return _random.nextDouble() < 0.4 && cashAfterUpgrade >= reserveNeeded * 0.5;
    }

    // Check if we own the full set (better ROI)
    final ownsFullSet = _ownsFullColorSet(property.groupId, aiPlayer, state);

    // Hard AI is strategic about upgrades
    if (config.difficulty == AIDifficulty.hard) {
      // Prioritize upgrading completed sets
      if (ownsFullSet) {
        return cashAfterUpgrade >= reserveNeeded;
      }
      // Don't upgrade unless we have the full set
      return false;
    }

    // Medium difficulty upgrades with reasonable logic
    if (ownsFullSet) {
      final modifier = config.upgradeModifier;
      return cashAfterUpgrade >= reserveNeeded * modifier;
    }

    // Aggressive personality upgrades even without full set
    if (config.personality == AIPersonality.aggressive) {
      return cashAfterUpgrade >= reserveNeeded * 1.5;
    }

    return false;
  }

  /// Decide whether to mortgage a property
  TileData? shouldMortgageProperty(Player aiPlayer, GameState state, int cashNeeded) {
    if (aiPlayer.cash >= cashNeeded) return null;

    final mortgageable = _getMortgageableProperties(aiPlayer, state);
    if (mortgageable.isEmpty) return null;

    // Easy AI mortgages randomly
    if (config.difficulty == AIDifficulty.easy) {
      return mortgageable[_random.nextInt(mortgageable.length)];
    }

    // Sort by strategic value (lower value first)
    mortgageable.sort((a, b) {
      final valueA = _getStrategicValue(a, aiPlayer, state);
      final valueB = _getStrategicValue(b, aiPlayer, state);
      return valueA.compareTo(valueB);
    });

    // Mortgage lowest value property
    return mortgageable.first;
  }

  /// Decide whether to accept a trade offer
  bool shouldAcceptTrade(TradeOffer offer, Player aiPlayer, GameState state) {
    if (offer.recipient.id != aiPlayer.id) return false;

    // Easy AI accepts randomly
    if (config.difficulty == AIDifficulty.easy) {
      return _random.nextDouble() < 0.5;
    }

    // Calculate value received vs given
    int receivingValue = offer.offeredCash;
    int givingValue = offer.requestedCash;

    for (final prop in offer.offeredProperties) {
      receivingValue += _getStrategicValue(prop, aiPlayer, state);
    }

    for (final prop in offer.requestedProperties) {
      givingValue += _getStrategicValue(prop, aiPlayer, state);
    }

    // Hard AI is stricter
    if (config.difficulty == AIDifficulty.hard) {
      return receivingValue >= givingValue * 1.1; // Needs 10% advantage
    }

    // Medium AI is fair
    return receivingValue >= givingValue * 0.95; // Accepts near-equal trades
  }

  /// Generate a trade offer
  TradeOffer? generateTradeOffer(Player aiPlayer, List<Player> otherPlayers, GameState state) {
    // Easy AI doesn't initiate trades
    if (config.difficulty == AIDifficulty.easy) return null;

    // Conservative AI rarely initiates trades
    if (config.personality == AIPersonality.conservative && _random.nextDouble() < 0.7) {
      return null;
    }

    // Trader personality initiates trades frequently
    if (config.personality == AIPersonality.trader && _random.nextDouble() < 0.6) {
      return _buildStrategicTrade(aiPlayer, otherPlayers, state);
    }

    // Flipper personality creates cash-focused trades when low on money
    if (config.personality == AIPersonality.flipper && aiPlayer.cash < 500) {
      return _buildCashTrade(aiPlayer, otherPlayers, state);
    }

    // Find a property we want
    for (final other in otherPlayers) {
      if (other.id == aiPlayer.id || other.status != PlayerStatus.active) continue;

      final targetProps = _getDesirableProperties(other, aiPlayer, state);
      if (targetProps.isEmpty) continue;

      final targetProp = targetProps.first;
      final targetValue = _getStrategicValue(targetProp, aiPlayer, state);

      // Find our properties to offer
      final ourProps = _getTradeableProperties(aiPlayer, state);
      if (ourProps.isEmpty && aiPlayer.cash < targetValue) continue;

      // Build a fair offer
      int offeredValue = 0;
      final offeredProps = <TileData>[];
      int offeredCash = 0;

      // Prefer offering cash first
      if (aiPlayer.cash >= targetValue + config.cashReserveTarget) {
        offeredCash = targetValue;
        offeredValue = targetValue;
      } else {
        // Offer properties
        for (final prop in ourProps) {
          if (offeredValue >= targetValue) break;
          offeredProps.add(prop);
          offeredValue += _getPropertyPrice(prop) ?? 0;
        }
        // Add cash if needed
        final remaining = targetValue - offeredValue;
        if (remaining > 0 && aiPlayer.cash >= remaining + config.cashReserveTarget) {
          offeredCash = remaining;
          offeredValue += remaining;
        }
      }

      if (offeredValue < targetValue * 0.8) continue; // Can't make good offer

      return TradeOffer(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        offerer: aiPlayer,
        recipient: other,
        offeredProperties: offeredProps,
        offeredCash: offeredCash,
        requestedProperties: [targetProp],
        requestedCash: 0,
      );
    }

    return null;
  }

  // Helper methods

  int? _getPropertyPrice(TileData tile) {
    if (tile is PropertyTileData) return tile.price;
    if (tile is RailroadTileData) return tile.price;
    if (tile is UtilityTileData) return tile.price;
    return null;
  }

  bool _wouldCompleteColorSet(TileData tile, Player player, GameState state) {
    if (tile is! PropertyTileData) return false;

    final groupId = tile.groupId;
    final groupProps = state.tiles
        .whereType<PropertyTileData>()
        .where((p) => p.groupId == groupId)
        .toList();

    final ownedCount = groupProps.where((p) => p.ownerId == player.id).length;
    return ownedCount == groupProps.length - 1; // Would complete with this one
  }

  bool _ownsFullColorSet(String groupId, Player player, GameState state) {
    final groupProps = state.tiles
        .whereType<PropertyTileData>()
        .where((p) => p.groupId == groupId)
        .toList();

    return groupProps.every((p) => p.ownerId == player.id);
  }

  List<TileData> _getMortgageableProperties(Player player, GameState state) {
    return state.tiles.where((tile) {
      if (tile is PropertyTileData) {
        return tile.ownerId == player.id && tile.canMortgage;
      } else if (tile is RailroadTileData) {
        return tile.ownerId == player.id && tile.canMortgage;
      } else if (tile is UtilityTileData) {
        return tile.ownerId == player.id && tile.canMortgage;
      }
      return false;
    }).toList();
  }

  int _getStrategicValue(TileData tile, Player player, GameState state) {
    final basePrice = _getPropertyPrice(tile) ?? 0;
    int bonus = 0;

    if (tile is PropertyTileData) {
      // Bonus for properties that would complete sets
      if (_wouldCompleteColorSet(tile, player, state)) {
        bonus += basePrice; // Double value for set completion
      }
      // Bonus for properties in sets we partially own
      final groupProps = state.tiles
          .whereType<PropertyTileData>()
          .where((p) => p.groupId == tile.groupId)
          .toList();
      final ownedCount = groupProps.where((p) => p.ownerId == player.id).length;
      bonus += ownedCount * 50;
    }

    if (tile is RailroadTileData) {
      // Bonus based on owned railroads
      final ownedRailroads = state.tiles
          .whereType<RailroadTileData>()
          .where((r) => r.ownerId == player.id)
          .length;
      bonus += ownedRailroads * 50;
    }

    return basePrice + bonus;
  }

  List<TileData> _getTradeableProperties(Player player, GameState state) {
    return state.tiles.where((tile) {
      if (tile is PropertyTileData) {
        if (tile.ownerId != player.id || tile.isMortgaged) return false;
        // Don't trade properties in completed sets
        if (_ownsFullColorSet(tile.groupId, player, state)) return false;
        return true;
      } else if (tile is RailroadTileData) {
        return tile.ownerId == player.id && !tile.isMortgaged;
      } else if (tile is UtilityTileData) {
        return tile.ownerId == player.id && !tile.isMortgaged;
      }
      return false;
    }).toList();
  }

  List<TileData> _getDesirableProperties(Player other, Player aiPlayer, GameState state) {
    return state.tiles.where((tile) {
      if (tile is PropertyTileData) {
        if (tile.ownerId != other.id || tile.isMortgaged) return false;
        // Prioritize properties that complete our sets
        return _wouldCompleteColorSet(tile, aiPlayer, state);
      }
      return false;
    }).toList();
  }

  /// Check if buying this property would block an opponent from completing a set
  bool _wouldBlockOpponent(TileData tile, Player aiPlayer, GameState state) {
    if (tile is! PropertyTileData) return false;

    final groupId = tile.groupId;
    final groupProps = state.tiles
        .whereType<PropertyTileData>()
        .where((p) => p.groupId == groupId)
        .toList();

    // Check if any opponent owns most of this color set
    for (final player in state.players) {
      if (player.id == aiPlayer.id || player.status != PlayerStatus.active) continue;

      final ownedCount = groupProps.where((p) => p.ownerId == player.id).length;
      // If opponent owns all but this one, buying it blocks them
      if (ownedCount == groupProps.length - 1) {
        return true;
      }
    }

    return false;
  }

  /// Build a strategic trade for Trader personality
  TradeOffer? _buildStrategicTrade(Player aiPlayer, List<Player> otherPlayers, GameState state) {
    // Look for mutually beneficial trades (e.g., both complete sets)
    for (final other in otherPlayers) {
      if (other.id == aiPlayer.id || other.status != PlayerStatus.active) continue;

      // Find properties we each want from each other
      final weWantFromThem = state.tiles.where((tile) {
        if (tile is! PropertyTileData) return false;
        if (tile.ownerId != other.id || tile.isMortgaged) return false;
        return _wouldCompleteColorSet(tile, aiPlayer, state);
      }).toList();

      final theyWantFromUs = state.tiles.where((tile) {
        if (tile is! PropertyTileData) return false;
        if (tile.ownerId != aiPlayer.id || tile.isMortgaged) return false;
        return _wouldCompleteColorSet(tile, other, state);
      }).toList();

      if (weWantFromThem.isNotEmpty && theyWantFromUs.isNotEmpty) {
        // Propose a swap
        return TradeOffer(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          offerer: aiPlayer,
          recipient: other,
          offeredProperties: [theyWantFromUs.first],
          offeredCash: 0,
          requestedProperties: [weWantFromThem.first],
          requestedCash: 0,
        );
      }
    }
    return null;
  }

  /// Build a cash-focused trade for Flipper personality
  TradeOffer? _buildCashTrade(Player aiPlayer, List<Player> otherPlayers, GameState state) {
    // Find cheap properties we own to sell for cash
    final ourCheapProps = state.tiles.where((tile) {
      if (tile is! PropertyTileData) return false;
      if (tile.ownerId != aiPlayer.id || tile.isMortgaged) return false;
      if (_ownsFullColorSet(tile.groupId, aiPlayer, state)) return false; // Don't break sets
      return tile.price < 200;
    }).toList();

    if (ourCheapProps.isEmpty) return null;

    // Find a player with cash
    for (final other in otherPlayers) {
      if (other.id == aiPlayer.id || other.status != PlayerStatus.active) continue;
      if (other.cash < 150) continue;

      final propToSell = ourCheapProps.first as PropertyTileData;
      final askingPrice = (propToSell.price * 0.9).toInt(); // Slight discount for quick sale

      if (other.cash >= askingPrice) {
        return TradeOffer(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          offerer: aiPlayer,
          recipient: other,
          offeredProperties: [propToSell],
          offeredCash: 0,
          requestedProperties: [],
          requestedCash: askingPrice,
        );
      }
    }
    return null;
  }
}

/// Extension to add AI config to Player
extension AIPlayerExtension on Player {
  static final Map<String, AIConfig> _aiConfigs = {};

  AIConfig get aiConfig => _aiConfigs[id] ?? const AIConfig();

  set aiConfig(AIConfig config) => _aiConfigs[id] = config;
}

/// Get display name for AI difficulty
String getAIDifficultyName(AIDifficulty difficulty) {
  switch (difficulty) {
    case AIDifficulty.easy:
      return 'Easy';
    case AIDifficulty.medium:
      return 'Medium';
    case AIDifficulty.hard:
      return 'Hard';
  }
}

/// Get display name for AI personality
String getAIPersonalityName(AIPersonality personality) {
  switch (personality) {
    case AIPersonality.aggressive:
      return 'Aggressive';
    case AIPersonality.conservative:
      return 'Cautious';
    case AIPersonality.balanced:
      return 'Balanced';
    case AIPersonality.collector:
      return 'Collector';
    case AIPersonality.riskTaker:
      return 'Risk Taker';
    case AIPersonality.defensive:
      return 'Defensive';
    case AIPersonality.trader:
      return 'Trader';
    case AIPersonality.flipper:
      return 'Flipper';
  }
}

/// Get description for AI personality
String getAIPersonalityDescription(AIPersonality personality) {
  switch (personality) {
    case AIPersonality.aggressive:
      return 'Buys everything and upgrades quickly';
    case AIPersonality.conservative:
      return 'Keeps cash reserves, plays it safe';
    case AIPersonality.balanced:
      return 'Mix of offense and defense';
    case AIPersonality.collector:
      return 'Focuses on completing color sets';
    case AIPersonality.riskTaker:
      return 'Targets expensive properties, high risk/reward';
    case AIPersonality.defensive:
      return 'Blocks opponents from completing sets';
    case AIPersonality.trader:
      return 'Actively seeks mutually beneficial trades';
    case AIPersonality.flipper:
      return 'Buys cheap properties and sells for cash';
  }
}

import 'tile.dart';
import 'player.dart';

/// Represents a trade offer between two players
class TradeOffer {
  final String id;
  final Player offerer;
  final Player recipient;

  /// Properties the offerer is giving
  final List<TileData> offeredProperties;

  /// Cash the offerer is giving
  final int offeredCash;

  /// Properties the offerer wants from recipient
  final List<TileData> requestedProperties;

  /// Cash the offerer wants from recipient
  final int requestedCash;

  TradeOffer({
    required this.id,
    required this.offerer,
    required this.recipient,
    this.offeredProperties = const [],
    this.offeredCash = 0,
    this.requestedProperties = const [],
    this.requestedCash = 0,
  });

  /// Check if this trade is valid
  bool get isValid {
    // Must have something to trade
    if (offeredProperties.isEmpty && offeredCash == 0 &&
        requestedProperties.isEmpty && requestedCash == 0) {
      return false;
    }

    // Offerer must own all offered properties
    for (final prop in offeredProperties) {
      if (!_isOwnedBy(prop, offerer.id)) return false;
    }

    // Recipient must own all requested properties
    for (final prop in requestedProperties) {
      if (!_isOwnedBy(prop, recipient.id)) return false;
    }

    // Players must have enough cash
    if (offerer.cash < offeredCash) return false;
    if (recipient.cash < requestedCash) return false;

    return true;
  }

  bool _isOwnedBy(TileData tile, String playerId) {
    if (tile is PropertyTileData) return tile.ownerId == playerId;
    if (tile is RailroadTileData) return tile.ownerId == playerId;
    if (tile is UtilityTileData) return tile.ownerId == playerId;
    return false;
  }

  /// Calculate the net value of the offer for the offerer
  /// Positive means offerer is giving more value
  int get netValueForOfferer {
    int offered = offeredCash;
    int requested = requestedCash;

    for (final prop in offeredProperties) {
      offered += _getPropertyValue(prop);
    }

    for (final prop in requestedProperties) {
      requested += _getPropertyValue(prop);
    }

    return offered - requested;
  }

  int _getPropertyValue(TileData tile) {
    if (tile is PropertyTileData) return tile.price;
    if (tile is RailroadTileData) return tile.price;
    if (tile is UtilityTileData) return tile.price;
    return 0;
  }

  /// Execute the trade (transfer properties and cash)
  void execute() {
    if (!isValid) return;

    // Transfer properties from offerer to recipient
    for (final prop in offeredProperties) {
      _transferProperty(prop, offerer, recipient);
    }

    // Transfer properties from recipient to offerer
    for (final prop in requestedProperties) {
      _transferProperty(prop, recipient, offerer);
    }

    // Transfer cash
    offerer.cash -= offeredCash;
    recipient.cash += offeredCash;
    recipient.cash -= requestedCash;
    offerer.cash += requestedCash;
  }

  void _transferProperty(TileData tile, Player from, Player to) {
    if (tile is PropertyTileData) {
      tile.ownerId = to.id;
      from.propertyIds.remove(tile.index.toString());
      to.propertyIds.add(tile.index.toString());
    } else if (tile is RailroadTileData) {
      tile.ownerId = to.id;
      from.propertyIds.remove(tile.index.toString());
      to.propertyIds.add(tile.index.toString());
    } else if (tile is UtilityTileData) {
      tile.ownerId = to.id;
      from.propertyIds.remove(tile.index.toString());
      to.propertyIds.add(tile.index.toString());
    }
  }

  /// Create a copy with updated fields
  TradeOffer copyWith({
    String? id,
    Player? offerer,
    Player? recipient,
    List<TileData>? offeredProperties,
    int? offeredCash,
    List<TileData>? requestedProperties,
    int? requestedCash,
  }) {
    return TradeOffer(
      id: id ?? this.id,
      offerer: offerer ?? this.offerer,
      recipient: recipient ?? this.recipient,
      offeredProperties: offeredProperties ?? List.from(this.offeredProperties),
      offeredCash: offeredCash ?? this.offeredCash,
      requestedProperties: requestedProperties ?? List.from(this.requestedProperties),
      requestedCash: requestedCash ?? this.requestedCash,
    );
  }
}

/// AI trading strategy
class AITradeStrategy {
  /// Evaluate if AI should accept a trade offer
  static bool shouldAcceptTrade(TradeOffer offer, Player aiPlayer) {
    if (offer.recipient.id != aiPlayer.id) return false;

    // Calculate values
    int receivingValue = offer.offeredCash;
    int givingValue = offer.requestedCash;

    for (final prop in offer.offeredProperties) {
      receivingValue += _getPropertyValue(prop);
      // Bonus if it completes a color set
      receivingValue += _getStrategicBonus(prop, aiPlayer, offer.recipient);
    }

    for (final prop in offer.requestedProperties) {
      givingValue += _getPropertyValue(prop);
      // Penalty if losing a color set
      givingValue += _getStrategicBonus(prop, aiPlayer, offer.offerer);
    }

    // AI accepts if receiving at least 90% of giving value
    // More lenient to encourage trading
    return receivingValue >= givingValue * 0.9;
  }

  /// Create a counter-offer
  static TradeOffer? createCounterOffer(TradeOffer original) {
    // Calculate the imbalance
    final imbalance = original.netValueForOfferer;

    if (imbalance.abs() < 50) return null; // Close enough, no counter needed

    // Suggest adjusting cash to balance
    if (imbalance > 0) {
      // Offerer is giving more, reduce their cash or increase requested
      final adjustment = (imbalance * 0.8).round();
      if (original.offeredCash >= adjustment) {
        return original.copyWith(offeredCash: original.offeredCash - adjustment);
      } else {
        return original.copyWith(requestedCash: original.requestedCash + adjustment);
      }
    } else {
      // Offerer is requesting more, increase their cash or reduce requested
      final adjustment = (-imbalance * 0.8).round();
      if (original.requestedCash >= adjustment) {
        return original.copyWith(requestedCash: original.requestedCash - adjustment);
      } else {
        return original.copyWith(offeredCash: original.offeredCash + adjustment);
      }
    }
  }

  static int _getPropertyValue(TileData tile) {
    if (tile is PropertyTileData) return tile.price;
    if (tile is RailroadTileData) return tile.price;
    if (tile is UtilityTileData) return tile.price;
    return 0;
  }

  static int _getStrategicBonus(TileData tile, Player player, Player otherPlayer) {
    // Add strategic value for completing sets, etc.
    // For now, simple bonus for properties
    if (tile is PropertyTileData) {
      return 50; // Bonus value for property
    }
    if (tile is RailroadTileData) {
      return 30; // Railroads have good rental income
    }
    return 20;
  }
}

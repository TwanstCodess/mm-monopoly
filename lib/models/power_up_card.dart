import 'package:flutter/material.dart';

/// Rarity levels for power-up cards
enum CardRarity {
  common,
  uncommon,
  rare,
  legendary,
}

/// Types of power-up effects
enum PowerUpType {
  rentReducer,      // Pay only 50% rent
  speedBoost,       // Roll again after moving
  propertyScout,    // See all unowned property prices
  rentCollector,    // Collect $50 from each player
  priceFreeze,      // Buy property at 75% price
  teleporter,       // Move to any unowned property
  shield,           // Block one rent payment
  doubleDice,       // Roll with advantage
  moneyMagnet,      // Extra $100 when passing GO
  monopolyMaster,   // Free house on all owned properties
}

/// Extension for card rarity properties
extension CardRarityExt on CardRarity {
  String get displayName {
    switch (this) {
      case CardRarity.common:
        return 'Common';
      case CardRarity.uncommon:
        return 'Uncommon';
      case CardRarity.rare:
        return 'Rare';
      case CardRarity.legendary:
        return 'Legendary';
    }
  }

  Color get color {
    switch (this) {
      case CardRarity.common:
        return const Color(0xFF9E9E9E); // Grey
      case CardRarity.uncommon:
        return const Color(0xFF4CAF50); // Green
      case CardRarity.rare:
        return const Color(0xFF2196F3); // Blue
      case CardRarity.legendary:
        return const Color(0xFFFFD700); // Gold
    }
  }

  Color get glowColor {
    switch (this) {
      case CardRarity.common:
        return Colors.grey.withOpacity(0.3);
      case CardRarity.uncommon:
        return Colors.green.withOpacity(0.4);
      case CardRarity.rare:
        return Colors.blue.withOpacity(0.5);
      case CardRarity.legendary:
        return Colors.amber.withOpacity(0.6);
    }
  }
}

/// A power-up card that can be collected and used
class PowerUpCard {
  final String id;
  final String name;
  final String description;
  final PowerUpType type;
  final CardRarity rarity;
  final IconData icon;
  final Color primaryColor;
  final int? duration; // For timed effects (in turns)

  const PowerUpCard({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.rarity,
    required this.icon,
    required this.primaryColor,
    this.duration,
  });

  /// Create a unique instance of this card
  PowerUpCard createInstance() {
    return PowerUpCard(
      id: '${id}_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      description: description,
      type: type,
      rarity: rarity,
      icon: icon,
      primaryColor: primaryColor,
      duration: duration,
    );
  }
}

/// All available power-up cards
class PowerUpCards {
  // Common cards
  static const rentReducer = PowerUpCard(
    id: 'rent_reducer',
    name: 'Rent Reducer',
    description: 'Pay only 50% rent this turn',
    type: PowerUpType.rentReducer,
    rarity: CardRarity.common,
    icon: Icons.percent,
    primaryColor: Color(0xFF66BB6A),
  );

  static const speedBoost = PowerUpCard(
    id: 'speed_boost',
    name: 'Speed Boost',
    description: 'Roll again after moving',
    type: PowerUpType.speedBoost,
    rarity: CardRarity.common,
    icon: Icons.fast_forward,
    primaryColor: Color(0xFF42A5F5),
  );

  static const propertyScout = PowerUpCard(
    id: 'property_scout',
    name: 'Property Scout',
    description: 'See all unowned property prices',
    type: PowerUpType.propertyScout,
    rarity: CardRarity.common,
    icon: Icons.search,
    primaryColor: Color(0xFF78909C),
  );

  // Uncommon cards
  static const rentCollector = PowerUpCard(
    id: 'rent_collector',
    name: 'Rent Collector',
    description: 'Collect \$50 from each player',
    type: PowerUpType.rentCollector,
    rarity: CardRarity.uncommon,
    icon: Icons.payments,
    primaryColor: Color(0xFF7CB342),
  );

  static const priceFreeze = PowerUpCard(
    id: 'price_freeze',
    name: 'Price Freeze',
    description: 'Buy next property at 75% price',
    type: PowerUpType.priceFreeze,
    rarity: CardRarity.uncommon,
    icon: Icons.ac_unit,
    primaryColor: Color(0xFF4FC3F7),
  );

  static const teleporter = PowerUpCard(
    id: 'teleporter',
    name: 'Teleporter',
    description: 'Move to any unowned property',
    type: PowerUpType.teleporter,
    rarity: CardRarity.uncommon,
    icon: Icons.flash_on,
    primaryColor: Color(0xFFBA68C8),
  );

  // Rare cards
  static const shield = PowerUpCard(
    id: 'shield',
    name: 'Shield',
    description: 'Block one rent payment',
    type: PowerUpType.shield,
    rarity: CardRarity.rare,
    icon: Icons.shield,
    primaryColor: Color(0xFF29B6F6),
  );

  static const doubleDice = PowerUpCard(
    id: 'double_dice',
    name: 'Double Dice',
    description: 'Roll with 4 dice, pick best 2',
    type: PowerUpType.doubleDice,
    rarity: CardRarity.rare,
    icon: Icons.casino,
    primaryColor: Color(0xFFEF5350),
  );

  static const moneyMagnet = PowerUpCard(
    id: 'money_magnet',
    name: 'Money Magnet',
    description: 'Extra \$100 when passing GO (3 turns)',
    type: PowerUpType.moneyMagnet,
    rarity: CardRarity.rare,
    icon: Icons.attach_money,
    primaryColor: Color(0xFFFFA726),
    duration: 3,
  );

  // Legendary cards
  static const monopolyMaster = PowerUpCard(
    id: 'monopoly_master',
    name: 'Monopoly Master',
    description: 'Free house on all owned properties!',
    type: PowerUpType.monopolyMaster,
    rarity: CardRarity.legendary,
    icon: Icons.home_work,
    primaryColor: Color(0xFFFFD700),
  );

  /// All available card templates
  static const List<PowerUpCard> all = [
    // Common
    rentReducer,
    speedBoost,
    propertyScout,
    // Uncommon
    rentCollector,
    priceFreeze,
    teleporter,
    // Rare
    shield,
    doubleDice,
    moneyMagnet,
    // Legendary
    monopolyMaster,
  ];

  /// Get cards by rarity
  static List<PowerUpCard> byRarity(CardRarity rarity) {
    return all.where((c) => c.rarity == rarity).toList();
  }

  /// Get a random card with weighted rarity
  static PowerUpCard getRandomCard({bool guaranteeRare = false}) {
    final random = DateTime.now().millisecondsSinceEpoch % 100;

    CardRarity rarity;
    if (guaranteeRare) {
      // Guaranteed at least rare
      if (random < 10) {
        rarity = CardRarity.legendary;
      } else {
        rarity = CardRarity.rare;
      }
    } else {
      // Normal distribution: 50% common, 30% uncommon, 15% rare, 5% legendary
      if (random < 50) {
        rarity = CardRarity.common;
      } else if (random < 80) {
        rarity = CardRarity.uncommon;
      } else if (random < 95) {
        rarity = CardRarity.rare;
      } else {
        rarity = CardRarity.legendary;
      }
    }

    final cards = byRarity(rarity);
    final cardTemplate = cards[DateTime.now().millisecond % cards.length];
    return cardTemplate.createInstance();
  }
}

/// Active effect from a used power-up card
class ActivePowerUp {
  final PowerUpCard card;
  final String playerId;
  int remainingTurns;

  ActivePowerUp({
    required this.card,
    required this.playerId,
    required this.remainingTurns,
  });

  bool get isExpired => remainingTurns <= 0;

  void decrementTurn() {
    if (remainingTurns > 0) {
      remainingTurns--;
    }
  }
}

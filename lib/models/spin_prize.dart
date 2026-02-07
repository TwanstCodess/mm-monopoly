import 'dart:math';
import 'package:flutter/material.dart';

/// Types of prizes that can be won from the spin wheel
enum SpinPrizeType {
  cash,
  freeHouse,
  doubleRent,
  shield,
  teleport,
  jackpot,
}

/// A prize that can be won from the spin wheel
class SpinPrize {
  final String id;
  final String name;
  final String description;
  final SpinPrizeType type;
  final Color color;
  final IconData icon;
  final int? value; // For cash prizes
  final double weight; // Probability weight

  const SpinPrize({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.color,
    required this.icon,
    this.value,
    required this.weight,
  });

  /// Serialize to JSON (only stores ID for lookup)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
    };
  }

  /// Deserialize from JSON (lookup from predefined constants)
  factory SpinPrize.fromJson(Map<String, dynamic> json) {
    final id = json['id'] as String;
    final prize = SpinPrizes.all.firstWhere(
      (p) => p.id == id,
      orElse: () => SpinPrizes.cash50, // Fallback to a default prize
    );
    return prize;
  }
}

/// Default spin wheel prizes
class SpinPrizes {
  static const cash50 = SpinPrize(
    id: 'cash_50',
    name: '\$50',
    description: 'Win \$50!',
    type: SpinPrizeType.cash,
    color: Color(0xFF4CAF50),
    icon: Icons.attach_money,
    value: 50,
    weight: 25,
  );

  static const cash100 = SpinPrize(
    id: 'cash_100',
    name: '\$100',
    description: 'Win \$100!',
    type: SpinPrizeType.cash,
    color: Color(0xFF8BC34A),
    icon: Icons.attach_money,
    value: 100,
    weight: 20,
  );

  static const cash200 = SpinPrize(
    id: 'cash_200',
    name: '\$200',
    description: 'Win \$200!',
    type: SpinPrizeType.cash,
    color: Color(0xFFCDDC39),
    icon: Icons.attach_money,
    value: 200,
    weight: 15,
  );

  static const freeHouse = SpinPrize(
    id: 'free_house',
    name: 'Free House',
    description: 'Build a free house on any property!',
    type: SpinPrizeType.freeHouse,
    color: Color(0xFF2196F3),
    icon: Icons.house,
    weight: 10,
  );

  static const doubleRent = SpinPrize(
    id: 'double_rent',
    name: '2x Rent',
    description: 'Next rent you collect is doubled!',
    type: SpinPrizeType.doubleRent,
    color: Color(0xFF9C27B0),
    icon: Icons.monetization_on,
    weight: 10,
  );

  static const shield = SpinPrize(
    id: 'shield',
    name: 'Shield',
    description: 'Skip your next rent payment!',
    type: SpinPrizeType.shield,
    color: Color(0xFF00BCD4),
    icon: Icons.shield,
    weight: 10,
  );

  static const teleport = SpinPrize(
    id: 'teleport',
    name: 'Teleport',
    description: 'Move to any tile of your choice!',
    type: SpinPrizeType.teleport,
    color: Color(0xFFE91E63),
    icon: Icons.flash_on,
    weight: 5,
  );

  static const jackpot = SpinPrize(
    id: 'jackpot',
    name: 'JACKPOT!',
    description: 'Win \$500 jackpot!',
    type: SpinPrizeType.jackpot,
    color: Color(0xFFFFD700),
    icon: Icons.star,
    value: 500,
    weight: 5,
  );

  /// All available prizes
  static const List<SpinPrize> all = [
    cash50,
    cash100,
    cash200,
    freeHouse,
    doubleRent,
    shield,
    teleport,
    jackpot,
  ];

  /// Total weight for probability calculations
  static double get totalWeight => all.fold(0, (sum, p) => sum + p.weight);

  static final _random = Random();

  /// Get a random prize based on weights
  static SpinPrize getRandomPrize() {
    final roll = _random.nextDouble();
    double cumulative = 0;

    for (final prize in all) {
      cumulative += prize.weight / totalWeight;
      if (roll <= cumulative) {
        return prize;
      }
    }
    return all.last;
  }
}

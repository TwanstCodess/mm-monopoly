import 'package:flutter/material.dart';

/// Types of tiles on the board
enum TileType {
  start,
  property,
  chance,
  communityChest,
  tax,
  jail,
  goToJail,
  freeParking,
  utility,
  railroad,
}

/// Position information for rendering a tile
class TilePosition {
  final int index;
  final double left;
  final double top;
  final double width;
  final double height;
  final int rotation; // 0, 1, 2, 3 for quarter turns

  const TilePosition({
    required this.index,
    required this.left,
    required this.top,
    required this.width,
    required this.height,
    this.rotation = 0,
  });

  bool get isCorner => index % 10 == 0;
}

/// Base tile data for all tile types
class TileData {
  final int index;
  final String name;
  final TileType type;
  final Color color;
  final String? subtext;

  const TileData({
    required this.index,
    required this.name,
    required this.type,
    required this.color,
    this.subtext,
  });

  bool get isCorner => index % 10 == 0;
}

/// Property tile with purchase and rent information
class PropertyTileData extends TileData {
  final String groupId;
  final Color groupColor;
  final int price;
  final List<int> rentLevels; // [base, 1house, 2house, 3house, 4house, hotel]

  String? ownerId;
  int upgradeLevel; // 0-5 (0 = no houses, 5 = hotel)
  bool isMortgaged;

  PropertyTileData({
    required super.index,
    required super.name,
    required this.groupId,
    required this.groupColor,
    required this.price,
    required this.rentLevels,
    this.ownerId,
    this.upgradeLevel = 0,
    this.isMortgaged = false,
  }) : super(
          type: TileType.property,
          color: groupColor,
        );

  int get currentRent {
    if (isMortgaged) return 0;
    return rentLevels[upgradeLevel.clamp(0, rentLevels.length - 1)];
  }

  bool get isOwned => ownerId != null;
  bool get canUpgrade => upgradeLevel < 5 && !isMortgaged;

  /// Mortgage value is 50% of the property price
  int get mortgageValue => (price * 0.5).round();

  /// Cost to unmortgage is mortgage value + 10% interest
  int get unmortgageCost => (mortgageValue * 1.1).round();

  /// Can only mortgage if owned and not already mortgaged
  bool get canMortgage => isOwned && !isMortgaged && upgradeLevel == 0;

  /// Can unmortgage if currently mortgaged
  bool get canUnmortgage => isOwned && isMortgaged;

  /// Cost to upgrade (buy one house or hotel) - 50% of property price
  int get upgradeCost => (price * 0.5).round();

  /// Rent at next upgrade level
  int get nextLevelRent {
    if (!canUpgrade) return currentRent;
    return rentLevels[(upgradeLevel + 1).clamp(0, rentLevels.length - 1)];
  }

  /// Description of current level (e.g., "2 Houses", "Hotel")
  String get levelDescription {
    switch (upgradeLevel) {
      case 0:
        return 'No houses';
      case 1:
        return '1 House';
      case 2:
        return '2 Houses';
      case 3:
        return '3 Houses';
      case 4:
        return '4 Houses';
      case 5:
        return 'Hotel';
      default:
        return '';
    }
  }

  /// Description of next level
  String get nextLevelDescription {
    switch (upgradeLevel) {
      case 0:
        return '1 House';
      case 1:
        return '2 Houses';
      case 2:
        return '3 Houses';
      case 3:
        return '4 Houses';
      case 4:
        return 'Hotel';
      default:
        return '';
    }
  }
}

/// Railroad tile data
class RailroadTileData extends TileData {
  final int price;
  String? ownerId;
  bool isMortgaged;

  RailroadTileData({
    required super.index,
    required super.name,
    this.price = 200,
    this.ownerId,
    this.isMortgaged = false,
  }) : super(
          type: TileType.railroad,
          color: Colors.white,
        );

  /// Rent depends on how many railroads owned (25, 50, 100, 200)
  int getRent(int railroadsOwned) {
    if (isMortgaged) return 0;
    const rents = [25, 50, 100, 200];
    return rents[(railroadsOwned - 1).clamp(0, 3)];
  }

  bool get isOwned => ownerId != null;

  /// Mortgage value is 50% of the property price
  int get mortgageValue => (price * 0.5).round();

  /// Cost to unmortgage is mortgage value + 10% interest
  int get unmortgageCost => (mortgageValue * 1.1).round();

  /// Can only mortgage if owned and not already mortgaged
  bool get canMortgage => isOwned && !isMortgaged;

  /// Can unmortgage if currently mortgaged
  bool get canUnmortgage => isOwned && isMortgaged;
}

/// Utility tile data
class UtilityTileData extends TileData {
  final int price;
  final bool isElectric;
  String? ownerId;
  bool isMortgaged;

  UtilityTileData({
    required super.index,
    required super.name,
    required this.isElectric,
    this.price = 150,
    this.ownerId,
    this.isMortgaged = false,
  }) : super(
          type: TileType.utility,
          color: Colors.white,
        );

  /// Rent is dice roll * 4 (one utility) or * 10 (both utilities)
  int getRent(int diceRoll, int utilitiesOwned) {
    if (isMortgaged) return 0;
    return diceRoll * (utilitiesOwned == 2 ? 10 : 4);
  }

  bool get isOwned => ownerId != null;

  /// Mortgage value is 50% of the property price
  int get mortgageValue => (price * 0.5).round();

  /// Cost to unmortgage is mortgage value + 10% interest
  int get unmortgageCost => (mortgageValue * 1.1).round();

  /// Can only mortgage if owned and not already mortgaged
  bool get canMortgage => isOwned && !isMortgaged;

  /// Can unmortgage if currently mortgaged
  bool get canUnmortgage => isOwned && isMortgaged;
}

/// Tax tile data
class TaxTileData extends TileData {
  final int amount;
  final double? percentage; // Optional percentage of wealth

  const TaxTileData({
    required super.index,
    required super.name,
    required this.amount,
    this.percentage,
  }) : super(
          type: TileType.tax,
          color: Colors.white,
          subtext: '\$$amount',
        );
}

/// Special corner tiles (GO, Jail, Free Parking, Go To Jail)
class CornerTileData extends TileData {
  const CornerTileData({
    required super.index,
    required super.name,
    required super.type,
    super.color = Colors.white,
    super.subtext,
  });
}

/// Card draw tiles (Chance/Community Chest)
class CardTileData extends TileData {
  final bool isChance;

  CardTileData({
    required super.index,
    required super.name,
    required this.isChance,
  }) : super(
          type: isChance ? TileType.chance : TileType.communityChest,
          color: Colors.white,
        );
}

/// Property group colors
class PropertyGroups {
  static const Color brown = Color(0xFF795548);
  static const Color lightBlue = Color(0xFF4FC3F7);
  static const Color pink = Color(0xFFF48FB1);
  static const Color orange = Color(0xFFFF9800);
  static const Color red = Color(0xFFF44336);
  static const Color yellow = Color(0xFFFFEB3B);
  static const Color green = Color(0xFF4CAF50);
  static const Color darkBlue = Color(0xFF1976D2);

  static const List<Color> all = [
    brown,
    lightBlue,
    pink,
    orange,
    red,
    yellow,
    green,
    darkBlue,
  ];
}

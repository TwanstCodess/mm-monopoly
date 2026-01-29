import 'package:flutter/material.dart';
import '../../models/tile.dart';

/// Classic Monopoly board configuration with 40 tiles
class ClassicBoard {
  static const int tileCount = 40;

  /// Property group definitions
  static const Map<String, List<int>> propertyGroups = {
    'brown': [1, 3],
    'lightBlue': [6, 8, 9],
    'pink': [11, 13, 14],
    'orange': [16, 18, 19],
    'red': [21, 23, 24],
    'yellow': [26, 27, 29],
    'green': [31, 32, 34],
    'darkBlue': [37, 39],
  };

  /// Railroad positions
  static const List<int> railroadPositions = [5, 15, 25, 35];

  /// Utility positions
  static const List<int> utilityPositions = [12, 28];

  /// Chance card positions
  static const List<int> chancePositions = [7, 22, 36];

  /// Community Chest positions
  static const List<int> communityChestPositions = [2, 17, 33];

  /// Generate all 40 tiles for the classic board
  static List<TileData> generateTiles() {
    return [
      // Bottom row (right to left: 0-10)
      _corner(0, 'GO', TileType.start, subtext: 'COLLECT \$200'),
      _property(1, 'Mediterranean Ave', 'brown', PropertyGroups.brown, 60, [2, 10, 30, 90, 160, 250]),
      _card(2, 'Community Chest', false),
      _property(3, 'Baltic Ave', 'brown', PropertyGroups.brown, 60, [4, 20, 60, 180, 320, 450]),
      _tax(4, 'Income Tax', 200),
      _railroad(5, 'Reading Railroad'),
      _property(6, 'Oriental Ave', 'lightBlue', PropertyGroups.lightBlue, 100, [6, 30, 90, 270, 400, 550]),
      _card(7, 'Chance', true),
      _property(8, 'Vermont Ave', 'lightBlue', PropertyGroups.lightBlue, 100, [6, 30, 90, 270, 400, 550]),
      _property(9, 'Connecticut Ave', 'lightBlue', PropertyGroups.lightBlue, 120, [8, 40, 100, 300, 450, 600]),
      _corner(10, 'JAIL', TileType.jail, color: const Color(0xFFFFE0B2), subtext: 'JUST VISITING'),

      // Left column (bottom to top: 11-20)
      _property(11, 'St. Charles Place', 'pink', PropertyGroups.pink, 140, [10, 50, 150, 450, 625, 750]),
      _utility(12, 'Electric Company', true),
      _property(13, 'States Ave', 'pink', PropertyGroups.pink, 140, [10, 50, 150, 450, 625, 750]),
      _property(14, 'Virginia Ave', 'pink', PropertyGroups.pink, 160, [12, 60, 180, 500, 700, 900]),
      _railroad(15, 'Pennsylvania Railroad'),
      _property(16, 'St. James Place', 'orange', PropertyGroups.orange, 180, [14, 70, 200, 550, 750, 950]),
      _card(17, 'Community Chest', false),
      _property(18, 'Tennessee Ave', 'orange', PropertyGroups.orange, 180, [14, 70, 200, 550, 750, 950]),
      _property(19, 'New York Ave', 'orange', PropertyGroups.orange, 200, [16, 80, 220, 600, 800, 1000]),
      _corner(20, 'FREE PARKING', TileType.freeParking),

      // Top row (left to right: 21-30)
      _property(21, 'Kentucky Ave', 'red', PropertyGroups.red, 220, [18, 90, 250, 700, 875, 1050]),
      _card(22, 'Chance', true),
      _property(23, 'Indiana Ave', 'red', PropertyGroups.red, 220, [18, 90, 250, 700, 875, 1050]),
      _property(24, 'Illinois Ave', 'red', PropertyGroups.red, 240, [20, 100, 300, 750, 925, 1100]),
      _railroad(25, 'B&O Railroad'),
      _property(26, 'Atlantic Ave', 'yellow', PropertyGroups.yellow, 260, [22, 110, 330, 800, 975, 1150]),
      _property(27, 'Ventnor Ave', 'yellow', PropertyGroups.yellow, 260, [22, 110, 330, 800, 975, 1150]),
      _utility(28, 'Water Works', false),
      _property(29, 'Marvin Gardens', 'yellow', PropertyGroups.yellow, 280, [24, 120, 360, 850, 1025, 1200]),
      _corner(30, 'GO TO JAIL', TileType.goToJail),

      // Right column (top to bottom: 31-39)
      _property(31, 'Pacific Ave', 'green', PropertyGroups.green, 300, [26, 130, 390, 900, 1100, 1275]),
      _property(32, 'North Carolina Ave', 'green', PropertyGroups.green, 300, [26, 130, 390, 900, 1100, 1275]),
      _card(33, 'Community Chest', false),
      _property(34, 'Pennsylvania Ave', 'green', PropertyGroups.green, 320, [28, 150, 450, 1000, 1200, 1400]),
      _railroad(35, 'Short Line'),
      _card(36, 'Chance', true),
      _property(37, 'Park Place', 'darkBlue', PropertyGroups.darkBlue, 350, [35, 175, 500, 1100, 1300, 1500]),
      _tax(38, 'Luxury Tax', 100),
      _property(39, 'Boardwalk', 'darkBlue', PropertyGroups.darkBlue, 400, [50, 200, 600, 1400, 1700, 2000]),
    ];
  }

  // Helper constructors
  static CornerTileData _corner(int index, String name, TileType type, {Color color = Colors.white, String? subtext}) {
    return CornerTileData(
      index: index,
      name: name,
      type: type,
      color: color,
      subtext: subtext,
    );
  }

  static PropertyTileData _property(int index, String name, String groupId, Color groupColor, int price, List<int> rentLevels) {
    return PropertyTileData(
      index: index,
      name: name,
      groupId: groupId,
      groupColor: groupColor,
      price: price,
      rentLevels: rentLevels,
    );
  }

  static RailroadTileData _railroad(int index, String name) {
    return RailroadTileData(
      index: index,
      name: name,
    );
  }

  static UtilityTileData _utility(int index, String name, bool isElectric) {
    return UtilityTileData(
      index: index,
      name: name,
      isElectric: isElectric,
    );
  }

  static TaxTileData _tax(int index, String name, int amount) {
    return TaxTileData(
      index: index,
      name: name,
      amount: amount,
    );
  }

  static CardTileData _card(int index, String name, bool isChance) {
    return CardTileData(
      index: index,
      name: name,
      isChance: isChance,
    );
  }
}

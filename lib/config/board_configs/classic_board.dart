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
      _property(1, 'Mediterranean Ave', 'brown', PropertyGroups.brown, 60, [2, 10, 30, 90, 160, 250],
        funFact: 'The most affordable property in Atlantic City, perfect for first-time property owners!'),
      _card(2, 'Comm Chest', false),
      _property(3, 'Baltic Ave', 'brown', PropertyGroups.brown, 60, [4, 20, 60, 180, 320, 450],
        funFact: 'Named after the Baltic Sea region, this street was home to many Eastern European immigrants.'),
      _tax(4, 'Income Tax', 200),
      _railroad(5, 'Reading Railroad',
        funFact: 'Founded in 1833, the Reading Railroad was one of the first railroads in the United States!'),
      _property(6, 'Oriental Ave', 'lightBlue', PropertyGroups.lightBlue, 100, [6, 30, 90, 270, 400, 550],
        funFact: 'This street celebrates Atlantic City\'s historic connection to Asian culture and trade.'),
      _card(7, 'Chance', true),
      _property(8, 'Vermont Ave', 'lightBlue', PropertyGroups.lightBlue, 100, [6, 30, 90, 270, 400, 550],
        funFact: 'Vermont, the Green Mountain State, is famous for its maple syrup and beautiful fall foliage.'),
      _property(9, 'Connecticut Ave', 'lightBlue', PropertyGroups.lightBlue, 120, [8, 40, 100, 300, 450, 600],
        funFact: 'Connecticut is known as the Constitution State and is home to Yale University!'),
      _corner(10, 'JAIL', TileType.jail, color: const Color(0xFFFFE0B2), subtext: 'JUST VISITING'),

      // Left column (bottom to top: 11-20)
      _property(11, 'St. Charles Place', 'pink', PropertyGroups.pink, 140, [10, 50, 150, 450, 625, 750],
        funFact: 'Named after a historic hotel, St. Charles Place was a popular destination in early Atlantic City.'),
      _utility(12, 'Electric Company', true,
        funFact: 'Thomas Edison\'s invention of the light bulb in 1879 revolutionized the electric industry!'),
      _property(13, 'States Ave', 'pink', PropertyGroups.pink, 140, [10, 50, 150, 450, 625, 750],
        funFact: 'This street represents the unity of all 50 states in America!'),
      _property(14, 'Virginia Ave', 'pink', PropertyGroups.pink, 160, [12, 60, 180, 500, 700, 900],
        funFact: 'Virginia was home to 8 U.S. Presidents, more than any other state!'),
      _railroad(15, 'Pennsylvania Railroad',
        funFact: 'The Pennsylvania Railroad was once the largest railroad in the world by traffic and revenue!'),
      _property(16, 'St. James Place', 'orange', PropertyGroups.orange, 180, [14, 70, 200, 550, 750, 950],
        funFact: 'St. James is the patron saint of pilgrims and travelers, perfect for a resort city!'),
      _card(17, 'Comm Chest', false),
      _property(18, 'Tennessee Ave', 'orange', PropertyGroups.orange, 180, [14, 70, 200, 550, 750, 950],
        funFact: 'Tennessee is the birthplace of country music and home to the Grand Ole Opry!'),
      _property(19, 'New York Ave', 'orange', PropertyGroups.orange, 200, [16, 80, 220, 600, 800, 1000],
        funFact: 'New York City is home to the Statue of Liberty, a symbol of freedom worldwide!'),
      _corner(20, 'LUCKY SPIN', TileType.freeParking),

      // Top row (left to right: 21-30)
      _property(21, 'Kentucky Ave', 'red', PropertyGroups.red, 220, [18, 90, 250, 700, 875, 1050],
        funFact: 'Kentucky is famous for the Kentucky Derby, the most exciting two minutes in sports!'),
      _card(22, 'Chance', true),
      _property(23, 'Indiana Ave', 'red', PropertyGroups.red, 220, [18, 90, 250, 700, 875, 1050],
        funFact: 'Indiana is home to the Indianapolis 500, the world\'s largest single-day sporting event!'),
      _property(24, 'Illinois Ave', 'red', PropertyGroups.red, 240, [20, 100, 300, 750, 925, 1100],
        funFact: 'Chicago, Illinois is home to the world\'s first skyscraper, built in 1885!'),
      _railroad(25, 'B&O Railroad',
        funFact: 'The Baltimore & Ohio Railroad was the first common carrier railroad in America, founded in 1827!'),
      _property(26, 'Atlantic Ave', 'yellow', PropertyGroups.yellow, 260, [22, 110, 330, 800, 975, 1150],
        funFact: 'Atlantic Avenue runs parallel to the famous Atlantic City Boardwalk!'),
      _property(27, 'Ventnor Ave', 'yellow', PropertyGroups.yellow, 260, [22, 110, 330, 800, 975, 1150],
        funFact: 'Ventnor City neighbors Atlantic City and offers beautiful beaches and quieter shores.'),
      _utility(28, 'Water Works', false,
        funFact: 'Atlantic City\'s water comes from the Kirkwood-Cohansey aquifer, one of the purest water sources!'),
      _property(29, 'Marvin Gardens', 'yellow', PropertyGroups.yellow, 280, [24, 120, 360, 850, 1025, 1200],
        funFact: 'Actually spelled "Marven Gardens" in real life, located in nearby Margate City!'),
      _corner(30, 'GO TO JAIL', TileType.goToJail),

      // Right column (top to bottom: 31-39)
      _property(31, 'Pacific Ave', 'green', PropertyGroups.green, 300, [26, 130, 390, 900, 1100, 1275],
        funFact: 'Pacific Avenue is one of Atlantic City\'s main thoroughfares, running through the heart of the city.'),
      _property(32, 'North Carolina Ave', 'green', PropertyGroups.green, 300, [26, 130, 390, 900, 1100, 1275],
        funFact: 'North Carolina was the first state to declare independence from British rule!'),
      _card(33, 'Comm Chest', false),
      _property(34, 'Pennsylvania Ave', 'green', PropertyGroups.green, 320, [28, 150, 450, 1000, 1200, 1400],
        funFact: 'Pennsylvania Avenue in Washington D.C. connects the White House to the Capitol Building!'),
      _railroad(35, 'Short Line',
        funFact: 'The Shore Fast Line provided rapid transit service along the Jersey Shore in the early 1900s!'),
      _card(36, 'Chance', true),
      _property(37, 'Park Place', 'darkBlue', PropertyGroups.darkBlue, 350, [35, 175, 500, 1100, 1300, 1500],
        funFact: 'One of the most prestigious addresses in Atlantic City, second only to Boardwalk!'),
      _tax(38, 'Luxury Tax', 100),
      _property(39, 'Boardwalk', 'darkBlue', PropertyGroups.darkBlue, 400, [50, 200, 600, 1400, 1700, 2000],
        funFact: 'Atlantic City Boardwalk, built in 1870, was the first boardwalk in the United States!'),
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

  static PropertyTileData _property(int index, String name, String groupId, Color groupColor, int price, List<int> rentLevels, {String? funFact}) {
    return PropertyTileData(
      index: index,
      name: name,
      groupId: groupId,
      groupColor: groupColor,
      price: price,
      rentLevels: rentLevels,
      funFact: funFact,
    );
  }

  static RailroadTileData _railroad(int index, String name, {String? funFact}) {
    return RailroadTileData(
      index: index,
      name: name,
      funFact: funFact,
    );
  }

  static UtilityTileData _utility(int index, String name, bool isElectric, {String? funFact}) {
    return UtilityTileData(
      index: index,
      name: name,
      isElectric: isElectric,
      funFact: funFact,
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

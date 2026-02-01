import 'package:flutter/material.dart';
import '../../models/tile.dart';

/// UK/London Monopoly board configuration with 40 tiles
class UKBoard {
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

  /// Railroad positions (Train Stations in UK)
  static const List<int> railroadPositions = [5, 15, 25, 35];

  /// Utility positions
  static const List<int> utilityPositions = [12, 28];

  /// Chance card positions
  static const List<int> chancePositions = [7, 22, 36];

  /// Community Chest positions
  static const List<int> communityChestPositions = [2, 17, 33];

  /// Generate all 40 tiles for the UK board
  static List<TileData> generateTiles() {
    return [
      // Bottom row (right to left: 0-10)
      _corner(0, 'GO', TileType.start, subtext: 'COLLECT £200'),
      _property(1, 'Old Kent Road', 'brown', PropertyGroups.brown, 60, [2, 10, 30, 90, 160, 250],
        funFact: 'One of London\'s oldest roads, dating back to Roman times when it connected London to Canterbury!'),
      _card(2, 'Community Chest', false),
      _property(3, 'Whitechapel Road', 'brown', PropertyGroups.brown, 60, [4, 20, 60, 180, 320, 450],
        funFact: 'Historic East End street, famous for the Whitechapel Bell Foundry which cast the Liberty Bell!'),
      _tax(4, 'Income Tax', 200),
      _railroad(5, 'King\'s Cross Station',
        funFact: 'Platform 9¾ at King\'s Cross is where Harry Potter catches the Hogwarts Express!'),
      _property(6, 'The Angel Islington', 'lightBlue', PropertyGroups.lightBlue, 100, [6, 30, 90, 270, 400, 550],
        funFact: 'Named after a historic coaching inn, The Angel has been a London landmark since 1614!'),
      _card(7, 'Chance', true),
      _property(8, 'Euston Road', 'lightBlue', PropertyGroups.lightBlue, 100, [6, 30, 90, 270, 400, 550],
        funFact: 'Home to the British Library, which houses over 170 million items including the Magna Carta!'),
      _property(9, 'Pentonville Road', 'lightBlue', PropertyGroups.lightBlue, 120, [8, 40, 100, 300, 450, 600],
        funFact: 'Named after Henry Penton who developed the area in the 1770s, near historic Pentonville Prison.'),
      _corner(10, 'JAIL', TileType.jail, color: const Color(0xFFFFE0B2), subtext: 'JUST VISITING'),

      // Left column (bottom to top: 11-20)
      _property(11, 'Pall Mall', 'pink', PropertyGroups.pink, 140, [10, 50, 150, 450, 625, 750],
        funFact: 'Home to exclusive gentlemen\'s clubs since the 1800s, and the famous Royal Automobile Club!'),
      _utility(12, 'Electric Company', true,
        funFact: 'London\'s first power station opened in 1882, bringing electric street lights to the city!'),
      _property(13, 'Whitehall', 'pink', PropertyGroups.pink, 140, [10, 50, 150, 450, 625, 750],
        funFact: 'The center of UK government! Home to 10 Downing Street and numerous ministry buildings.'),
      _property(14, 'Northumberland Ave', 'pink', PropertyGroups.pink, 160, [12, 60, 180, 500, 700, 900],
        funFact: 'Built in the 1870s, this grand avenue connects Trafalgar Square to the Thames Embankment!'),
      _railroad(15, 'Marylebone Station',
        funFact: 'London\'s most recent major station, opened in 1899, and featured in many Sherlock Holmes stories!'),
      _property(16, 'Bow Street', 'orange', PropertyGroups.orange, 180, [14, 70, 200, 550, 750, 950],
        funFact: 'Home to the Royal Opera House and the first professional police force, the Bow Street Runners!'),
      _card(17, 'Community Chest', false),
      _property(18, 'Marlborough Street', 'orange', PropertyGroups.orange, 180, [14, 70, 200, 550, 750, 950],
        funFact: 'Located in Mayfair, this elegant street has been home to British aristocracy for centuries!'),
      _property(19, 'Vine Street', 'orange', PropertyGroups.orange, 200, [16, 80, 220, 600, 800, 1000],
        funFact: 'A prestigious Mayfair address, Vine Street has housed famous residents and luxury establishments!'),
      _corner(20, 'LUCKY SPIN', TileType.freeParking),

      // Top row (left to right: 21-30)
      _property(21, 'Strand', 'red', PropertyGroups.red, 220, [18, 90, 250, 700, 875, 1050],
        funFact: 'One of London\'s busiest thoroughfares, the Strand connects Westminster to the City of London!'),
      _card(22, 'Chance', true),
      _property(23, 'Fleet Street', 'red', PropertyGroups.red, 220, [18, 90, 250, 700, 875, 1050],
        funFact: 'The historic heart of British journalism! Named after the River Fleet that runs beneath it.'),
      _property(24, 'Trafalgar Square', 'red', PropertyGroups.red, 240, [20, 100, 300, 750, 925, 1100],
        funFact: 'Named after the Battle of Trafalgar, features Nelson\'s Column and is visited by 15 million people yearly!'),
      _railroad(25, 'Fenchurch St Station',
        funFact: 'The smallest of London\'s major terminals, built in 1841, serving the historic City of London!'),
      _property(26, 'Leicester Square', 'yellow', PropertyGroups.yellow, 260, [22, 110, 330, 800, 975, 1150],
        funFact: 'The heart of London\'s entertainment district, hosting movie premieres and surrounded by theaters!'),
      _property(27, 'Coventry Street', 'yellow', PropertyGroups.yellow, 260, [22, 110, 330, 800, 975, 1150],
        funFact: 'Connects Piccadilly Circus to Leicester Square, lined with restaurants and entertainment venues!'),
      _utility(28, 'Water Works', false,
        funFact: 'London\'s water comes from the Thames and Lea rivers, treating over 2.6 billion liters daily!'),
      _property(29, 'Piccadilly', 'yellow', PropertyGroups.yellow, 280, [24, 120, 360, 850, 1025, 1200],
        funFact: 'Home to Piccadilly Circus and luxury shopping! Named after piccadills, fashionable 17th century collars.'),
      _corner(30, 'GO TO JAIL', TileType.goToJail),

      // Right column (top to bottom: 31-39)
      _property(31, 'Regent Street', 'green', PropertyGroups.green, 300, [26, 130, 390, 900, 1100, 1275],
        funFact: 'Designed by John Nash in 1811, Regent Street curves elegantly through the West End with flagship stores!'),
      _property(32, 'Oxford Street', 'green', PropertyGroups.green, 300, [26, 130, 390, 900, 1100, 1275],
        funFact: 'Europe\'s busiest shopping street with over 300 shops and 200 million visitors each year!'),
      _card(33, 'Community Chest', false),
      _property(34, 'Bond Street', 'green', PropertyGroups.green, 320, [28, 150, 450, 1000, 1200, 1400],
        funFact: 'The epitome of luxury since the 1700s, home to world-famous jewelers, fashion houses, and art dealers!'),
      _railroad(35, 'Liverpool St Station',
        funFact: 'One of London\'s busiest stations, serving over 67 million passengers annually!'),
      _card(36, 'Chance', true),
      _property(37, 'Park Lane', 'darkBlue', PropertyGroups.darkBlue, 350, [35, 175, 500, 1100, 1300, 1500],
        funFact: 'Overlooks Hyde Park and is home to some of London\'s most expensive real estate and luxury hotels!'),
      _tax(38, 'Luxury Tax', 100),
      _property(39, 'Mayfair', 'darkBlue', PropertyGroups.darkBlue, 400, [50, 200, 600, 1400, 1700, 2000],
        funFact: 'London\'s most exclusive district! Named after the annual May Fair held here from 1686 to 1764.'),
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

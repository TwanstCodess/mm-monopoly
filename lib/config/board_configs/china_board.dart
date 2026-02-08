import 'package:flutter/material.dart';
import '../../models/tile.dart';

/// China/Beijing Monopoly board configuration with 40 tiles
class ChinaBoard {
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

  /// Railroad positions (Subway Lines in China)
  static const List<int> railroadPositions = [5, 15, 25, 35];

  /// Utility positions
  static const List<int> utilityPositions = [12, 28];

  /// Chance card positions
  static const List<int> chancePositions = [7, 22, 36];

  /// Community Chest positions
  static const List<int> communityChestPositions = [2, 17, 33];

  /// Generate all 40 tiles for the China board
  static List<TileData> generateTiles() {
    return [
      // Bottom row (right to left: 0-10)
      _corner(0, 'GO', TileType.start, subtext: '开始'),
      _property(1, 'Nanluoguxiang', 'brown', PropertyGroups.brown, 60, [2, 10, 30, 90, 160, 250],
        funFact: 'This 800-year-old hutong alley is one of Beijing\'s best-preserved historical streets!',
        subtext: '南锣鼓巷'),
      _card(2, 'Comm Chest', false),
      _property(3, 'Houhai', 'brown', PropertyGroups.brown, 60, [4, 20, 60, 180, 320, 450],
        funFact: 'Historic lake area where emperors once went ice skating!',
        subtext: '后海'),
      _tax(4, 'Income Tax', 200),
      _railroad(5, 'Line 1', subtext: '地铁1号线',
        funFact: 'Beijing\'s first subway line, opened in 1971, running through Tiananmen Square!'),
      _property(6, 'Wangfujing', 'lightBlue', PropertyGroups.lightBlue, 100, [6, 30, 90, 270, 400, 550],
        funFact: 'Beijing\'s premier shopping street, over 700 years old!',
        subtext: '王府井'),
      _card(7, 'Chance', true),
      _property(8, 'Sanlitun', 'lightBlue', PropertyGroups.lightBlue, 100, [6, 30, 90, 270, 400, 550],
        funFact: 'Beijing\'s most international neighborhood, home to embassies and nightlife!',
        subtext: '三里屯'),
      _property(9, 'CBD', 'lightBlue', PropertyGroups.lightBlue, 120, [8, 40, 100, 300, 450, 600],
        funFact: 'The Central Business District features the iconic CCTV Tower by Rem Koolhaas!',
        subtext: '国贸'),
      _corner(10, 'JAIL', TileType.jail, color: const Color(0xFFFFE0B2), subtext: '监狱'),

      // Left column (bottom to top: 11-20)
      _property(11, 'Dongcheng', 'pink', PropertyGroups.pink, 140, [10, 50, 150, 450, 625, 750],
        funFact: 'The eastern district preserves countless historical hutongs and courtyard homes!',
        subtext: '东城区'),
      _utility(12, 'State Grid', true,
        funFact: 'The world\'s largest utility company, powering over 1.1 billion people!'),
      _property(13, 'Beihai Park', 'pink', PropertyGroups.pink, 140, [10, 50, 150, 450, 625, 750],
        funFact: 'Imperial garden dating back to the 10th century, featuring the stunning White Dagoba!',
        subtext: '北海公园'),
      _property(14, 'Jingshan', 'pink', PropertyGroups.pink, 160, [12, 60, 180, 500, 700, 900],
        funFact: 'This artificial hill offers the best panoramic view of the Forbidden City!',
        subtext: '景山'),
      _railroad(15, 'Line 2', subtext: '地铁2号线',
        funFact: 'Forms a rectangle around central Beijing, following the old city wall route!'),
      _property(16, 'Lama Temple', 'orange', PropertyGroups.orange, 180, [14, 70, 200, 550, 750, 950],
        funFact: 'Home to a 26-meter tall Buddha carved from a single sandalwood tree!',
        subtext: '雍和宫'),
      _card(17, 'Comm Chest', false),
      _property(18, 'Temple of Heaven', 'orange', PropertyGroups.orange, 180, [14, 70, 200, 550, 750, 950],
        funFact: 'Where emperors prayed for good harvests! The Echo Wall can carry whispers 65 meters!',
        subtext: '天坛'),
      _property(19, 'Summer Palace', 'orange', PropertyGroups.orange, 200, [16, 80, 220, 600, 800, 1000],
        funFact: 'UNESCO site covering 290 hectares, 75% water! Empress Cixi\'s marble boat still stands!',
        subtext: '颐和园'),
      _corner(20, 'LUCKY SPIN', TileType.freeParking, subtext: '幸运转盘'),

      // Top row (left to right: 21-30)
      _property(21, 'Drum Tower', 'red', PropertyGroups.red, 220, [18, 90, 250, 700, 875, 1050],
        funFact: 'Built in 1272, drummers once marked time for the entire city!',
        subtext: '鼓楼'),
      _card(22, 'Chance', true),
      _property(23, 'Bell Tower', 'red', PropertyGroups.red, 220, [18, 90, 250, 700, 875, 1050],
        funFact: 'Houses a massive 63-ton bronze bell from the Ming Dynasty!',
        subtext: '钟楼'),
      _property(24, 'Tiananmen', 'red', PropertyGroups.red, 240, [20, 100, 300, 750, 925, 1100],
        funFact: 'The largest public square in the world, holding up to 1 million people!',
        subtext: '天安门'),
      _railroad(25, 'Line 4', subtext: '地铁4号线',
        funFact: 'Connects the Summer Palace to the south, carrying 1 million riders daily!'),
      _property(26, 'Chaoyang', 'yellow', PropertyGroups.yellow, 260, [22, 110, 330, 800, 975, 1150],
        funFact: 'Beijing\'s most international district, hosting the Olympic venues!',
        subtext: '朝阳区'),
      _property(27, 'Olympic Park', 'yellow', PropertyGroups.yellow, 260, [22, 110, 330, 800, 975, 1150],
        funFact: 'Home to the Bird\'s Nest stadium and Water Cube from the 2008 Olympics!',
        subtext: '奥林匹克公园'),
      _utility(28, 'Beijing Water', false,
        funFact: 'The South-North Water Transfer Project brings water from 1,400km away!'),
      _property(29, 'Zhongguancun', 'yellow', PropertyGroups.yellow, 280, [24, 120, 360, 850, 1025, 1200],
        funFact: 'China\'s Silicon Valley, home to tech giants like Baidu and Lenovo!',
        subtext: '中关村'),
      _corner(30, 'GO TO JAIL', TileType.goToJail, subtext: '去监狱'),

      // Right column (top to bottom: 31-39)
      _property(31, 'Silk Street', 'green', PropertyGroups.green, 300, [26, 130, 390, 900, 1100, 1275],
        funFact: 'Famous shopping market following the ancient Silk Road trading tradition!',
        subtext: '秀水街'),
      _property(32, 'Panjiayuan', 'green', PropertyGroups.green, 300, [26, 130, 390, 900, 1100, 1275],
        funFact: 'Asia\'s largest antique market with over 3,000 vendors!',
        subtext: '潘家园'),
      _card(33, 'Comm Chest', false),
      _property(34, 'National Museum', 'green', PropertyGroups.green, 320, [28, 150, 450, 1000, 1200, 1400],
        funFact: 'The world\'s most visited museum with 7.4 million visitors annually!',
        subtext: '国家博物馆'),
      _railroad(35, 'Line 10', subtext: '地铁10号线',
        funFact: 'Forms a giant loop connecting all major districts of Beijing!'),
      _card(36, 'Chance', true),
      _property(37, 'CCTV Tower', 'darkBlue', PropertyGroups.darkBlue, 350, [35, 175, 500, 1100, 1300, 1500],
        funFact: 'Standing 405 meters tall with a revolutionary "loop" design!',
        subtext: '央视大楼'),
      _tax(38, 'Luxury Tax', 100),
      _property(39, 'Forbidden City', 'darkBlue', PropertyGroups.darkBlue, 400, [50, 200, 600, 1400, 1700, 2000],
        funFact: 'The world\'s largest palace complex with 9,999 rooms, home to 24 emperors!',
        subtext: '故宫'),
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

  static PropertyTileData _property(int index, String name, String groupId, Color groupColor, int price, List<int> rentLevels, {String? funFact, String? subtext}) {
    return PropertyTileData(
      index: index,
      name: name,
      groupId: groupId,
      groupColor: groupColor,
      price: price,
      rentLevels: rentLevels,
      funFact: funFact,
      subtext: subtext,
    );
  }

  static RailroadTileData _railroad(int index, String name, {String? funFact, String? subtext}) {
    return RailroadTileData(
      index: index,
      name: name,
      funFact: funFact,
      subtext: subtext,
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

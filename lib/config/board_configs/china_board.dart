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
        funFact: 'Dating back to the Yuan Dynasty in 1267, this 786-meter hutong was once home to Qing Dynasty nobles and now attracts over 10,000 visitors daily.',
        subtext: '南锣鼓巷'),
      _card(2, 'Comm Chest', false),
      _property(3, 'Houhai', 'brown', PropertyGroups.brown, 60, [4, 20, 60, 180, 320, 450],
        funFact: 'Since the Qing Dynasty (1644-1912), emperors held grand ice skating competitions here each winter. The lake covers 34 hectares and is surrounded by centuries-old courtyard homes.',
        subtext: '后海'),
      _tax(4, 'Income Tax', 200),
      _railroad(5, 'Line 1', subtext: '地铁1号线',
        funFact: 'Opened on October 1, 1969 for military use and to the public in 1971, Line 1 stretches 31 km with 23 stations and was China\'s first underground railway.'),
      _property(6, 'Wangfujing', 'lightBlue', PropertyGroups.lightBlue, 100, [6, 30, 90, 270, 400, 550],
        funFact: 'Established during the Yuan Dynasty around 1280, this 810-meter street was named after a sweet-water well discovered in a prince\'s mansion. Today it draws over 600,000 shoppers daily.',
        subtext: '王府井'),
      _card(7, 'Chance', true),
      _property(8, 'Sanlitun', 'lightBlue', PropertyGroups.lightBlue, 100, [6, 30, 90, 270, 400, 550],
        funFact: 'Named for being exactly three li (1.5 km) from the old city wall, Sanlitun hosts over 70 foreign embassies and became Beijing\'s nightlife hub after the 1990s bar street boom.',
        subtext: '三里屯'),
      _property(9, 'CBD', 'lightBlue', PropertyGroups.lightBlue, 120, [8, 40, 100, 300, 450, 600],
        funFact: 'Established in 2001, Beijing\'s CBD spans 3.99 sq km in Chaoyang and houses over 60% of Fortune 500 regional headquarters in the city.',
        subtext: '国贸'),
      _corner(10, 'JAIL', TileType.jail, color: const Color(0xFFFFE0B2), subtext: '监狱'),

      // Left column (bottom to top: 11-20)
      _property(11, 'Dongcheng', 'pink', PropertyGroups.pink, 140, [10, 50, 150, 450, 625, 750],
        funFact: 'Covering 41.84 sq km, Dongcheng contains over 200 protected historical hutongs and was the site of the imperial examinations that shaped Chinese governance for 1,300 years.',
        subtext: '东城区'),
      _utility(12, 'State Grid', true,
        funFact: 'Founded in 2002, State Grid is the world\'s largest utility company by revenue (\$383 billion in 2022) and operates over 1 million km of power lines across 88% of China.'),
      _property(13, 'Beihai Park', 'pink', PropertyGroups.pink, 140, [10, 50, 150, 450, 625, 750],
        funFact: 'First built in 938 AD, Beihai is one of the oldest imperial gardens in China. Its iconic 36-meter White Dagoba was erected in 1651 to honor the 5th Dalai Lama\'s visit.',
        subtext: '北海公园'),
      _property(14, 'Jingshan', 'pink', PropertyGroups.pink, 160, [12, 60, 180, 500, 700, 900],
        funFact: 'Built from earth excavated while constructing the Forbidden City moat in 1421, this 45-meter hill is where the last Ming Emperor Chongzhen tragically ended his life in 1644.',
        subtext: '景山'),
      _railroad(15, 'Line 2', subtext: '地铁2号线',
        funFact: 'Opened in 1984, Line 2 traces the demolished Ming Dynasty city wall in a 23 km loop with 18 stations. It was the first metro line in China to use automated fare collection.'),
      _property(16, 'Lama Temple', 'orange', PropertyGroups.orange, 180, [14, 70, 200, 550, 750, 950],
        funFact: 'Originally built as an imperial residence in 1694, it became a Tibetan Buddhist monastery in 1744. Its 18-meter Maitreya Buddha was carved from a single white sandalwood tree gifted by the 7th Dalai Lama.',
        subtext: '雍和宫'),
      _card(17, 'Comm Chest', false),
      _property(18, 'Temple of Heaven', 'orange', PropertyGroups.orange, 180, [14, 70, 200, 550, 750, 950],
        funFact: 'Built in 1420 by the Yongle Emperor, this UNESCO World Heritage Site spans 273 hectares, nearly four times the size of the Forbidden City. Its Hall of Prayer has no nails or cement.',
        subtext: '天坛'),
      _property(19, 'Summer Palace', 'orange', PropertyGroups.orange, 200, [16, 80, 220, 600, 800, 1000],
        funFact: 'Empress Cixi controversially diverted 30 million taels of silver from the navy budget in 1888 to rebuild this garden. Its Long Corridor stretches 728 meters with over 14,000 painted scenes.',
        subtext: '颐和园'),
      _corner(20, 'LUCKY SPIN', TileType.freeParking, subtext: '幸运转盘'),

      // Top row (left to right: 21-30)
      _property(21, 'Drum Tower', 'red', PropertyGroups.red, 220, [18, 90, 250, 700, 875, 1050],
        funFact: 'Originally built by Kublai Khan in 1272, the current tower dates from 1420 and stands 47 meters tall. Its 25 drums were beaten 13 times at dusk to signal the city gates\' closing.',
        subtext: '鼓楼'),
      _card(22, 'Chance', true),
      _property(23, 'Bell Tower', 'red', PropertyGroups.red, 220, [18, 90, 250, 700, 875, 1050],
        funFact: 'Rebuilt in 1745, the Bell Tower houses a 63-ton bronze bell cast during the Yongle era (1420) that could be heard over 20 km away. Legend says a girl sacrificed herself in the molten bronze to perfect the casting.',
        subtext: '钟楼'),
      _property(24, 'Tiananmen', 'red', PropertyGroups.red, 240, [20, 100, 300, 750, 925, 1100],
        funFact: 'The gate was built in 1420 and reconstructed in 1651. Tiananmen Square itself was enlarged to 44 hectares in 1959, making it the world\'s largest public square.',
        subtext: '天安门'),
      _railroad(25, 'Line 4', subtext: '地铁4号线',
        funFact: 'Opened on September 28, 2009, Line 4 runs 28.2 km with 24 stations and was Beijing\'s first public-private partnership metro line, co-operated with Hong Kong\'s MTR Corporation.'),
      _property(26, 'Chaoyang', 'yellow', PropertyGroups.yellow, 260, [22, 110, 330, 800, 975, 1150],
        funFact: 'With 3.45 million residents across 455 sq km, Chaoyang is Beijing\'s largest urban district. It houses over 130 foreign embassies and generates nearly 30% of Beijing\'s GDP.',
        subtext: '朝阳区'),
      _property(27, 'Olympic Park', 'yellow', PropertyGroups.yellow, 260, [22, 110, 330, 800, 975, 1150],
        funFact: 'Built for the 2008 Summer Olympics at a cost of \$480 million, the Bird\'s Nest used 42,000 tons of steel and seats 91,000. The park also hosted events for the 2022 Winter Olympics.',
        subtext: '奥林匹克公园'),
      _utility(28, 'Beijing Water', false,
        funFact: 'The South-to-North Water Diversion Project, conceived by Mao Zedong in 1952 and begun in 2002, cost over \$80 billion and channels water 1,432 km from the Yangtze River to parched Beijing.'),
      _property(29, 'Zhongguancun', 'yellow', PropertyGroups.yellow, 280, [24, 120, 360, 850, 1025, 1200],
        funFact: 'Dubbed \"China\'s Silicon Valley\" since the 1980s, Zhongguancun hosts over 20,000 tech firms and was where Lenovo was founded in a guardhouse with just \$25,000 in 1984.',
        subtext: '中关村'),
      _corner(30, 'GO TO JAIL', TileType.goToJail, subtext: '去监狱'),

      // Right column (top to bottom: 31-39)
      _property(31, 'Silk Street', 'green', PropertyGroups.green, 300, [26, 130, 390, 900, 1100, 1275],
        funFact: 'Originally an open-air market that sprang up in the 1980s to serve foreign embassy staff, Silk Street moved into a 7-story, 28,000 sq meter building in 2005 and receives 20,000 visitors daily.',
        subtext: '秀水街'),
      _property(32, 'Panjiayuan', 'green', PropertyGroups.green, 300, [26, 130, 390, 900, 1100, 1275],
        funFact: 'Open since 1992, this 48,500 sq meter market is Asia\'s largest antique bazaar with over 3,000 vendors selling everything from Ming Dynasty porcelain to Cultural Revolution memorabilia.',
        subtext: '潘家园'),
      _card(33, 'Comm Chest', false),
      _property(34, 'National Museum', 'green', PropertyGroups.green, 320, [28, 150, 450, 1000, 1200, 1400],
        funFact: 'Reopened in 2011 after a \$400 million renovation, the National Museum of China spans 192,000 sq meters and holds over 1.4 million artifacts spanning 1.7 million years of Chinese civilization.',
        subtext: '国家博物馆'),
      _railroad(35, 'Line 10', subtext: '地铁10号线',
        funFact: 'Completed as a full loop in 2013, Line 10 is Beijing\'s longest single metro line at 57.1 km with 45 stations, carrying over 2 million passengers daily around the city\'s Third Ring Road.'),
      _card(36, 'Chance', true),
      _property(37, 'CCTV Tower', 'darkBlue', PropertyGroups.darkBlue, 350, [35, 175, 500, 1100, 1300, 1500],
        funFact: 'Completed in 2012 at a cost of \$800 million, this 234-meter OMA-designed tower uses 10,000 tons of structural steel in its continuous loop and was nicknamed "Big Underpants" by locals.',
        subtext: '央视大楼'),
      _tax(38, 'Luxury Tax', 100),
      _property(39, 'Forbidden City', 'darkBlue', PropertyGroups.darkBlue, 400, [50, 200, 600, 1400, 1700, 2000],
        funFact: 'Built between 1406-1420 by over 1 million workers, the Forbidden City spans 72 hectares with 980 buildings and 8,728 rooms. It served as home to 24 emperors across the Ming and Qing dynasties.',
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

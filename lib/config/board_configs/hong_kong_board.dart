import 'package:flutter/material.dart';
import '../../models/tile.dart';

/// Hong Kong Monopoly board configuration with 40 tiles
class HongKongBoard {
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

  /// Railroad positions (MTR and ferries in Hong Kong)
  static const List<int> railroadPositions = [5, 15, 25, 35];

  /// Utility positions
  static const List<int> utilityPositions = [12, 28];

  /// Chance card positions
  static const List<int> chancePositions = [7, 22, 36];

  /// Community Chest positions
  static const List<int> communityChestPositions = [2, 17, 33];

  /// Generate all 40 tiles for the Hong Kong board
  static List<TileData> generateTiles() {
    return [
      // Bottom row (right to left: 0-10)
      _corner(0, 'GO', TileType.start, subtext: '开始'),
      _property(1, 'Sham Shui Po', 'brown', PropertyGroups.brown, 60, [2, 10, 30, 90, 160, 250],
        funFact: 'Sham Shui Po is one of Hong Kong\'s oldest neighborhoods, famous for its electronics markets on Apliu Street and fabric shops on Ki Lung Street dating back to the 1940s.',
        subtext: '深水埗'),
      _card(2, 'Comm Chest', false),
      _property(3, 'Mong Kok', 'brown', PropertyGroups.brown, 60, [4, 20, 60, 180, 320, 450],
        funFact: 'Mong Kok holds the Guinness World Record for the highest population density ever recorded, with over 130,000 people per square kilometer in its peak years.',
        subtext: '旺角'),
      _tax(4, 'Income Tax', 200),
      _railroad(5, 'MTR Island Line', subtext: '港铁港岛线',
        funFact: 'The MTR Island Line opened in 1985 and runs entirely on Hong Kong Island, connecting Kennedy Town to Chai Wan across 17 stations.'),
      _property(6, 'Tsim Sha Tsui', 'lightBlue', PropertyGroups.lightBlue, 100, [6, 30, 90, 270, 400, 550],
        funFact: 'Tsim Sha Tsui\'s waterfront promenade offers the iconic view of Victoria Harbour, and its Clock Tower, built in 1915, is the only remaining structure of the original Kowloon-Canton Railway terminus.',
        subtext: '尖沙咀'),
      _card(7, 'Chance', true),
      _property(8, 'Yau Ma Tei', 'lightBlue', PropertyGroups.lightBlue, 100, [6, 30, 90, 270, 400, 550],
        funFact: 'Yau Ma Tei\'s name means "place of sesame plants" in Cantonese, and its Tin Hau Temple complex, built around 1870, is one of the oldest temple clusters in Kowloon.',
        subtext: '油麻地'),
      _property(9, 'Jordan', 'lightBlue', PropertyGroups.lightBlue, 120, [8, 40, 100, 300, 450, 600],
        funFact: 'Jordan is named after Sir John Jordan, a British diplomat, and is famous for its late-night street food stalls along Ning Po Street that have been serving locals for over 50 years.',
        subtext: '佐敦'),
      _corner(10, 'JAIL', TileType.jail, color: const Color(0xFFFFE0B2), subtext: '监狱'),

      // Left column (bottom to top: 11-20)
      _property(11, 'Temple Street', 'pink', PropertyGroups.pink, 140, [10, 50, 150, 450, 625, 750],
        funFact: 'Temple Street Night Market comes alive after 6 PM with over 300 stalls selling everything from electronics to jade, and fortune tellers and Cantonese opera singers perform under the stars.',
        subtext: '庙街'),
      _utility(12, 'CLP Power', true,
        funFact: 'CLP Power has been supplying electricity to Kowloon and the New Territories since 1901, serving over 2.7 million customer accounts across Hong Kong.'),
      _property(13, 'Nathan Road', 'pink', PropertyGroups.pink, 140, [10, 50, 150, 450, 625, 750],
        funFact: 'Nathan Road stretches 3.6 km through Kowloon and is known as the "Golden Mile" due to its dense concentration of shops, hotels, and glowing neon signs.',
        subtext: '弥敦道'),
      _property(14, 'Victoria Peak', 'pink', PropertyGroups.pink, 160, [12, 60, 180, 500, 700, 900],
        funFact: 'Victoria Peak stands 552 meters above sea level and during the colonial era, only the Governor and select wealthy residents were permitted to live at the summit.',
        subtext: '太平山'),
      _railroad(15, 'MTR Tsuen Wan Line', subtext: '港铁荃湾线',
        funFact: 'The Tsuen Wan Line was the first cross-harbour rail line when it opened in 1979, connecting Hong Kong Island to Kowloon via the immersed tube tunnel under Victoria Harbour.'),
      _property(16, 'Central', 'orange', PropertyGroups.orange, 180, [14, 70, 200, 550, 750, 950],
        funFact: 'Central is the financial heart of Hong Kong where office rents regularly rank among the highest in the world, surpassing even Manhattan and London\'s City district.',
        subtext: '中环'),
      _card(17, 'Comm Chest', false),
      _property(18, 'Star Ferry', 'orange', PropertyGroups.orange, 180, [14, 70, 200, 550, 750, 950],
        funFact: 'The Star Ferry has been crossing Victoria Harbour since 1888, and National Geographic named it one of the 50 Places of a Lifetime. A single ride costs less than HK\$5!',
        subtext: '天星小轮'),
      _property(19, 'Wan Chai', 'orange', PropertyGroups.orange, 200, [16, 80, 220, 600, 800, 1000],
        funFact: 'Wan Chai is home to the Hong Kong Convention and Exhibition Centre, whose distinctive wing-shaped roof extends over the harbour and was the venue for the 1997 Handover Ceremony.',
        subtext: '湾仔'),
      _corner(20, 'LUCKY SPIN', TileType.freeParking, subtext: '幸运转盘'),

      // Top row (left to right: 21-30)
      _property(21, 'Happy Valley', 'red', PropertyGroups.red, 220, [18, 90, 250, 700, 875, 1050],
        funFact: 'Happy Valley Racecourse has hosted horse racing since 1846 and is surrounded by high-rise apartments; Wednesday night races under floodlights attract up to 55,000 spectators.',
        subtext: '跑马地'),
      _card(22, 'Chance', true),
      _property(23, 'Causeway Bay', 'red', PropertyGroups.red, 220, [18, 90, 250, 700, 875, 1050],
        funFact: 'Causeway Bay has repeatedly topped global rankings as the most expensive retail district in the world, with rents reaching over US\$2,600 per square foot annually.',
        subtext: '铜锣湾'),
      _property(24, 'Aberdeen', 'red', PropertyGroups.red, 240, [20, 100, 300, 750, 925, 1100],
        funFact: 'Aberdeen Harbour was once home to thousands of Tanka boat-dwellers who lived their entire lives on sampans; the floating Jumbo Kingdom restaurant served over 30 million guests before closing.',
        subtext: '香港仔'),
      _railroad(25, 'Peak Tram', subtext: '山顶缆车',
        funFact: 'The Peak Tram has been carrying passengers up Victoria Peak since 1888 at a steep 27-degree gradient, making it one of the world\'s oldest and steepest funicular railways.'),
      _property(26, 'Repulse Bay', 'yellow', PropertyGroups.yellow, 260, [22, 110, 330, 800, 975, 1150],
        funFact: 'Repulse Bay gets its name from a British warship HMS Repulse that helped repel pirates in the area in 1841; its crescent-shaped beach is one of the most popular in Hong Kong.',
        subtext: '浅水湾'),
      _property(27, 'Stanley', 'yellow', PropertyGroups.yellow, 260, [22, 110, 330, 800, 975, 1150],
        funFact: 'Stanley was the site of the last British stand during the Japanese invasion of 1941, and Murray House, a 170-year-old colonial building, was relocated here brick by brick from Central.',
        subtext: '赤柱'),
      _utility(28, 'Water Supplies Dept', false,
        funFact: 'Hong Kong\'s Water Supplies Department manages 17 impounding reservoirs and imports about 70-80% of its fresh water from Dongjiang in Guangdong province through a dedicated pipeline system.'),
      _property(29, 'Lan Kwai Fong', 'yellow', PropertyGroups.yellow, 280, [24, 120, 360, 850, 1025, 1200],
        funFact: 'Lan Kwai Fong is an L-shaped street with over 90 restaurants and bars packed into just a few blocks, transformed from a flower market area in the 1980s by entrepreneur Allan Zeman.',
        subtext: '兰桂坊'),
      _corner(30, 'GO TO JAIL', TileType.goToJail, subtext: '去监狱'),

      // Right column (top to bottom: 31-39)
      _property(31, 'IFC Mall', 'green', PropertyGroups.green, 300, [26, 130, 390, 900, 1100, 1275],
        funFact: 'The International Finance Centre complex includes Two IFC, which stands 415 meters tall and was the tallest building in Hong Kong until 2010; the Apple Store at IFC Mall was the first in Hong Kong.',
        subtext: '国际金融中心'),
      _property(32, 'Ocean Park', 'green', PropertyGroups.green, 300, [26, 130, 390, 900, 1100, 1275],
        funFact: 'Ocean Park opened in 1977 and spans 91.5 hectares across two sides of a mountain connected by a 1.5 km cable car ride offering sweeping views of the South China Sea.',
        subtext: '海洋公园'),
      _card(33, 'Comm Chest', false),
      _property(34, 'Hong Kong Park', 'green', PropertyGroups.green, 320, [28, 150, 450, 1000, 1200, 1400],
        funFact: 'Hong Kong Park is an 8-hectare oasis in the heart of the city featuring the Edward Youde Aviary, which houses over 600 birds of 80 species in a giant walk-through rainforest enclosure.',
        subtext: '香港公园'),
      _railroad(35, 'Star Ferry', subtext: '天星小轮',
        funFact: 'The Star Ferry operates a fleet of 9 double-decker vessels, each named with the word "Star," and completes the crossing of Victoria Harbour in just 7 minutes.'),
      _card(36, 'Chance', true),
      _property(37, 'ICC Tower', 'darkBlue', PropertyGroups.darkBlue, 350, [35, 175, 500, 1100, 1300, 1500],
        funFact: 'The International Commerce Centre stands 484 meters tall with 118 floors, and its Sky100 observation deck on the 100th floor is Hong Kong\'s highest indoor viewpoint.',
        subtext: '环球贸易广场'),
      _tax(38, 'Luxury Tax', 100),
      _property(39, 'The Peak Tower', 'darkBlue', PropertyGroups.darkBlue, 400, [50, 200, 600, 1400, 1700, 2000],
        funFact: 'The Peak Tower\'s wok-shaped design by British architect Terry Farrell sits at 396 meters above sea level, and on clear days its viewing terrace offers visibility of up to 60 kilometers.',
        subtext: '凌霄阁'),
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

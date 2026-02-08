import 'package:flutter/material.dart';
import '../../models/tile.dart';

/// Shanghai Monopoly board configuration with 40 tiles
class ShanghaiBoard {
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

  /// Railroad positions (Metro Lines in Shanghai)
  static const List<int> railroadPositions = [5, 15, 25, 35];

  /// Utility positions
  static const List<int> utilityPositions = [12, 28];

  /// Chance card positions
  static const List<int> chancePositions = [7, 22, 36];

  /// Community Chest positions
  static const List<int> communityChestPositions = [2, 17, 33];

  /// Generate all 40 tiles for the Shanghai board
  static List<TileData> generateTiles() {
    return [
      // Bottom row (right to left: 0-10)
      _corner(0, 'GO', TileType.start, subtext: '开始'),
      _property(1, 'Tianzifang', 'brown', PropertyGroups.brown, 60, [2, 10, 30, 90, 160, 250],
        funFact: 'Tianzifang is a labyrinth of narrow alleys in a 1930s shikumen housing complex, now filled with over 200 tiny art studios, boutiques, and cafes.',
        subtext: '田子坊'),
      _card(2, 'Comm Chest', false),
      _property(3, 'Old City', 'brown', PropertyGroups.brown, 60, [4, 20, 60, 180, 320, 450],
        funFact: 'The Old City was once enclosed by a circular wall built in 1553 to defend against Japanese pirates, and its outline can still be traced in the street layout today.',
        subtext: '老城厢'),
      _tax(4, 'Income Tax', 200),
      _railroad(5, 'Metro Line 1', subtext: '地铁1号线',
        funFact: 'Shanghai Metro Line 1 opened in 1995 as the city\'s first subway line, running 36.9 km from Fujin Road to Xinzhuang.'),
      _property(6, 'People\'s Square', 'lightBlue', PropertyGroups.lightBlue, 100, [6, 30, 90, 270, 400, 550],
        funFact: 'People\'s Square was formerly the Shanghai Racecourse built by the British in 1862, and it was converted into a public park after 1949.',
        subtext: '人民广场'),
      _card(7, 'Chance', true),
      _property(8, 'Jing\'an Temple', 'lightBlue', PropertyGroups.lightBlue, 100, [6, 30, 90, 270, 400, 550],
        funFact: 'Jing\'an Temple was originally built in 247 AD during the Three Kingdoms period, making it one of the oldest temples in Shanghai at over 1,700 years old.',
        subtext: '静安寺'),
      _property(9, 'Xintiandi', 'lightBlue', PropertyGroups.lightBlue, 120, [8, 40, 100, 300, 450, 600],
        funFact: 'Xintiandi is a masterful restoration of traditional shikumen stone-gate houses into an upscale dining and entertainment district, and it also houses the site of the First National Congress of the Chinese Communist Party.',
        subtext: '新天地'),
      _corner(10, 'JAIL', TileType.jail, color: const Color(0xFFFFE0B2), subtext: '监狱'),

      // Left column (bottom to top: 11-20)
      _property(11, 'Yu Garden', 'pink', PropertyGroups.pink, 140, [10, 50, 150, 450, 625, 750],
        funFact: 'Yu Garden was built in 1559 by a Ming Dynasty official for his aging father; the name "Yu" means "pleasing" and the garden spans over 2 hectares with exquisite rockeries and pavilions.',
        subtext: '豫园'),
      _utility(12, 'State Grid Shanghai', true,
        funFact: 'State Grid Shanghai supplies electricity to over 24 million residents and manages a peak load exceeding 34 million kilowatts during summer.'),
      _property(13, 'Nanjing Road', 'pink', PropertyGroups.pink, 140, [10, 50, 150, 450, 625, 750],
        funFact: 'Nanjing Road stretches 5.5 km and is one of the world\'s busiest shopping streets, attracting over 1 million visitors daily on peak days.',
        subtext: '南京路'),
      _property(14, 'The Bund', 'pink', PropertyGroups.pink, 160, [12, 60, 180, 500, 700, 900],
        funFact: 'The Bund features 52 buildings in a stunning mix of Gothic, Baroque, Romanesque, and Art Deco styles, earning it the nickname "Museum of International Architecture."',
        subtext: '外滩'),
      _railroad(15, 'Metro Line 2', subtext: '地铁2号线',
        funFact: 'Metro Line 2 connects Pudong International Airport to Hongqiao Airport, spanning 64 km across the entire city from east to west.'),
      _property(16, 'French Concession', 'orange', PropertyGroups.orange, 180, [14, 70, 200, 550, 750, 950],
        funFact: 'The French Concession was established in 1849 and is famous for its tree-lined avenues of plane trees, which were imported from France over a century ago.',
        subtext: '法租界'),
      _card(17, 'Comm Chest', false),
      _property(18, 'Huangpu River', 'orange', PropertyGroups.orange, 180, [14, 70, 200, 550, 750, 950],
        funFact: 'The Huangpu River is 113 km long and divides Shanghai into Puxi and Pudong; its name literally means "Yellow Bank River" and it flows into the Yangtze at Wusongkou.',
        subtext: '黄浦江'),
      _property(19, 'Oriental Pearl', 'orange', PropertyGroups.orange, 200, [16, 80, 220, 600, 800, 1000],
        funFact: 'The Oriental Pearl Tower stands 468 meters tall and was the tallest structure in China when completed in 1994; its glass floor observation deck at 259 meters offers a thrilling view straight down.',
        subtext: '东方明珠'),
      _corner(20, 'LUCKY SPIN', TileType.freeParking, subtext: '幸运转盘'),

      // Top row (left to right: 21-30)
      _property(21, 'Shanghai Tower', 'red', PropertyGroups.red, 220, [18, 90, 250, 700, 875, 1050],
        funFact: 'Shanghai Tower is the tallest building in China and the third tallest in the world at 632 meters, featuring 127 stories and the world\'s highest observation deck at 561 meters.',
        subtext: '上海中心'),
      _card(22, 'Chance', true),
      _property(23, 'Lujiazui', 'red', PropertyGroups.red, 220, [18, 90, 250, 700, 875, 1050],
        funFact: 'Lujiazui is the only national-level financial zone named after a person; "Lu Jiazui" refers to the Lu family who once lived at this bend in the Huangpu River.',
        subtext: '陆家嘴'),
      _property(24, 'Pudong', 'red', PropertyGroups.red, 240, [20, 100, 300, 750, 925, 1100],
        funFact: 'Before 1990, Pudong was mostly farmland; a popular saying went "Rather a bed in Puxi than a room in Pudong," but today it is home to China\'s tallest skyscrapers and busiest financial district.',
        subtext: '浦东'),
      _railroad(25, 'Maglev Train', subtext: '磁悬浮列车',
        funFact: 'The Shanghai Maglev reaches a top speed of 431 km/h, covering the 30 km from Pudong Airport to Longyang Road in just 7 minutes and 20 seconds.'),
      _property(26, 'Zhujiajiao', 'yellow', PropertyGroups.yellow, 260, [22, 110, 330, 800, 975, 1150],
        funFact: 'Zhujiajiao is a 1,700-year-old water town with 36 ancient stone bridges; its Fangsheng Bridge, built in 1571, is the longest and tallest stone bridge in the Shanghai region.',
        subtext: '朱家角'),
      _property(27, 'Longhua Temple', 'yellow', PropertyGroups.yellow, 260, [22, 110, 330, 800, 975, 1150],
        funFact: 'Longhua Temple is the oldest and largest temple complex in Shanghai, originally founded in 242 AD; its seven-story pagoda leans slightly and has never been open to the public.',
        subtext: '龙华寺'),
      _utility(28, 'Shanghai Water', false,
        funFact: 'Shanghai Water supplies over 7.3 million cubic meters of tap water daily to the city, primarily sourced from the Qingcaosha Reservoir on Changxing Island in the Yangtze estuary.'),
      _property(29, 'Jade Buddha', 'yellow', PropertyGroups.yellow, 280, [24, 120, 360, 850, 1025, 1200],
        funFact: 'The Jade Buddha Temple houses two jade Buddha statues brought from Burma in 1882; the sitting Buddha is 1.95 meters tall and encrusted with precious gems.',
        subtext: '玉佛寺'),
      _corner(30, 'GO TO JAIL', TileType.goToJail, subtext: '去监狱'),

      // Right column (top to bottom: 31-39)
      _property(31, 'Hongqiao', 'green', PropertyGroups.green, 300, [26, 130, 390, 900, 1100, 1275],
        funFact: 'Hongqiao Transportation Hub is one of the largest in Asia, integrating an airport, high-speed rail station, metro lines, and bus terminals into a single complex serving over 300,000 passengers daily.',
        subtext: '虹桥'),
      _property(32, 'Hengshan Road', 'green', PropertyGroups.green, 300, [26, 130, 390, 900, 1100, 1275],
        funFact: 'Hengshan Road is lined with century-old plane trees and elegant European-style villas from the 1920s, once home to foreign diplomats and wealthy Shanghai families.',
        subtext: '衡山路'),
      _card(33, 'Comm Chest', false),
      _property(34, 'World Financial Center', 'green', PropertyGroups.green, 320, [28, 150, 450, 1000, 1200, 1400],
        funFact: 'The Shanghai World Financial Center stands 492 meters tall and its distinctive trapezoidal opening at the top earned it the nickname "The Bottle Opener" among locals.',
        subtext: '环球金融'),
      _railroad(35, 'Metro Line 10', subtext: '地铁10号线',
        funFact: 'Metro Line 10 was Shanghai\'s first driverless metro line when it opened in 2010, running fully automated trains across 41 stations.'),
      _card(36, 'Chance', true),
      _property(37, 'Jin Mao Tower', 'darkBlue', PropertyGroups.darkBlue, 350, [35, 175, 500, 1100, 1300, 1500],
        funFact: 'Jin Mao Tower stands 420.5 meters with 88 floors, and its design is based on the lucky number 8: the building tapers in segments of 1/8, creating a pagoda-like silhouette.',
        subtext: '金茂大厦'),
      _tax(38, 'Luxury Tax', 100),
      _property(39, 'Disneyland', 'darkBlue', PropertyGroups.darkBlue, 400, [50, 200, 600, 1400, 1700, 2000],
        funFact: 'Shanghai Disneyland opened in 2016 and features the largest Disney castle ever built, the Enchanted Storybook Castle, standing 60 meters tall with interactive walk-through attractions inside.',
        subtext: '迪士尼'),
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

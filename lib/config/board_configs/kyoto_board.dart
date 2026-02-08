import 'package:flutter/material.dart';
import '../../models/tile.dart';

/// Kyoto Monopoly board configuration with 40 tiles
class KyotoBoard {
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

  /// Railroad positions (Train Lines in Kyoto)
  static const List<int> railroadPositions = [5, 15, 25, 35];

  /// Utility positions
  static const List<int> utilityPositions = [12, 28];

  /// Chance card positions
  static const List<int> chancePositions = [7, 22, 36];

  /// Community Chest positions
  static const List<int> communityChestPositions = [2, 17, 33];

  /// Generate all 40 tiles for the Kyoto board
  static List<TileData> generateTiles() {
    return [
      // Bottom row (right to left: 0-10)
      _corner(0, 'GO', TileType.start, subtext: 'スタート'),
      _property(1, 'Tofukuji', 'brown', PropertyGroups.brown, 60, [2, 10, 30, 90, 160, 250],
        funFact: 'Founded in 1236 by Kujo Michiie, Tofukuji\'s Tsutenkyo Bridge offers one of Kyoto\'s most stunning autumn views over a valley of 2,000 maple trees!',
        subtext: '東福寺'),
      _card(2, 'Comm Chest', false),
      _property(3, 'Fushimi', 'brown', PropertyGroups.brown, 60, [4, 20, 60, 180, 320, 450],
        funFact: 'Fushimi is Kyoto\'s legendary sake brewing district, producing about 40% of all sake in Japan thanks to its pristine underground spring water!',
        subtext: '伏見'),
      _tax(4, 'Income Tax', 200),
      _railroad(5, 'Hankyu Line', subtext: '阪急線',
        funFact: 'The Hankyu Kyoto Line has connected Kyoto and Osaka since 1928, famous for its distinctive maroon-colored trains and elegant Kawaramachi terminus!'),
      _property(6, 'Nijo Castle', 'lightBlue', PropertyGroups.lightBlue, 100, [6, 30, 90, 270, 400, 550],
        funFact: 'Built in 1603 by Tokugawa Ieyasu, Nijo Castle features "nightingale floors" that chirp when walked upon to alert against ninja intruders!',
        subtext: '二条城'),
      _card(7, 'Chance', true),
      _property(8, 'Gion', 'lightBlue', PropertyGroups.lightBlue, 100, [6, 30, 90, 270, 400, 550],
        funFact: 'Gion is Kyoto\'s most famous geisha district, where around 200 geiko and maiko still practice traditional arts dating back to the 17th century!',
        subtext: '祇園'),
      _property(9, 'Pontocho', 'lightBlue', PropertyGroups.lightBlue, 120, [8, 40, 100, 300, 450, 600],
        funFact: 'Pontocho is a narrow alley just one block wide running 500 meters along the Kamo River, lined with traditional restaurants and summer dining platforms called kawayuka!',
        subtext: '先斗町'),
      _corner(10, 'JAIL', TileType.jail, color: const Color(0xFFFFE0B2), subtext: '刑務所'),

      // Left column (bottom to top: 11-20)
      _property(11, 'Kinkaku-ji', 'pink', PropertyGroups.pink, 140, [10, 50, 150, 450, 625, 750],
        funFact: 'The Golden Pavilion\'s top two floors are covered in pure gold leaf! Originally built in 1397, it was rebuilt in 1955 after a monk set it on fire.',
        subtext: '金閣寺'),
      _utility(12, 'Kansai Electric Power', true,
        funFact: 'Founded in 1951, Kansai Electric Power supplies electricity to over 13 million customers across the entire Kansai region of western Japan!'),
      _property(13, 'Ryoan-ji', 'pink', PropertyGroups.pink, 140, [10, 50, 150, 450, 625, 750],
        funFact: 'Ryoan-ji\'s famous rock garden contains 15 stones arranged so that no matter where you stand, only 14 are visible at once, symbolizing the incompleteness of human perspective!',
        subtext: '龍安寺'),
      _property(14, 'Ninna-ji', 'pink', PropertyGroups.pink, 160, [12, 60, 180, 500, 700, 900],
        funFact: 'Founded in 888 AD by Emperor Uda, Ninna-ji is famous for its late-blooming Omuro cherry trees that grow only 2-3 meters tall, a UNESCO World Heritage Site!',
        subtext: '仁和寺'),
      _railroad(15, 'JR Sagano Line', subtext: 'JR嵯峨野線',
        funFact: 'The JR Sagano Line runs through western Kyoto to Arashiyama, and the scenic Sagano Romantic Train covers 7.3 kilometers along the Hozu River gorge!'),
      _property(16, 'Arashiyama', 'orange', PropertyGroups.orange, 180, [14, 70, 200, 550, 750, 950],
        funFact: 'Arashiyama has been a popular retreat since the Heian period over 1,000 years ago, when nobles built villas here to enjoy the mountain scenery and autumn colors!',
        subtext: '嵐山'),
      _card(17, 'Comm Chest', false),
      _property(18, 'Bamboo Grove', 'orange', PropertyGroups.orange, 180, [14, 70, 200, 550, 750, 950],
        funFact: 'The Arashiyama Bamboo Grove\'s towering stalks reach heights of over 20 meters, and the sound of wind through the bamboo was voted one of Japan\'s top 100 soundscapes!',
        subtext: '竹林'),
      _property(19, 'Togetsukyo', 'orange', PropertyGroups.orange, 200, [16, 80, 220, 600, 800, 1000],
        funFact: 'The "Moon Crossing Bridge" was first built during the Heian period in the 9th century. Its name comes from Emperor Kameyama who saw the moon appear to cross the bridge!',
        subtext: '渡月橋'),
      _corner(20, 'LUCKY SPIN', TileType.freeParking, subtext: 'ラッキースピン'),

      // Top row (left to right: 21-30)
      _property(21, 'Kiyomizu-dera', 'red', PropertyGroups.red, 220, [18, 90, 250, 700, 875, 1050],
        funFact: 'Built in 778 AD, Kiyomizu-dera\'s famous wooden stage juts out 13 meters over the hillside, constructed without a single nail using a special interlocking technique!',
        subtext: '清水寺'),
      _card(22, 'Chance', true),
      _property(23, 'Sannenzaka', 'red', PropertyGroups.red, 220, [18, 90, 250, 700, 875, 1050],
        funFact: 'This preserved stone-paved slope dates back to 807 AD. Local superstition says if you stumble on these steps, you will have three years of bad luck!',
        subtext: '三年坂'),
      _property(24, 'Higashiyama', 'red', PropertyGroups.red, 240, [20, 100, 300, 750, 925, 1100],
        funFact: 'The Higashiyama district is one of the best-preserved historic areas in Japan, with traditional wooden machiya townhouses and over 2,500 temples and shrines!',
        subtext: '東山'),
      _railroad(25, 'Keifuku Line', subtext: '嵐電',
        funFact: 'Known lovingly as "Randen," the Keifuku Electric Railroad has been running since 1910 and is Kyoto\'s only remaining streetcar line at 7.2 kilometers!'),
      _property(26, 'Imperial Palace', 'yellow', PropertyGroups.yellow, 260, [22, 110, 330, 800, 975, 1150],
        funFact: 'The Kyoto Imperial Palace served as the residence of Japan\'s Emperor for over 1,000 years until the capital moved to Tokyo in 1869!',
        subtext: '京都御所'),
      _property(27, 'Shimogamo', 'yellow', PropertyGroups.yellow, 260, [22, 110, 330, 800, 975, 1150],
        funFact: 'Shimogamo Shrine, formally Kamo Mioya Jinja, is one of Kyoto\'s oldest shrines predating the city itself, with a sacred forest called Tadasu no Mori that is over 2,000 years old!',
        subtext: '下鴨'),
      _utility(28, 'Kyoto Water', false,
        funFact: 'Kyoto\'s water supply system, drawing from Lake Biwa through the 1890 Lake Biwa Canal, was one of Japan\'s first modern hydroelectric power projects!'),
      _property(29, 'Philosopher Path', 'yellow', PropertyGroups.yellow, 280, [24, 120, 360, 850, 1025, 1200],
        funFact: 'This 2-kilometer stone path along a canal is named after philosopher Nishida Kitaro who meditated here daily. It is lined with hundreds of cherry trees donated in 1921!',
        subtext: '哲学の道'),
      _corner(30, 'GO TO JAIL', TileType.goToJail, subtext: '刑務所へ'),

      // Right column (top to bottom: 31-39)
      _property(31, 'Fushimi Inari', 'green', PropertyGroups.green, 300, [26, 130, 390, 900, 1100, 1275],
        funFact: 'Fushimi Inari Taisha features over 10,000 vermillion torii gates winding 4 kilometers up Mount Inari, donated by businesses since the Edo period for good fortune!',
        subtext: '伏見稲荷'),
      _property(32, 'Byodo-in', 'green', PropertyGroups.green, 300, [26, 130, 390, 900, 1100, 1275],
        funFact: 'Built in 1053, Byodo-in\'s Phoenix Hall is depicted on the Japanese 10-yen coin! It is the only surviving example of Heian-period Pure Land Buddhist architecture.',
        subtext: '平等院'),
      _card(33, 'Comm Chest', false),
      _property(34, 'Uji', 'green', PropertyGroups.green, 320, [28, 150, 450, 1000, 1200, 1400],
        funFact: 'Uji has been Japan\'s most prestigious tea-growing region for over 800 years. The Tale of Genji, the world\'s first novel, set its final chapters in Uji!',
        subtext: '宇治'),
      _railroad(35, 'Kintetsu Line', subtext: '近鉄線',
        funFact: 'The Kintetsu Railway is Japan\'s largest private railway network at 508 kilometers, connecting Kyoto to Nara in just 35 minutes on the limited express!'),
      _card(36, 'Chance', true),
      _property(37, 'Daitoku-ji', 'darkBlue', PropertyGroups.darkBlue, 350, [35, 175, 500, 1100, 1300, 1500],
        funFact: 'Founded in 1319, Daitoku-ji is a vast Zen temple complex with 24 sub-temples and is closely linked to the history of the Japanese tea ceremony through Sen no Rikyu!',
        subtext: '大徳寺'),
      _tax(38, 'Luxury Tax', 100),
      _property(39, 'Kitano Tenmangu', 'darkBlue', PropertyGroups.darkBlue, 400, [50, 200, 600, 1400, 1700, 2000],
        funFact: 'Established in 947 AD to honor scholar Sugawara no Michizane, Kitano Tenmangu has 2,000 plum trees and is Japan\'s most important shrine for academic success!',
        subtext: '北野天満宮'),
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

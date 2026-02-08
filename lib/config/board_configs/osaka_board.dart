import 'package:flutter/material.dart';
import '../../models/tile.dart';

/// Osaka Monopoly board configuration with 40 tiles
class OsakaBoard {
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

  /// Railroad positions (Train Lines in Osaka)
  static const List<int> railroadPositions = [5, 15, 25, 35];

  /// Utility positions
  static const List<int> utilityPositions = [12, 28];

  /// Chance card positions
  static const List<int> chancePositions = [7, 22, 36];

  /// Community Chest positions
  static const List<int> communityChestPositions = [2, 17, 33];

  /// Generate all 40 tiles for the Osaka board
  static List<TileData> generateTiles() {
    return [
      // Bottom row (right to left: 0-10)
      _corner(0, 'GO', TileType.start, subtext: 'スタート'),
      _property(1, 'Shinsekai', 'brown', PropertyGroups.brown, 60, [2, 10, 30, 90, 160, 250],
        funFact: 'Built in 1912 as a "new world" modeled after New York and Paris, Shinsekai is famous for its retro atmosphere and kushikatsu deep-fried skewers!',
        subtext: '新世界'),
      _card(2, 'Comm Chest', false),
      _property(3, 'Tennoji', 'brown', PropertyGroups.brown, 60, [4, 20, 60, 180, 320, 450],
        funFact: 'Tennoji Park was established in 1909 and houses the Osaka Municipal Museum of Fine Art with over 8,000 works of Japanese and Chinese art!',
        subtext: '天王寺'),
      _tax(4, 'Income Tax', 200),
      _railroad(5, 'Midosuji Line', subtext: '御堂筋線',
        funFact: 'Opened in 1933, the Midosuji Line is Osaka\'s busiest subway line carrying over 1.2 million passengers daily along the iconic Midosuji Boulevard!'),
      _property(6, 'Namba', 'lightBlue', PropertyGroups.lightBlue, 100, [6, 30, 90, 270, 400, 550],
        funFact: 'Namba is Osaka\'s vibrant entertainment hub, home to the famous Namba Grand Kagetsu theater where yoshimoto comedians have performed since 1912!',
        subtext: '難波'),
      _card(7, 'Chance', true),
      _property(8, 'Shinsaibashi', 'lightBlue', PropertyGroups.lightBlue, 100, [6, 30, 90, 270, 400, 550],
        funFact: 'The Shinsaibashi-suji shopping arcade stretches 600 meters and has been Osaka\'s premier shopping street since the Edo period in the 17th century!',
        subtext: '心斎橋'),
      _property(9, 'Amerikamura', 'lightBlue', PropertyGroups.lightBlue, 120, [8, 40, 100, 300, 450, 600],
        funFact: 'Known as "Amemura," this youth culture district emerged in the 1970s when shops began importing American vintage clothing and records!',
        subtext: 'アメリカ村'),
      _corner(10, 'JAIL', TileType.jail, color: const Color(0xFFFFE0B2), subtext: '刑務所'),

      // Left column (bottom to top: 11-20)
      _property(11, 'Tsutenkaku', 'pink', PropertyGroups.pink, 140, [10, 50, 150, 450, 625, 750],
        funFact: 'The current 108-meter Tsutenkaku Tower was rebuilt in 1956 after the original 1912 tower was dismantled for steel during World War II!',
        subtext: '通天閣'),
      _utility(12, 'Kansai Electric Power', true,
        funFact: 'Founded in 1951, Kansai Electric Power supplies electricity to over 13 million customers across the entire Kansai region of western Japan!'),
      _property(13, 'Sumiyoshi Taisha', 'pink', PropertyGroups.pink, 140, [10, 50, 150, 450, 625, 750],
        funFact: 'Founded in 211 AD, Sumiyoshi Taisha is one of Japan\'s oldest shrines and the headquarters of over 2,300 Sumiyoshi shrines nationwide!',
        subtext: '住吉大社'),
      _property(14, 'Osaka Castle', 'pink', PropertyGroups.pink, 160, [12, 60, 180, 500, 700, 900],
        funFact: 'Originally built by Toyotomi Hideyoshi in 1583, the castle\'s main tower stands 55 meters tall and played a key role in Japan\'s unification!',
        subtext: '大阪城'),
      _railroad(15, 'Osaka Loop Line', subtext: '大阪環状線',
        funFact: 'The Osaka Loop Line completed its circular route in 1961, connecting 19 stations over 21.7 kilometers around central Osaka!'),
      _property(16, 'Dotonbori', 'orange', PropertyGroups.orange, 180, [14, 70, 200, 550, 750, 950],
        funFact: 'Named after merchant Yasui Doton who funded the canal in 1612, Dotonbori\'s famous Glico Running Man sign has been an icon since 1935!',
        subtext: '道頓堀'),
      _card(17, 'Comm Chest', false),
      _property(18, 'Kuromon Market', 'orange', PropertyGroups.orange, 180, [14, 70, 200, 550, 750, 950],
        funFact: 'Known as "Osaka\'s Kitchen" for over 190 years, Kuromon Market has around 150 shops specializing in fresh seafood, produce, and street food!',
        subtext: '黒門市場'),
      _property(19, 'Umeda', 'orange', PropertyGroups.orange, 200, [16, 80, 220, 600, 800, 1000],
        funFact: 'The Umeda Sky Building\'s Floating Garden Observatory at 173 meters was named one of the world\'s top 20 architectural structures by a travel guide!',
        subtext: '梅田'),
      _corner(20, 'LUCKY SPIN', TileType.freeParking, subtext: 'ラッキースピン'),

      // Top row (left to right: 21-30)
      _property(21, 'Universal Studios', 'red', PropertyGroups.red, 220, [18, 90, 250, 700, 875, 1050],
        funFact: 'Universal Studios Japan opened in 2001 and attracts over 14 million visitors annually, making it the most visited amusement park in Japan!',
        subtext: 'ユニバーサル'),
      _card(22, 'Chance', true),
      _property(23, 'Tempozan', 'red', PropertyGroups.red, 220, [18, 90, 250, 700, 875, 1050],
        funFact: 'At just 4.53 meters, Mount Tempozan is one of Japan\'s lowest officially recognized mountains, created from soil dredged from Osaka harbor in 1831!',
        subtext: '天保山'),
      _property(24, 'Kaiyukan', 'red', PropertyGroups.red, 240, [20, 100, 300, 750, 925, 1100],
        funFact: 'Osaka\'s Kaiyukan aquarium holds 10,941 tons of water and is home to whale sharks, manta rays, and over 30,000 marine creatures from the Pacific Rim!',
        subtext: '海遊館'),
      _railroad(25, 'Nankai Line', subtext: '南海本線',
        funFact: 'The Nankai Main Line, established in 1885, is one of Japan\'s oldest railway lines and connects Osaka to Kansai International Airport and Wakayama!'),
      _property(26, 'Nakanoshima', 'yellow', PropertyGroups.yellow, 260, [22, 110, 330, 800, 975, 1150],
        funFact: 'This sandbar island between the Dojima and Tosabori rivers has been Osaka\'s cultural center since 1891, housing the National Museum of Art!',
        subtext: '中之島'),
      _property(27, 'Kitashinchi', 'yellow', PropertyGroups.yellow, 260, [22, 110, 330, 800, 975, 1150],
        funFact: 'Kitashinchi is Osaka\'s most exclusive dining and entertainment district with over 3,000 bars, clubs, and restaurants in a compact area!',
        subtext: '北新地'),
      _utility(28, 'Osaka Gas', false,
        funFact: 'Founded in 1897, Osaka Gas serves over 7 million customers and operates the Gas Science Museum showcasing energy innovation!'),
      _property(29, 'Abeno Harukas', 'yellow', PropertyGroups.yellow, 280, [24, 120, 360, 850, 1025, 1200],
        funFact: 'At 300 meters, Abeno Harukas was Japan\'s tallest skyscraper from its 2014 completion until 2023, featuring a museum, hotel, and observation deck!',
        subtext: 'あべのハルカス'),
      _corner(30, 'GO TO JAIL', TileType.goToJail, subtext: '刑務所へ'),

      // Right column (top to bottom: 31-39)
      _property(31, 'Expo Park', 'green', PropertyGroups.green, 300, [26, 130, 390, 900, 1100, 1275],
        funFact: 'Site of Expo \'70, the first World\'s Fair in Asia with 64 million visitors! The iconic Tower of the Sun by Taro Okamoto still stands at 70 meters!',
        subtext: '万博記念公園'),
      _property(32, 'Minoh Falls', 'green', PropertyGroups.green, 300, [26, 130, 390, 900, 1100, 1275],
        funFact: 'Minoh Waterfall cascades 33 meters and is one of Japan\'s top 100 waterfalls, famous for its spectacular autumn foliage and maple leaf tempura!',
        subtext: '箕面滝'),
      _card(33, 'Comm Chest', false),
      _property(34, 'Sakai', 'green', PropertyGroups.green, 320, [28, 150, 450, 1000, 1200, 1400],
        funFact: 'Sakai is home to the Daisen Kofun, the largest keyhole-shaped burial mound in the world at 486 meters long, built in the 5th century for Emperor Nintoku!',
        subtext: '堺'),
      _railroad(35, 'Keihan Line', subtext: '京阪本線',
        funFact: 'The Keihan Line has connected Osaka and Kyoto since 1910, running premium double-decker cars on its 49.3-kilometer main line!'),
      _card(36, 'Chance', true),
      _property(37, 'Grand Front', 'darkBlue', PropertyGroups.darkBlue, 350, [35, 175, 500, 1100, 1300, 1500],
        funFact: 'Grand Front Osaka opened in 2013 as part of the massive Umeda North Yard redevelopment with 266 shops, a knowledge center, and intercontinental hotel!',
        subtext: 'グランフロント'),
      _tax(38, 'Luxury Tax', 100),
      _property(39, 'Kita', 'darkBlue', PropertyGroups.darkBlue, 400, [50, 200, 600, 1400, 1700, 2000],
        funFact: 'The Kita district is Osaka\'s northern commercial heart, anchored by Osaka Station City which serves over 2.5 million passengers daily!',
        subtext: 'キタ'),
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

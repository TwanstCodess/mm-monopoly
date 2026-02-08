import 'package:flutter/material.dart';
import '../../models/tile.dart';

/// Japan/Tokyo Monopoly board configuration with 40 tiles
class JapanBoard {
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

  /// Railroad positions (Train Lines in Japan)
  static const List<int> railroadPositions = [5, 15, 25, 35];

  /// Utility positions
  static const List<int> utilityPositions = [12, 28];

  /// Chance card positions
  static const List<int> chancePositions = [7, 22, 36];

  /// Community Chest positions
  static const List<int> communityChestPositions = [2, 17, 33];

  /// Generate all 40 tiles for the Japan board
  static List<TileData> generateTiles() {
    return [
      // Bottom row (right to left: 0-10)
      _corner(0, 'GO', TileType.start, subtext: 'スタート'),
      _property(1, 'Asakusa', 'brown', PropertyGroups.brown, 60, [2, 10, 30, 90, 160, 250],
        funFact: 'Senso-ji, founded in 645 AD, is Tokyo\'s oldest temple and draws over 30 million visitors annually, making it Japan\'s most visited spiritual site.',
        subtext: '浅草'),
      _card(2, 'Comm Chest', false),
      _property(3, 'Ueno', 'brown', PropertyGroups.brown, 60, [4, 20, 60, 180, 320, 450],
        funFact: 'Ueno Park, established in 1873 as one of Japan\'s first public parks, hosts over 1,000 cherry trees and contains four major national museums within its 53-hectare grounds.',
        subtext: '上野'),
      _tax(4, 'Income Tax', 200),
      _railroad(5, 'Yamanote Line', subtext: '山手線',
        funFact: 'Opened in 1885, the Yamanote Line\'s 30 stations form a 34.5 km loop carrying 3.5 million passengers daily, and its trains arrive with an average delay of just 18 seconds.'),
      _property(6, 'Akihabara', 'lightBlue', PropertyGroups.lightBlue, 100, [6, 30, 90, 270, 400, 550],
        funFact: 'Akihabara\'s transformation from a postwar black market for radio parts in the 1940s to the global capital of otaku culture makes it home to over 250 electronics shops and maid cafes.',
        subtext: '秋葉原'),
      _card(7, 'Chance', true),
      _property(8, 'Ikebukuro', 'lightBlue', PropertyGroups.lightBlue, 100, [6, 30, 90, 270, 400, 550],
        funFact: 'Ikebukuro Station, opened in 1903, serves 2.7 million passengers daily across 8 railway lines and features Sunshine City, built in 1978 on the former site of Sugamo Prison.',
        subtext: '池袋'),
      _property(9, 'Shinjuku', 'lightBlue', PropertyGroups.lightBlue, 120, [8, 40, 100, 300, 450, 600],
        funFact: 'Shinjuku Station holds the Guinness World Record as the busiest transport hub on Earth, with 3.6 million daily passengers navigating over 200 exits across 12 railway lines.',
        subtext: '新宿'),
      _corner(10, 'JAIL', TileType.jail, color: const Color(0xFFFFE0B2), subtext: '刑務所'),

      // Left column (bottom to top: 11-20)
      _property(11, 'Harajuku', 'pink', PropertyGroups.pink, 140, [10, 50, 150, 450, 625, 750],
        funFact: 'Harajuku\'s 350-meter Takeshita Street, a fashion mecca since the 1970s, draws over 10,000 visitors on peak weekends and was where Japan\'s cosplay culture first took root in the 1990s.',
        subtext: '原宿'),
      _utility(12, 'Tokyo Electric Power', true,
        funFact: 'Founded in 1951, TEPCO supplies electricity to 45 million people across a 39,000 km2 service area, generating roughly 290 billion kWh annually through one of the world\'s largest power grids.'),
      _property(13, 'Omotesando', 'pink', PropertyGroups.pink, 140, [10, 50, 150, 450, 625, 750],
        funFact: 'Originally built in 1920 as the grand approach to Meiji Shrine, Omotesando\'s 1 km boulevard is now lined with architectural masterpieces by Tadao Ando, Toyo Ito, and SANAA.',
        subtext: '表参道'),
      _property(14, 'Odaiba', 'pink', PropertyGroups.pink, 160, [12, 60, 180, 500, 700, 900],
        funFact: 'Odaiba was originally built as cannon battery islands in 1853 to defend against Commodore Perry\'s fleet; today its 400+ hectares of reclaimed land feature a 19.7-meter life-size Gundam statue.',
        subtext: 'お台場'),
      _railroad(15, 'Tokaido Shinkansen', subtext: '東海道新幹線',
        funFact: 'Launched on October 1, 1964, just 9 days before the Tokyo Olympics, the Tokaido Shinkansen has carried over 10 billion passengers with zero fatalities in its 60+ year history.'),
      _property(16, 'Roppongi', 'orange', PropertyGroups.orange, 180, [14, 70, 200, 550, 750, 950],
        funFact: 'Roppongi means "six trees" in Japanese, named after six ancient zelkova trees that once stood here; today the area houses over 80 foreign embassies and a vibrant 24-hour entertainment district.',
        subtext: '六本木'),
      _card(17, 'Comm Chest', false),
      _property(18, 'Ebisu', 'orange', PropertyGroups.orange, 180, [14, 70, 200, 550, 750, 950],
        funFact: 'Ebisu is named after the Yebisu Beer brewery built here in 1890 by Japan Beer Brewery Co.; the station, streets, and even the district all took their name from this single beer brand.',
        subtext: '恵比寿'),
      _property(19, 'Shibuya', 'orange', PropertyGroups.orange, 200, [16, 80, 220, 600, 800, 1000],
        funFact: 'Shibuya Crossing sees up to 3,000 people crossing simultaneously during peak hours, and the nearby Hachiko statue commemorates the loyal Akita dog who waited for his owner at the station every day from 1925 to 1935.',
        subtext: '渋谷'),
      _corner(20, 'LUCKY SPIN', TileType.freeParking, subtext: 'ラッキースピン'),

      // Top row (left to right: 21-30)
      _property(21, 'Tsukiji', 'red', PropertyGroups.red, 220, [18, 90, 250, 700, 875, 1050],
        funFact: 'Tsukiji Market operated for 83 years (1935-2018) handling over 480 different types of seafood daily; in January 2019, a 278 kg bluefin tuna sold at the new Toyosu Market for a record \$3.1 million.',
        subtext: '築地'),
      _card(22, 'Chance', true),
      _property(23, 'Ginza', 'red', PropertyGroups.red, 220, [18, 90, 250, 700, 875, 1050],
        funFact: 'Ginza\'s name means "silver mint," dating from 1612 when the Tokugawa shogunate established a silver coin mint here. Today its Chuo-dori becomes a pedestrian paradise every weekend since 1970.',
        subtext: '銀座'),
      _property(24, 'Tokyo Station', 'red', PropertyGroups.red, 240, [20, 100, 300, 750, 925, 1100],
        funFact: 'Designed by Tatsuno Kingo and opened on December 20, 1914, Tokyo Station\'s red-brick Marunouchi building survived WWII bombings and was fully restored to its original 3-story grandeur in 2012.',
        subtext: '東京駅'),
      _railroad(25, 'Chuo Line', subtext: '中央線',
        funFact: 'The Chuo Line, opened in 1889, runs 53.1 km from Tokyo to Takao and its distinctive orange trains were introduced in 1957 to help commuters quickly identify the rapid service.'),
      _property(26, 'Marunouchi', 'yellow', PropertyGroups.yellow, 260, [22, 110, 330, 800, 975, 1150],
        funFact: 'Marunouchi, meaning "inside the circle" of the Imperial Palace moat, was purchased entirely by Mitsubishi in 1890 for 1.5 million yen and transformed from a desolate field into Japan\'s Wall Street.',
        subtext: '丸の内'),
      _property(27, 'Nihombashi', 'yellow', PropertyGroups.yellow, 260, [22, 110, 330, 800, 975, 1150],
        funFact: 'The original wooden Nihombashi Bridge was built in 1603 and designated the official starting point of Japan\'s five major highways; the current stone bridge from 1911 still bears the bronze "kilometer zero" marker.',
        subtext: '日本橋'),
      _utility(28, 'Tokyo Gas', false,
        funFact: 'Tokyo Gas, established on October 1, 1885, lit Tokyo\'s first gas streetlamps in Ginza and today serves over 12 million customers through a 66,000 km underground pipeline network.'),
      _property(29, 'Roppongi Hills', 'yellow', PropertyGroups.yellow, 280, [24, 120, 360, 850, 1025, 1200],
        funFact: 'Roppongi Hills took 17 years to develop and opened in 2003 as an 11.6-hectare "city within a city," requiring the relocation of over 400 residents and the cooperation of 77 landowners.',
        subtext: '六本木ヒルズ'),
      _corner(30, 'GO TO JAIL', TileType.goToJail, subtext: '刑務所へ'),

      // Right column (top to bottom: 31-39)
      _property(31, 'Aoyama', 'green', PropertyGroups.green, 300, [26, 130, 390, 900, 1100, 1275],
        funFact: 'Aoyama is named after a feudal lord whose estate was here during the Edo period (1603-1868); today its tree-lined avenues house the Nezu Museum, showcasing over 7,400 pre-modern art works.',
        subtext: '青山'),
      _property(32, 'Azabu', 'green', PropertyGroups.green, 300, [26, 130, 390, 900, 1100, 1275],
        funFact: 'Azabu has been an elite residential area since the Edo period and today hosts over 50 foreign embassies, earning it the nickname "Embassy Row" with some of Tokyo\'s highest per-capita income levels.',
        subtext: '麻布'),
      _card(33, 'Comm Chest', false),
      _property(34, 'Tokyo Tower', 'green', PropertyGroups.green, 320, [28, 150, 450, 1000, 1200, 1400],
        funFact: 'Completed on December 23, 1958, Tokyo Tower stands exactly 333 meters tall (13 meters taller than the Eiffel Tower) and was built using steel partly recycled from American tanks from the Korean War.',
        subtext: '東京タワー'),
      _railroad(35, 'Sobu Line', subtext: '総武線',
        funFact: 'The Sobu Line, operational since 1894, stretches 120.5 km between Chiba and Mitaka, and its yellow-striped local trains are one of Tokyo\'s most recognizable commuter services.'),
      _card(36, 'Chance', true),
      _property(37, 'Akasaka', 'darkBlue', PropertyGroups.darkBlue, 350, [35, 175, 500, 1100, 1300, 1500],
        funFact: 'Akasaka\'s State Guest House, built in 1909 as the Crown Prince\'s Palace, is Japan\'s only Neo-Baroque palace and hosted state dinners for leaders including U.S. presidents and European royalty.',
        subtext: '赤坂'),
      _tax(38, 'Luxury Tax', 100),
      _property(39, 'Tokyo Skytree', 'darkBlue', PropertyGroups.darkBlue, 400, [50, 200, 600, 1400, 1700, 2000],
        funFact: 'Opened on May 22, 2012, Tokyo Skytree stands 634 meters tall (a number that reads as "mu-sa-shi," the old name for Tokyo) and can withstand earthquakes up to magnitude 7, swaying up to 6 meters at its tip.',
        subtext: '東京スカイツリー'),
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

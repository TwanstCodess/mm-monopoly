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
        funFact: 'Home to Senso-ji, Tokyo\'s oldest Buddhist temple built in 645 AD!',
        subtext: '浅草'),
      _card(2, 'Community Chest', false),
      _property(3, 'Ueno', 'brown', PropertyGroups.brown, 60, [4, 20, 60, 180, 320, 450],
        funFact: 'Ueno Park has over 1,000 cherry blossom trees and is Tokyo\'s most popular hanami spot!',
        subtext: '上野'),
      _tax(4, 'Income Tax', 200),
      _railroad(5, 'Yamanote Line', subtext: '山手線',
        funFact: 'The Yamanote Line completes a full loop around central Tokyo every 59-65 minutes, carrying 3.5 million passengers daily!'),
      _property(6, 'Akihabara', 'lightBlue', PropertyGroups.lightBlue, 100, [6, 30, 90, 270, 400, 550],
        funFact: 'Known as "Electric Town," Akihabara is the global center of anime, manga, and electronics culture!',
        subtext: '秋葉原'),
      _card(7, 'Chance', true),
      _property(8, 'Ikebukuro', 'lightBlue', PropertyGroups.lightBlue, 100, [6, 30, 90, 270, 400, 550],
        funFact: 'Ikebukuro Station is the world\'s second-busiest train station, serving over 2.7 million passengers daily!',
        subtext: '池袋'),
      _property(9, 'Shinjuku', 'lightBlue', PropertyGroups.lightBlue, 120, [8, 40, 100, 300, 450, 600],
        funFact: 'Shinjuku Station is the busiest train station in the world with over 3.6 million daily passengers!',
        subtext: '新宿'),
      _corner(10, 'JAIL', TileType.jail, color: const Color(0xFFFFE0B2), subtext: '刑務所'),

      // Left column (bottom to top: 11-20)
      _property(11, 'Harajuku', 'pink', PropertyGroups.pink, 140, [10, 50, 150, 450, 625, 750],
        funFact: 'The epicenter of Tokyo\'s youth fashion culture! Takeshita Street attracts millions of trendsetting visitors.',
        subtext: '原宿'),
      _utility(12, 'Tokyo Electric Power', true,
        funFact: 'TEPCO powers over 45 million people in the greater Tokyo area, one of the world\'s largest power grids!'),
      _property(13, 'Omotesando', 'pink', PropertyGroups.pink, 140, [10, 50, 150, 450, 625, 750],
        funFact: 'Known as Tokyo\'s Champs-Élysées, lined with zelkova trees and flagship stores by world-renowned architects!',
        subtext: '表参道'),
      _property(14, 'Odaiba', 'pink', PropertyGroups.pink, 160, [12, 60, 180, 500, 700, 900],
        funFact: 'Built on reclaimed land in Tokyo Bay, home to teamLab Borderless and a giant Gundam statue!',
        subtext: 'お台場'),
      _railroad(15, 'Tokaido Shinkansen', subtext: '東海道新幹線',
        funFact: 'Japan\'s first bullet train line, connecting Tokyo to Osaka at speeds up to 285 km/h since 1964!'),
      _property(16, 'Roppongi', 'orange', PropertyGroups.orange, 180, [14, 70, 200, 550, 750, 950],
        funFact: 'Home to Roppongi Hills and Tokyo Midtown, featuring world-class art museums and nightlife!',
        subtext: '六本木'),
      _card(17, 'Community Chest', false),
      _property(18, 'Ebisu', 'orange', PropertyGroups.orange, 180, [14, 70, 200, 550, 750, 950],
        funFact: 'Named after Yebisu Beer, this upscale neighborhood is known for great restaurants and the Tokyo Photographic Art Museum!',
        subtext: '恵比寿'),
      _property(19, 'Shibuya', 'orange', PropertyGroups.orange, 200, [16, 80, 220, 600, 800, 1000],
        funFact: 'Shibuya Crossing is the world\'s busiest pedestrian intersection, with up to 3,000 people crossing at once!',
        subtext: '渋谷'),
      _corner(20, 'LUCKY SPIN', TileType.freeParking, subtext: 'ラッキースピン'),

      // Top row (left to right: 21-30)
      _property(21, 'Tsukiji', 'red', PropertyGroups.red, 220, [18, 90, 250, 700, 875, 1050],
        funFact: 'The former site of the world\'s largest fish market, where a bluefin tuna once sold for \$3.1 million!',
        subtext: '築地'),
      _card(22, 'Chance', true),
      _property(23, 'Ginza', 'red', PropertyGroups.red, 220, [18, 90, 250, 700, 875, 1050],
        funFact: 'Tokyo\'s most luxurious shopping district! Land prices can reach \$100,000 per square meter.',
        subtext: '銀座'),
      _property(24, 'Tokyo Station', 'red', PropertyGroups.red, 240, [20, 100, 300, 750, 925, 1100],
        funFact: 'The beautifully restored 1914 red-brick station serves as the terminus for all Shinkansen lines!',
        subtext: '東京駅'),
      _railroad(25, 'Chuo Line', subtext: '中央線',
        funFact: 'The Chuo Rapid Line is one of Tokyo\'s most important commuter lines, recognizable by its orange trains!'),
      _property(26, 'Marunouchi', 'yellow', PropertyGroups.yellow, 260, [22, 110, 330, 800, 975, 1150],
        funFact: 'Tokyo\'s premier business district, home to major corporations and facing the Imperial Palace!',
        subtext: '丸の内'),
      _property(27, 'Nihombashi', 'yellow', PropertyGroups.yellow, 260, [22, 110, 330, 800, 975, 1150],
        funFact: 'The historic commercial center of Tokyo, where the famous Nihombashi Bridge marks "kilometer zero" for Japan!',
        subtext: '日本橋'),
      _utility(28, 'Tokyo Gas', false,
        funFact: 'Founded in 1885, Tokyo Gas was one of Japan\'s first modern utility companies!'),
      _property(29, 'Roppongi Hills', 'yellow', PropertyGroups.yellow, 280, [24, 120, 360, 850, 1025, 1200],
        funFact: 'This massive urban complex includes the Mori Art Museum, luxury residences, and a 238-meter observation deck!',
        subtext: '六本木ヒルズ'),
      _corner(30, 'GO TO JAIL', TileType.goToJail, subtext: '刑務所へ'),

      // Right column (top to bottom: 31-39)
      _property(31, 'Aoyama', 'green', PropertyGroups.green, 300, [26, 130, 390, 900, 1100, 1275],
        funFact: 'One of Tokyo\'s most fashionable neighborhoods, known for high-end boutiques and trendy cafes!',
        subtext: '青山'),
      _property(32, 'Azabu', 'green', PropertyGroups.green, 300, [26, 130, 390, 900, 1100, 1275],
        funFact: 'An exclusive residential area home to many embassies and international schools!',
        subtext: '麻布'),
      _card(33, 'Community Chest', false),
      _property(34, 'Tokyo Tower', 'green', PropertyGroups.green, 320, [28, 150, 450, 1000, 1200, 1400],
        funFact: 'Inspired by the Eiffel Tower, this 333-meter landmark has been Tokyo\'s symbol since 1958!',
        subtext: '東京タワー'),
      _railroad(35, 'Sobu Line', subtext: '総武線',
        funFact: 'The Sobu Line connects Tokyo\'s eastern suburbs and carries over 1 million passengers daily!'),
      _card(36, 'Chance', true),
      _property(37, 'Akasaka', 'darkBlue', PropertyGroups.darkBlue, 350, [35, 175, 500, 1100, 1300, 1500],
        funFact: 'Home to the State Guest House and many high-end restaurants, including Michelin-starred establishments!',
        subtext: '赤坂'),
      _tax(38, 'Luxury Tax', 100),
      _property(39, 'Tokyo Skytree', 'darkBlue', PropertyGroups.darkBlue, 400, [50, 200, 600, 1400, 1700, 2000],
        funFact: 'The world\'s tallest tower at 634 meters! The height represents "Musashi," the historic name for Tokyo.',
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

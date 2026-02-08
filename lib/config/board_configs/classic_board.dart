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
        funFact: 'Mediterranean Avenue was one of Atlantic City\'s poorest neighborhoods in the 1930s, with homes valued at just \$2,500 — reflecting its status as the cheapest property on the board.'),
      _card(2, 'Comm Chest', false),
      _property(3, 'Baltic Ave', 'brown', PropertyGroups.brown, 60, [4, 20, 60, 180, 320, 450],
        funFact: 'In the early 1900s, Baltic Avenue was the heart of Atlantic City\'s African American community, and by the 1930s it had become one of the most densely populated streets in the city.'),
      _tax(4, 'Income Tax', 200),
      _railroad(5, 'Reading Railroad',
        funFact: 'Founded in 1833, the Reading Railroad once employed over 100,000 workers and hauled more coal than any other railroad, making it a powerhouse of America\'s Industrial Revolution.'),
      _property(6, 'Oriental Ave', 'lightBlue', PropertyGroups.lightBlue, 100, [6, 30, 90, 270, 400, 550],
        funFact: 'Oriental Avenue in Atlantic City was home to the city\'s Chinese laundries and shops in the late 1800s, and the street still exists today between Atlantic and Pacific Avenues.'),
      _card(7, 'Chance', true),
      _property(8, 'Vermont Ave', 'lightBlue', PropertyGroups.lightBlue, 100, [6, 30, 90, 270, 400, 550],
        funFact: 'Vermont Avenue in Atlantic City was named after the 14th state admitted to the Union in 1791. In the game, it is statistically one of the least-landed-on properties on the board.'),
      _property(9, 'Connecticut Ave', 'lightBlue', PropertyGroups.lightBlue, 120, [8, 40, 100, 300, 450, 600],
        funFact: 'Connecticut Avenue was one of the streets Charles Darrow walked during his 1932 visits to Atlantic City, which inspired him to create the version of Monopoly he patented in 1935.'),
      _corner(10, 'JAIL', TileType.jail, color: const Color(0xFFFFE0B2), subtext: 'JUST VISITING'),

      // Left column (bottom to top: 11-20)
      _property(11, 'St. Charles Place', 'pink', PropertyGroups.pink, 140, [10, 50, 150, 450, 625, 750],
        funFact: 'St. Charles Place no longer exists in Atlantic City — it was demolished in the 1970s to make way for the Showboat Casino, making it one of the few Monopoly streets that has vanished entirely.'),
      _utility(12, 'Electric Company', true,
        funFact: 'Atlantic City became one of the first cities in America to have electric streetlights in 1883, just four years after Edison\'s first practical light bulb, earning it the nickname "The Electric City."'),
      _property(13, 'States Ave', 'pink', PropertyGroups.pink, 140, [10, 50, 150, 450, 625, 750],
        funFact: 'States Avenue in Atlantic City ran through the city\'s entertainment district in the 1920s. Like many of the board\'s streets, it was named as part of a patriotic naming scheme honoring U.S. states.'),
      _property(14, 'Virginia Ave', 'pink', PropertyGroups.pink, 160, [12, 60, 180, 500, 700, 900],
        funFact: 'Virginia Avenue was home to many of Atlantic City\'s African American-owned hotels and nightclubs during the 1920s-1950s, making it the vibrant heart of the city\'s jazz and entertainment scene.'),
      _railroad(15, 'Pennsylvania Railroad',
        funFact: 'At its peak in the 1920s, the Pennsylvania Railroad was the largest corporation in the world, employing over 250,000 workers and operating 10,000 miles of track across 13 states.'),
      _property(16, 'St. James Place', 'orange', PropertyGroups.orange, 180, [14, 70, 200, 550, 750, 950],
        funFact: 'St. James Place in Atlantic City was located near the famous Steel Pier, which opened in 1898 and hosted diving horses, big band acts, and over 9 million visitors at its peak in the 1960s.'),
      _card(17, 'Comm Chest', false),
      _property(18, 'Tennessee Ave', 'orange', PropertyGroups.orange, 180, [14, 70, 200, 550, 750, 950],
        funFact: 'Tennessee Avenue was part of Atlantic City\'s bustling hotel district in the 1920s. The orange properties (St. James, Tennessee, New York) are statistically the most landed-on color group in Monopoly.'),
      _property(19, 'New York Ave', 'orange', PropertyGroups.orange, 200, [16, 80, 220, 600, 800, 1000],
        funFact: 'New York Avenue in Atlantic City intersects with the Boardwalk and was a prime commercial corridor. In Monopoly strategy, the orange group including New York Ave offers the best return on investment.'),
      _corner(20, 'LUCKY SPIN', TileType.freeParking),

      // Top row (left to right: 21-30)
      _property(21, 'Kentucky Ave', 'red', PropertyGroups.red, 220, [18, 90, 250, 700, 875, 1050],
        funFact: 'Kentucky Avenue is one of the few Monopoly streets that still thrives in modern Atlantic City, serving as a popular dining and nightlife strip just one block from the Boardwalk.'),
      _card(22, 'Chance', true),
      _property(23, 'Indiana Ave', 'red', PropertyGroups.red, 220, [18, 90, 250, 700, 875, 1050],
        funFact: 'Indiana Avenue was the main street of Atlantic City\'s African American cultural scene from the 1920s to the 1960s, featuring legendary jazz clubs where artists like Sammy Davis Jr. performed.'),
      _property(24, 'Illinois Ave', 'red', PropertyGroups.red, 240, [20, 100, 300, 750, 925, 1100],
        funFact: 'Illinois Avenue is statistically the single most landed-on property in Monopoly, thanks to its position relative to the Jail space — players leaving Jail have a high probability of landing here.'),
      _railroad(25, 'B&O Railroad',
        funFact: 'The B&O Railroad, chartered on February 28, 1827, was the first railroad to offer scheduled passenger service in the U.S. Its famous Tom Thumb locomotive raced a horse-drawn car in 1830 — and lost.'),
      _property(26, 'Atlantic Ave', 'yellow', PropertyGroups.yellow, 260, [22, 110, 330, 800, 975, 1150],
        funFact: 'Atlantic Avenue has been Atlantic City\'s main commercial street since the 1850s, running the full 4-mile length of the island. It served as the city\'s primary shopping district for over a century.'),
      _property(27, 'Ventnor Ave', 'yellow', PropertyGroups.yellow, 260, [22, 110, 330, 800, 975, 1150],
        funFact: 'Ventnor City was incorporated in 1903 as a quieter residential alternative to Atlantic City. Its name comes from Ventnor on England\'s Isle of Wight, a Victorian seaside resort town.'),
      _utility(28, 'Water Works', false,
        funFact: 'Atlantic City built its first municipal waterworks in 1882, pumping 3 million gallons daily from wells on the mainland to supply the growing resort island\'s hotels and residents.'),
      _property(29, 'Marvin Gardens', 'yellow', PropertyGroups.yellow, 280, [24, 120, 360, 850, 1025, 1200],
        funFact: 'The real neighborhood is spelled "Marven Gardens" (a blend of Margate and Ventnor). Parker Brothers acknowledged the 1935 misspelling in 1995 but kept "Marvin" as it had become iconic.'),
      _corner(30, 'GO TO JAIL', TileType.goToJail),

      // Right column (top to bottom: 31-39)
      _property(31, 'Pacific Ave', 'green', PropertyGroups.green, 300, [26, 130, 390, 900, 1100, 1275],
        funFact: 'Pacific Avenue was Atlantic City\'s grand hotel row in the early 1900s, lined with luxurious resorts like the Marlborough-Blenheim (built 1902), the first reinforced-concrete building in the world.'),
      _property(32, 'North Carolina Ave', 'green', PropertyGroups.green, 300, [26, 130, 390, 900, 1100, 1275],
        funFact: 'North Carolina Avenue in Atlantic City was part of the upscale residential area. The Wright Brothers made their historic first powered flight at Kitty Hawk, North Carolina on December 17, 1903.'),
      _card(33, 'Comm Chest', false),
      _property(34, 'Pennsylvania Ave', 'green', PropertyGroups.green, 320, [28, 150, 450, 1000, 1200, 1400],
        funFact: 'Pennsylvania Avenue in Atlantic City was a fashionable address in the 1920s. Its Washington D.C. namesake has hosted every presidential inaugural parade since Thomas Jefferson\'s in 1805.'),
      _railroad(35, 'Short Line',
        funFact: 'The Short Line refers to the Shore Fast Line, an electric trolley that ran from 1907 to 1948, connecting Atlantic City to Ocean City at speeds up to 60 mph along the Jersey Shore.'),
      _card(36, 'Chance', true),
      _property(37, 'Park Place', 'darkBlue', PropertyGroups.darkBlue, 350, [35, 175, 500, 1100, 1300, 1500],
        funFact: 'Park Place in Atlantic City was an exclusive address near the luxurious Traymore Hotel (built 1879). In Monopoly tournaments, Park Place is actually landed on less often than most mid-board properties.'),
      _tax(38, 'Luxury Tax', 100),
      _property(39, 'Boardwalk', 'darkBlue', PropertyGroups.darkBlue, 400, [50, 200, 600, 1400, 1700, 2000],
        funFact: 'Built on June 26, 1870, the Atlantic City Boardwalk was the world\'s first boardwalk, originally designed to keep sand out of hotel lobbies. It stretches 4 miles and today attracts 27 million visitors annually.'),
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

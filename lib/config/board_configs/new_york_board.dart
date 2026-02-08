import 'package:flutter/material.dart';
import '../../models/tile.dart';

/// New York City Monopoly board configuration with 40 tiles
class NewYorkBoard {
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

  /// Generate all 40 tiles for the New York City board
  static List<TileData> generateTiles() {
    return [
      // Bottom row (right to left: 0-10)
      _corner(0, 'GO', TileType.start, subtext: 'COLLECT \$200'),
      _property(1, 'Chinatown', 'brown', PropertyGroups.brown, 60, [2, 10, 30, 90, 160, 250],
        funFact: 'Manhattan\'s Chinatown is the largest in the Western Hemisphere, home to over 90,000 residents and more than 200 restaurants.'),
      _card(2, 'Comm Chest', false),
      _property(3, 'Lower East Side', 'brown', PropertyGroups.brown, 60, [4, 20, 60, 180, 320, 450],
        funFact: 'In the early 1900s, the Lower East Side was the most densely populated neighborhood in the world, housing waves of immigrants from Europe.'),
      _tax(4, 'Income Tax', 200),
      _railroad(5, 'Grand Central',
        funFact: 'Grand Central Terminal has 44 platforms and 67 tracks, making it the largest train station in the world by number of platforms.'),
      _property(6, 'SoHo', 'lightBlue', PropertyGroups.lightBlue, 100, [6, 30, 90, 270, 400, 550],
        funFact: 'SoHo stands for "South of Houston Street" and contains the largest collection of cast-iron architecture in the world.'),
      _card(7, 'Chance', true),
      _property(8, 'Greenwich Village', 'lightBlue', PropertyGroups.lightBlue, 100, [6, 30, 90, 270, 400, 550],
        funFact: 'Greenwich Village was the birthplace of the American bohemian movement and the 1969 Stonewall uprising that launched the modern LGBTQ rights movement.'),
      _property(9, 'Chelsea', 'lightBlue', PropertyGroups.lightBlue, 120, [8, 40, 100, 300, 450, 600],
        funFact: 'The High Line, a 1.45-mile elevated park built on a former freight rail line, runs through Chelsea and attracts over 8 million visitors annually.'),
      _corner(10, 'JAIL', TileType.jail, color: const Color(0xFFFFE0B2), subtext: 'JUST VISITING'),

      // Left column (bottom to top: 11-20)
      _property(11, 'East Village', 'pink', PropertyGroups.pink, 140, [10, 50, 150, 450, 625, 750],
        funFact: 'The East Village was the epicenter of the 1960s counterculture movement and punk rock scene, with legendary venue CBGB hosting the Ramones and Blondie.'),
      _utility(12, 'Con Edison', true,
        funFact: 'Consolidated Edison traces its origins to Thomas Edison\'s first commercial power station on Pearl Street in 1882, which lit up lower Manhattan.'),
      _property(13, 'Times Square', 'pink', PropertyGroups.pink, 140, [10, 50, 150, 450, 625, 750],
        funFact: 'Times Square\'s iconic billboards use enough electricity to power 161 homes for a year, and nearly 50 million people visit the area annually.'),
      _property(14, 'Midtown', 'pink', PropertyGroups.pink, 160, [12, 60, 180, 500, 700, 900],
        funFact: 'Midtown Manhattan has the highest concentration of skyscrapers in the world, including the Empire State Building, Chrysler Building, and One Vanderbilt.'),
      _railroad(15, 'Penn Station',
        funFact: 'Penn Station is the busiest transportation hub in the Western Hemisphere, serving over 600,000 passengers daily across Amtrak, LIRR, and NJ Transit.'),
      _property(16, 'Hell\'s Kitchen', 'orange', PropertyGroups.orange, 180, [14, 70, 200, 550, 750, 950],
        funFact: 'Hell\'s Kitchen got its name in the 1880s when a police officer said "this place is hell itself," and the neighborhood became known for its tough reputation.'),
      _card(17, 'Comm Chest', false),
      _property(18, 'Wall Street', 'orange', PropertyGroups.orange, 180, [14, 70, 200, 550, 750, 950],
        funFact: 'Wall Street is named after an actual wall built by Dutch colonists in 1653 to protect New Amsterdam from British invasion. The NYSE trades over \$20 trillion annually.'),
      _property(19, 'Brooklyn Bridge', 'orange', PropertyGroups.orange, 200, [16, 80, 220, 600, 800, 1000],
        funFact: 'When the Brooklyn Bridge opened in 1883, it was the longest suspension bridge in the world at 1,595 feet, and six days later 12 people died in a stampede caused by panic.'),
      _corner(20, 'LUCKY SPIN', TileType.freeParking),

      // Top row (left to right: 21-30)
      _property(21, 'Central Park', 'red', PropertyGroups.red, 220, [18, 90, 250, 700, 875, 1050],
        funFact: 'Central Park spans 843 acres and was designed by Frederick Law Olmsted and Calvert Vaux in 1858. It contains over 18,000 trees and receives 42 million visits per year.'),
      _card(22, 'Chance', true),
      _property(23, 'Harlem', 'red', PropertyGroups.red, 220, [18, 90, 250, 700, 875, 1050],
        funFact: 'The Harlem Renaissance of the 1920s produced legendary artists like Langston Hughes, Duke Ellington, and Zora Neale Hurston, transforming American culture forever.'),
      _property(24, 'Upper West Side', 'red', PropertyGroups.red, 240, [20, 100, 300, 750, 925, 1100],
        funFact: 'The Upper West Side is home to Lincoln Center, the world\'s leading performing arts complex with 11 resident organizations including the Metropolitan Opera.'),
      _railroad(25, 'PATH Train',
        funFact: 'The PATH train connects Manhattan to New Jersey through tunnels beneath the Hudson River, carrying over 80 million passengers per year since opening in 1908.'),
      _property(26, 'Upper East Side', 'yellow', PropertyGroups.yellow, 260, [22, 110, 330, 800, 975, 1150],
        funFact: 'The Upper East Side\'s Museum Mile along Fifth Avenue contains nine world-class museums within one mile, including the Metropolitan Museum of Art.'),
      _property(27, 'Williamsburg', 'yellow', PropertyGroups.yellow, 260, [22, 110, 330, 800, 975, 1150],
        funFact: 'Williamsburg was originally an independent city and became part of Brooklyn in 1855. Its transformation into a creative hub began in the 1990s with artists seeking affordable studio space.'),
      _utility(28, 'NYC Water', false,
        funFact: 'New York City\'s water supply system delivers over 1 billion gallons daily from reservoirs up to 125 miles away, and is so pure it is one of only five major US cities that doesn\'t need to filter it.'),
      _property(29, 'DUMBO', 'yellow', PropertyGroups.yellow, 280, [24, 120, 360, 850, 1025, 1200],
        funFact: 'DUMBO stands for "Down Under the Manhattan Bridge Overpass." Artists in the 1970s invented the unappealing name hoping to discourage developers from gentrifying the area.'),
      _corner(30, 'GO TO JAIL', TileType.goToJail),

      // Right column (top to bottom: 31-39)
      _property(31, 'Tribeca', 'green', PropertyGroups.green, 300, [26, 130, 390, 900, 1100, 1275],
        funFact: 'Tribeca, short for "Triangle Below Canal Street," is one of the most expensive neighborhoods in Manhattan and hosts the prestigious Tribeca Film Festival founded by Robert De Niro.'),
      _property(32, 'Flatiron', 'green', PropertyGroups.green, 300, [26, 130, 390, 900, 1100, 1275],
        funFact: 'The Flatiron Building, completed in 1902, was one of NYC\'s first skyscrapers at 22 stories. Its distinctive triangular shape causes strong wind gusts at street level.'),
      _card(33, 'Comm Chest', false),
      _property(34, 'Hudson Yards', 'green', PropertyGroups.green, 320, [28, 150, 450, 1000, 1200, 1400],
        funFact: 'Hudson Yards is the largest private real estate development in U.S. history at \$25 billion. Its centerpiece, the Vessel, contains 154 interconnecting flights of stairs.'),
      _railroad(35, 'Brooklyn Terminal',
        funFact: 'Brooklyn\'s Atlantic Terminal sits where the Long Island Rail Road began service in 1836, making it one of the oldest railroad terminals in the United States.'),
      _card(36, 'Chance', true),
      _property(37, 'Empire State', 'darkBlue', PropertyGroups.darkBlue, 350, [35, 175, 500, 1100, 1300, 1500],
        funFact: 'The Empire State Building was constructed in just 410 days during the Great Depression, employing 3,400 workers daily. It has its own zip code: 10118.'),
      _tax(38, 'Luxury Tax', 100),
      _property(39, 'Statue of Liberty', 'darkBlue', PropertyGroups.darkBlue, 400, [50, 200, 600, 1400, 1700, 2000],
        funFact: 'The Statue of Liberty was a gift from France in 1886, standing 305 feet tall. Her torch was originally designed as a lighthouse visible 24 miles out to sea.'),
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

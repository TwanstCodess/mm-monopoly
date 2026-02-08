import 'package:flutter/material.dart';
import '../../models/tile.dart';

/// Los Angeles Monopoly board configuration with 40 tiles
class LosAngelesBoard {
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

  /// Generate all 40 tiles for the Los Angeles board
  static List<TileData> generateTiles() {
    return [
      // Bottom row (right to left: 0-10)
      _corner(0, 'GO', TileType.start, subtext: 'COLLECT \$200'),
      _property(1, 'Boyle Heights', 'brown', PropertyGroups.brown, 60, [2, 10, 30, 90, 160, 250],
        funFact: 'Boyle Heights was one of the most diverse neighborhoods in America during the 1940s, home to Jewish, Japanese, Mexican, and African American communities living side by side.'),
      _card(2, 'Comm Chest', false),
      _property(3, 'Echo Park', 'brown', PropertyGroups.brown, 60, [4, 20, 60, 180, 320, 450],
        funFact: 'Echo Park Lake was created in the 1860s as a drinking water reservoir. Its iconic lotus beds bloom every July and were originally planted in the 1920s.'),
      _tax(4, 'Income Tax', 200),
      _railroad(5, 'Union Station',
        funFact: 'LA\'s Union Station opened in 1939 as the last great railroad station built in America, blending Spanish Colonial, Mission Revival, and Art Deco architecture.'),
      _property(6, 'Silver Lake', 'lightBlue', PropertyGroups.lightBlue, 100, [6, 30, 90, 270, 400, 550],
        funFact: 'Silver Lake is named after Herman Silver, a city water commissioner, not the color of its reservoir. The neighborhood became LA\'s hipster epicenter in the early 2000s.'),
      _card(7, 'Chance', true),
      _property(8, 'Los Feliz', 'lightBlue', PropertyGroups.lightBlue, 100, [6, 30, 90, 270, 400, 550],
        funFact: 'Los Feliz takes its name from Corporal Jose Vicente Feliz, who received the Rancho Los Feliz land grant from Spain in 1796. Walt Disney built his first studio here in 1923.'),
      _property(9, 'Hollywood Blvd', 'lightBlue', PropertyGroups.lightBlue, 120, [8, 40, 100, 300, 450, 600],
        funFact: 'The Hollywood Walk of Fame stretches 1.3 miles along Hollywood Boulevard and contains over 2,700 brass stars embedded in the sidewalk, with the first ones installed in 1958.'),
      _corner(10, 'JAIL', TileType.jail, color: const Color(0xFFFFE0B2), subtext: 'JUST VISITING'),

      // Left column (bottom to top: 11-20)
      _property(11, 'Sunset Strip', 'pink', PropertyGroups.pink, 140, [10, 50, 150, 450, 625, 750],
        funFact: 'The Sunset Strip is a 1.5-mile stretch of Sunset Boulevard that lies in unincorporated LA County, which historically meant looser laws that attracted nightclubs and rock venues.'),
      _utility(12, 'LADWP Electric', true,
        funFact: 'The Los Angeles Department of Water and Power is the largest municipal utility in the United States, serving over 4 million residents and generating 7,880 megawatts of power.'),
      _property(13, 'Venice Beach', 'pink', PropertyGroups.pink, 140, [10, 50, 150, 450, 625, 750],
        funFact: 'Venice Beach was founded in 1905 by Abbot Kinney as "Venice of America," complete with Italian-style canals. The famous Muscle Beach outdoor gym has operated since the 1930s.'),
      _property(14, 'Santa Monica', 'pink', PropertyGroups.pink, 160, [12, 60, 180, 500, 700, 900],
        funFact: 'The Santa Monica Pier, built in 1909, marks the western terminus of Route 66. Its Pacific Park amusement rides include the world\'s only solar-powered Ferris wheel.'),
      _railroad(15, 'Metro Purple Line',
        funFact: 'The Metro Purple Line runs beneath Wilshire Boulevard through the La Brea Tar Pits area, where construction workers discovered Ice Age fossils including mammoth bones during tunneling.'),
      _property(16, 'Malibu', 'orange', PropertyGroups.orange, 180, [14, 70, 200, 550, 750, 950],
        funFact: 'Malibu stretches 27 miles along the Pacific Coast and was originally home to the Chumash people. The name comes from the Chumash word "Humaliwo" meaning "the surf sounds loudly."'),
      _card(17, 'Comm Chest', false),
      _property(18, 'Downtown LA', 'orange', PropertyGroups.orange, 180, [14, 70, 200, 550, 750, 950],
        funFact: 'Downtown LA\'s Bradbury Building, built in 1893, was designed based on instructions from a spiritual medium. Its stunning iron atrium has appeared in Blade Runner and 500 Days of Summer.'),
      _property(19, 'Arts District', 'orange', PropertyGroups.orange, 200, [16, 80, 220, 600, 800, 1000],
        funFact: 'LA\'s Arts District was officially designated in 1981, making it one of the first areas in the country to legally permit artists to live in industrial buildings.'),
      _corner(20, 'LUCKY SPIN', TileType.freeParking),

      // Top row (left to right: 21-30)
      _property(21, 'Little Tokyo', 'red', PropertyGroups.red, 220, [18, 90, 250, 700, 875, 1050],
        funFact: 'Little Tokyo is one of only three official Japantowns remaining in the United States. Founded in the 1880s, it was forcibly emptied during WWII Japanese American internment.'),
      _card(22, 'Chance', true),
      _property(23, 'Griffith Observatory', 'red', PropertyGroups.red, 220, [18, 90, 250, 700, 875, 1050],
        funFact: 'Griffith Observatory has welcomed over 80 million visitors since 1935, more than any other observatory in the world. Admission to the building and telescopes has always been free.'),
      _property(24, 'Beverly Hills', 'red', PropertyGroups.red, 240, [20, 100, 300, 750, 925, 1100],
        funFact: 'Beverly Hills was originally a lima bean ranch before it was developed in 1914. The city is only 5.7 square miles but has its own police and fire departments.'),
      _railroad(25, 'Metro Gold Line',
        funFact: 'The Metro Gold Line connects downtown LA to Pasadena, following a route once traveled by the Pacific Electric Railway\'s Red Cars that were dismantled in the 1950s and 60s.'),
      _property(26, 'Rodeo Drive', 'yellow', PropertyGroups.yellow, 260, [22, 110, 330, 800, 975, 1150],
        funFact: 'Rodeo Drive became a luxury shopping destination after the Beverly Wilshire Hotel opened in 1928. A single block on Rodeo Drive generates more revenue per square foot than any other retail street in the US.'),
      _property(27, 'Bel Air', 'yellow', PropertyGroups.yellow, 260, [22, 110, 330, 800, 975, 1150],
        funFact: 'Bel Air was developed in 1923 by Alphonzo Bell Sr., who made his fortune from oil discovered on his Santa Fe Springs ranch. Its East Gate on Sunset Boulevard is a Los Angeles landmark.'),
      _utility(28, 'LADWP Water', false,
        funFact: 'LADWP operates the Los Angeles Aqueduct, which carries water 233 miles from the Owens Valley. The aqueduct\'s construction in 1913 was one of the most controversial engineering projects in American history.'),
      _property(29, 'Westwood', 'yellow', PropertyGroups.yellow, 280, [24, 120, 360, 850, 1025, 1200],
        funFact: 'Westwood is home to UCLA, founded in 1919, and the Westwood Village Memorial Park cemetery where Marilyn Monroe, Dean Martin, and many other Hollywood legends are buried.'),
      _corner(30, 'GO TO JAIL', TileType.goToJail),

      // Right column (top to bottom: 31-39)
      _property(31, 'Century City', 'green', PropertyGroups.green, 300, [26, 130, 390, 900, 1100, 1275],
        funFact: 'Century City was built on the backlot of 20th Century Fox studios, which sold 180 acres in 1961 to cover the cost overruns from the film Cleopatra starring Elizabeth Taylor.'),
      _property(32, 'Pasadena', 'green', PropertyGroups.green, 300, [26, 130, 390, 900, 1100, 1275],
        funFact: 'Pasadena hosts the annual Rose Parade and Rose Bowl game since 1890. It is also home to Caltech and NASA\'s Jet Propulsion Laboratory, which has managed every Mars rover mission.'),
      _card(33, 'Comm Chest', false),
      _property(34, 'Long Beach', 'green', PropertyGroups.green, 320, [28, 150, 450, 1000, 1200, 1400],
        funFact: 'The Port of Long Beach is the second busiest container port in the United States, handling over \$200 billion in trade annually. The RMS Queen Mary has been permanently docked there since 1967.'),
      _railroad(35, 'Metro Expo Line',
        funFact: 'The Metro Expo Line connects downtown LA to Santa Monica along the former Pacific Electric Exposition Line right-of-way, restoring rail service to the coast after a 63-year absence.'),
      _card(36, 'Chance', true),
      _property(37, 'Manhattan Beach', 'darkBlue', PropertyGroups.darkBlue, 350, [35, 175, 500, 1100, 1300, 1500],
        funFact: 'Manhattan Beach was founded in 1912 and its pier was originally built for a Pacific Electric Railway stop. The neighborhood\'s "Strand" beachfront path stretches 22 miles along the coast.'),
      _tax(38, 'Luxury Tax', 100),
      _property(39, 'Getty Center', 'darkBlue', PropertyGroups.darkBlue, 400, [50, 200, 600, 1400, 1700, 2000],
        funFact: 'The Getty Center cost \$1.3 billion to build and opened in 1997. Designed by Richard Meier, it sits atop a hill in the Santa Monica Mountains and admission has always been free.'),
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

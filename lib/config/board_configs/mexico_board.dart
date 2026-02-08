import 'package:flutter/material.dart';
import '../../models/tile.dart';

/// Mexico/Mexico City Monopoly board configuration with 40 tiles
class MexicoBoard {
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

  /// Railroad positions (Metro Lines in Mexico)
  static const List<int> railroadPositions = [5, 15, 25, 35];

  /// Utility positions
  static const List<int> utilityPositions = [12, 28];

  /// Chance card positions
  static const List<int> chancePositions = [7, 22, 36];

  /// Community Chest positions
  static const List<int> communityChestPositions = [2, 17, 33];

  /// Generate all 40 tiles for the Mexico board
  static List<TileData> generateTiles() {
    return [
      // Bottom row (right to left: 0-10)
      _corner(0, 'GO', TileType.start, subtext: 'SALIDA'),
      _property(1, 'Coyoacán', 'brown', PropertyGroups.brown, 60, [2, 10, 30, 90, 160, 250],
        funFact: 'Frida Kahlo was born here in 1907, and her Casa Azul museum, opened in 1958, now draws over 800,000 visitors per year.',
        subtext: 'Coyoacán'),
      _card(2, 'Comm Chest', false),
      _property(3, 'Xochimilco', 'brown', PropertyGroups.brown, 60, [4, 20, 60, 180, 320, 450],
        funFact: 'A UNESCO World Heritage Site since 1987, Xochimilco preserves 170 km of ancient canals and chinampas dating back to 1200 AD.',
        subtext: 'Xochimilco'),
      _tax(4, 'Income Tax', 200),
      _railroad(5, 'Línea 1', subtext: 'Metro Línea 1',
        funFact: 'Opened September 4, 1969, this 18.8 km line has 20 stations, each with a unique pictographic icon so riders can navigate without reading.'),
      _property(6, 'Roma Norte', 'lightBlue', PropertyGroups.lightBlue, 100, [6, 30, 90, 270, 400, 550],
        funFact: 'Developed in the early 1900s and heavily damaged in the 1985 earthquake, Roma Norte was revitalized in the 2000s into one of the city\'s top cultural hubs.',
        subtext: 'Roma Norte'),
      _card(7, 'Chance', true),
      _property(8, 'Condesa', 'lightBlue', PropertyGroups.lightBlue, 100, [6, 30, 90, 270, 400, 550],
        funFact: 'Built in the 1920s around the former Hipodromo de la Condesa racetrack, and Parque Mexico still traces the original oval track shape.',
        subtext: 'Condesa'),
      _property(9, 'Polanco', 'lightBlue', PropertyGroups.lightBlue, 120, [8, 40, 100, 300, 450, 600],
        funFact: 'Developed in the 1930s-40s and named after a 17th-century friar, Polanco hosts more museums per square kilometer than almost any neighborhood in the Americas.',
        subtext: 'Polanco'),
      _corner(10, 'JAIL', TileType.jail, color: const Color(0xFFFFE0B2), subtext: 'CÁRCEL'),

      // Left column (bottom to top: 11-20)
      _property(11, 'San Ángel', 'pink', PropertyGroups.pink, 140, [10, 50, 150, 450, 625, 750],
        funFact: 'The famous Bazar Sabado has run every Saturday since 1960 in the 17th-century Casa del Risco, making it one of Mexico\'s longest-running art markets.',
        subtext: 'San Ángel'),
      _utility(12, 'CFE', true,
        funFact: 'Founded on August 14, 1937, CFE serves over 46 million customers and is one of the largest electric utilities in the Americas.'),
      _property(13, 'Chapultepec', 'pink', PropertyGroups.pink, 140, [10, 50, 150, 450, 625, 750],
        funFact: 'Its name means \"Grasshopper Hill\" in Nahuatl, and this 686-hectare park has been a sacred site since at least the 13th century.',
        subtext: 'Chapultepec'),
      _property(14, 'Bosque de Chapultepec', 'pink', PropertyGroups.pink, 160, [12, 60, 180, 500, 700, 900],
        funFact: 'At 686 hectares (twice the size of Central Park), the Bosque contains 9 museums, a zoo founded in 1924, and ahuehuete trees over 700 years old.',
        subtext: 'Bosque'),
      _railroad(15, 'Línea 2', subtext: 'Metro Línea 2',
        funFact: 'Opened August 1, 1970, this 23.4 km line runs beneath key landmarks, and its construction unearthed Aztec artifacts now displayed in the stations.'),
      _property(16, 'Teotihuacán', 'orange', PropertyGroups.orange, 180, [14, 70, 200, 550, 750, 950],
        funFact: 'Built between 100 BC and 250 AD, the 65-meter-tall Pyramid of the Sun once anchored a city of over 125,000 residents, making it the 6th largest in the ancient world.',
        subtext: 'Teotihuacán'),
      _card(17, 'Comm Chest', false),
      _property(18, 'Templo Mayor', 'orange', PropertyGroups.orange, 180, [14, 70, 200, 550, 750, 950],
        funFact: 'Discovered on February 21, 1978 when electrical workers struck a massive stone disc, the excavation has yielded over 7,000 Aztec artifacts from this once 60-meter-tall temple.',
        subtext: 'Templo Mayor'),
      _property(19, 'Zócalo', 'orange', PropertyGroups.orange, 200, [16, 80, 220, 600, 800, 1000],
        funFact: 'Officially the Plaza de la Constitucion, this 46,800 m\u00B2 square has been the center of Mexican public life since the Aztec capital Tenochtitlan was founded in 1325.',
        subtext: 'Zócalo'),
      _corner(20, 'LUCKY SPIN', TileType.freeParking, subtext: 'GIRA Y GANA'),

      // Top row (left to right: 21-30)
      _property(21, 'Palacio Nacional', 'red', PropertyGroups.red, 220, [18, 90, 250, 700, 875, 1050],
        funFact: 'Built on the site of Moctezuma II\'s palace starting in 1522, Diego Rivera painted his epic murals across its walls from 1929 to 1951.',
        subtext: 'Palacio Nacional'),
      _card(22, 'Chance', true),
      _property(23, 'Bellas Artes', 'red', PropertyGroups.red, 220, [18, 90, 250, 700, 875, 1050],
        funFact: 'Construction began in 1904 but took 30 years to complete; its famous Tiffany glass curtain weighs 24 tons and depicts the Valley of Mexico volcanoes.',
        subtext: 'Bellas Artes'),
      _property(24, 'Reforma', 'red', PropertyGroups.red, 240, [20, 100, 300, 750, 925, 1100],
        funFact: 'Commissioned by Emperor Maximilian in 1864 as \"Paseo de la Emperatriz,\" this 15 km boulevard was renamed after the Reform War and is now Mexico City\'s main artery.',
        subtext: 'Reforma'),
      _railroad(25, 'Línea 3', subtext: 'Metro Línea 3',
        funFact: 'Opened November 20, 1970, this 23.6 km line with 21 stations is one of the system\'s busiest, carrying over 1 million riders daily.'),
      _property(26, 'Ángel de la Independencia', 'yellow', PropertyGroups.yellow, 260, [22, 110, 330, 800, 975, 1150],
        funFact: 'Inaugurated on September 16, 1910 for the centennial of independence, the gold-plated angel statue stands 6.7 meters tall atop a 36-meter column.',
        subtext: 'El Ángel'),
      _property(27, 'Zona Rosa', 'yellow', PropertyGroups.yellow, 260, [22, 110, 330, 800, 975, 1150],
        funFact: 'Named in the 1960s by artist Jose Luis Cuevas, it became Mexico\'s first openly LGBTQ+ neighborhood in the 1980s and home to a thriving Koreatown since the 1990s.',
        subtext: 'Zona Rosa'),
      _utility(28, 'Agua de México', false,
        funFact: 'Mexico City pumps 40% of its water from the Cutzamala system 127 km away; over-extraction from aquifers causes the city to sink 5-10 cm per year.'),
      _property(29, 'Santa Fe', 'yellow', PropertyGroups.yellow, 280, [24, 120, 360, 850, 1025, 1200],
        funFact: 'Transformed in the 1990s from what was once Latin America\'s largest garbage dump into a gleaming business district with over 10,000 corporate offices.',
        subtext: 'Santa Fe'),
      _corner(30, 'GO TO JAIL', TileType.goToJail, subtext: 'VE A LA CÁRCEL'),

      // Right column (top to bottom: 31-39)
      _property(31, 'Museo Frida Kahlo', 'green', PropertyGroups.green, 300, [26, 130, 390, 900, 1100, 1275],
        funFact: 'La Casa Azul opened as a museum in 1958, four years after Frida\'s death in 1954, and now receives over 800,000 visitors annually.',
        subtext: 'Casa Azul'),
      _property(32, 'Museo Soumaya', 'green', PropertyGroups.green, 300, [26, 130, 390, 900, 1100, 1275],
        funFact: 'Opened in 2011 with a facade of 16,000 aluminum hexagons, it houses 66,000 artworks including the largest Rodin collection outside France.',
        subtext: 'Soumaya'),
      _card(33, 'Comm Chest', false),
      _property(34, 'Antropología', 'green', PropertyGroups.green, 320, [28, 150, 450, 1000, 1200, 1400],
        funFact: 'Opened September 17, 1964, this museum holds the 24-ton Aztec Sun Stone and receives over 2 million visitors per year.',
        subtext: 'Antropología'),
      _railroad(35, 'Línea 12', subtext: 'Metro Línea 12',
        funFact: 'Opened October 30, 2012, this 24.5 km golden-colored line with 20 stations is the newest addition to Mexico City\'s metro network.'),
      _card(36, 'Chance', true),
      _property(37, 'Torre Latinoamericana', 'darkBlue', PropertyGroups.darkBlue, 350, [35, 175, 500, 1100, 1300, 1500],
        funFact: 'Completed in 1956 at 44 stories (182 m), it survived the devastating 8.0-magnitude 1985 earthquake without structural damage thanks to its deep-pile floating foundation.',
        subtext: 'Torre Latino'),
      _tax(38, 'Luxury Tax', 100),
      _property(39, 'Castillo de Chapultepec', 'darkBlue', PropertyGroups.darkBlue, 400, [50, 200, 600, 1400, 1700, 2000],
        funFact: 'Built between 1785 and 1864, it is the only royal castle in the Americas; Emperor Maximilian and Empress Carlota lived here from 1864 to 1867.',
        subtext: 'Castillo'),
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

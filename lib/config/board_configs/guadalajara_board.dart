import 'package:flutter/material.dart';
import '../../models/tile.dart';

/// Guadalajara, Mexico Monopoly board configuration with 40 tiles
class GuadalajaraBoard {
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

  /// Railroad positions (Tren Ligero and transit lines in Guadalajara)
  static const List<int> railroadPositions = [5, 15, 25, 35];

  /// Utility positions
  static const List<int> utilityPositions = [12, 28];

  /// Chance card positions
  static const List<int> chancePositions = [7, 22, 36];

  /// Community Chest positions
  static const List<int> communityChestPositions = [2, 17, 33];

  /// Generate all 40 tiles for the Guadalajara board
  static List<TileData> generateTiles() {
    return [
      // Bottom row (right to left: 0-10)
      _corner(0, 'GO', TileType.start, subtext: 'SALIDA'),
      _property(1, 'San Juan de Dios', 'brown', PropertyGroups.brown, 60, [2, 10, 30, 90, 160, 250],
        funFact: 'One of Latin America\'s largest indoor markets with over 3,000 stalls selling everything from leather goods to folk art, built in 1954.',
        subtext: 'San Juan de Dios'),
      _card(2, 'Comm Chest', false),
      _property(3, 'Analco', 'brown', PropertyGroups.brown, 60, [4, 20, 60, 180, 320, 450],
        funFact: 'One of Guadalajara\'s oldest neighborhoods, its Nahuatl name means "on the other side of the river" and dates back to the 16th century.',
        subtext: 'Analco'),
      _tax(4, 'Income Tax', 200),
      _railroad(5, 'Línea 1 (Tren Ligero)', subtext: 'Línea 1',
        funFact: 'Guadalajara\'s first light rail line opened in 1989, running north-south for 15.5 km through the heart of the city.'),
      _property(6, 'Tlaquepaque', 'lightBlue', PropertyGroups.lightBlue, 100, [6, 30, 90, 270, 400, 550],
        funFact: 'Famous artisan village known worldwide for hand-blown glass, pottery, and papier-mache figures. Its pedestrian center is a UNESCO cultural treasure.',
        subtext: 'Tlaquepaque'),
      _card(7, 'Chance', true),
      _property(8, 'Tonalá', 'lightBlue', PropertyGroups.lightBlue, 100, [6, 30, 90, 270, 400, 550],
        funFact: 'Mexico\'s largest open-air artisan market held every Thursday and Sunday, attracting over 10,000 vendors selling ceramics, blown glass, and folk art.',
        subtext: 'Tonalá'),
      _property(9, 'Zapopan Centro', 'lightBlue', PropertyGroups.lightBlue, 120, [8, 40, 100, 300, 450, 600],
        funFact: 'Home to the Basilica of Our Lady of Zapopan, where a tiny 16th-century corn-paste statue is paraded through the city every October 12th.',
        subtext: 'Zapopan Centro'),
      _corner(10, 'JAIL', TileType.jail, color: const Color(0xFFFFE0B2), subtext: 'CÁRCEL'),

      // Left column (bottom to top: 11-20)
      _property(11, 'La Minerva', 'pink', PropertyGroups.pink, 140, [10, 50, 150, 450, 625, 750],
        funFact: 'The iconic Minerva fountain roundabout features a Greek goddess statue symbolizing Guadalajara\'s strength and wisdom, erected in 1957.',
        subtext: 'La Minerva'),
      _utility(12, 'CFE Guadalajara', true,
        funFact: 'CFE provides electricity to Guadalajara\'s metropolitan area of over 5 million residents, the second-largest metro area in Mexico.'),
      _property(13, 'Chapalita', 'pink', PropertyGroups.pink, 140, [10, 50, 150, 450, 625, 750],
        funFact: 'An upscale residential neighborhood built in the 1940s around a central park, known for its tree-lined streets and European-style architecture.',
        subtext: 'Chapalita'),
      _property(14, 'Providencia', 'pink', PropertyGroups.pink, 160, [12, 60, 180, 500, 700, 900],
        funFact: 'Guadalajara\'s most exclusive residential area features luxury homes, upscale restaurants, and the famous Avenida Providencia lined with towering ash trees.',
        subtext: 'Providencia'),
      _railroad(15, 'Línea 2 (Tren Ligero)', subtext: 'Línea 2',
        funFact: 'Running east-west for 8.5 km, Línea 2 opened in 1994 and intersects with Línea 1 at the Juárez station downtown.'),
      _property(16, 'Centro Histórico', 'orange', PropertyGroups.orange, 180, [14, 70, 200, 550, 750, 950],
        funFact: 'Guadalajara\'s historic center was founded in 1542 and features stunning colonial architecture spanning nearly five centuries of Mexican history.',
        subtext: 'Centro Histórico'),
      _card(17, 'Comm Chest', false),
      _property(18, 'Catedral', 'orange', PropertyGroups.orange, 180, [14, 70, 200, 550, 750, 950],
        funFact: 'Guadalajara\'s twin-towered cathedral, built between 1561 and 1618, features a mix of Gothic, Baroque, and Neoclassical styles unique in Mexico.',
        subtext: 'Catedral'),
      _property(19, 'Hospicio Cabañas', 'orange', PropertyGroups.orange, 200, [16, 80, 220, 600, 800, 1000],
        funFact: 'A UNESCO World Heritage Site since 1997, housing José Clemente Orozco\'s masterpiece mural "The Man of Fire" painted across 57 ceiling frescoes.',
        subtext: 'Hospicio Cabañas'),
      _corner(20, 'LUCKY SPIN', TileType.freeParking, subtext: 'GIRA Y GANA'),

      // Top row (left to right: 21-30)
      _property(21, 'Teatro Degollado', 'red', PropertyGroups.red, 220, [18, 90, 250, 700, 875, 1050],
        funFact: 'Opened in 1866, this neoclassical theater features a ceiling fresco inspired by Dante\'s Divine Comedy and hosts the Guadalajara Philharmonic.',
        subtext: 'Teatro Degollado'),
      _card(22, 'Chance', true),
      _property(23, 'Chapultepec', 'red', PropertyGroups.red, 220, [18, 90, 250, 700, 875, 1050],
        funFact: 'Guadalajara\'s trendiest avenue is packed with sidewalk cafes, art galleries, and nightlife. Every weekend the street closes to traffic for a vibrant cultural corridor.',
        subtext: 'Chapultepec'),
      _property(24, 'Americana', 'red', PropertyGroups.red, 240, [20, 100, 300, 750, 925, 1100],
        funFact: 'A bohemian neighborhood with stunning early-1900s mansions blending French and Art Deco styles, now home to boutique hotels and trendy restaurants.',
        subtext: 'Americana'),
      _railroad(25, 'Línea 3 (Mi Tren)', subtext: 'Línea 3',
        funFact: 'Guadalajara\'s first elevated rail line opened in 2020, spanning 21.5 km and connecting Zapopan to Tlaquepaque with modern driverless trains.'),
      _property(26, 'Plaza del Sol', 'yellow', PropertyGroups.yellow, 260, [22, 110, 330, 800, 975, 1150],
        funFact: 'When it opened in 1969, Plaza del Sol was the largest shopping center in Latin America, revolutionizing retail culture in western Mexico.',
        subtext: 'Plaza del Sol'),
      _property(27, 'Colonia Moderna', 'yellow', PropertyGroups.yellow, 260, [22, 110, 330, 800, 975, 1150],
        funFact: 'A vibrant neighborhood where traditional Mexican culture meets modern urban life, known for its colorful street murals and local taco stands.',
        subtext: 'Colonia Moderna'),
      _utility(28, 'SIAPA', false,
        funFact: 'SIAPA manages drinking water and sewage for Guadalajara\'s metro area, sourcing water from Lake Chapala, Mexico\'s largest freshwater lake.'),
      _property(29, 'Glorieta de Los Niños Héroes', 'yellow', PropertyGroups.yellow, 280, [24, 120, 360, 850, 1025, 1200],
        funFact: 'This monument honors the six teenage military cadets who died defending Chapultepec Castle during the Mexican-American War in 1847.',
        subtext: 'Niños Héroes'),
      _corner(30, 'GO TO JAIL', TileType.goToJail, subtext: 'VE A LA CÁRCEL'),

      // Right column (top to bottom: 31-39)
      _property(31, 'Parque Metropolitano', 'green', PropertyGroups.green, 300, [26, 130, 390, 900, 1100, 1275],
        funFact: 'At 113 hectares, this urban forest is Guadalajara\'s green lung, featuring jogging trails, a lake, and the city\'s largest outdoor amphitheater.',
        subtext: 'Parque Metropolitano'),
      _property(32, 'Barranca de Huentitán', 'green', PropertyGroups.green, 300, [26, 130, 390, 900, 1100, 1275],
        funFact: 'A dramatic 600-meter-deep canyon on Guadalajara\'s northern edge with the Santiago River flowing below, offering breathtaking hiking trails and zip lines.',
        subtext: 'Barranca'),
      _card(33, 'Comm Chest', false),
      _property(34, 'Tequila', 'green', PropertyGroups.green, 320, [28, 150, 450, 1000, 1200, 1400],
        funFact: 'The UNESCO-listed town 60 km from Guadalajara gave the world\'s most famous spirit its name. Blue agave fields surrounding it were declared a World Heritage landscape in 2006.',
        subtext: 'Tequila'),
      _railroad(35, 'Macrobús', subtext: 'Macrobús',
        funFact: 'Guadalajara\'s bus rapid transit system launched in 2009, moving 180,000 passengers daily along a dedicated 16 km corridor on Calzada Independencia.'),
      _card(36, 'Chance', true),
      _property(37, 'Lago de Chapala', 'darkBlue', PropertyGroups.darkBlue, 350, [35, 175, 500, 1100, 1300, 1500],
        funFact: 'Mexico\'s largest freshwater lake at 1,112 square kilometers, just 45 minutes from Guadalajara, home to the largest American and Canadian expat community in Mexico.',
        subtext: 'Lago de Chapala'),
      _tax(38, 'Luxury Tax', 100),
      _property(39, 'Rotonda de los Jaliscienses Ilustres', 'darkBlue', PropertyGroups.darkBlue, 400, [50, 200, 600, 1400, 1700, 2000],
        funFact: 'This neoclassical rotunda honors 98 illustrious citizens of Jalisco. Built in 1952, it contains the remains of famous artists, scientists, and revolutionaries.',
        subtext: 'Rotonda'),
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

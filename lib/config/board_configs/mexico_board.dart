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
        funFact: 'Frida Kahlo\'s birthplace! Her famous Blue House museum attracts thousands daily!',
        subtext: 'Coyoacán'),
      _card(2, 'Comm Chest', false),
      _property(3, 'Xochimilco', 'brown', PropertyGroups.brown, 60, [4, 20, 60, 180, 320, 450],
        funFact: 'Ancient Aztec canals where colorful trajineras float among floating gardens!',
        subtext: 'Xochimilco'),
      _tax(4, 'Income Tax', 200),
      _railroad(5, 'Línea 1', subtext: 'Metro Línea 1',
        funFact: 'Mexico City\'s first metro line, opened in 1969! Uses symbols for illiterate riders!'),
      _property(6, 'Roma Norte', 'lightBlue', PropertyGroups.lightBlue, 100, [6, 30, 90, 270, 400, 550],
        funFact: 'Hip neighborhood filled with Art Nouveau and Art Deco architecture!',
        subtext: 'Roma Norte'),
      _card(7, 'Chance', true),
      _property(8, 'Condesa', 'lightBlue', PropertyGroups.lightBlue, 100, [6, 30, 90, 270, 400, 550],
        funFact: 'Tree-lined Art Deco district built around a former horse racing track!',
        subtext: 'Condesa'),
      _property(9, 'Polanco', 'lightBlue', PropertyGroups.lightBlue, 120, [8, 40, 100, 300, 450, 600],
        funFact: 'Mexico City\'s Beverly Hills, home to embassies and luxury boutiques!',
        subtext: 'Polanco'),
      _corner(10, 'JAIL', TileType.jail, color: const Color(0xFFFFE0B2), subtext: 'CÁRCEL'),

      // Left column (bottom to top: 11-20)
      _property(11, 'San Ángel', 'pink', PropertyGroups.pink, 140, [10, 50, 150, 450, 625, 750],
        funFact: 'Colonial neighborhood with cobblestone streets and a vibrant Saturday art market!',
        subtext: 'San Ángel'),
      _utility(12, 'CFE', true,
        funFact: 'Comisión Federal de Electricidad powers all of Mexico!'),
      _property(13, 'Chapultepec', 'pink', PropertyGroups.pink, 140, [10, 50, 150, 450, 625, 750],
        funFact: 'One of the largest city parks in the Western Hemisphere at 686 hectares!',
        subtext: 'Chapultepec'),
      _property(14, 'Bosque de Chapultepec', 'pink', PropertyGroups.pink, 160, [12, 60, 180, 500, 700, 900],
        funFact: 'This forest park is twice the size of New York\'s Central Park!',
        subtext: 'Bosque'),
      _railroad(15, 'Línea 2', subtext: 'Metro Línea 2',
        funFact: 'The Blue Line connects major cultural sites including Bellas Artes!'),
      _property(16, 'Teotihuacán', 'orange', PropertyGroups.orange, 180, [14, 70, 200, 550, 750, 950],
        funFact: 'Ancient pyramids! The Pyramid of the Sun is the 3rd largest pyramid in the world!',
        subtext: 'Teotihuacán'),
      _card(17, 'Comm Chest', false),
      _property(18, 'Templo Mayor', 'orange', PropertyGroups.orange, 180, [14, 70, 200, 550, 750, 950],
        funFact: 'Main temple of the Aztecs, discovered accidentally in 1978 by electric workers!',
        subtext: 'Templo Mayor'),
      _property(19, 'Zócalo', 'orange', PropertyGroups.orange, 200, [16, 80, 220, 600, 800, 1000],
        funFact: 'One of the world\'s largest public squares, the heart of Mexico City since Aztec times!',
        subtext: 'Zócalo'),
      _corner(20, 'LUCKY SPIN', TileType.freeParking, subtext: 'GIRA Y GANA'),

      // Top row (left to right: 21-30)
      _property(21, 'Palacio Nacional', 'red', PropertyGroups.red, 220, [18, 90, 250, 700, 875, 1050],
        funFact: 'Home to Diego Rivera\'s famous murals depicting Mexican history!',
        subtext: 'Palacio Nacional'),
      _card(22, 'Chance', true),
      _property(23, 'Bellas Artes', 'red', PropertyGroups.red, 220, [18, 90, 250, 700, 875, 1050],
        funFact: 'Stunning Art Nouveau palace with a curtain made of nearly 1 million glass pieces!',
        subtext: 'Bellas Artes'),
      _property(24, 'Reforma', 'red', PropertyGroups.red, 240, [20, 100, 300, 750, 925, 1100],
        funFact: 'Grand avenue inspired by the Champs-Élysées, lined with monuments and skyscrapers!',
        subtext: 'Reforma'),
      _railroad(25, 'Línea 3', subtext: 'Metro Línea 3',
        funFact: 'The Olive Line serves 1.3 million passengers daily!'),
      _property(26, 'Ángel de la Independencia', 'yellow', PropertyGroups.yellow, 260, [22, 110, 330, 800, 975, 1150],
        funFact: 'Mexico\'s most iconic monument, celebrating independence from Spain!',
        subtext: 'El Ángel'),
      _property(27, 'Zona Rosa', 'yellow', PropertyGroups.yellow, 260, [22, 110, 330, 800, 975, 1150],
        funFact: 'Pink Zone! Historic LGBTQ+ friendly neighborhood with Korean and international flair!',
        subtext: 'Zona Rosa'),
      _utility(28, 'Agua de México', false,
        funFact: 'Mexico City gets water from underground aquifers and distant mountain sources!'),
      _property(29, 'Santa Fe', 'yellow', PropertyGroups.yellow, 280, [24, 120, 360, 850, 1025, 1200],
        funFact: 'Ultra-modern business district rising from a former garbage dump!',
        subtext: 'Santa Fe'),
      _corner(30, 'GO TO JAIL', TileType.goToJail, subtext: 'VE A LA CÁRCEL'),

      // Right column (top to bottom: 31-39)
      _property(31, 'Museo Frida Kahlo', 'green', PropertyGroups.green, 300, [26, 130, 390, 900, 1100, 1275],
        funFact: 'The Blue House where Frida lived, loved, and created her iconic art!',
        subtext: 'Casa Azul'),
      _property(32, 'Museo Soumaya', 'green', PropertyGroups.green, 300, [26, 130, 390, 900, 1100, 1275],
        funFact: 'Stunning silver building housing 66,000 artworks, including works by Rodin!',
        subtext: 'Soumaya'),
      _card(33, 'Comm Chest', false),
      _property(34, 'Antropología', 'green', PropertyGroups.green, 320, [28, 150, 450, 1000, 1200, 1400],
        funFact: 'World\'s largest anthropology museum, showcasing 3,000 years of Mexican culture!',
        subtext: 'Antropología'),
      _railroad(35, 'Línea 12', subtext: 'Metro Línea 12',
        funFact: 'The Golden Line, Mexico City\'s newest metro line!'),
      _card(36, 'Chance', true),
      _property(37, 'Torre Latinoamericana', 'darkBlue', PropertyGroups.darkBlue, 350, [35, 175, 500, 1100, 1300, 1500],
        funFact: 'Built in 1956, survived major earthquakes thanks to innovative floating foundation!',
        subtext: 'Torre Latino'),
      _tax(38, 'Luxury Tax', 100),
      _property(39, 'Castillo de Chapultepec', 'darkBlue', PropertyGroups.darkBlue, 400, [50, 200, 600, 1400, 1700, 2000],
        funFact: 'The only royal castle in North America, former home of Emperor Maximilian!',
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

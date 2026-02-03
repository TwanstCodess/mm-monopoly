import 'package:flutter/material.dart';
import '../../models/tile.dart';

/// France/Paris Monopoly board configuration with 40 tiles
class FranceBoard {
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

  /// Railroad positions (Metro Lines in France)
  static const List<int> railroadPositions = [5, 15, 25, 35];

  /// Utility positions
  static const List<int> utilityPositions = [12, 28];

  /// Chance card positions
  static const List<int> chancePositions = [7, 22, 36];

  /// Community Chest positions
  static const List<int> communityChestPositions = [2, 17, 33];

  /// Generate all 40 tiles for the France board
  static List<TileData> generateTiles() {
    return [
      // Bottom row (right to left: 0-10)
      _corner(0, 'GO', TileType.start, subtext: 'DÉPART'),
      _property(1, 'Montmartre', 'brown', PropertyGroups.brown, 60, [2, 10, 30, 90, 160, 250],
        funFact: 'This hilltop village is crowned by the stunning white Sacré-Cœur Basilica!',
        subtext: 'Montmartre'),
      _card(2, 'Community Chest', false),
      _property(3, 'Pigalle', 'brown', PropertyGroups.brown, 60, [4, 20, 60, 180, 320, 450],
        funFact: 'Famous for the Moulin Rouge cabaret, founded in 1889!',
        subtext: 'Pigalle'),
      _tax(4, 'Income Tax', 200),
      _railroad(5, 'Ligne 1', subtext: 'Métro Ligne 1',
        funFact: 'The first metro line in Paris, opened in 1900 for the World\'s Fair!'),
      _property(6, 'Bastille', 'lightBlue', PropertyGroups.lightBlue, 100, [6, 30, 90, 270, 400, 550],
        funFact: 'Site of the famous fortress prison stormed during the French Revolution in 1789!',
        subtext: 'Bastille'),
      _card(7, 'Chance', true),
      _property(8, 'Marais', 'lightBlue', PropertyGroups.lightBlue, 100, [6, 30, 90, 270, 400, 550],
        funFact: 'The historic Jewish quarter, now one of Paris\'s trendiest neighborhoods!',
        subtext: 'Le Marais'),
      _property(9, 'Luxembourg', 'lightBlue', PropertyGroups.lightBlue, 120, [8, 40, 100, 300, 450, 600],
        funFact: 'The Luxembourg Gardens feature 106 statues and the beautiful Medici Fountain!',
        subtext: 'Luxembourg'),
      _corner(10, 'JAIL', TileType.jail, color: const Color(0xFFFFE0B2), subtext: 'PRISON'),

      // Left column (bottom to top: 11-20)
      _property(11, 'Saint-Germain', 'pink', PropertyGroups.pink, 140, [10, 50, 150, 450, 625, 750],
        funFact: 'Historic literary café district where Hemingway and Sartre debated philosophy!',
        subtext: 'St-Germain-des-Prés'),
      _utility(12, 'EDF', true,
        funFact: 'Électricité de France is the world\'s largest producer of electricity!'),
      _property(13, 'Latin Quarter', 'pink', PropertyGroups.pink, 140, [10, 50, 150, 450, 625, 750],
        funFact: 'Home to the Sorbonne University, founded in 1257!',
        subtext: 'Quartier Latin'),
      _property(14, 'Panthéon', 'pink', PropertyGroups.pink, 160, [12, 60, 180, 500, 700, 900],
        funFact: 'Final resting place of France\'s greatest minds including Voltaire and Rousseau!',
        subtext: 'Panthéon'),
      _railroad(15, 'Ligne 4', subtext: 'Métro Ligne 4',
        funFact: 'This line crosses the Seine twice and passes under Île de la Cité!'),
      _property(16, 'Versailles', 'orange', PropertyGroups.orange, 180, [14, 70, 200, 550, 750, 950],
        funFact: 'The Palace of Versailles has 2,300 rooms and 67,000 square meters of floor space!',
        subtext: 'Versailles'),
      _card(17, 'Community Chest', false),
      _property(18, 'Tuileries', 'orange', PropertyGroups.orange, 180, [14, 70, 200, 550, 750, 950],
        funFact: 'These royal gardens connect the Louvre to the Place de la Concorde!',
        subtext: 'Tuileries'),
      _property(19, 'Louvre', 'orange', PropertyGroups.orange, 200, [16, 80, 220, 600, 800, 1000],
        funFact: 'The world\'s largest art museum, home to the Mona Lisa and 38,000 artworks!',
        subtext: 'Le Louvre'),
      _corner(20, 'LUCKY SPIN', TileType.freeParking, subtext: 'ROUE CHANCE'),

      // Top row (left to right: 21-30)
      _property(21, 'Opéra', 'red', PropertyGroups.red, 220, [18, 90, 250, 700, 875, 1050],
        funFact: 'The Palais Garnier opera house inspired "The Phantom of the Opera"!',
        subtext: 'Opéra Garnier'),
      _card(22, 'Chance', true),
      _property(23, 'Champs-Élysées', 'red', PropertyGroups.red, 220, [18, 90, 250, 700, 875, 1050],
        funFact: 'The most expensive retail street in Europe at €12,000 per square meter!',
        subtext: 'Champs-Élysées'),
      _property(24, 'Arc de Triomphe', 'red', PropertyGroups.red, 240, [20, 100, 300, 750, 925, 1100],
        funFact: 'Built by Napoleon, it honors those who fought for France!',
        subtext: 'Arc de Triomphe'),
      _railroad(25, 'RER A', subtext: 'RER Ligne A',
        funFact: 'The busiest train line in Europe, carrying 1.2 million passengers daily!'),
      _property(26, 'La Défense', 'yellow', PropertyGroups.yellow, 260, [22, 110, 330, 800, 975, 1150],
        funFact: 'Europe\'s largest business district with the iconic Grande Arche!',
        subtext: 'La Défense'),
      _property(27, 'Concorde', 'yellow', PropertyGroups.yellow, 260, [22, 110, 330, 800, 975, 1150],
        funFact: 'Where Louis XVI and Marie Antoinette were executed during the Revolution!',
        subtext: 'Place de la Concorde'),
      _utility(28, 'Veolia Water', false,
        funFact: 'Paris water comes from sources over 150km away, ensuring the finest quality!'),
      _property(29, 'Invalides', 'yellow', PropertyGroups.yellow, 280, [24, 120, 360, 850, 1025, 1200],
        funFact: 'Napoleon\'s tomb lies under the golden dome of Les Invalides!',
        subtext: 'Les Invalides'),
      _corner(30, 'GO TO JAIL', TileType.goToJail, subtext: 'ALLEZ EN PRISON'),

      // Right column (top to bottom: 31-39)
      _property(31, 'Île de la Cité', 'green', PropertyGroups.green, 300, [26, 130, 390, 900, 1100, 1275],
        funFact: 'The historic heart of Paris, where the city was founded in 250 BC!',
        subtext: 'Île de la Cité'),
      _property(32, 'Notre-Dame', 'green', PropertyGroups.green, 300, [26, 130, 390, 900, 1100, 1275],
        funFact: 'This Gothic masterpiece took 182 years to complete (1163-1345)!',
        subtext: 'Notre-Dame'),
      _card(33, 'Community Chest', false),
      _property(34, 'Musée d\'Orsay', 'green', PropertyGroups.green, 320, [28, 150, 450, 1000, 1200, 1400],
        funFact: 'Built in a former railway station, it houses the world\'s finest Impressionist collection!',
        subtext: 'Musée d\'Orsay'),
      _railroad(35, 'Ligne 14', subtext: 'Métro Ligne 14',
        funFact: 'Paris\'s newest fully automated metro line, opened in 1998!'),
      _card(36, 'Chance', true),
      _property(37, 'Montparnasse', 'darkBlue', PropertyGroups.darkBlue, 350, [35, 175, 500, 1100, 1300, 1500],
        funFact: 'Historic artist quarter where Picasso, Hemingway, and Fitzgerald gathered!',
        subtext: 'Montparnasse'),
      _tax(38, 'Luxury Tax', 100),
      _property(39, 'Eiffel Tower', 'darkBlue', PropertyGroups.darkBlue, 400, [50, 200, 600, 1400, 1700, 2000],
        funFact: 'The Iron Lady weighs 10,100 tons and was the world\'s tallest structure until 1930!',
        subtext: 'Tour Eiffel'),
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

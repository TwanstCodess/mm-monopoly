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
        funFact: 'Sacré-Cœur Basilica, completed in 1914 after 39 years of construction, sits atop the highest point in Paris at 130 meters above sea level.',
        subtext: 'Montmartre'),
      _card(2, 'Comm Chest', false),
      _property(3, 'Pigalle', 'brown', PropertyGroups.brown, 60, [4, 20, 60, 180, 320, 450],
        funFact: 'The Moulin Rouge opened on October 6, 1889, introducing the can-can dance to the world and attracting 300,000 visitors in its first year.',
        subtext: 'Pigalle'),
      _tax(4, 'Income Tax', 200),
      _railroad(5, 'Ligne 1', subtext: 'Métro Ligne 1',
        funFact: 'Opened on July 19, 1900 for the Paris World\'s Fair, Ligne 1 now carries over 725,000 passengers daily across 16.5 km with 25 stations.'),
      _property(6, 'Bastille', 'lightBlue', PropertyGroups.lightBlue, 100, [6, 30, 90, 270, 400, 550],
        funFact: 'On July 14, 1789, a crowd of about 1,000 stormed the Bastille fortress, an event now celebrated annually as France\'s national holiday.',
        subtext: 'Bastille'),
      _card(7, 'Chance', true),
      _property(8, 'Marais', 'lightBlue', PropertyGroups.lightBlue, 100, [6, 30, 90, 270, 400, 550],
        funFact: 'Dating back to the 13th century as marshland (marais means swamp), Le Marais was saved from demolition in 1962 when Andre Malraux passed France\'s first historic preservation law.',
        subtext: 'Le Marais'),
      _property(9, 'Luxembourg', 'lightBlue', PropertyGroups.lightBlue, 120, [8, 40, 100, 300, 450, 600],
        funFact: 'Created in 1612 for Marie de Medici, the Luxembourg Gardens span 23 hectares and feature 106 statues, a puppet theater dating to 1933, and a miniature Statue of Liberty.',
        subtext: 'Luxembourg'),
      _corner(10, 'JAIL', TileType.jail, color: const Color(0xFFFFE0B2), subtext: 'PRISON'),

      // Left column (bottom to top: 11-20)
      _property(11, 'Saint-Germain', 'pink', PropertyGroups.pink, 140, [10, 50, 150, 450, 625, 750],
        funFact: 'In the 1940s-1950s, Cafe de Flore and Les Deux Magots became the intellectual heart of Paris, where Sartre and Simone de Beauvoir wrote entire books at their regular tables.',
        subtext: 'St-Germain-des-Prés'),
      _utility(12, 'EDF', true,
        funFact: 'Founded in 1946 by nationalizing 1,700 private companies, EDF now operates 56 nuclear reactors supplying about 70% of France\'s electricity.'),
      _property(13, 'Latin Quarter', 'pink', PropertyGroups.pink, 140, [10, 50, 150, 450, 625, 750],
        funFact: 'Named for the Latin spoken by medieval scholars, the Quartier Latin is home to the Sorbonne, founded in 1257 by Robert de Sorbon as a theology college for just 16 students.',
        subtext: 'Quartier Latin'),
      _property(14, 'Panthéon', 'pink', PropertyGroups.pink, 160, [12, 60, 180, 500, 700, 900],
        funFact: 'Originally built as a church from 1758 to 1790, the Pantheon houses 83 distinguished figures including Marie Curie, the first woman honored there in 1995 on her own merit.',
        subtext: 'Panthéon'),
      _railroad(15, 'Ligne 4', subtext: 'Métro Ligne 4',
        funFact: 'Opened in 1908, Ligne 4 was the first Paris metro to cross beneath the Seine River, using a revolutionary compressed-air tunneling method to bore through the riverbed.'),
      _property(16, 'Versailles', 'orange', PropertyGroups.orange, 180, [14, 70, 200, 550, 750, 950],
        funFact: 'Louis XIV transformed a hunting lodge into the Palace of Versailles between 1661 and 1715, spending roughly 2 billion euros in today\'s money on its 2,300 rooms and 800 hectares of gardens.',
        subtext: 'Versailles'),
      _card(17, 'Comm Chest', false),
      _property(18, 'Tuileries', 'orange', PropertyGroups.orange, 180, [14, 70, 200, 550, 750, 950],
        funFact: 'Designed by Catherine de Medici in 1564, the Tuileries Garden is Paris\'s oldest public park and spans 25.5 hectares between the Louvre and Place de la Concorde.',
        subtext: 'Tuileries'),
      _property(19, 'Louvre', 'orange', PropertyGroups.orange, 200, [16, 80, 220, 600, 800, 1000],
        funFact: 'Originally a 12th-century fortress built by King Philippe Auguste in 1190, the Louvre welcomed 8.9 million visitors in 2023, making it the world\'s most visited museum.',
        subtext: 'Le Louvre'),
      _corner(20, 'LUCKY SPIN', TileType.freeParking, subtext: 'ROUE CHANCE'),

      // Top row (left to right: 21-30)
      _property(21, 'Opéra', 'red', PropertyGroups.red, 220, [18, 90, 250, 700, 875, 1050],
        funFact: 'Designed by Charles Garnier in 1861, the Palais Garnier took 14 years to build, features a 7-ton bronze chandelier, and has an underground lake that inspired Gaston Leroux\'s 1910 novel.',
        subtext: 'Opéra Garnier'),
      _card(22, 'Chance', true),
      _property(23, 'Champs-Élysées', 'red', PropertyGroups.red, 220, [18, 90, 250, 700, 875, 1050],
        funFact: 'Stretching 1.91 km from the Arc de Triomphe to Place de la Concorde, the Champs-Elysees was originally farmland until 1667 when Andre Le Notre transformed it into a grand promenade.',
        subtext: 'Champs-Élysées'),
      _property(24, 'Arc de Triomphe', 'red', PropertyGroups.red, 240, [20, 100, 300, 750, 925, 1100],
        funFact: 'Commissioned by Napoleon in 1806 after the Battle of Austerlitz, the Arc de Triomphe took 30 years to complete and stands 50 meters tall with the names of 660 generals engraved on its walls.',
        subtext: 'Arc de Triomphe'),
      _railroad(25, 'RER A', subtext: 'RER Ligne A',
        funFact: 'Opened in 1969, the RER A stretches 109 km across the Paris region, carrying over 1.2 million passengers daily and connecting La Defense business district to Disneyland Paris.'),
      _property(26, 'La Défense', 'yellow', PropertyGroups.yellow, 260, [22, 110, 330, 800, 975, 1150],
        funFact: 'Home to 1,500 corporate headquarters and 180,000 daily workers, La Defense\'s Grande Arche was completed in 1989 for the French Revolution\'s bicentennial and could fit Notre-Dame inside it.',
        subtext: 'La Défense'),
      _property(27, 'Concorde', 'yellow', PropertyGroups.yellow, 260, [22, 110, 330, 800, 975, 1150],
        funFact: 'The 3,300-year-old Luxor Obelisk at its center was a gift from Egypt in 1833, and during the Revolution over 1,300 people were guillotined at this square between 1793 and 1795.',
        subtext: 'Place de la Concorde'),
      _utility(28, 'Veolia Water', false,
        funFact: 'Paris remunicipalized its water supply in 2010 with Eau de Paris, delivering 483,000 cubic meters daily through 2,000 km of pipes to 3 million residents.'),
      _property(29, 'Invalides', 'yellow', PropertyGroups.yellow, 280, [24, 120, 360, 850, 1025, 1200],
        funFact: 'Built by Louis XIV in 1670 to house wounded soldiers, Les Invalides\' golden dome soars 107 meters high, and Napoleon\'s tomb rests in six nested coffins beneath it.',
        subtext: 'Les Invalides'),
      _corner(30, 'GO TO JAIL', TileType.goToJail, subtext: 'ALLEZ EN PRISON'),

      // Right column (top to bottom: 31-39)
      _property(31, 'Île de la Cité', 'green', PropertyGroups.green, 300, [26, 130, 390, 900, 1100, 1275],
        funFact: 'Settled by the Parisii tribe around 250 BC, this 22-acre island in the Seine is home to both Notre-Dame and the Sainte-Chapelle, whose 15 stained-glass windows contain 1,113 biblical scenes.',
        subtext: 'Île de la Cité'),
      _property(32, 'Notre-Dame', 'green', PropertyGroups.green, 300, [26, 130, 390, 900, 1100, 1275],
        funFact: 'Construction began in 1163 and took 182 years to complete. After the devastating fire of April 15, 2019, over 840 million euros were donated within days for its restoration.',
        subtext: 'Notre-Dame'),
      _card(33, 'Comm Chest', false),
      _property(34, 'Musée d\'Orsay', 'green', PropertyGroups.green, 320, [28, 150, 450, 1000, 1200, 1400],
        funFact: 'Built as the Gare d\'Orsay railway station for the 1900 World\'s Fair, it was converted into a museum in 1986 and now houses over 3,000 Impressionist masterpieces by Monet, Renoir, and Van Gogh.',
        subtext: 'Musée d\'Orsay'),
      _railroad(35, 'Ligne 14', subtext: 'Métro Ligne 14',
        funFact: 'Opened in 1998 as Paris\'s first fully driverless metro line, Ligne 14 runs trains every 85 seconds during peak hours and was extended to Orly Airport in 2024.'),
      _card(36, 'Chance', true),
      _property(37, 'Montparnasse', 'darkBlue', PropertyGroups.darkBlue, 350, [35, 175, 500, 1100, 1300, 1500],
        funFact: 'In the 1920s, La Rotonde and Le Dome cafes became the creative hub for Picasso, Modigliani, and Man Ray. Today the 210-meter Tour Montparnasse offers the best panoramic view of Paris.',
        subtext: 'Montparnasse'),
      _tax(38, 'Luxury Tax', 100),
      _property(39, 'Eiffel Tower', 'darkBlue', PropertyGroups.darkBlue, 400, [50, 200, 600, 1400, 1700, 2000],
        funFact: 'Built in just 2 years and 2 months for the 1889 World\'s Fair by 300 workers using 2.5 million rivets, the 330-meter tower was meant to be temporary but was saved by its usefulness as a radio antenna.',
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

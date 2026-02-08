import 'package:flutter/material.dart';
import '../../models/tile.dart';

/// Lyon, France Monopoly board configuration with 40 tiles
class LyonBoard {
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

  /// Railroad positions (Lyon rail and metro lines)
  static const List<int> railroadPositions = [5, 15, 25, 35];

  /// Utility positions
  static const List<int> utilityPositions = [12, 28];

  /// Chance card positions
  static const List<int> chancePositions = [7, 22, 36];

  /// Community Chest positions
  static const List<int> communityChestPositions = [2, 17, 33];

  /// Generate all 40 tiles for the Lyon board
  static List<TileData> generateTiles() {
    return [
      // Bottom row (right to left: 0-10)
      _corner(0, 'GO', TileType.start, subtext: 'DÉPART'),
      _property(1, 'Vieux Lyon', 'brown', PropertyGroups.brown, 60, [2, 10, 30, 90, 160, 250],
        funFact: 'Vieux Lyon is one of the largest Renaissance districts in Europe, spanning 424 hectares and designated a UNESCO World Heritage Site in 1998.',
        subtext: 'Vieux Lyon'),
      _card(2, 'Comm Chest', false),
      _property(3, 'Traboules', 'brown', PropertyGroups.brown, 60, [4, 20, 60, 180, 320, 450],
        funFact: 'Lyon\'s traboules are secret passageways that cut through buildings and courtyards, originally used by silk workers and later by the French Resistance during World War II.',
        subtext: 'Les Traboules'),
      _tax(4, 'Income Tax', 200),
      _railroad(5, 'Lyon Part-Dieu', subtext: 'Gare Part-Dieu',
        funFact: 'Lyon Part-Dieu is the largest railway station in France outside Paris, serving over 30 million passengers annually.'),
      _property(6, 'Guillotière', 'lightBlue', PropertyGroups.lightBlue, 100, [6, 30, 90, 270, 400, 550],
        funFact: 'La Guillotière is one of Lyon\'s oldest neighborhoods, home to the historic Pont de la Guillotière bridge dating back to 1070.',
        subtext: 'La Guillotière'),
      _card(7, 'Chance', true),
      _property(8, 'Ainay', 'lightBlue', PropertyGroups.lightBlue, 100, [6, 30, 90, 270, 400, 550],
        funFact: 'The Basilica of Saint-Martin d\'Ainay in this quarter is one of the oldest churches in Lyon, consecrated by Pope Paschal II in 1107.',
        subtext: 'Quartier d\'Ainay'),
      _property(9, 'Croix-Rousse', 'lightBlue', PropertyGroups.lightBlue, 120, [8, 40, 100, 300, 450, 600],
        funFact: 'Known as "the hill that works," Croix-Rousse was the heart of Lyon\'s silk weaving industry, with buildings featuring extra-tall ceilings to accommodate the Jacquard looms.',
        subtext: 'La Croix-Rousse'),
      _corner(10, 'JAIL', TileType.jail, color: const Color(0xFFFFE0B2), subtext: 'PRISON'),

      // Left column (bottom to top: 11-20)
      _property(11, 'St-Jean', 'pink', PropertyGroups.pink, 140, [10, 50, 150, 450, 625, 750],
        funFact: 'The Cathedral of Saint-Jean-Baptiste took over 300 years to build, from 1180 to 1480, and houses a 14th-century astronomical clock that still functions today.',
        subtext: 'Cathédrale St-Jean'),
      _utility(12, 'EDF Lyon', true,
        funFact: 'Lyon\'s EDF operations manage electricity distribution across the Rhône-Alpes region, powering one of France\'s most industrialized metropolitan areas.'),
      _property(13, 'Terreaux', 'pink', PropertyGroups.pink, 140, [10, 50, 150, 450, 625, 750],
        funFact: 'Place des Terreaux features the famous Bartholdi Fountain, designed by the same sculptor who created the Statue of Liberty in New York.',
        subtext: 'Place des Terreaux'),
      _property(14, 'Place des Jacobins', 'pink', PropertyGroups.pink, 160, [12, 60, 180, 500, 700, 900],
        funFact: 'The Place des Jacobins fountain, erected in 1885, honors four Lyonnais artists and is surrounded by elegant 19th-century Haussmann-style buildings.',
        subtext: 'Place des Jacobins'),
      _railroad(15, 'Lyon Perrache', subtext: 'Gare de Perrache',
        funFact: 'Opened in 1857, Gare de Perrache was Lyon\'s main station for over a century and sits at the southern tip of the Presqu\'île peninsula.'),
      _property(16, 'Opéra', 'orange', PropertyGroups.orange, 180, [14, 70, 200, 550, 750, 950],
        funFact: 'The Opéra de Lyon was radically redesigned by architect Jean Nouvel in 1993, who added a striking glass barrel-vault roof that doubled the building\'s height.',
        subtext: 'Opéra de Lyon'),
      _card(17, 'Comm Chest', false),
      _property(18, 'Halles de Lyon', 'orange', PropertyGroups.orange, 180, [14, 70, 200, 550, 750, 950],
        funFact: 'Les Halles de Lyon Paul Bocuse is named after the legendary chef and features over 50 gourmet vendors, earning its reputation as the stomach of Lyon.',
        subtext: 'Halles Paul Bocuse'),
      _property(19, 'Presqu\'île', 'orange', PropertyGroups.orange, 200, [16, 80, 220, 600, 800, 1000],
        funFact: 'The Presqu\'île is a narrow peninsula formed between the Rhône and Saône rivers, serving as Lyon\'s commercial and cultural heart since Roman times.',
        subtext: 'La Presqu\'île'),
      _corner(20, 'LUCKY SPIN', TileType.freeParking, subtext: 'ROUE CHANCE'),

      // Top row (left to right: 21-30)
      _property(21, 'Institut Lumière', 'red', PropertyGroups.red, 220, [18, 90, 250, 700, 875, 1050],
        funFact: 'The Lumière brothers filmed the world\'s first motion picture in Lyon in 1895, and the Institut Lumière museum occupies their family villa in the Monplaisir neighborhood.',
        subtext: 'Institut Lumière'),
      _card(22, 'Chance', true),
      _property(23, 'Part-Dieu', 'red', PropertyGroups.red, 220, [18, 90, 250, 700, 875, 1050],
        funFact: 'The Part-Dieu district is Lyon\'s modern business center, dominated by the 165-meter Tour Part-Dieu skyscraper, nicknamed "the pencil" by locals for its distinctive shape.',
        subtext: 'Quartier Part-Dieu'),
      _property(24, 'Bellecour', 'red', PropertyGroups.red, 240, [20, 100, 300, 750, 925, 1100],
        funFact: 'Place Bellecour is the largest open pedestrian square in Europe, spanning 62,000 square meters, with a famous equestrian statue of Louis XIV at its center.',
        subtext: 'Place Bellecour'),
      _railroad(25, 'Métro A', subtext: 'Métro Ligne A',
        funFact: 'Lyon\'s Métro Line A opened in 1978 and runs east-west through the city, connecting Perrache to Vaulx-en-Velin across 14 stations.'),
      _property(26, 'Grand Hôtel-Dieu', 'yellow', PropertyGroups.yellow, 260, [22, 110, 330, 800, 975, 1150],
        funFact: 'The Grand Hôtel-Dieu served as a hospital for over 800 years before being transformed into a luxury hotel, shopping, and cultural complex that reopened in 2018.',
        subtext: 'Grand Hôtel-Dieu'),
      _property(27, 'Confluence', 'yellow', PropertyGroups.yellow, 260, [22, 110, 330, 800, 975, 1150],
        funFact: 'Lyon Confluence is a massive urban renewal project at the meeting point of the Rhône and Saône rivers, transforming 150 hectares of former industrial land into an eco-district.',
        subtext: 'La Confluence'),
      _utility(28, 'Veolia Lyon', false,
        funFact: 'Veolia manages Lyon\'s water supply drawn from the Rhône aquifer, delivering over 200,000 cubic meters of drinking water daily to the metropolitan area.'),
      _property(29, 'Musée des Confluences', 'yellow', PropertyGroups.yellow, 280, [24, 120, 360, 850, 1025, 1200],
        funFact: 'The Musée des Confluences is housed in a futuristic deconstructivist building made of glass and steel that resembles a crystal cloud, designed by the Austrian firm Coop Himmelb(l)au.',
        subtext: 'Musée des Confluences'),
      _corner(30, 'GO TO JAIL', TileType.goToJail, subtext: 'ALLEZ EN PRISON'),

      // Right column (top to bottom: 31-39)
      _property(31, 'Fourvière', 'green', PropertyGroups.green, 300, [26, 130, 390, 900, 1100, 1275],
        funFact: 'The hill of Fourvière was the site of the original Roman settlement of Lugdunum, founded in 43 BC as the capital of the three Gauls under the Roman Empire.',
        subtext: 'Colline de Fourvière'),
      _property(32, 'Perrache', 'green', PropertyGroups.green, 300, [26, 130, 390, 900, 1100, 1275],
        funFact: 'The Perrache quarter sits on land artificially created in the 18th century by engineer Antoine-Michel Perrache, who redirected the confluence of the two rivers southward.',
        subtext: 'Quartier Perrache'),
      _card(33, 'Comm Chest', false),
      _property(34, 'Brotteaux', 'green', PropertyGroups.green, 320, [28, 150, 450, 1000, 1200, 1400],
        funFact: 'Les Brotteaux is Lyon\'s most upscale neighborhood, home to the stunning former Brotteaux railway station built in 1908, now converted into a gourmet food hall.',
        subtext: 'Les Brotteaux'),
      _railroad(35, 'Métro D', subtext: 'Métro Ligne D',
        funFact: 'Lyon\'s Métro Line D, opened in 1991, was the world\'s first fully automated driverless metro line, pioneering technology later adopted by cities worldwide.'),
      _card(36, 'Chance', true),
      _property(37, 'Tête d\'Or', 'darkBlue', PropertyGroups.darkBlue, 350, [35, 175, 500, 1100, 1300, 1500],
        funFact: 'Parc de la Tête d\'Or is one of the largest urban parks in France at 117 hectares, featuring a free zoo, botanical garden with over 16,000 plant species, and a large lake.',
        subtext: 'Parc de la Tête d\'Or'),
      _tax(38, 'Luxury Tax', 100),
      _property(39, 'Basilique de Fourvière', 'darkBlue', PropertyGroups.darkBlue, 400, [50, 200, 600, 1400, 1700, 2000],
        funFact: 'The Basilica of Notre-Dame de Fourvière was built between 1872 and 1884, and its four towers and golden Virgin Mary statue make it the most iconic landmark of the Lyon skyline.',
        subtext: 'Basilique de Fourvière'),
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

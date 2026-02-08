import 'package:flutter/material.dart';
import '../../models/tile.dart';

/// Marseille, France Monopoly board configuration with 40 tiles
class MarseilleBoard {
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

  /// Railroad positions (Marseille rail, metro, and tramway)
  static const List<int> railroadPositions = [5, 15, 25, 35];

  /// Utility positions
  static const List<int> utilityPositions = [12, 28];

  /// Chance card positions
  static const List<int> chancePositions = [7, 22, 36];

  /// Community Chest positions
  static const List<int> communityChestPositions = [2, 17, 33];

  /// Generate all 40 tiles for the Marseille board
  static List<TileData> generateTiles() {
    return [
      // Bottom row (right to left: 0-10)
      _corner(0, 'GO', TileType.start, subtext: 'DÉPART'),
      _property(1, 'Le Panier', 'brown', PropertyGroups.brown, 60, [2, 10, 30, 90, 160, 250],
        funFact: 'Le Panier is the oldest quarter in Marseille and one of the oldest in France, originally settled by the Greeks when they founded Massalia around 600 BC.',
        subtext: 'Le Panier'),
      _card(2, 'Comm Chest', false),
      _property(3, 'Noailles', 'brown', PropertyGroups.brown, 60, [4, 20, 60, 180, 320, 450],
        funFact: 'Noailles is known as the "belly of Marseille" for its vibrant open-air market on Rue du Marché des Capucins, where vendors sell spices, produce, and goods from across the Mediterranean.',
        subtext: 'Quartier Noailles'),
      _tax(4, 'Income Tax', 200),
      _railroad(5, 'Gare Saint-Charles', subtext: 'Gare St-Charles',
        funFact: 'Gare Saint-Charles is reached by a monumental staircase of 104 steps built in 1927, offering panoramic views over the city and the Mediterranean Sea.'),
      _property(6, 'Cours Julien', 'lightBlue', PropertyGroups.lightBlue, 100, [6, 30, 90, 270, 400, 550],
        funFact: 'Cours Julien is Marseille\'s bohemian quarter, famous for its street art murals, independent bookshops, and weekly organic farmers\' market held every Wednesday.',
        subtext: 'Cours Julien'),
      _card(7, 'Chance', true),
      _property(8, 'Joliette', 'lightBlue', PropertyGroups.lightBlue, 100, [6, 30, 90, 270, 400, 550],
        funFact: 'La Joliette was once Marseille\'s main commercial port district and has been transformed into the Euromed center with the striking CMA CGM Tower designed by Zaha Hadid.',
        subtext: 'La Joliette'),
      _property(9, 'La Canebière', 'lightBlue', PropertyGroups.lightBlue, 120, [8, 40, 100, 300, 450, 600],
        funFact: 'La Canebière is Marseille\'s most famous boulevard, running from the Vieux-Port inland. Its name derives from "canèbe," the Provençal word for hemp, once sold in the area.',
        subtext: 'La Canebière'),
      _corner(10, 'JAIL', TileType.jail, color: const Color(0xFFFFE0B2), subtext: 'PRISON'),

      // Left column (bottom to top: 11-20)
      _property(11, 'Vallon des Auffes', 'pink', PropertyGroups.pink, 140, [10, 50, 150, 450, 625, 750],
        funFact: 'The Vallon des Auffes is a tiny fishing port hidden beneath the Corniche road, named after the auffiers who once made rope from esparto grass in its sheltered cove.',
        subtext: 'Vallon des Auffes'),
      _utility(12, 'EDF Marseille', true,
        funFact: 'EDF Marseille powers France\'s second-largest city, whose sunny Mediterranean climate makes it a prime location for solar energy, with over 2,800 hours of sunshine per year.'),
      _property(13, 'Longchamp', 'pink', PropertyGroups.pink, 140, [10, 50, 150, 450, 625, 750],
        funFact: 'The Palais Longchamp was built in 1869 to celebrate the arrival of water from the Durance River via a 160-kilometer canal, ending centuries of chronic water shortages.',
        subtext: 'Palais Longchamp'),
      _property(14, 'Pharo', 'pink', PropertyGroups.pink, 160, [12, 60, 180, 500, 700, 900],
        funFact: 'The Palais du Pharo was built by Napoleon III as a residence for Empress Eugénie, but she never lived there. Today its gardens offer stunning views of the Vieux-Port.',
        subtext: 'Palais du Pharo'),
      _railroad(15, 'Métro 1', subtext: 'Métro Ligne 1',
        funFact: 'Marseille\'s Métro Line 1 opened in 1977 and runs from La Rose to Castellane, passing through the historic city center across 18 stations.'),
      _property(16, 'Fort Saint-Jean', 'orange', PropertyGroups.orange, 180, [14, 70, 200, 550, 750, 950],
        funFact: 'Fort Saint-Jean was built by Louis XIV in 1660 not to defend the city, but to control its rebellious citizens. It is now connected to the MuCEM by a dramatic footbridge.',
        subtext: 'Fort Saint-Jean'),
      _card(17, 'Comm Chest', false),
      _property(18, 'Castellane', 'orange', PropertyGroups.orange, 180, [14, 70, 200, 550, 750, 950],
        funFact: 'Place Castellane is a major transportation hub centered around a monumental fountain topped by a marble column, erected in 1911 to celebrate the arrival of canal water to Marseille.',
        subtext: 'Place Castellane'),
      _property(19, 'Vieux-Port', 'orange', PropertyGroups.orange, 200, [16, 80, 220, 600, 800, 1000],
        funFact: 'The Vieux-Port has been the heart of Marseille for over 2,600 years since the Greeks first anchored here. Today it shelters over 3,500 pleasure boats and hosts a daily fish market.',
        subtext: 'Le Vieux-Port'),
      _corner(20, 'LUCKY SPIN', TileType.freeParking, subtext: 'ROUE CHANCE'),

      // Top row (left to right: 21-30)
      _property(21, 'MuCEM', 'red', PropertyGroups.red, 220, [18, 90, 250, 700, 875, 1050],
        funFact: 'The Museum of European and Mediterranean Civilisations, designed by Rudy Ricciotti, is wrapped in a lattice concrete shell inspired by a mashrabiya and opened in 2013 when Marseille was European Capital of Culture.',
        subtext: 'MuCEM'),
      _card(22, 'Chance', true),
      _property(23, 'Corniche', 'red', PropertyGroups.red, 220, [18, 90, 250, 700, 875, 1050],
        funFact: 'The Corniche Kennedy stretches nearly 5 kilometers along the Mediterranean coast and features the longest bench in the world at over 3 kilometers long.',
        subtext: 'La Corniche'),
      _property(24, 'Stade Vélodrome', 'red', PropertyGroups.red, 240, [20, 100, 300, 750, 925, 1100],
        funFact: 'The Stade Vélodrome seats 67,394 spectators and is the home of Olympique de Marseille. It was renovated for Euro 2016 with a dramatic new wave-shaped roof.',
        subtext: 'Stade Vélodrome'),
      _railroad(25, 'Métro 2', subtext: 'Métro Ligne 2',
        funFact: 'Marseille\'s Métro Line 2 runs from Bougainville to Sainte-Marguerite-Dromel, passing beneath the iconic Canebière boulevard and serving the main train station.'),
      _property(26, 'La Cité Radieuse', 'yellow', PropertyGroups.yellow, 260, [22, 110, 330, 800, 975, 1150],
        funFact: 'La Cité Radieuse was designed by Le Corbusier and completed in 1952 as a "vertical village" with 337 apartments, a rooftop terrace, and an interior shopping street on the third floor.',
        subtext: 'Cité Radieuse'),
      _property(27, 'Prado', 'yellow', PropertyGroups.yellow, 260, [22, 110, 330, 800, 975, 1150],
        funFact: 'The Prado beaches were entirely man-made in the 1970s using rubble from the construction of the Marseille Metro, creating 3.5 hectares of sandy coastline.',
        subtext: 'Plages du Prado'),
      _utility(28, 'Société des Eaux de Marseille', false,
        funFact: 'The Société des Eaux de Marseille has managed the city\'s water since 1943, distributing over 80 million cubic meters annually sourced primarily from the Canal de Marseille.'),
      _property(29, 'Frioul Islands', 'yellow', PropertyGroups.yellow, 280, [24, 120, 360, 850, 1025, 1200],
        funFact: 'The Frioul archipelago lies just 2.7 kilometers offshore and includes four islands that served as a quarantine station during the great plague outbreaks of the 17th and 18th centuries.',
        subtext: 'Îles du Frioul'),
      _corner(30, 'GO TO JAIL', TileType.goToJail, subtext: 'ALLEZ EN PRISON'),

      // Right column (top to bottom: 31-39)
      _property(31, 'Château d\'If', 'green', PropertyGroups.green, 300, [26, 130, 390, 900, 1100, 1275],
        funFact: 'The Château d\'If was built by King Francis I in 1524 on a tiny limestone island and became world-famous as the prison in Alexandre Dumas\'s novel "The Count of Monte Cristo."',
        subtext: 'Château d\'If'),
      _property(32, 'Unité d\'Habitation', 'green', PropertyGroups.green, 300, [26, 130, 390, 900, 1100, 1275],
        funFact: 'Le Corbusier\'s Unité d\'Habitation is considered one of the most influential buildings of the 20th century. Its rooftop features a swimming pool, gym, and running track with panoramic sea views.',
        subtext: 'Unité d\'Habitation'),
      _card(33, 'Comm Chest', false),
      _property(34, 'Les Goudes', 'green', PropertyGroups.green, 320, [28, 150, 450, 1000, 1200, 1400],
        funFact: 'Les Goudes is a remote fishing village at the very end of the road south of Marseille, perched on dramatic white limestone cliffs and serving as the gateway to the Calanques.',
        subtext: 'Les Goudes'),
      _railroad(35, 'Tramway T2', subtext: 'Tramway Ligne T2',
        funFact: 'Marseille\'s Tramway Line T2, inaugurated in 2007, runs through the heart of the city from Arenc-Le Silo to Blancarde and helped revitalize the Joliette district.'),
      _card(36, 'Chance', true),
      _property(37, 'Calanques', 'darkBlue', PropertyGroups.darkBlue, 350, [35, 175, 500, 1100, 1300, 1500],
        funFact: 'The Calanques National Park, established in 2012, protects 20 kilometers of dramatic white limestone fjords plunging into turquoise waters, making it one of only two national parks in Europe to border a major city.',
        subtext: 'Parc des Calanques'),
      _tax(38, 'Luxury Tax', 100),
      _property(39, 'Notre-Dame de la Garde', 'darkBlue', PropertyGroups.darkBlue, 400, [50, 200, 600, 1400, 1700, 2000],
        funFact: 'Known affectionately as "La Bonne Mère," Notre-Dame de la Garde sits atop a 154-meter limestone peak and is crowned by a 9.7-meter gilded statue of the Virgin Mary visible from nearly everywhere in the city.',
        subtext: 'Notre-Dame de la Garde'),
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

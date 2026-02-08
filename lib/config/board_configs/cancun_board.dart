import 'package:flutter/material.dart';
import '../../models/tile.dart';

/// Cancún, Mexico Monopoly board configuration with 40 tiles
class CancunBoard {
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

  /// Railroad positions (Tren Maya stations in the Riviera Maya)
  static const List<int> railroadPositions = [5, 15, 25, 35];

  /// Utility positions
  static const List<int> utilityPositions = [12, 28];

  /// Chance card positions
  static const List<int> chancePositions = [7, 22, 36];

  /// Community Chest positions
  static const List<int> communityChestPositions = [2, 17, 33];

  /// Generate all 40 tiles for the Cancún board
  static List<TileData> generateTiles() {
    return [
      // Bottom row (right to left: 0-10)
      _corner(0, 'GO', TileType.start, subtext: 'SALIDA'),
      _property(1, 'Mercado 28', 'brown', PropertyGroups.brown, 60, [2, 10, 30, 90, 160, 250],
        funFact: 'Downtown Cancún\'s most famous market where locals and tourists haggle for silver jewelry, hammocks, and Mexican handicrafts since 1973.',
        subtext: 'Mercado 28'),
      _card(2, 'Comm Chest', false),
      _property(3, 'Parque de las Palapas', 'brown', PropertyGroups.brown, 60, [4, 20, 60, 180, 320, 450],
        funFact: 'The cultural heart of downtown Cancún where families gather every evening for free concerts, street food, and traditional dance performances.',
        subtext: 'Parque de las Palapas'),
      _tax(4, 'Income Tax', 200),
      _railroad(5, 'Tren Maya - Estación Cancún', subtext: 'Tren Maya Cancún',
        funFact: 'The Tren Maya\'s Cancún station connects the resort city to the entire Yucatán Peninsula across 1,554 km of track through five Mexican states.'),
      _property(6, 'Hotel Zone North', 'lightBlue', PropertyGroups.lightBlue, 100, [6, 30, 90, 270, 400, 550],
        funFact: 'The northern section of Cancún\'s famous L-shaped sandbar features calm bay-side waters perfect for families and over 20 major resort properties.',
        subtext: 'Zona Hotelera Norte'),
      _card(7, 'Chance', true),
      _property(8, 'Hotel Zone South', 'lightBlue', PropertyGroups.lightBlue, 100, [6, 30, 90, 270, 400, 550],
        funFact: 'The southern stretch faces the open Caribbean with powerful surf, and is home to Cancún\'s most exclusive all-inclusive mega-resorts.',
        subtext: 'Zona Hotelera Sur'),
      _property(9, 'Playa Delfines', 'lightBlue', PropertyGroups.lightBlue, 120, [8, 40, 100, 300, 450, 600],
        funFact: 'One of Cancún\'s only public beaches with no hotel frontage, famous for its giant colorful "CANCÚN" sign and spectacular turquoise waters.',
        subtext: 'Playa Delfines'),
      _corner(10, 'JAIL', TileType.jail, color: const Color(0xFFFFE0B2), subtext: 'CÁRCEL'),

      // Left column (bottom to top: 11-20)
      _property(11, 'Playa Forum', 'pink', PropertyGroups.pink, 140, [10, 50, 150, 450, 625, 750],
        funFact: 'Located at the bend of the Hotel Zone, this beach sits next to Cancún\'s famous party district and offers some of the calmest swimming waters.',
        subtext: 'Playa Forum'),
      _utility(12, 'CFE Cancún', true,
        funFact: 'CFE powers Cancún\'s massive tourism infrastructure, supplying electricity to over 30,000 hotel rooms and the city\'s 900,000 residents.'),
      _property(13, 'Punta Cancún', 'pink', PropertyGroups.pink, 140, [10, 50, 150, 450, 625, 750],
        funFact: 'The elbow-shaped tip of the Hotel Zone where the Caribbean Sea meets the Nichupté Lagoon, home to the densest concentration of nightclubs and restaurants.',
        subtext: 'Punta Cancún'),
      _property(14, 'Punta Nizuc', 'pink', PropertyGroups.pink, 160, [12, 60, 180, 500, 700, 900],
        funFact: 'The southern tip of the Hotel Zone is home to MUSA, an underwater museum with over 500 life-sized sculptures submerged in the crystal-clear reef.',
        subtext: 'Punta Nizuc'),
      _railroad(15, 'Tren Maya - Estación Puerto Morelos', subtext: 'Tren Maya Pto. Morelos',
        funFact: 'This station serves the quiet fishing village of Puerto Morelos, gateway to the Mesoamerican Barrier Reef, the second largest in the world.'),
      _property(16, 'El Rey Ruins', 'orange', PropertyGroups.orange, 180, [14, 70, 200, 550, 750, 950],
        funFact: 'Ancient Maya ruins right in the Hotel Zone dating to 300 BC, where hundreds of wild iguanas freely roam among 47 archaeological structures.',
        subtext: 'Ruinas El Rey'),
      _card(17, 'Comm Chest', false),
      _property(18, 'Isla Mujeres', 'orange', PropertyGroups.orange, 180, [14, 70, 200, 550, 750, 950],
        funFact: 'The "Island of Women" was sacred to the Maya goddess Ixchel. Just 13 km offshore, it features Punta Sur, the easternmost point of Mexico.',
        subtext: 'Isla Mujeres'),
      _property(19, 'Puerto Morelos', 'orange', PropertyGroups.orange, 200, [16, 80, 220, 600, 800, 1000],
        funFact: 'A charming fishing village with a famously leaning lighthouse damaged by Hurricane Beulah in 1967, now a national marine park protecting pristine reefs.',
        subtext: 'Puerto Morelos'),
      _corner(20, 'LUCKY SPIN', TileType.freeParking, subtext: 'GIRA Y GANA'),

      // Top row (left to right: 21-30)
      _property(21, 'Playa del Carmen', 'red', PropertyGroups.red, 220, [18, 90, 250, 700, 875, 1050],
        funFact: 'Once a tiny ferry port to Cozumel, it became one of the fastest-growing cities in the world. Its Quinta Avenida stretches 20 blocks of shops and restaurants.',
        subtext: 'Playa del Carmen'),
      _card(22, 'Chance', true),
      _property(23, 'Cozumel', 'red', PropertyGroups.red, 220, [18, 90, 250, 700, 875, 1050],
        funFact: 'Jacques Cousteau made this island world-famous in 1961 for its crystal-clear reefs. It is now the busiest cruise port in Mexico with over 1,200 ships annually.',
        subtext: 'Cozumel'),
      _property(24, 'Xcaret', 'red', PropertyGroups.red, 240, [20, 100, 300, 750, 925, 1100],
        funFact: 'A massive eco-archaeological park built around ancient Maya ruins and underground rivers, hosting a nightly spectacular with 300 performers celebrating Mexican culture.',
        subtext: 'Xcaret'),
      _railroad(25, 'Tren Maya - Estación Playa del Carmen', subtext: 'Tren Maya Playa',
        funFact: 'This station links Playa del Carmen to the Tren Maya network, allowing visitors to reach Chichén Itzá and Mérida without driving.'),
      _property(26, 'Xel-Há', 'yellow', PropertyGroups.yellow, 260, [22, 110, 330, 800, 975, 1150],
        funFact: 'The world\'s largest natural aquarium where freshwater cenotes meet the Caribbean Sea, creating a snorkeling paradise with over 90 marine species.',
        subtext: 'Xel-Há'),
      _property(27, 'Tulum Ruins', 'yellow', PropertyGroups.yellow, 260, [22, 110, 330, 800, 975, 1150],
        funFact: 'The only major Maya city built on a Caribbean cliff, Tulum was a thriving trading port from 1200 to 1521 AD and is Mexico\'s third most visited archaeological site.',
        subtext: 'Ruinas de Tulum'),
      _utility(28, 'CAPA', false,
        funFact: 'CAPA manages Cancún\'s water supply sourced from underground cenotes and aquifers in the porous limestone of the Yucatán Peninsula.'),
      _property(29, 'Cenote Ik Kil', 'yellow', PropertyGroups.yellow, 280, [24, 120, 360, 850, 1025, 1200],
        funFact: 'A breathtaking 60-meter-deep sinkhole near Chichén Itzá with vines cascading from the rim. The Maya considered cenotes sacred portals to the underworld.',
        subtext: 'Cenote Ik Kil'),
      _corner(30, 'GO TO JAIL', TileType.goToJail, subtext: 'VE A LA CÁRCEL'),

      // Right column (top to bottom: 31-39)
      _property(31, 'Zona Hotelera', 'green', PropertyGroups.green, 300, [26, 130, 390, 900, 1100, 1275],
        funFact: 'Cancún\'s iconic 23 km L-shaped barrier island was planned from scratch in 1970 by a government computer program that selected it as the ideal resort location.',
        subtext: 'Zona Hotelera'),
      _property(32, 'La Isla Shopping', 'green', PropertyGroups.green, 300, [26, 130, 390, 900, 1100, 1275],
        funFact: 'An open-air shopping village built over the Nichupté Lagoon with canals running through it, featuring an interactive aquarium and sunset waterfront dining.',
        subtext: 'La Isla Shopping'),
      _card(33, 'Comm Chest', false),
      _property(34, 'Kukulcán Boulevard', 'green', PropertyGroups.green, 320, [28, 150, 450, 1000, 1200, 1400],
        funFact: 'Named after the feathered serpent god, this 26 km road is the main artery of the Hotel Zone, connecting all major resorts, malls, and nightlife venues.',
        subtext: 'Blvd. Kukulcán'),
      _railroad(35, 'Tren Maya - Estación Tulum', subtext: 'Tren Maya Tulum',
        funFact: 'The Tulum station serves as a gateway to the Riviera Maya\'s southern coast and provides direct rail access to the ancient ruins of the Yucatán interior.'),
      _card(36, 'Chance', true),
      _property(37, 'Nichupté Lagoon', 'darkBlue', PropertyGroups.darkBlue, 350, [35, 175, 500, 1100, 1300, 1500],
        funFact: 'This 3,000-hectare lagoon system separates the Hotel Zone from the mainland, home to crocodiles, manatees, and mangrove forests vital to Cancún\'s ecosystem.',
        subtext: 'Laguna Nichupté'),
      _tax(38, 'Luxury Tax', 100),
      _property(39, 'Chichén Itzá', 'darkBlue', PropertyGroups.darkBlue, 400, [50, 200, 600, 1400, 1700, 2000],
        funFact: 'One of the New Seven Wonders of the World, the Kukulcán pyramid creates a shadow serpent effect during equinoxes that draws over 2.6 million visitors annually.',
        subtext: 'Chichén Itzá'),
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

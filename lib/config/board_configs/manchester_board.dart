import 'package:flutter/material.dart';
import '../../models/tile.dart';

/// Manchester, England Monopoly board configuration with 40 tiles
class ManchesterBoard {
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

  /// Railroad positions (Train Stations in Manchester)
  static const List<int> railroadPositions = [5, 15, 25, 35];

  /// Utility positions
  static const List<int> utilityPositions = [12, 28];

  /// Chance card positions
  static const List<int> chancePositions = [7, 22, 36];

  /// Community Chest positions
  static const List<int> communityChestPositions = [2, 17, 33];

  /// Generate all 40 tiles for the Manchester board
  static List<TileData> generateTiles() {
    return [
      // Bottom row (right to left: 0-10)
      _corner(0, 'GO', TileType.start, subtext: 'COLLECT £200'),
      _property(1, 'Northern Quarter', 'brown', PropertyGroups.brown, 60, [2, 10, 30, 90, 160, 250],
        funFact: 'Manchester\'s creative hub was once the city\'s garment district. Its red-brick warehouses now house independent shops, street art, and over 30 record stores.'),
      _card(2, 'Comm Chest', false),
      _property(3, 'Ancoats', 'brown', PropertyGroups.brown, 60, [4, 20, 60, 180, 320, 450],
        funFact: 'Known as "Little Italy" in the early 1900s due to its Italian immigrant community, Ancoats is considered the world\'s first industrial suburb, built in the 1790s.'),
      _tax(4, 'Income Tax', 200),
      _railroad(5, 'Piccadilly Station',
        funFact: 'Manchester Piccadilly is the busiest railway station in the UK outside London, handling over 32 million passengers per year across its 14 platforms.'),
      _property(6, 'Castlefield', 'lightBlue', PropertyGroups.lightBlue, 100, [6, 30, 90, 270, 400, 550],
        funFact: 'Site of the Roman fort Mamucium founded in 79 AD, from which Manchester gets its name. It also contains the terminus of the world\'s first industrial canal.'),
      _card(7, 'Chance', true),
      _property(8, 'Salford Quays', 'lightBlue', PropertyGroups.lightBlue, 100, [6, 30, 90, 270, 400, 550],
        funFact: 'Once the busiest inland port in Britain, Salford Quays was transformed from derelict docklands into a cultural waterfront home to The Lowry theatre and Imperial War Museum North.'),
      _property(9, 'MediaCityUK', 'lightBlue', PropertyGroups.lightBlue, 120, [8, 40, 100, 300, 450, 600],
        funFact: 'This 200-acre development at Salford Quays became the new northern home for the BBC in 2011 and also houses ITV Studios, making it the UK\'s largest media hub outside London.'),
      _corner(10, 'JAIL', TileType.jail, color: const Color(0xFFFFE0B2), subtext: 'JUST VISITING'),

      // Left column (bottom to top: 11-20)
      _property(11, 'Deansgate', 'pink', PropertyGroups.pink, 140, [10, 50, 150, 450, 625, 750],
        funFact: 'One of Manchester\'s longest and oldest streets, Deansgate follows the line of a Roman road and stretches over a mile from the cathedral to Knott Mill.'),
      _utility(12, 'Electricity North West', true,
        funFact: 'Electricity North West operates 13,000 kilometres of overhead lines and underground cables, delivering power to 2.4 million homes and businesses across the North West.'),
      _property(13, 'Didsbury', 'pink', PropertyGroups.pink, 140, [10, 50, 150, 450, 625, 750],
        funFact: 'This leafy South Manchester suburb was home to the Bee Gees in their childhood. Its village-like atmosphere features Victorian parks and one of Manchester\'s oldest pubs.'),
      _property(14, 'Chorlton', 'pink', PropertyGroups.pink, 160, [12, 60, 180, 500, 700, 900],
        funFact: 'Chorlton-cum-Hardy is famous for its bohemian culture and independent food scene. The nearby Chorlton Water Park was created from flooded gravel pits in the 1970s.'),
      _railroad(15, 'Victoria Station',
        funFact: 'Manchester Victoria opened in 1844 and features the longest station platform in the UK at 693 metres. It was badly damaged by the 1996 IRA bombing and fully restored in 2015.'),
      _property(16, 'Old Trafford', 'orange', PropertyGroups.orange, 180, [14, 70, 200, 550, 750, 950],
        funFact: 'Home to Manchester United\'s "Theatre of Dreams" since 1910, Old Trafford stadium holds 74,310 spectators and is the largest club football ground in the United Kingdom.'),
      _card(17, 'Comm Chest', false),
      _property(18, 'Etihad Campus', 'orange', PropertyGroups.orange, 180, [14, 70, 200, 550, 750, 950],
        funFact: 'The Etihad Campus spans 80 acres in East Manchester, centred on the stadium built for the 2002 Commonwealth Games and now home to Manchester City Football Club.'),
      _property(19, 'Piccadilly Gardens', 'orange', PropertyGroups.orange, 200, [16, 80, 220, 600, 800, 1000],
        funFact: 'Once the site of Manchester Royal Infirmary, Piccadilly Gardens has been the city\'s main public square since 1853 and is the busiest Metrolink tram stop in the network.'),
      _corner(20, 'LUCKY SPIN', TileType.freeParking),

      // Top row (left to right: 21-30)
      _property(21, 'Spinningfields', 'red', PropertyGroups.red, 220, [18, 90, 250, 700, 875, 1050],
        funFact: 'Manchester\'s premier business district was named after a medieval spinning and weaving community. It now houses the Civil Justice Centre, one of Europe\'s most striking court buildings.'),
      _card(22, 'Chance', true),
      _property(23, 'King Street', 'red', PropertyGroups.red, 220, [18, 90, 250, 700, 875, 1050],
        funFact: 'Manchester\'s most elegant commercial street features stunning architecture from every era, including the former Reform Club where the suffragette movement held early meetings.'),
      _property(24, 'Exchange Square', 'red', PropertyGroups.red, 240, [20, 100, 300, 750, 925, 1100],
        funFact: 'Completely rebuilt after the devastating 1996 IRA bombing, Exchange Square became the centrepiece of Manchester\'s urban renewal and hosts the city\'s annual Christmas markets.'),
      _railroad(25, 'Oxford Road Station',
        funFact: 'Manchester Oxford Road is one of the busiest stations in the UK with a train every 20 seconds at peak times, serving the city\'s university corridor of 100,000 students.'),
      _property(26, 'Albert Square', 'yellow', PropertyGroups.yellow, 260, [22, 110, 330, 800, 975, 1150],
        funFact: 'Dominated by the magnificent neo-Gothic Town Hall designed by Alfred Waterhouse in 1877, Albert Square contains the Albert Memorial, predating London\'s more famous version.'),
      _property(27, 'St Ann\'s Square', 'yellow', PropertyGroups.yellow, 260, [22, 110, 330, 800, 975, 1150],
        funFact: 'Named after the 18th-century St Ann\'s Church, this elegant square became a powerful memorial site after the 2017 Manchester Arena attack, with flowers covering the entire space.'),
      _utility(28, 'United Utilities', false,
        funFact: 'United Utilities manages the water supply for seven million people across the North West, operating Thirlmere Aqueduct which carries Lake District water 96 miles to Manchester.'),
      _property(29, 'Museum of Science', 'yellow', PropertyGroups.yellow, 280, [24, 120, 360, 850, 1025, 1200],
        funFact: 'Housed in the world\'s oldest surviving passenger railway station, the Science and Industry Museum celebrates Manchester\'s role as the birthplace of the Industrial Revolution.'),
      _corner(30, 'GO TO JAIL', TileType.goToJail),

      // Right column (top to bottom: 31-39)
      _property(31, 'Whitworth', 'green', PropertyGroups.green, 300, [26, 130, 390, 900, 1100, 1275],
        funFact: 'The Whitworth gallery houses over 60,000 works of art including pieces by Turner and Hockney. Its award-winning 2015 extension features walls made of reclaimed bricks.'),
      _property(32, 'John Rylands', 'green', PropertyGroups.green, 300, [26, 130, 390, 900, 1100, 1275],
        funFact: 'The John Rylands Library on Deansgate is a stunning neo-Gothic masterpiece opened in 1900. It holds the oldest known piece of the New Testament, a papyrus fragment from 125 AD.'),
      _card(33, 'Comm Chest', false),
      _property(34, 'Victoria Baths', 'green', PropertyGroups.green, 320, [28, 150, 450, 1000, 1200, 1400],
        funFact: 'Opened in 1906 and dubbed "a water palace of which Manchester may well be proud," Victoria Baths won the first series of BBC\'s Restoration programme in 2003.'),
      _railroad(35, 'Deansgate Station',
        funFact: 'Deansgate station sits beneath the Great Northern Warehouse, a former railway goods depot built in 1899 that is now a leisure and entertainment complex.'),
      _card(36, 'Chance', true),
      _property(37, 'Beetham Tower', 'darkBlue', PropertyGroups.darkBlue, 350, [35, 175, 500, 1100, 1300, 1500],
        funFact: 'At 168 metres tall, Beetham Tower was the tallest building in the UK outside London when completed in 2006. Its distinctive glass blade at the top famously hums in strong winds.'),
      _tax(38, 'Luxury Tax', 100),
      _property(39, 'Midland Hotel', 'darkBlue', PropertyGroups.darkBlue, 400, [50, 200, 600, 1400, 1700, 2000],
        funFact: 'This grand Edwardian Baroque hotel opened in 1903 and is where Charles Rolls met Henry Royce in 1904, leading to the founding of Rolls-Royce, one of the world\'s most iconic brands.'),
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

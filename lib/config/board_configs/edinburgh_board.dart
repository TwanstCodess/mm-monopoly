import 'package:flutter/material.dart';
import '../../models/tile.dart';

/// Edinburgh, Scotland Monopoly board configuration with 40 tiles
class EdinburghBoard {
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

  /// Railroad positions (Train Stations in Edinburgh)
  static const List<int> railroadPositions = [5, 15, 25, 35];

  /// Utility positions
  static const List<int> utilityPositions = [12, 28];

  /// Chance card positions
  static const List<int> chancePositions = [7, 22, 36];

  /// Community Chest positions
  static const List<int> communityChestPositions = [2, 17, 33];

  /// Generate all 40 tiles for the Edinburgh board
  static List<TileData> generateTiles() {
    return [
      // Bottom row (right to left: 0-10)
      _corner(0, 'GO', TileType.start, subtext: 'COLLECT £200'),
      _property(1, 'Grassmarket', 'brown', PropertyGroups.brown, 60, [2, 10, 30, 90, 160, 250],
        funFact: 'Once Edinburgh\'s main marketplace and site of public executions, the Grassmarket has been a bustling trading hub since the 15th century.'),
      _card(2, 'Comm Chest', false),
      _property(3, 'Portobello', 'brown', PropertyGroups.brown, 60, [4, 20, 60, 180, 320, 450],
        funFact: 'Edinburgh\'s seaside suburb was named after a sailor\'s cottage called Porto Bello, inspired by the 1739 British capture of Portobelo in Panama.'),
      _tax(4, 'Income Tax', 200),
      _railroad(5, 'Edinburgh Waverley',
        funFact: 'Edinburgh Waverley is the second largest railway station in the UK by number of platforms and the only major station named after a novel, Sir Walter Scott\'s "Waverley".'),
      _property(6, 'Leith', 'lightBlue', PropertyGroups.lightBlue, 100, [6, 30, 90, 270, 400, 550],
        funFact: 'Edinburgh\'s historic port district was an independent burgh until 1920 and is now home to the Royal Yacht Britannia, the Queen\'s former floating palace.'),
      _card(7, 'Chance', true),
      _property(8, 'Stockbridge', 'lightBlue', PropertyGroups.lightBlue, 100, [6, 30, 90, 270, 400, 550],
        funFact: 'This charming village within Edinburgh takes its name from a wooden stock bridge that once crossed the Water of Leith, and hosts a popular Sunday farmers\' market.'),
      _property(9, 'Bruntsfield', 'lightBlue', PropertyGroups.lightBlue, 120, [8, 40, 100, 300, 450, 600],
        funFact: 'Bruntsfield Links is one of the oldest golf courses in the world, with records of golf being played there as early as 1456.'),
      _corner(10, 'JAIL', TileType.jail, color: const Color(0xFFFFE0B2), subtext: 'JUST VISITING'),

      // Left column (bottom to top: 11-20)
      _property(11, 'New Town', 'pink', PropertyGroups.pink, 140, [10, 50, 150, 450, 625, 750],
        funFact: 'Edinburgh\'s New Town is a masterpiece of Georgian urban planning, designed by James Craig in 1767 and now a UNESCO World Heritage Site.'),
      _utility(12, 'Scottish Power', true,
        funFact: 'Scotland generates enough wind energy to power the equivalent of every Scottish household twice over, making it a European leader in renewable energy.'),
      _property(13, 'Marchmont', 'pink', PropertyGroups.pink, 140, [10, 50, 150, 450, 625, 750],
        funFact: 'Built in the 1870s as tenement housing for Edinburgh\'s growing middle class, Marchmont is famous for its red sandstone Victorian flats and student population.'),
      _property(14, 'Morningside', 'pink', PropertyGroups.pink, 160, [12, 60, 180, 500, 700, 900],
        funFact: 'Known for its refined accent and genteel character, Morningside was once a separate village and is said to have inspired the fictional suburb of Springfield in "The Simpsons".'),
      _railroad(15, 'Haymarket Station',
        funFact: 'Haymarket Station opened in 1842 and stands near the site where Edinburgh\'s last public execution took place, as well as the famous Haymarket clock.'),
      _property(16, 'Dean Village', 'orange', PropertyGroups.orange, 180, [14, 70, 200, 550, 750, 950],
        funFact: 'This picturesque medieval village along the Water of Leith was once home to over 70 grain mills and is now one of Edinburgh\'s most photographed locations.'),
      _card(17, 'Comm Chest', false),
      _property(18, 'Haymarket', 'orange', PropertyGroups.orange, 180, [14, 70, 200, 550, 750, 950],
        funFact: 'The Haymarket area features the famous Heart of Midlothian mosaic in the pavement and has been a major transport hub since the Victorian railway era.'),
      _property(19, 'Murrayfield', 'orange', PropertyGroups.orange, 200, [16, 80, 220, 600, 800, 1000],
        funFact: 'Home to Scotland\'s national rugby stadium since 1925, Murrayfield holds 67,144 spectators and was the first stadium in the UK to install undersoil heating.'),
      _corner(20, 'LUCKY SPIN', TileType.freeParking),

      // Top row (left to right: 21-30)
      _property(21, 'Calton Hill', 'red', PropertyGroups.red, 220, [18, 90, 250, 700, 875, 1050],
        funFact: 'Calton Hill\'s unfinished National Monument, begun in 1826 to honor those who died in the Napoleonic Wars, earned Edinburgh the nickname "Athens of the North".'),
      _card(22, 'Chance', true),
      _property(23, 'Holyrood', 'red', PropertyGroups.red, 220, [18, 90, 250, 700, 875, 1050],
        funFact: 'The Palace of Holyroodhouse has been the official Scottish residence of the monarchy since the 16th century and was home to Mary, Queen of Scots.'),
      _property(24, 'Arthur\'s Seat', 'red', PropertyGroups.red, 240, [20, 100, 300, 750, 925, 1100],
        funFact: 'This ancient volcano rising 251 metres above Edinburgh is roughly 340 million years old and is believed to be one of the possible inspirations for Camelot.'),
      _railroad(25, 'South Gyle',
        funFact: 'South Gyle station serves Edinburgh\'s western business district and the Gyle Shopping Centre, connecting the city to Fife and the Forth Bridge.'),
      _property(26, 'Princes Street', 'yellow', PropertyGroups.yellow, 260, [22, 110, 330, 800, 975, 1150],
        funFact: 'Edinburgh\'s main shopping thoroughfare has buildings on only one side, giving uninterrupted views of the Old Town, Edinburgh Castle, and the Scott Monument.'),
      _property(27, 'George Street', 'yellow', PropertyGroups.yellow, 260, [22, 110, 330, 800, 975, 1150],
        funFact: 'Named after King George III, this elegant New Town street was originally designed as the principal residential street and now hosts upscale bars and restaurants.'),
      _utility(28, 'Scottish Water', false,
        funFact: 'Scottish Water supplies 1.46 billion litres of drinking water daily to 5.4 million customers, sourced from some of the purest reservoirs in Europe.'),
      _property(29, 'Heriot Row', 'yellow', PropertyGroups.yellow, 280, [24, 120, 360, 850, 1025, 1200],
        funFact: 'This prestigious New Town address was once home to Robert Louis Stevenson, who wrote "Treasure Island" while living at number 17 Heriot Row.'),
      _corner(30, 'GO TO JAIL', TileType.goToJail),

      // Right column (top to bottom: 31-39)
      _property(31, 'Scott Monument', 'green', PropertyGroups.green, 300, [26, 130, 390, 900, 1100, 1275],
        funFact: 'At 61 metres tall, the Scott Monument is the largest monument to a writer anywhere in the world, with 287 steps leading to panoramic views of Edinburgh.'),
      _property(32, 'St Giles Cathedral', 'green', PropertyGroups.green, 300, [26, 130, 390, 900, 1100, 1275],
        funFact: 'The High Kirk of Edinburgh dates back to the 12th century and its distinctive crown steeple, added in 1495, has become an iconic symbol of the city.'),
      _card(33, 'Comm Chest', false),
      _property(34, 'Cramond', 'green', PropertyGroups.green, 320, [28, 150, 450, 1000, 1200, 1400],
        funFact: 'Cramond was a Roman fort settlement dating to 142 AD, and in 1997 a priceless Roman sculpture of a lioness devouring a prisoner was found in the River Almond.'),
      _railroad(35, 'Edinburgh Park',
        funFact: 'Edinburgh Park station serves Scotland\'s largest business park and was designed as a key stop on the Edinburgh Gateway interchange with tram services.'),
      _card(36, 'Chance', true),
      _property(37, 'Royal Mile', 'darkBlue', PropertyGroups.darkBlue, 350, [35, 175, 500, 1100, 1300, 1500],
        funFact: 'The Royal Mile stretches exactly one Scots mile from Edinburgh Castle to the Palace of Holyroodhouse and contains more than 80 narrow closes and wynds.'),
      _tax(38, 'Luxury Tax', 100),
      _property(39, 'Edinburgh Castle', 'darkBlue', PropertyGroups.darkBlue, 400, [50, 200, 600, 1400, 1700, 2000],
        funFact: 'Perched atop an extinct volcanic rock, Edinburgh Castle has been a royal residence since the 12th century and houses the Scottish Crown Jewels, the oldest regalia in Britain.'),
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

import 'package:flutter/material.dart';
import '../../models/tile.dart';

/// UK/London Monopoly board configuration with 40 tiles
class UKBoard {
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

  /// Railroad positions (Train Stations in UK)
  static const List<int> railroadPositions = [5, 15, 25, 35];

  /// Utility positions
  static const List<int> utilityPositions = [12, 28];

  /// Chance card positions
  static const List<int> chancePositions = [7, 22, 36];

  /// Community Chest positions
  static const List<int> communityChestPositions = [2, 17, 33];

  /// Generate all 40 tiles for the UK board
  static List<TileData> generateTiles() {
    return [
      // Bottom row (right to left: 0-10)
      _corner(0, 'GO', TileType.start, subtext: 'COLLECT £200'),
      _property(1, 'Old Kent Road', 'brown', PropertyGroups.brown, 60, [2, 10, 30, 90, 160, 250],
        funFact: 'Dating back to the 1st century AD, Old Kent Road was part of the Roman road Watling Street and remains one of London\'s longest roads at 2.5 miles, connecting the city to Dover and Canterbury.'),
      _card(2, 'Comm Chest', false),
      _property(3, 'Whitechapel Road', 'brown', PropertyGroups.brown, 60, [4, 20, 60, 180, 320, 450],
        funFact: 'The Whitechapel Bell Foundry, located on this street from 1570 to 2017, cast both the Liberty Bell in 1752 and Big Ben in 1858, making it Britain\'s oldest manufacturing company.'),
      _tax(4, 'Income Tax', 200),
      _railroad(5, 'King\'s Cross Station',
        funFact: 'Opened in 1852, King\'s Cross handles over 34 million passengers yearly. Its massive restoration completed in 2012 added a stunning 1,700-tonne steel roof, and a real Platform 9 3/4 trolley attracts Harry Potter fans from around the world.'),
      _property(6, 'The Angel Islington', 'lightBlue', PropertyGroups.lightBlue, 100, [6, 30, 90, 270, 400, 550],
        funFact: 'Named after a coaching inn established around 1614, The Angel was a key stop on the Great North Road. The area\'s famous corner building, rebuilt in 1903, now houses a Co-op Bank and remains one of London\'s most recognised landmarks.'),
      _card(7, 'Chance', true),
      _property(8, 'Euston Road', 'lightBlue', PropertyGroups.lightBlue, 100, [6, 30, 90, 270, 400, 550],
        funFact: 'Euston Road is home to the British Library, which moved here in 1997 and holds over 170 million items including a 1215 Magna Carta, a Gutenberg Bible from the 1450s, and original Beatles lyrics scribbled on napkins.'),
      _property(9, 'Pentonville Road', 'lightBlue', PropertyGroups.lightBlue, 120, [8, 40, 100, 300, 450, 600],
        funFact: 'Named after Henry Penton who developed the area in 1773, Pentonville Road leads to the infamous HMP Pentonville, opened in 1842, which became the model for 54 other prisons across the British Empire.'),
      _corner(10, 'JAIL', TileType.jail, color: const Color(0xFFFFE0B2), subtext: 'JUST VISITING'),

      // Left column (bottom to top: 11-20)
      _property(11, 'Pall Mall', 'pink', PropertyGroups.pink, 140, [10, 50, 150, 450, 625, 750],
        funFact: 'Pall Mall gets its name from paille-maille, a croquet-like game played here in the 1660s by Charles II. Today it houses over a dozen exclusive gentlemen\'s clubs, including the Athenaeum (founded 1824) and the Reform Club (1836).'),
      _utility(12, 'Electric Company', true,
        funFact: 'The Edison Electric Light Station at 57 Holborn Viaduct opened on 12 January 1882, making London one of the first cities in the world to have electric street lighting, initially powering just 968 lamps.'),
      _property(13, 'Whitehall', 'pink', PropertyGroups.pink, 140, [10, 50, 150, 450, 625, 750],
        funFact: 'Whitehall has been the centre of British government since 1530 when Henry VIII seized York Place from Cardinal Wolsey. The street\'s name comes from the vast Palace of Whitehall, which was the largest palace in Europe before it burned down in 1698.'),
      _property(14, 'Northumberland Ave', 'pink', PropertyGroups.pink, 160, [12, 60, 180, 500, 700, 900],
        funFact: 'Built in 1876 on the site of the demolished Northumberland House, this avenue was one of London\'s first streets to have electric lighting installed in 1878, four years before the rest of the city.'),
      _railroad(15, 'Marylebone Station',
        funFact: 'London\'s last and smallest main-line terminus, Marylebone opened on 15 March 1899. It was so quiet in the 1960s that British Rail nearly closed it, and its booking hall was famously used to film scenes for the 1964 Beatles movie A Hard Day\'s Night.'),
      _property(16, 'Bow Street', 'orange', PropertyGroups.orange, 180, [14, 70, 200, 550, 750, 950],
        funFact: 'In 1749, magistrate Henry Fielding (author of Tom Jones) founded the Bow Street Runners here, London\'s first professional police force. The Royal Opera House, rebuilt in 1858 and seating 2,256, has stood on this street since 1732.'),
      _card(17, 'Comm Chest', false),
      _property(18, 'Marlborough Street', 'orange', PropertyGroups.orange, 180, [14, 70, 200, 550, 750, 950],
        funFact: 'Great Marlborough Street\'s magistrates\' court, built in 1792, saw famous defendants including the Marquess of Queensberry in 1895 and Christine Keeler during the 1963 Profumo affair. Oscar Wilde also gave evidence there.'),
      _property(19, 'Vine Street', 'orange', PropertyGroups.orange, 200, [16, 80, 220, 600, 800, 1000],
        funFact: 'Vine Street was home to the Vine Street Police Station from 1830 to 1997, one of the busiest in London\'s West End. The street itself is only about 100 metres long but sits at the heart of Mayfair\'s most exclusive quarter.'),
      _corner(20, 'LUCKY SPIN', TileType.freeParking),

      // Top row (left to right: 21-30)
      _property(21, 'Strand', 'red', PropertyGroups.red, 220, [18, 90, 250, 700, 875, 1050],
        funFact: 'The Strand\'s name comes from the Old English for "shore," as it once ran along the Thames before the 1865 Victoria Embankment pushed the river back. The Savoy Theatre, built here in 1881, was the world\'s first public building lit entirely by electricity.'),
      _card(22, 'Chance', true),
      _property(23, 'Fleet Street', 'red', PropertyGroups.red, 220, [18, 90, 250, 700, 875, 1050],
        funFact: 'Fleet Street was the centre of British press from 1702 (when the Daily Courant launched) until 2005, when Reuters became the last major agency to leave. The subterranean River Fleet below still flows into the Thames at Blackfriars Bridge.'),
      _property(24, 'Trafalgar Square', 'red', PropertyGroups.red, 240, [20, 100, 300, 750, 925, 1100],
        funFact: 'Opened in 1844 to commemorate Nelson\'s 1805 victory at Trafalgar, the square\'s column stands 51.6 metres tall with a 5.5-metre statue of Nelson on top. The four bronze lions, sculpted by Sir Edwin Landseer, were not added until 1867.'),
      _railroad(25, 'Fenchurch St Station',
        funFact: 'Opened on 2 August 1841, Fenchurch Street was the first railway terminus built in the City of London. It is the only London terminus with no Underground connection, and its compact size means it has just 4 platforms serving Essex commuters.'),
      _property(26, 'Leicester Square', 'yellow', PropertyGroups.yellow, 260, [22, 110, 330, 800, 975, 1150],
        funFact: 'Leicester Square was laid out in 1670 on land owned by the 2nd Earl of Leicester. Its garden features a statue of Shakespeare erected in 1874, and since the 1930s the Odeon and Empire cinemas have hosted virtually every major London film premiere.'),
      _property(27, 'Coventry Street', 'yellow', PropertyGroups.yellow, 260, [22, 110, 330, 800, 975, 1150],
        funFact: 'This short street linking Piccadilly Circus to Leicester Square was named after Henry Coventry, Charles II\'s Secretary of State in the 1670s. The Trocadero entertainment complex dominated the street from 1896 until its 2014 conversion to a hotel.'),
      _utility(28, 'Water Works', false,
        funFact: 'The New River, a 62-kilometre aqueduct completed in 1613, was London\'s first major clean water supply. Today Thames Water serves 9 million customers and treats over 2.6 billion litres of water daily across 234 water treatment works.'),
      _property(29, 'Piccadilly', 'yellow', PropertyGroups.yellow, 280, [24, 120, 360, 850, 1025, 1200],
        funFact: 'Piccadilly takes its name from Robert Baker, a 1600s tailor who made his fortune selling "piccadills" (stiff lace collars). The famous Eros statue in Piccadilly Circus, unveiled in 1893, actually depicts Anteros, the Angel of Christian Charity.'),
      _corner(30, 'GO TO JAIL', TileType.goToJail),

      // Right column (top to bottom: 31-39)
      _property(31, 'Regent Street', 'green', PropertyGroups.green, 300, [26, 130, 390, 900, 1100, 1275],
        funFact: 'Designed by architect John Nash in 1811 for the Prince Regent (later George IV), Regent Street was completely rebuilt between 1895 and 1927 in the grander Beaux-Arts style. Its famous Christmas lights tradition began in 1954.'),
      _property(32, 'Oxford Street', 'green', PropertyGroups.green, 300, [26, 130, 390, 900, 1100, 1275],
        funFact: 'Europe\'s busiest shopping street stretches 1.9 kilometres with over 300 shops and 200 million annual visitors. Selfridges, opened here in 1909 by American Harry Gordon Selfridge, revolutionised retail by letting customers browse freely.'),
      _card(33, 'Comm Chest', false),
      _property(34, 'Bond Street', 'green', PropertyGroups.green, 320, [28, 150, 450, 1000, 1200, 1400],
        funFact: 'Bond Street has been London\'s premier luxury destination since the 1720s. Sotheby\'s, the world\'s oldest auction house, has operated at number 34-35 since 1744, and Admiral Nelson once lived at number 147 New Bond Street.'),
      _railroad(35, 'Liverpool St Station',
        funFact: 'Originally opened in 1874, Liverpool Street Station is the third-busiest in the UK with over 67 million passengers annually. A memorial to the Kindertransport, which rescued nearly 10,000 Jewish children through this station in 1938-1939, stands in its concourse.'),
      _card(36, 'Chance', true),
      _property(37, 'Park Lane', 'darkBlue', PropertyGroups.darkBlue, 350, [35, 175, 500, 1100, 1300, 1500],
        funFact: 'Running alongside Hyde Park\'s eastern boundary, Park Lane was transformed from a quiet country lane in the 1820s into London\'s most prestigious address. The Dorchester (1931) and Grosvenor House (1929) hotels still anchor the street\'s luxury reputation.'),
      _tax(38, 'Luxury Tax', 100),
      _property(39, 'Mayfair', 'darkBlue', PropertyGroups.darkBlue, 400, [50, 200, 600, 1400, 1700, 2000],
        funFact: 'Mayfair takes its name from the 15-day May Fair held annually from 1686 until it was suppressed in 1764 for rowdiness. Today it boasts the most expensive property in Britain, with average house prices over 20 times the national average.'),
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

  static PropertyTileData _property(int index, String name, String groupId, Color groupColor, int price, List<int> rentLevels, {String? funFact}) {
    return PropertyTileData(
      index: index,
      name: name,
      groupId: groupId,
      groupColor: groupColor,
      price: price,
      rentLevels: rentLevels,
      funFact: funFact,
    );
  }

  static RailroadTileData _railroad(int index, String name, {String? funFact}) {
    return RailroadTileData(
      index: index,
      name: name,
      funFact: funFact,
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

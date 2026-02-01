import 'package:flutter/material.dart';
import '../../models/tile.dart';
import '../../config/theme.dart';
import 'animated_dialog.dart';

/// Fun facts and educational content about Monopoly tiles
class TileFacts {
  /// Get fun facts for a specific tile
  static TileInfo getInfo(TileData tile) {
    // Property tiles - based on real Atlantic City locations
    final propertyFacts = <int, TileInfo>{
      // Brown properties
      1: TileInfo(
        location: 'Atlantic City, New Jersey, USA',
        facts: [
          'Mediterranean Avenue was one of the poorest streets in Atlantic City',
          'It was named after the Mediterranean Sea!',
          'In the 1930s, this area had small boarding houses',
        ],
        funFact: '🏖️ Atlantic City is famous for its beaches and boardwalk!',
        emoji: '🏠',
      ),
      3: TileInfo(
        location: 'Atlantic City, New Jersey, USA',
        facts: [
          'Baltic Avenue was near the railroad tracks',
          'The Baltic Sea is in Northern Europe',
          'This is one of the cheapest properties in Monopoly!',
        ],
        funFact: '🚂 Trains used to bring visitors to Atlantic City!',
        emoji: '🏚️',
      ),
      // Light Blue properties
      6: TileInfo(
        location: 'Atlantic City, New Jersey, USA',
        facts: [
          'Oriental Avenue got its name from Asian-themed buildings',
          'In the 1920s, this area had exotic restaurants',
          'It\'s now called Martin Luther King Jr. Boulevard',
        ],
        funFact: '🥢 Imagine eating yummy noodles on this street!',
        emoji: '🏮',
      ),
      8: TileInfo(
        location: 'Atlantic City, New Jersey, USA',
        facts: [
          'Vermont Avenue was named after the US state',
          'Vermont means "Green Mountain" in French',
          'The state of Vermont is famous for maple syrup!',
        ],
        funFact: '🍁 Vermont makes the most maple syrup in the USA!',
        emoji: '🌲',
      ),
      9: TileInfo(
        location: 'Atlantic City, New Jersey, USA',
        facts: [
          'Connecticut Avenue was named after the state',
          'Connecticut is called "The Constitution State"',
          'The first hamburger was served in Connecticut!',
        ],
        funFact: '🍔 Would you believe the hamburger was invented there?',
        emoji: '🏛️',
      ),
      // Pink properties
      11: TileInfo(
        location: 'Atlantic City, New Jersey, USA',
        facts: [
          'St. Charles Place was a real street with nice homes',
          'It was named after Charles II, King of England',
          'Many famous people visited this area in the 1920s',
        ],
        funFact: '👑 This street was named after a real king!',
        emoji: '🏰',
      ),
      13: TileInfo(
        location: 'Atlantic City, New Jersey, USA',
        facts: [
          'States Avenue represented all 50 US states',
          'In the original game, it was called State Street',
          'Many states have their own special birds and flowers!',
        ],
        funFact: '🗺️ The USA has 50 states - can you name them all?',
        emoji: '🇺🇸',
      ),
      14: TileInfo(
        location: 'Atlantic City, New Jersey, USA',
        facts: [
          'Virginia Avenue was named after the state',
          'Virginia is called "The Old Dominion"',
          'Eight US Presidents were born in Virginia!',
        ],
        funFact: '🏛️ More presidents came from Virginia than any other state!',
        emoji: '⭐',
      ),
      // Orange properties
      16: TileInfo(
        location: 'Atlantic City, New Jersey, USA',
        facts: [
          'St. James Place was a fancy street',
          'Named after St. James, one of Jesus\'s disciples',
          'There\'s a famous St. James Palace in London!',
        ],
        funFact: '🇬🇧 The royal family in England has a St. James Palace!',
        emoji: '👸',
      ),
      18: TileInfo(
        location: 'Atlantic City, New Jersey, USA',
        facts: [
          'Tennessee Avenue was named after the state',
          'Tennessee is called "The Volunteer State"',
          'Country music was born in Tennessee!',
        ],
        funFact: '🎸 Nashville, Tennessee is the home of country music!',
        emoji: '🎵',
      ),
      19: TileInfo(
        location: 'Atlantic City, New Jersey, USA',
        facts: [
          'New York Avenue was named after NYC',
          'New York City is called "The Big Apple"',
          'The Statue of Liberty is in New York!',
        ],
        funFact: '🗽 The Statue of Liberty was a gift from France!',
        emoji: '🍎',
      ),
      // Red properties
      21: TileInfo(
        location: 'Atlantic City, New Jersey, USA',
        facts: [
          'Kentucky Avenue was named after the state',
          'Kentucky is famous for horse racing',
          'The Kentucky Derby is the most famous horse race!',
        ],
        funFact: '🏇 Horses run super fast at the Kentucky Derby!',
        emoji: '🐴',
      ),
      23: TileInfo(
        location: 'Atlantic City, New Jersey, USA',
        facts: [
          'Indiana Avenue was named after the state',
          'Indiana means "Land of Indians"',
          'The famous Indy 500 car race is there!',
        ],
        funFact: '🏎️ Race cars go over 200 mph at the Indy 500!',
        emoji: '🏁',
      ),
      24: TileInfo(
        location: 'Atlantic City, New Jersey, USA',
        facts: [
          'Illinois Avenue was named after the state',
          'Chicago is the biggest city in Illinois',
          'The first skyscraper was built in Chicago!',
        ],
        funFact: '🏙️ Chicago has amazing pizza and tall buildings!',
        emoji: '🍕',
      ),
      // Yellow properties
      26: TileInfo(
        location: 'Atlantic City, New Jersey, USA',
        facts: [
          'Atlantic Avenue was the main street!',
          'It ran along the famous boardwalk',
          'Many hotels and shops were on this street',
        ],
        funFact: '🎡 The boardwalk had rides and games!',
        emoji: '🌊',
      ),
      27: TileInfo(
        location: 'Atlantic City, New Jersey, USA',
        facts: [
          'Ventnor Avenue was named after a nearby town',
          'Ventnor is just south of Atlantic City',
          'It had beautiful beach homes',
        ],
        funFact: '🏖️ Ventnor has quiet, peaceful beaches!',
        emoji: '🐚',
      ),
      29: TileInfo(
        location: 'Atlantic City, New Jersey, USA',
        facts: [
          'Marvin Gardens was actually "Marven Gardens"',
          'It\'s a fancy neighborhood between two towns',
          'The game had a spelling mistake that stuck!',
        ],
        funFact: '✏️ Oops! The game spelled the name wrong!',
        emoji: '🌷',
      ),
      // Green properties
      31: TileInfo(
        location: 'Atlantic City, New Jersey, USA',
        facts: [
          'Pacific Avenue runs parallel to the ocean',
          'It was named after the Pacific Ocean',
          'Many big hotels were built here',
        ],
        funFact: '🌅 You could see beautiful sunrises from here!',
        emoji: '🌴',
      ),
      32: TileInfo(
        location: 'Atlantic City, New Jersey, USA',
        facts: [
          'North Carolina Avenue was named after the state',
          'North Carolina has beautiful mountains and beaches',
          'The Wright Brothers flew the first airplane there!',
        ],
        funFact: '✈️ The first airplane flight was only 12 seconds!',
        emoji: '🛫',
      ),
      34: TileInfo(
        location: 'Atlantic City, New Jersey, USA',
        facts: [
          'Pennsylvania Avenue is also in Washington DC',
          'The White House is on Pennsylvania Avenue!',
          'Pennsylvania means "Penn\'s Woods"',
        ],
        funFact: '🏛️ The President lives on a Pennsylvania Avenue!',
        emoji: '🦅',
      ),
      // Dark Blue properties
      37: TileInfo(
        location: 'Atlantic City, New Jersey, USA',
        facts: [
          'Park Place was a very wealthy area',
          'Rich families lived in big mansions here',
          'It\'s the second most expensive property!',
        ],
        funFact: '💎 Only millionaires could afford to live here!',
        emoji: '🎩',
      ),
      39: TileInfo(
        location: 'Atlantic City, New Jersey, USA',
        facts: [
          'Boardwalk is the most famous property!',
          'Atlantic City\'s boardwalk was built in 1870',
          'It was the first boardwalk in America!',
        ],
        funFact: '🎢 The boardwalk had cotton candy and saltwater taffy!',
        emoji: '🎪',
      ),
    };

    // Railroad info
    final railroadFacts = <int, TileInfo>{
      5: TileInfo(
        location: 'Philadelphia & Reading Railroad',
        facts: [
          'This was a real railroad company from 1833!',
          'Trains carried coal from mines to cities',
          'Steam engines were very loud and smoky!',
        ],
        funFact: '🚂 Choo choo! Steam trains could go 60 mph!',
        emoji: '🚃',
      ),
      15: TileInfo(
        location: 'Pennsylvania Railroad',
        facts: [
          'The Pennsylvania Railroad was HUGE!',
          'It was called "The Standard Railroad of the World"',
          'It connected New York to Chicago!',
        ],
        funFact: '🌟 This was the biggest railroad company in America!',
        emoji: '🚂',
      ),
      25: TileInfo(
        location: 'Baltimore & Ohio Railroad',
        facts: [
          'B&O was America\'s first railroad!',
          'It started in 1827 - almost 200 years ago!',
          'Horses pulled the first train cars!',
        ],
        funFact: '🐴 Before engines, horses pulled trains!',
        emoji: '🚆',
      ),
      35: TileInfo(
        location: 'Short Line Railroad',
        facts: [
          'Short Line railroads were small local trains',
          'They connected small towns to big cities',
          'Some were only a few miles long!',
        ],
        funFact: '🏘️ Small towns needed trains too!',
        emoji: '🚈',
      ),
    };

    // Utility info
    final utilityFacts = <int, TileInfo>{
      12: TileInfo(
        location: 'Atlantic City Electric Company',
        facts: [
          'Electricity was a new invention in the 1900s!',
          'Thomas Edison invented the light bulb',
          'Before electricity, people used candles!',
        ],
        funFact: '💡 Edison tried 1,000 times before the light bulb worked!',
        emoji: '⚡',
      ),
      28: TileInfo(
        location: 'Atlantic City Water Works',
        facts: [
          'Clean water is super important!',
          'Water treatment makes water safe to drink',
          'We use water for drinking, cooking, and bathing',
        ],
        funFact: '💧 Your body is 60% water!',
        emoji: '🚰',
      ),
    };

    // Check specific tile info
    if (propertyFacts.containsKey(tile.index)) {
      return propertyFacts[tile.index]!;
    }
    if (railroadFacts.containsKey(tile.index)) {
      return railroadFacts[tile.index]!;
    }
    if (utilityFacts.containsKey(tile.index)) {
      return utilityFacts[tile.index]!;
    }

    // Special tiles
    switch (tile.type) {
      case TileType.start:
        return TileInfo(
          location: 'Starting Point',
          facts: [
            'Everyone starts the game here!',
            'Pass GO and collect \$200!',
            'This rule has been the same since 1935!',
          ],
          funFact: '🎉 GO is like getting your allowance!',
          emoji: '🚀',
        );
      case TileType.jail:
        return TileInfo(
          location: 'Just Visiting / In Jail',
          facts: [
            'You can visit without going to jail!',
            'If you\'re "just visiting," you\'re safe',
            'Roll doubles to get out of jail!',
          ],
          funFact: '🔑 You can pay \$50 to leave jail!',
          emoji: '🔒',
        );
      case TileType.freeParking:
        return TileInfo(
          location: 'Spin to Win!',
          facts: [
            'Spin the colorful wheel for prizes!',
            'Win cash, power-ups, or special bonuses!',
            'Every spin is a chance for something amazing!',
          ],
          funFact: '🎰 Lucky Spin can change the game!',
          emoji: '🎡',
        );
      case TileType.goToJail:
        return TileInfo(
          location: 'Go To Jail',
          facts: [
            'Uh oh! Go directly to jail!',
            'Do not pass GO!',
            'Do not collect \$200!',
          ],
          funFact: '👮 The police officer sends you to jail!',
          emoji: '🚨',
        );
      case TileType.chance:
        return TileInfo(
          location: 'Chance Card',
          facts: [
            'Draw a card and see what happens!',
            'You might win money or pay a fine',
            'There are 16 different Chance cards!',
          ],
          funFact: '🎲 Chance cards add surprise to the game!',
          emoji: '❓',
        );
      case TileType.communityChest:
        return TileInfo(
          location: 'Community Chest',
          facts: [
            'The community helps each other!',
            'These cards often give you money',
            'Bank error in your favor = win!',
          ],
          funFact: '💰 Community Chest cards are usually nice!',
          emoji: '📦',
        );
      case TileType.tax:
        final taxTile = tile as TaxTileData;
        if (tile.index == 4) {
          return TileInfo(
            location: 'Income Tax',
            facts: [
              'Everyone has to pay taxes!',
              'Taxes pay for schools and roads',
              'Pay \$${taxTile.amount} when you land here',
            ],
            funFact: '🏫 Taxes help build schools and parks!',
            emoji: '💸',
          );
        } else {
          return TileInfo(
            location: 'Luxury Tax',
            facts: [
              'Luxury means something fancy!',
              'Expensive things have extra taxes',
              'Pay \$${taxTile.amount} for luxury items',
            ],
            funFact: '💎 Fancy jewelry has luxury tax!',
            emoji: '👛',
          );
        }
      default:
        return TileInfo(
          location: 'Monopoly Board',
          facts: [
            'Monopoly was invented in 1935!',
            'The game is sold in over 100 countries',
            'Millions of people play every year!',
          ],
          funFact: '🌍 Kids all over the world play Monopoly!',
          emoji: '🎲',
        );
    }
  }
}

/// Tile information data class
class TileInfo {
  final String location;
  final List<String> facts;
  final String funFact;
  final String emoji;

  const TileInfo({
    required this.location,
    required this.facts,
    required this.funFact,
    required this.emoji,
  });
}

/// Dialog showing tile information
class TileInfoDialog extends StatelessWidget {
  final TileData tile;

  const TileInfoDialog({
    super.key,
    required this.tile,
  });

  Color get _headerColor {
    if (tile is PropertyTileData) {
      return (tile as PropertyTileData).groupColor;
    }
    switch (tile.type) {
      case TileType.railroad:
        return Colors.grey.shade800;
      case TileType.utility:
        return Colors.amber.shade700;
      case TileType.chance:
        return Colors.orange;
      case TileType.communityChest:
        return Colors.blue.shade600;
      case TileType.tax:
        return Colors.purple;
      case TileType.start:
        return Colors.red;
      case TileType.jail:
        return Colors.orange.shade800;
      case TileType.freeParking:
        return Colors.green;
      case TileType.goToJail:
        return Colors.red.shade700;
      default:
        return AppTheme.primary;
    }
  }

  /// Determine if the header color is light (needs dark text)
  bool get _isLightColor {
    final color = _headerColor;
    // Calculate relative luminance
    final luminance = (0.299 * color.r + 0.587 * color.g + 0.114 * color.b);
    return luminance > 0.55; // Light colors need dark text
  }

  Color get _headerTextColor => _isLightColor ? Colors.black87 : Colors.white;
  Color get _headerSubTextColor =>
      _isLightColor ? Colors.black54 : Colors.white.withOpacity(0.85);

  /// Get location text from tile type
  String _getLocationFromTile() {
    if (tile is PropertyTileData || tile is RailroadTileData || tile is UtilityTileData) {
      // Generic location - the tile name itself is the location
      return 'Property Location';
    }
    switch (tile.type) {
      case TileType.start:
        return 'Starting Point';
      case TileType.jail:
        return 'Just Visiting / In Jail';
      case TileType.freeParking:
        return 'Spin to Win!';
      case TileType.goToJail:
        return 'Go To Jail';
      case TileType.chance:
        return 'Chance Card';
      case TileType.communityChest:
        return 'Community Chest';
      case TileType.tax:
        return tile.index == 4 ? 'Income Tax' : 'Luxury Tax';
      default:
        return 'Monopoly Board';
    }
  }

  /// Convert fun fact to facts list
  List<String> _getFactsFromFunFact(String funFact) {
    // Simply return the fun fact as a single item list
    return [funFact];
  }

  /// Get emoji from tile type
  String _getEmojiFromTileType() {
    switch (tile.type) {
      case TileType.property:
        return '🏠';
      case TileType.railroad:
        return '🚂';
      case TileType.utility:
        return (tile as UtilityTileData).isElectric ? '⚡' : '💧';
      case TileType.chance:
        return '❓';
      case TileType.communityChest:
        return '📦';
      case TileType.tax:
        return '💸';
      case TileType.start:
        return '🚀';
      case TileType.jail:
        return '🔒';
      case TileType.freeParking:
        return '🎡';
      case TileType.goToJail:
        return '🚨';
      default:
        return '🎲';
    }
  }

  IconData get _icon {
    switch (tile.type) {
      case TileType.property:
        return Icons.home;
      case TileType.railroad:
        return Icons.train;
      case TileType.utility:
        return (tile as UtilityTileData).isElectric
            ? Icons.bolt
            : Icons.water_drop;
      case TileType.chance:
        return Icons.help_outline;
      case TileType.communityChest:
        return Icons.inventory_2;
      case TileType.tax:
        return Icons.account_balance;
      case TileType.start:
        return Icons.flag;
      case TileType.jail:
        return Icons.gavel;
      case TileType.freeParking:
        return Icons.local_parking;
      case TileType.goToJail:
        return Icons.warning;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Use tile's built-in fun fact if available, otherwise fall back to hardcoded facts
    final info = tile.funFact != null
      ? TileInfo(
          location: _getLocationFromTile(),
          facts: _getFactsFromFunFact(tile.funFact!),
          funFact: tile.funFact!,
          emoji: _getEmojiFromTileType(),
        )
      : TileFacts.getInfo(tile);

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 380, maxHeight: 600),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white24, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(info),
            Flexible(child: _buildContent(info)),
            _buildCloseButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(TileInfo info) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: _headerColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            info.emoji,
            style: const TextStyle(fontSize: 24),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  tile.name,
                  style: TextStyle(
                    color: _headerTextColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  info.location,
                  style: TextStyle(
                    color: _headerSubTextColor,
                    fontSize: 11,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Icon(_icon, color: _headerTextColor, size: 24),
        ],
      ),
    );
  }

  Widget _buildContent(TileInfo info) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Price info for purchasable tiles
          if (tile is PropertyTileData ||
              tile is RailroadTileData ||
              tile is UtilityTileData)
            _buildPriceSection(),

          // Fun fact banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.amber.shade400, Colors.orange.shade400],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Text('✨', style: TextStyle(fontSize: 20)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    info.funFact,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Facts section
          const Text(
            'Did You Know? 🧠',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ...info.facts.map((fact) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('• ', style: TextStyle(color: Colors.amber, fontSize: 16)),
                    Expanded(
                      child: Text(
                        fact,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),
              )),

          // Game rules for special tiles
          if (tile.type == TileType.chance ||
              tile.type == TileType.communityChest ||
              tile.type == TileType.jail ||
              tile.type == TileType.goToJail ||
              tile.type == TileType.tax) ...[
            const SizedBox(height: 12),
            _buildRulesSection(),
          ],
        ],
      ),
    );
  }

  Widget _buildPriceSection() {
    int? price;
    String rentInfo = '';

    if (tile is PropertyTileData) {
      final prop = tile as PropertyTileData;
      price = prop.price;
      rentInfo = 'Rent: \$${prop.rentLevels.first} (up to \$${prop.rentLevels.last} with hotel!)';
    } else if (tile is RailroadTileData) {
      price = (tile as RailroadTileData).price;
      rentInfo = 'Rent: \$25-\$200 (depends on how many railroads you own!)';
    } else if (tile is UtilityTileData) {
      price = (tile as UtilityTileData).price;
      rentInfo = 'Rent: 4x or 10x your dice roll!';
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.attach_money, color: AppTheme.cashGreen, size: 24),
              Text(
                'Price: \$$price',
                style: const TextStyle(
                  color: AppTheme.cashGreen,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            rentInfo,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildRulesSection() {
    String title;
    List<String> rules;

    switch (tile.type) {
      case TileType.chance:
        title = '🎲 How to Play';
        rules = [
          'Draw the top card from the Chance pile',
          'Read the card out loud',
          'Do what the card says!',
          'Put the card at the bottom of the pile',
        ];
        break;
      case TileType.communityChest:
        title = '📦 How to Play';
        rules = [
          'Draw the top card from the chest',
          'Read it out loud to everyone',
          'Follow the instructions on the card',
          'Return the card to the bottom',
        ];
        break;
      case TileType.jail:
        title = '🔒 Jail Rules';
        rules = [
          'If you\'re "Just Visiting" - you\'re safe!',
          'If you\'re IN jail, you can:',
          '  • Pay \$50 to get out',
          '  • Try to roll doubles (3 tries)',
          '  • Use a "Get Out of Jail Free" card',
        ];
        break;
      case TileType.goToJail:
        title = '🚨 Go To Jail Rules';
        rules = [
          'Go directly to Jail!',
          'Do NOT pass GO',
          'Do NOT collect \$200',
          'Your turn ends immediately',
        ];
        break;
      case TileType.tax:
        title = '💰 Tax Rules';
        rules = [
          'You MUST pay this tax!',
          'Pay the bank the amount shown',
          'If you can\'t pay, you might go bankrupt!',
        ];
        break;
      default:
        return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ...rules.map((rule) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  rule,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    height: 1.3,
                  ),
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildCloseButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          style: ElevatedButton.styleFrom(
            backgroundColor: _headerColor,
            foregroundColor: _headerTextColor,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            'Got it!',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

/// Show the tile info dialog with animation
Future<void> showTileInfoDialog({
  required BuildContext context,
  required TileData tile,
}) {
  return showAnimatedDialog(
    context: context,
    barrierDismissible: true,
    animationType: DialogAnimationType.scale,
    builder: (context) => TileInfoDialog(tile: tile),
  );
}

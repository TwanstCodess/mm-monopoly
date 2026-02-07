import 'package:flutter/material.dart';
import '../../models/tile.dart';
import '../../config/theme.dart';
import '../../l10n/app_localizations.dart';
import 'animated_dialog.dart';

/// Localized facts and educational content for Monopoly tiles
class TileFacts {
  static TileInfo getInfo(BuildContext context, TileData tile) {
    final l10n = AppLocalizations.of(context)!;

    switch (tile.type) {
      case TileType.start:
        return TileInfo(
          location: l10n.startingPoint,
          facts: [l10n.collectGoBonus, l10n.passGoEarn],
          funFact: l10n.startTileFunFact,
          emoji: '🚀',
        );
      case TileType.jail:
        return TileInfo(
          location: l10n.justVisiting,
          facts: [l10n.jailFactOne, l10n.jailFactTwo],
          funFact: l10n.jailFunFact,
          emoji: '🔒',
        );
      case TileType.freeParking:
        return TileInfo(
          location: l10n.spinToWin,
          facts: [l10n.freeParkingFactOne, l10n.freeParkingFactTwo],
          funFact: l10n.freeParkingFunFact,
          emoji: '🎡',
        );
      case TileType.goToJail:
        return TileInfo(
          location: l10n.goToJailLabel,
          facts: [l10n.goToJailFactOne, l10n.goToJailFactTwo],
          funFact: l10n.goToJailFunFact,
          emoji: '🚨',
        );
      case TileType.chance:
        return TileInfo(
          location: l10n.chanceCard,
          facts: [
            l10n.drawTopCard,
            l10n.readCardAloud,
            l10n.followInstructions,
          ],
          funFact: l10n.chanceFunFact,
          emoji: '❓',
        );
      case TileType.communityChest:
        return TileInfo(
          location: l10n.communityChestCard,
          facts: [
            l10n.communityChestFactOne,
            l10n.communityChestFactTwo,
            l10n.communityChestFactThree,
          ],
          funFact: l10n.communityChestFunFact,
          emoji: '📦',
        );
      case TileType.tax:
        final taxTile = tile as TaxTileData;
        return TileInfo(
          location: tile.index == 4 ? l10n.incomeTax : l10n.luxuryTax,
          facts: [
            l10n.taxFactOne,
            l10n.taxFactTwo,
            l10n.payAmount(taxTile.amount),
          ],
          funFact: l10n.taxFunFact,
          emoji: '💸',
        );
      case TileType.property:
      case TileType.railroad:
      case TileType.utility:
        return TileInfo(
          location: l10n.propertyLocation,
          facts: const [],
          funFact: tile.funFact ?? l10n.didYouKnow,
          emoji:
              tile.type == TileType.railroad
                  ? '🚂'
                  : tile.type == TileType.utility
                  ? ((tile as UtilityTileData).isElectric ? '⚡' : '💧')
                  : '🏠',
        );
    }
  }
}

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

  const TileInfoDialog({super.key, required this.tile});

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
  String _getLocationFromTile(BuildContext context) {
    if (tile is PropertyTileData ||
        tile is RailroadTileData ||
        tile is UtilityTileData) {
      // Generic location - the tile name itself is the location
      return AppLocalizations.of(context)!.propertyLocation;
    }
    switch (tile.type) {
      case TileType.start:
        return AppLocalizations.of(context)!.startingPoint;
      case TileType.jail:
        return AppLocalizations.of(context)!.justVisiting;
      case TileType.freeParking:
        return AppLocalizations.of(context)!.spinToWin;
      case TileType.goToJail:
        return AppLocalizations.of(context)!.goToJailLabel;
      case TileType.chance:
        return AppLocalizations.of(context)!.chanceCard;
      case TileType.communityChest:
        return AppLocalizations.of(context)!.communityChestCard;
      case TileType.tax:
        return tile.index == 4
            ? AppLocalizations.of(context)!.incomeTax
            : AppLocalizations.of(context)!.luxuryTax;
      default:
        return AppLocalizations.of(context)!.appTitle;
    }
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

  /// Get game tips/facts for purchasable tiles
  List<String> _getGameTips(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (tile is PropertyTileData) {
      final property = tile as PropertyTileData;
      return [
        l10n.ownAllPropertiesTip,
        l10n.buildHousesEvenlyTip,
        l10n.hotelsMaxRentTip(property.rentLevels.last),
      ];
    } else if (tile is RailroadTileData) {
      return [
        l10n.railroad1Tip,
        l10n.railroad2Tip,
        l10n.railroad3Tip,
        l10n.railroad4Tip,
      ];
    } else if (tile is UtilityTileData) {
      return [l10n.utility1Tip, l10n.utility2Tip, l10n.utilitiesProfitableTip];
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    // Get the base tile info from TileFacts (for special tiles like Chance, Tax, corners, etc.)
    final baseInfo = TileFacts.getInfo(context, tile);

    // Determine if this is a special tile type that should use TileFacts
    final isSpecialTile =
        tile.type == TileType.start ||
        tile.type == TileType.jail ||
        tile.type == TileType.freeParking ||
        tile.type == TileType.goToJail ||
        tile.type == TileType.chance ||
        tile.type == TileType.communityChest ||
        tile.type == TileType.tax;

    // Determine facts to show
    List<String> facts;
    String funFact;

    if (tile.funFact != null) {
      // Tile has its own funFact (all boards) - use it for banner
      // Add game tips as bullet points for properties/railroads/utilities
      funFact = tile.funFact!;
      facts = _getGameTips(context);
    } else if (isSpecialTile) {
      // Special tiles use TileFacts (Chance, Tax, corners, etc.)
      funFact = baseInfo.funFact;
      facts = baseInfo.facts;
    } else {
      // Fallback to TileFacts
      funFact = baseInfo.funFact;
      facts = baseInfo.facts;
    }

    final info = TileInfo(
      location: _getLocationFromTile(context),
      facts: facts,
      funFact: funFact,
      emoji: _getEmojiFromTileType(),
    );

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
            Flexible(child: _buildContent(context, info)),
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
          Text(info.emoji, style: const TextStyle(fontSize: 24)),
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
                  style: TextStyle(color: _headerSubTextColor, fontSize: 11),
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

  Widget _buildContent(BuildContext context, TileInfo info) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Price info for purchasable tiles
          if (tile is PropertyTileData ||
              tile is RailroadTileData ||
              tile is UtilityTileData)
            _buildPriceSection(context),

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

          // Facts section - only show if there are facts to display
          if (info.facts.isNotEmpty) ...[
            Text(
              '${AppLocalizations.of(context)!.didYouKnow} 🧠',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...info.facts.map(
              (fact) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '• ',
                      style: TextStyle(color: Colors.amber, fontSize: 16),
                    ),
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
              ),
            ),
          ],

          // Game rules for special tiles
          if (tile.type == TileType.chance ||
              tile.type == TileType.communityChest ||
              tile.type == TileType.jail ||
              tile.type == TileType.goToJail ||
              tile.type == TileType.tax) ...[
            const SizedBox(height: 12),
            _buildRulesSection(context),
          ],
        ],
      ),
    );
  }

  Widget _buildPriceSection(BuildContext context) {
    int? price;
    String rentInfo = '';

    if (tile is PropertyTileData) {
      final prop = tile as PropertyTileData;
      price = prop.price;
      rentInfo =
          '${AppLocalizations.of(context)!.rent}: \$${prop.rentLevels.first} (${AppLocalizations.of(context)!.hotelsMaxRentTip(prop.rentLevels.last)})';
    } else if (tile is RailroadTileData) {
      price = (tile as RailroadTileData).price;
      rentInfo = '${AppLocalizations.of(context)!.rent}: \$25-\$200';
    } else if (tile is UtilityTileData) {
      price = (tile as UtilityTileData).price;
      rentInfo = AppLocalizations.of(context)!.utilityRentDesc;
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
              const Icon(
                Icons.attach_money,
                color: AppTheme.cashGreen,
                size: 24,
              ),
              Text(
                '${AppLocalizations.of(context)!.price}: \$$price',
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

  Widget _buildRulesSection(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    String title;
    List<String> rules;

    switch (tile.type) {
      case TileType.chance:
        title = '🎲 ${l10n.chanceHowToPlay}';
        rules = [
          l10n.drawTopCard,
          l10n.readCardAloud,
          l10n.doWhatCardSays,
          l10n.putCardBottom,
        ];
        break;
      case TileType.communityChest:
        title = '📦 ${l10n.chestHowToPlay}';
        rules = [
          l10n.drawTopChestCard,
          l10n.readToEveryone,
          l10n.followInstructions,
          l10n.returnCardBottom,
        ];
        break;
      case TileType.jail:
        title = '🔒 ${l10n.jailRules}';
        rules = [
          l10n.justVisitingSafe,
          l10n.inJailYouCan,
          l10n.pay50GetOut,
          l10n.rollDoublesThreeTries,
          l10n.useGetOutCard,
        ];
        break;
      case TileType.goToJail:
        title = '🚨 ${l10n.goToJailRules}';
        rules = [
          l10n.goDirectlyToJail,
          l10n.doNotPassGo,
          l10n.doNotCollect200,
          l10n.turnEndsImmediately,
        ];
        break;
      case TileType.tax:
        title = '💰 ${l10n.taxRules}';
        rules = [
          l10n.mustPayTaxRule,
          l10n.payBankAmountShown,
          l10n.cantPayMightGoBankrupt,
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
          ...rules.map(
            (rule) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                rule,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                  height: 1.3,
                ),
              ),
            ),
          ),
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
          child: Text(
            AppLocalizations.of(context)!.gotIt,
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

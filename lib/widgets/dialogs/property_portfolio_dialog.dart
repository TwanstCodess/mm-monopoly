import 'package:flutter/material.dart';
import '../../models/player.dart';
import '../../models/tile.dart';
import '../../models/game_state.dart';
import '../../config/theme.dart';
import '../../l10n/app_localizations.dart';
import '../../utils/currency_utils.dart';

/// Comprehensive property portfolio dialog showing all owned properties
class PropertyPortfolioDialog extends StatelessWidget {
  final Player player;
  final List<TileData> tiles;
  final GameState gameState;
  final Function(PropertyTileData)? onMortgage;
  final Function(PropertyTileData)? onUpgrade;

  const PropertyPortfolioDialog({
    super.key,
    required this.player,
    required this.tiles,
    required this.gameState,
    this.onMortgage,
    this.onUpgrade,
  });

  String _withLocaleCurrency(BuildContext context, String text) {
    final symbol = CurrencyUtils.symbolForLocale(
      Localizations.localeOf(context),
    );
    return text.replaceAll(RegExp(r'[\$€¥]'), symbol);
  }

  @override
  Widget build(BuildContext context) {
    final ownedProperties = _getOwnedProperties();
    final netWorth = player.calculateNetWorth(tiles);

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppTheme.surface, AppTheme.surface.withOpacity(0.95)],
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: player.color, width: 3),
          boxShadow: [
            BoxShadow(
              color: player.color.withOpacity(0.3),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(context, netWorth),
            Expanded(
              child:
                  ownedProperties.isEmpty
                      ? _buildEmptyState(context)
                      : _buildPropertyList(context, ownedProperties),
            ),
            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, int netWorth) {
    final l10n = AppLocalizations.of(context)!;
    final positionTileName =
        (player.position >= 0 && player.position < tiles.length)
            ? tiles[player.position].name
            : l10n.tileN(player.position);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [player.color, player.color.withOpacity(0.7)],
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(21)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    player.effectiveAvatar.emoji,
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.playerPortfolio(player.name),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _withLocaleCurrency(context, l10n.netWorth(netWorth)),
                      style: const TextStyle(
                        color: AppTheme.cashGreen,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatChip(
                l10n.cash,
                CurrencyUtils.format(context, player.cash),
                Icons.attach_money,
                leadingText: CurrencyUtils.symbolForLocale(
                  Localizations.localeOf(context),
                ),
              ),
              _buildStatChip(
                l10n.properties,
                '${player.propertyIds.length}',
                Icons.home,
              ),
              _buildStatChip(
                l10n.position,
                positionTileName,
                Icons.location_on,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip(
    String label,
    String value,
    IconData icon, {
    String? leadingText,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (leadingText != null)
            Text(
              leadingText,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            )
          else
            Icon(icon, color: Colors.white, size: 16),
          const SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(color: Colors.white70, fontSize: 10),
              ),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.home_outlined, size: 80, color: Colors.grey.shade600),
            const SizedBox(height: 16),
            Text(
              l10n.noPropertiesYet,
              style: TextStyle(
                color: Colors.grey.shade400,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.startBuyingProperties,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPropertyList(
    BuildContext context,
    List<TileData> ownedProperties,
  ) {
    // Group properties by color
    final grouped = _groupPropertiesByColor(context, ownedProperties);

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: grouped.length,
      itemBuilder: (context, index) {
        final group = grouped[index];
        return _buildPropertyGroup(context, group);
      },
    );
  }

  Widget _buildPropertyGroup(BuildContext context, PropertyGroup group) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: Colors.black26,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Group header
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: group.color.withOpacity(0.3),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: group.color,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.white, width: 1),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    group.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (group.totalCount > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color:
                          group.isComplete ? AppTheme.cashGreen : Colors.orange,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${group.ownedCount}/${group.totalCount}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          // Properties in group
          ...group.properties.map((tile) => _buildPropertyTile(context, tile)),
        ],
      ),
    );
  }

  Widget _buildPropertyTile(BuildContext context, TileData tile) {
    final l10n = AppLocalizations.of(context)!;
    if (tile is PropertyTileData) {
      return ListTile(
        dense: true,
        title: Row(
          children: [
            Expanded(
              child: Text(
                tile.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (tile.isMortgaged)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  l10n.mortgaged,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        subtitle: Row(
          children: [
            Text(
              _withLocaleCurrency(context, l10n.rentAmount(tile.currentRent)),
              style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
            ),
            const SizedBox(width: 12),
            if (tile.upgradeLevel > 0)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppTheme.cashGreen,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  tile.levelDescription,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        trailing: Text(
          CurrencyUtils.format(context, tile.price),
          style: const TextStyle(
            color: AppTheme.cashGreen,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    } else if (tile is RailroadTileData) {
      return ListTile(
        dense: true,
        leading: const Icon(Icons.train, color: Colors.white70, size: 20),
        title: Text(
          tile.name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          tile.isMortgaged ? l10n.mortgagedLabel : l10n.railroad,
          style: TextStyle(
            color: tile.isMortgaged ? Colors.red : Colors.grey.shade400,
            fontSize: 12,
          ),
        ),
        trailing: Text(
          CurrencyUtils.format(context, tile.price),
          style: const TextStyle(
            color: AppTheme.cashGreen,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    } else if (tile is UtilityTileData) {
      return ListTile(
        dense: true,
        leading: Icon(
          tile.isElectric ? Icons.bolt : Icons.water_drop,
          color: Colors.white70,
          size: 20,
        ),
        title: Text(
          tile.name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          tile.isMortgaged ? l10n.mortgagedLabel : l10n.utility,
          style: TextStyle(
            color: tile.isMortgaged ? Colors.red : Colors.grey.shade400,
            fontSize: 12,
          ),
        ),
        trailing: Text(
          CurrencyUtils.format(context, tile.price),
          style: const TextStyle(
            color: AppTheme.cashGreen,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildFooter(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ElevatedButton(
        onPressed: () => Navigator.of(context).pop(),
        style: ElevatedButton.styleFrom(
          backgroundColor: player.color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          minimumSize: const Size(double.infinity, 48),
        ),
        child: Text(
          l10n.close,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  List<TileData> _getOwnedProperties() {
    return player.propertyIds
        .map((id) {
          final index = int.tryParse(id);
          if (index != null && index < tiles.length) {
            final tile = tiles[index];
            if (tile.isOwned) return tile;
          }
          return null;
        })
        .whereType<TileData>()
        .toList();
  }

  List<PropertyGroup> _groupPropertiesByColor(
    BuildContext context,
    List<TileData> properties,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final Map<String, PropertyGroup> groups = {};

    for (final tile in properties) {
      String groupKey;
      String groupName;
      Color groupColor;
      int totalInGroup = 0;

      if (tile is PropertyTileData) {
        groupKey = tile.groupId;
        groupName = _getGroupName(context, tile.groupColor);
        groupColor = tile.groupColor;
        // Count total properties in this color group
        totalInGroup =
            tiles
                .whereType<PropertyTileData>()
                .where((t) => t.groupId == tile.groupId)
                .length;
      } else if (tile is RailroadTileData) {
        groupKey = 'railroads';
        groupName = l10n.railroads;
        groupColor = Colors.grey.shade800;
        totalInGroup = tiles.whereType<RailroadTileData>().length;
      } else if (tile is UtilityTileData) {
        groupKey = 'utilities';
        groupName = l10n.utilities;
        groupColor = Colors.blue.shade300;
        totalInGroup = tiles.whereType<UtilityTileData>().length;
      } else {
        continue;
      }

      if (!groups.containsKey(groupKey)) {
        groups[groupKey] = PropertyGroup(
          name: groupName,
          color: groupColor,
          properties: [],
          totalCount: totalInGroup,
        );
      }
      groups[groupKey]!.properties.add(tile);
    }

    return groups.values.toList();
  }

  String _getGroupName(BuildContext context, Color color) {
    final l10n = AppLocalizations.of(context)!;
    if (color.value == const Color(0xFF795548).value) return l10n.colorBrown;
    if (color.value == const Color(0xFF4FC3F7).value)
      return l10n.colorLightBlue;
    if (color.value == const Color(0xFFF48FB1).value) return l10n.colorPink;
    if (color.value == const Color(0xFFFF9800).value) return l10n.colorOrange;
    if (color.value == const Color(0xFFF44336).value) return l10n.colorRed;
    if (color.value == const Color(0xFFFFEB3B).value) return l10n.colorYellow;
    if (color.value == const Color(0xFF4CAF50).value) return l10n.colorGreen;
    if (color.value == const Color(0xFF1976D2).value) return l10n.colorDarkBlue;
    return l10n.special;
  }
}

/// Helper class to group properties by color
class PropertyGroup {
  final String name;
  final Color color;
  final List<TileData> properties;
  final int totalCount;

  PropertyGroup({
    required this.name,
    required this.color,
    required this.properties,
    required this.totalCount,
  });

  int get ownedCount => properties.length;
  bool get isComplete => totalCount > 0 && ownedCount == totalCount;
}

/// Extension to check if a tile is owned
extension TileOwnership on TileData {
  bool get isOwned {
    if (this is PropertyTileData)
      return (this as PropertyTileData).ownerId != null;
    if (this is RailroadTileData)
      return (this as RailroadTileData).ownerId != null;
    if (this is UtilityTileData)
      return (this as UtilityTileData).ownerId != null;
    return false;
  }
}

/// Show the property portfolio dialog
Future<void> showPropertyPortfolioDialog({
  required BuildContext context,
  required Player player,
  required List<TileData> tiles,
  required GameState gameState,
}) {
  return showDialog(
    context: context,
    barrierDismissible: true,
    builder:
        (context) => PropertyPortfolioDialog(
          player: player,
          tiles: tiles,
          gameState: gameState,
        ),
  );
}

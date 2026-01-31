import 'package:flutter/material.dart';
import '../../models/tile.dart';
import '../../models/player.dart';
import '../../config/theme.dart';
import 'animated_dialog.dart';

/// Dialog for managing properties (mortgage/unmortgage)
class PropertyManagementDialog extends StatefulWidget {
  final Player player;
  final List<TileData> tiles;
  final Function(TileData) onMortgage;
  final Function(TileData) onUnmortgage;

  const PropertyManagementDialog({super.key, required this.player, required this.tiles, required this.onMortgage, required this.onUnmortgage});

  @override
  State<PropertyManagementDialog> createState() => _PropertyManagementDialogState();
}

class _PropertyManagementDialogState extends State<PropertyManagementDialog> {
  int _selectedTab = 0; // 0 = mortgage, 1 = unmortgage

  List<TileData> get _mortgageableProperties {
    return widget.tiles.where((tile) {
      if (tile is PropertyTileData) {
        return tile.ownerId == widget.player.id && tile.canMortgage;
      } else if (tile is RailroadTileData) {
        return tile.ownerId == widget.player.id && tile.canMortgage;
      } else if (tile is UtilityTileData) {
        return tile.ownerId == widget.player.id && tile.canMortgage;
      }
      return false;
    }).toList();
  }

  List<TileData> get _mortgagedProperties {
    return widget.tiles.where((tile) {
      if (tile is PropertyTileData) {
        return tile.ownerId == widget.player.id && tile.isMortgaged;
      } else if (tile is RailroadTileData) {
        return tile.ownerId == widget.player.id && tile.isMortgaged;
      } else if (tile is UtilityTileData) {
        return tile.ownerId == widget.player.id && tile.isMortgaged;
      }
      return false;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400, maxHeight: 500),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white24, width: 2),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(),
            _buildTabs(),
            Flexible(child: _buildPropertyList()),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.primary,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
      ),
      child: Column(
        children: [
          const Icon(Icons.account_balance, color: Colors.white, size: 32),
          const SizedBox(height: 8),
          const Text(
            'Property Management',
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text('Cash: \$${widget.player.cash}', style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedTab = 0),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(color: _selectedTab == 0 ? AppTheme.warning : Colors.transparent, borderRadius: BorderRadius.circular(12)),
                child: Text(
                  'Mortgage (${_mortgageableProperties.length})',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: _selectedTab == 0 ? Colors.black : Colors.white70, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedTab = 1),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(color: _selectedTab == 1 ? AppTheme.cashGreen : Colors.transparent, borderRadius: BorderRadius.circular(12)),
                child: Text(
                  'Unmortgage (${_mortgagedProperties.length})',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: _selectedTab == 1 ? Colors.black : Colors.white70, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPropertyList() {
    final properties = _selectedTab == 0 ? _mortgageableProperties : _mortgagedProperties;

    if (properties.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Text(
            _selectedTab == 0 ? 'No properties available to mortgage.\nProperties with houses must sell houses first.' : 'No mortgaged properties.',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white54),
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: properties.length,
      itemBuilder: (context, index) {
        final tile = properties[index];
        return _buildPropertyTile(tile);
      },
    );
  }

  Widget _buildPropertyTile(TileData tile) {
    String name = tile.name;
    int value = 0;
    Color? color;
    bool canAfford = true;

    if (tile is PropertyTileData) {
      color = tile.groupColor;
      value = _selectedTab == 0 ? tile.mortgageValue : tile.unmortgageCost;
      canAfford = _selectedTab == 1 ? widget.player.cash >= tile.unmortgageCost : true;
    } else if (tile is RailroadTileData) {
      value = _selectedTab == 0 ? tile.mortgageValue : tile.unmortgageCost;
      canAfford = _selectedTab == 1 ? widget.player.cash >= tile.unmortgageCost : true;
    } else if (tile is UtilityTileData) {
      value = _selectedTab == 0 ? tile.mortgageValue : tile.unmortgageCost;
      canAfford = _selectedTab == 1 ? widget.player.cash >= tile.unmortgageCost : true;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(12),
        border: color != null ? Border.all(color: color, width: 2) : null,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(color: color ?? Colors.grey, borderRadius: BorderRadius.circular(8)),
          child: Icon(
            tile is RailroadTileData
                ? Icons.train
                : tile is UtilityTileData
                ? Icons.bolt
                : Icons.home,
            color: Colors.white,
            size: 20,
          ),
        ),
        title: Text(
          name,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
        ),
        subtitle: Text(_selectedTab == 0 ? 'Receive: \$$value' : 'Cost: \$$value', style: TextStyle(color: _selectedTab == 0 ? AppTheme.cashGreen : AppTheme.warning, fontSize: 12)),
        trailing: ElevatedButton(
          onPressed: canAfford
              ? () {
                  if (_selectedTab == 0) {
                    widget.onMortgage(tile);
                  } else {
                    widget.onUnmortgage(tile);
                  }
                  setState(() {});
                }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: _selectedTab == 0 ? AppTheme.warning : AppTheme.cashGreen,
            foregroundColor: Colors.black,
            disabledBackgroundColor: Colors.grey,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: Text(_selectedTab == 0 ? 'Mortgage' : 'Pay', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton(
          onPressed: () => Navigator.of(context).pop(),
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.white70,
            side: const BorderSide(color: Colors.white24),
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text('Close', style: TextStyle(fontSize: 16)),
        ),
      ),
    );
  }
}

/// Show the property management dialog
Future<void> showPropertyManagementDialog({required BuildContext context, required Player player, required List<TileData> tiles, required Function(TileData) onMortgage, required Function(TileData) onUnmortgage}) {
  return showAnimatedDialog(
    context: context,
    barrierDismissible: true,
    animationType: DialogAnimationType.slideUp,
    builder: (context) => PropertyManagementDialog(player: player, tiles: tiles, onMortgage: onMortgage, onUnmortgage: onUnmortgage),
  );
}

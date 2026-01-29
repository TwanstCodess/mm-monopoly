import 'package:flutter/material.dart';
import '../../models/tile.dart';
import '../../config/theme.dart';
import 'animated_dialog.dart';

/// Dialog for selecting a tile to teleport to
class TeleportDialog extends StatefulWidget {
  final List<TileData> tiles;
  final int currentPosition;
  final Function(int) onTileSelected;

  const TeleportDialog({
    super.key,
    required this.tiles,
    required this.currentPosition,
    required this.onTileSelected,
  });

  @override
  State<TeleportDialog> createState() => _TeleportDialogState();
}

class _TeleportDialogState extends State<TeleportDialog> {
  int? _selectedTileIndex;
  String _filter = 'all';

  List<TileData> get _filteredTiles {
    return widget.tiles.where((tile) {
      // Exclude current position
      if (tile.index == widget.currentPosition) return false;

      switch (_filter) {
        case 'property':
          return tile is PropertyTileData;
        case 'special':
          return tile.type == TileType.freeParking ||
              tile.type == TileType.start ||
              tile.type == TileType.chance ||
              tile.type == TileType.communityChest;
        case 'railroad':
          return tile is RailroadTileData;
        case 'utility':
          return tile is UtilityTileData;
        default:
          return true;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400, maxHeight: 550),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.pink.withOpacity(0.5), width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.pink.withOpacity(0.2),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(),
            _buildFilterChips(),
            Flexible(child: _buildTileGrid()),
            _buildActions(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.pink.shade700, Colors.pink.shade500],
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.flash_on,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'TELEPORT!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Choose any tile to teleport to',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildChip('All', 'all'),
            _buildChip('Properties', 'property'),
            _buildChip('Railroads', 'railroad'),
            _buildChip('Utilities', 'utility'),
            _buildChip('Special', 'special'),
          ],
        ),
      ),
    );
  }

  Widget _buildChip(String label, String value) {
    final isSelected = _filter == value;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white70,
            fontSize: 12,
          ),
        ),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _filter = value;
            _selectedTileIndex = null;
          });
        },
        backgroundColor: Colors.white.withOpacity(0.1),
        selectedColor: Colors.pink.shade400,
        checkmarkColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 4),
      ),
    );
  }

  Widget _buildTileGrid() {
    final tiles = _filteredTiles;

    if (tiles.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.location_off,
              size: 48,
              color: Colors.white.withOpacity(0.3),
            ),
            const SizedBox(height: 12),
            Text(
              'No tiles match this filter',
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: tiles.length,
      itemBuilder: (context, index) {
        final tile = tiles[index];
        final isSelected = _selectedTileIndex == tile.index;

        return _buildTileCard(tile, isSelected);
      },
    );
  }

  Widget _buildTileCard(TileData tile, bool isSelected) {
    Color tileColor = Colors.grey;
    IconData tileIcon = Icons.location_on;

    if (tile is PropertyTileData) {
      tileColor = tile.groupColor;
      tileIcon = Icons.home;
    } else if (tile is RailroadTileData) {
      tileColor = Colors.grey.shade600;
      tileIcon = Icons.train;
    } else if (tile is UtilityTileData) {
      tileColor = Colors.amber;
      tileIcon = tile.name.contains('Electric') ? Icons.bolt : Icons.water_drop;
    } else {
      switch (tile.type) {
        case TileType.start:
          tileColor = Colors.green;
          tileIcon = Icons.play_arrow;
          break;
        case TileType.freeParking:
          tileColor = Colors.amber;
          tileIcon = Icons.casino;
          break;
        case TileType.chance:
          tileColor = Colors.orange.shade300;
          tileIcon = Icons.help_outline;
          break;
        case TileType.communityChest:
          tileColor = Colors.blue.shade300;
          tileIcon = Icons.inventory_2;
          break;
        case TileType.jail:
          tileColor = Colors.grey;
          tileIcon = Icons.gavel;
          break;
        case TileType.goToJail:
          tileColor = Colors.red.shade700;
          tileIcon = Icons.gavel;
          break;
        case TileType.tax:
          tileColor = Colors.purple;
          tileIcon = Icons.account_balance;
          break;
        default:
          break;
      }
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedTileIndex = tile.index;
          });
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            color: isSelected
                ? tileColor.withOpacity(0.3)
                : Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? tileColor : Colors.white.withOpacity(0.1),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: tileColor.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  tileIcon,
                  color: tileColor,
                  size: 20,
                ),
              ),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  tile.name,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (isSelected)
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 14,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white70,
                side: BorderSide(color: Colors.white.withOpacity(0.3)),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Save for Later'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: _selectedTileIndex != null
                  ? () {
                      widget.onTileSelected(_selectedTileIndex!);
                      Navigator.of(context).pop();
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink,
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.grey.shade700,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.flash_on, size: 18),
                  SizedBox(width: 4),
                  Text(
                    'Teleport!',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Show the teleport selection dialog
Future<void> showTeleportDialog({
  required BuildContext context,
  required List<TileData> tiles,
  required int currentPosition,
  required Function(int) onTileSelected,
}) {
  return showAnimatedDialog(
    context: context,
    barrierDismissible: false,
    animationType: DialogAnimationType.scale,
    builder: (context) => TeleportDialog(
      tiles: tiles,
      currentPosition: currentPosition,
      onTileSelected: onTileSelected,
    ),
  );
}

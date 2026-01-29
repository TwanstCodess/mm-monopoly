import 'package:flutter/material.dart';
import '../../models/tile.dart';
import '../../config/theme.dart';
import 'animated_dialog.dart';
import '../effects/confetti.dart';

/// Dialog for buying a property
class BuyPropertyDialog extends StatelessWidget {
  final TileData tile;
  final int playerCash;
  final VoidCallback onBuy;
  final VoidCallback onSkip;

  const BuyPropertyDialog({
    super.key,
    required this.tile,
    required this.playerCash,
    required this.onBuy,
    required this.onSkip,
  });

  int get _price {
    if (tile is PropertyTileData) return (tile as PropertyTileData).price;
    if (tile is RailroadTileData) return (tile as RailroadTileData).price;
    if (tile is UtilityTileData) return (tile as UtilityTileData).price;
    return 0;
  }

  int get _baseRent {
    if (tile is PropertyTileData) {
      return (tile as PropertyTileData).rentLevels.first;
    }
    if (tile is RailroadTileData) return 25;
    if (tile is UtilityTileData) return 0; // Depends on dice
    return 0;
  }

  Color? get _color {
    if (tile is PropertyTileData) return (tile as PropertyTileData).groupColor;
    return null;
  }

  bool get _canAfford => playerCash >= _price;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 350),
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
            _buildHeader(),
            _buildContent(),
            _buildActions(context),
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
        color: _color ?? AppTheme.primary,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
      ),
      child: Column(
        children: [
          const Icon(Icons.home, color: Colors.white, size: 40),
          const SizedBox(height: 8),
          Text(
            tile.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Text(
            'This property is available!',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 20),
          _buildInfoRow('Price', '\$$_price', AppTheme.warning),
          const SizedBox(height: 8),
          if (tile is! UtilityTileData)
            _buildInfoRow('Base Rent', '\$$_baseRent', AppTheme.cashGreen),
          if (tile is UtilityTileData)
            _buildInfoRow('Rent', '4x or 10x dice roll', AppTheme.cashGreen),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Your Cash',
                  style: TextStyle(color: Colors.white70),
                ),
                Text(
                  '\$$playerCash',
                  style: TextStyle(
                    color: _canAfford ? AppTheme.cashGreen : AppTheme.error,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          if (!_canAfford) ...[
            const SizedBox(height: 12),
            const Text(
              'Not enough cash!',
              style: TextStyle(
                color: AppTheme.error,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, Color valueColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 16),
        ),
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                Navigator.of(context).pop();
                onSkip();
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white70,
                side: const BorderSide(color: Colors.white24),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Skip', style: TextStyle(fontSize: 16)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Builder(
              builder: (buttonContext) => ElevatedButton(
              onPressed: _canAfford
                  ? () {
                      // Get button position for confetti
                      final RenderBox? box = buttonContext.findRenderObject() as RenderBox?;
                      if (box != null) {
                        final position = box.localToGlobal(
                          Offset(box.size.width / 2, box.size.height / 2),
                        );
                        // Show confetti celebration!
                        ConfettiManager.show(
                          context,
                          position: position,
                          primaryColor: _color ?? AppTheme.cashGreen,
                        );
                      }
                      Navigator.of(context).pop();
                      onBuy();
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.cashGreen,
                foregroundColor: Colors.black,
                disabledBackgroundColor: Colors.grey,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Buy \$$_price',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          ),
        ],
      ),
    );
  }
}

/// Show the buy property dialog with animation
Future<void> showBuyPropertyDialog({
  required BuildContext context,
  required TileData tile,
  required int playerCash,
  required VoidCallback onBuy,
  required VoidCallback onSkip,
}) {
  return showAnimatedDialog(
    context: context,
    barrierDismissible: false,
    animationType: DialogAnimationType.scale,
    builder: (context) => BuyPropertyDialog(
      tile: tile,
      playerCash: playerCash,
      onBuy: onBuy,
      onSkip: onSkip,
    ),
  );
}

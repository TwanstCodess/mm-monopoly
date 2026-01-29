import 'package:flutter/material.dart';
import '../../models/tile.dart';
import '../../config/theme.dart';
import 'animated_dialog.dart';

/// Dialog for upgrading a property (buying houses/hotel)
class PropertyUpgradeDialog extends StatelessWidget {
  final PropertyTileData property;
  final int playerCash;
  final VoidCallback onUpgrade;
  final VoidCallback onSkip;

  const PropertyUpgradeDialog({
    super.key,
    required this.property,
    required this.playerCash,
    required this.onUpgrade,
    required this.onSkip,
  });

  bool get _canAfford => playerCash >= property.upgradeCost;

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
        color: property.groupColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
      ),
      child: Column(
        children: [
          _buildUpgradeIcon(),
          const SizedBox(height: 8),
          Text(
            property.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              property.levelDescription,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpgradeIcon() {
    // Show houses or hotel icon based on current level
    if (property.upgradeLevel == 4) {
      // About to become a hotel
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.apartment, color: Colors.white.withOpacity(0.7), size: 32),
          const Icon(Icons.arrow_forward, color: Colors.white70, size: 20),
          const Icon(Icons.business, color: Colors.amber, size: 40),
        ],
      );
    } else {
      // Show current houses + new house
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Current houses
          ...List.generate(
            property.upgradeLevel,
            (_) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Icon(Icons.home, color: Colors.green.shade300, size: 24),
            ),
          ),
          // Arrow
          if (property.upgradeLevel > 0)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: Icon(Icons.add, color: Colors.white70, size: 20),
            ),
          // New house
          Icon(Icons.home, color: Colors.green.shade100, size: 28),
        ],
      );
    }
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            property.upgradeLevel == 4
                ? 'Build a Hotel!'
                : 'Build a House!',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 20),
          // Upgrade cost
          _buildInfoRow(
            'Upgrade Cost',
            '\$${property.upgradeCost}',
            AppTheme.warning,
          ),
          const SizedBox(height: 12),
          // Current rent
          _buildInfoRow(
            'Current Rent',
            '\$${property.currentRent}',
            Colors.white70,
          ),
          const SizedBox(height: 8),
          // New rent
          _buildInfoRow(
            'New Rent',
            '\$${property.nextLevelRent}',
            AppTheme.cashGreen,
          ),
          const SizedBox(height: 8),
          // Rent increase
          _buildInfoRow(
            'Increase',
            '+\$${property.nextLevelRent - property.currentRent}',
            Colors.amber,
          ),
          const SizedBox(height: 16),
          // Player cash
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
            child: ElevatedButton(
              onPressed: _canAfford
                  ? () {
                      Navigator.of(context).pop();
                      onUpgrade();
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                foregroundColor: Colors.black,
                disabledBackgroundColor: Colors.grey,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    property.upgradeLevel == 4 ? Icons.business : Icons.home,
                    size: 20,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Build \$${property.upgradeCost}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
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

/// Show the property upgrade dialog with scale animation
Future<void> showPropertyUpgradeDialog({
  required BuildContext context,
  required PropertyTileData property,
  required int playerCash,
  required VoidCallback onUpgrade,
  required VoidCallback onSkip,
}) {
  return showAnimatedDialog(
    context: context,
    barrierDismissible: false,
    animationType: DialogAnimationType.scale,
    builder: (context) => PropertyUpgradeDialog(
      property: property,
      playerCash: playerCash,
      onUpgrade: onUpgrade,
      onSkip: onSkip,
    ),
  );
}

import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../config/constants.dart';
import 'animated_dialog.dart';

/// Dialog for jail options - pay fine or stay
class JailDialog extends StatelessWidget {
  final int playerCash;
  final int turnsRemaining;
  final VoidCallback onPayFine;
  final VoidCallback onStay;

  const JailDialog({
    super.key,
    required this.playerCash,
    required this.turnsRemaining,
    required this.onPayFine,
    required this.onStay,
  });

  bool get canAffordFine => playerCash >= GameConstants.jailBailAmount;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 350),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.orange, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(128),
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
      decoration: const BoxDecoration(
        color: Colors.orange,
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      child: const Column(
        children: [
          Icon(Icons.gavel, color: Colors.white, size: 40),
          SizedBox(height: 8),
          Text(
            'IN JAIL',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
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
            'You are in jail!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Bail Amount',
                      style: TextStyle(color: Colors.white70),
                    ),
                    Text(
                      '\$${GameConstants.jailBailAmount}',
                      style: const TextStyle(
                        color: AppTheme.warning,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Your Cash',
                      style: TextStyle(color: Colors.white70),
                    ),
                    Text(
                      '\$$playerCash',
                      style: TextStyle(
                        color: canAffordFine ? AppTheme.cashGreen : AppTheme.error,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            turnsRemaining > 0
              ? 'Or stay in jail for $turnsRemaining more turn${turnsRemaining > 1 ? 's' : ''}.'
              : 'You must pay the fine to get out!',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Row(
        children: [
          if (turnsRemaining > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  onStay();
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white70,
                  side: const BorderSide(color: Colors.white24),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Stay in Jail', style: TextStyle(fontSize: 16)),
              ),
            ),
          if (turnsRemaining > 0) const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: canAffordFine
                  ? () {
                      Navigator.of(context).pop();
                      onPayFine();
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
                'Pay \$${GameConstants.jailBailAmount}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Show the jail dialog with scale animation
Future<void> showJailDialog({
  required BuildContext context,
  required int playerCash,
  required int turnsRemaining,
  required VoidCallback onPayFine,
  required VoidCallback onStay,
}) {
  return showAnimatedDialog(
    context: context,
    barrierDismissible: false,
    animationType: DialogAnimationType.scale,
    builder: (context) => JailDialog(
      playerCash: playerCash,
      turnsRemaining: turnsRemaining,
      onPayFine: onPayFine,
      onStay: onStay,
    ),
  );
}

import 'package:flutter/material.dart';
import '../../models/player.dart';
import '../../config/theme.dart';
import 'animated_dialog.dart';

/// Dialog showing rent payment
class RentPaymentDialog extends StatelessWidget {
  final String propertyName;
  final int amount;
  final Player owner;
  final Player payer;
  final bool isBankruptcy;
  final VoidCallback onConfirm;

  const RentPaymentDialog({
    super.key,
    required this.propertyName,
    required this.amount,
    required this.owner,
    required this.payer,
    this.isBankruptcy = false,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 350),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isBankruptcy ? AppTheme.error : Colors.white24,
            width: 2,
          ),
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
            _buildAction(context),
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
        color: isBankruptcy ? AppTheme.error : owner.color,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
      ),
      child: Column(
        children: [
          Icon(
            isBankruptcy ? Icons.warning : Icons.attach_money,
            color: Colors.white,
            size: 40,
          ),
          const SizedBox(height: 8),
          Text(
            isBankruptcy ? 'BANKRUPTCY!' : 'Pay Rent',
            style: const TextStyle(
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
          Text(
            'You landed on $propertyName',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          // Owner info
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: owner.color,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: Center(
                  child: Text(
                    owner.effectiveAvatar.emoji,
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                owner.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'owns this property',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 20),
          // Amount
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                const Text(
                  'Rent Due',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  '\$$amount',
                  style: TextStyle(
                    color: isBankruptcy ? AppTheme.error : AppTheme.warning,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          if (isBankruptcy) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.error.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.error),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning, color: AppTheme.error, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'You don\'t have enough cash! You are bankrupt.',
                      style: TextStyle(
                        color: AppTheme.error.withOpacity(0.9),
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAction(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            onConfirm();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: isBankruptcy ? AppTheme.error : AppTheme.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            isBankruptcy ? 'Accept Bankruptcy' : 'Pay \$$amount',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

/// Show the rent payment dialog with slide-up animation
Future<void> showRentPaymentDialog({
  required BuildContext context,
  required String propertyName,
  required int amount,
  required Player owner,
  required Player payer,
  bool isBankruptcy = false,
  required VoidCallback onConfirm,
}) {
  return showAnimatedDialog(
    context: context,
    barrierDismissible: false,
    animationType: DialogAnimationType.slideUp,
    builder: (context) => RentPaymentDialog(
      propertyName: propertyName,
      amount: amount,
      owner: owner,
      payer: payer,
      isBankruptcy: isBankruptcy,
      onConfirm: onConfirm,
    ),
  );
}

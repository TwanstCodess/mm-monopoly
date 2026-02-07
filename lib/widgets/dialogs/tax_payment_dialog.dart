import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../l10n/app_localizations.dart';
import 'animated_dialog.dart';

/// Dialog showing tax payment
class TaxPaymentDialog extends StatelessWidget {
  final String taxName;
  final int amount;
  final int playerCash;
  final bool isBankruptcy;
  final VoidCallback onConfirm;

  const TaxPaymentDialog({
    super.key,
    required this.taxName,
    required this.amount,
    required this.playerCash,
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
            _buildHeader(context),
            _buildContent(context),
            _buildAction(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isBankruptcy ? AppTheme.error : Colors.purple,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
      ),
      child: Column(
        children: [
          Icon(
            isBankruptcy ? Icons.warning : Icons.receipt_long,
            color: Colors.white,
            size: 40,
          ),
          const SizedBox(height: 8),
          Text(
            isBankruptcy ? AppLocalizations.of(context)!.bankruptcy : taxName,
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

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            AppLocalizations.of(context)!.payTaxToBank,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
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
                Text(
                  AppLocalizations.of(context)!.taxAmount,
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
          const SizedBox(height: 16),
          // Cash remaining
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.yourCash,
                style: TextStyle(color: Colors.white70),
              ),
              Text(
                '\$$playerCash',
                style: TextStyle(
                  color: isBankruptcy ? AppTheme.error : AppTheme.cashGreen,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
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
                      AppLocalizations.of(context)!.bankruptMessage,
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
            isBankruptcy ? AppLocalizations.of(context)!.acceptBankruptcy : AppLocalizations.of(context)!.payAmount(amount),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

/// Show the tax payment dialog with slide-up animation
Future<void> showTaxPaymentDialog({
  required BuildContext context,
  required String taxName,
  required int amount,
  required int playerCash,
  bool isBankruptcy = false,
  required VoidCallback onConfirm,
}) {
  return showAnimatedDialog(
    context: context,
    barrierDismissible: false,
    animationType: DialogAnimationType.slideUp,
    builder: (context) => TaxPaymentDialog(
      taxName: taxName,
      amount: amount,
      playerCash: playerCash,
      isBankruptcy: isBankruptcy,
      onConfirm: onConfirm,
    ),
  );
}

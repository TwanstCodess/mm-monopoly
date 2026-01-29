import 'package:flutter/material.dart';
import '../../config/theme.dart';

/// In-game menu dialog
class GameMenuDialog extends StatelessWidget {
  final VoidCallback onClose;
  final VoidCallback onRestart;
  final VoidCallback onQuit;
  final VoidCallback? onRules;

  const GameMenuDialog({
    super.key,
    required this.onClose,
    required this.onRestart,
    required this.onQuit,
    this.onRules,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 320),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white24, width: 2),
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
            _buildMenuItems(context),
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
        color: AppTheme.primary,
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      child: const Column(
        children: [
          Icon(Icons.settings, color: Colors.white, size: 40),
          SizedBox(height: 8),
          Text(
            'Game Menu',
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

  Widget _buildMenuItems(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildMenuItem(
            icon: Icons.arrow_back,
            label: 'Back to Game',
            color: AppTheme.cashGreen,
            onTap: () {
              Navigator.of(context).pop();
              // onClose is called by the .then() callback
            },
          ),
          const SizedBox(height: 12),
          if (onRules != null) ...[
            _buildMenuItem(
              icon: Icons.help_outline,
              label: 'How to Play',
              color: Colors.blue,
              onTap: () {
                Navigator.of(context).pop();
                onRules!();
              },
            ),
            const SizedBox(height: 12),
          ],
          _buildMenuItem(
            icon: Icons.refresh,
            label: 'Restart Game',
            color: AppTheme.warning,
            onTap: () {
              Navigator.of(context).pop();
              _showConfirmDialog(
                context,
                'Restart Game?',
                'All progress will be lost.',
                onRestart,
              );
            },
          ),
          const SizedBox(height: 12),
          _buildMenuItem(
            icon: Icons.exit_to_app,
            label: 'Quit to Menu',
            color: AppTheme.error,
            onTap: () {
              Navigator.of(context).pop();
              _showConfirmDialog(
                context,
                'Quit Game?',
                'All progress will be lost.',
                onQuit,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.black26,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withAlpha(51),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 16),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              const Icon(Icons.chevron_right, color: Colors.white38),
            ],
          ),
        ),
      ),
    );
  }

  void _showConfirmDialog(
    BuildContext context,
    String title,
    String message,
    VoidCallback onConfirm,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        content: Text(message, style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              onConfirm();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.error,
            ),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }
}

/// Show the game menu dialog
Future<void> showGameMenuDialog({
  required BuildContext context,
  required VoidCallback onClose,
  required VoidCallback onRestart,
  required VoidCallback onQuit,
  VoidCallback? onRules,
}) {
  return showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) => GameMenuDialog(
      onClose: onClose,
      onRestart: onRestart,
      onQuit: onQuit,
      onRules: onRules,
    ),
  ).then((_) {
    // Call onClose when dialog is dismissed (by tapping outside or "Back to Game")
    onClose();
  });
}

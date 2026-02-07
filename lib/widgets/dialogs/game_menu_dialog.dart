import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../l10n/app_localizations.dart';

/// In-game menu dialog with fun colorful styling
class GameMenuDialog extends StatelessWidget {
  final VoidCallback onClose;
  final VoidCallback onRestart;
  final VoidCallback onQuit;
  final VoidCallback? onRules;
  final VoidCallback? onSave;
  final VoidCallback? onLoad;

  const GameMenuDialog({
    super.key,
    required this.onClose,
    required this.onRestart,
    required this.onQuit,
    this.onRules,
    this.onSave,
    this.onLoad,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 340),
        decoration: BoxDecoration(
          gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF667eea), Color(0xFF764ba2)]),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
          boxShadow: [
            BoxShadow(color: const Color(0xFF764ba2).withOpacity(0.5), blurRadius: 20, spreadRadius: 2),
            BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8)),
          ],
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: [_buildHeader(context), _buildMenuItems(context)]),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)]),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
            child: const Icon(Icons.sports_esports_rounded, color: Colors.white, size: 32),
          ),
          const SizedBox(height: 12),
          Text(
            l10n.gameMenu,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              shadows: [Shadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItems(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildMenuItem(
            icon: Icons.play_arrow_rounded,
            label: l10n.backToGame,
            gradient: const [Color(0xFF4ECDC4), Color(0xFF44A08D)],
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
          const SizedBox(height: 12),
          if (onSave != null) ...[
            _buildMenuItem(
              icon: Icons.save_rounded,
              label: l10n.saveGame,
              gradient: const [Color(0xFF56CCF2), Color(0xFF2F80ED)],
              onTap: () {
                Navigator.of(context).pop();
                onSave!();
              },
            ),
            const SizedBox(height: 12),
          ],
          if (onLoad != null) ...[
            _buildMenuItem(
              icon: Icons.folder_open_rounded,
              label: l10n.loadGame,
              gradient: const [Color(0xFFB06AB3), Color(0xFF4568DC)],
              onTap: () {
                Navigator.of(context).pop();
                _showConfirmDialog(
                  context,
                  l10n.loadSavedGame,
                  l10n.currentProgressLost,
                  onLoad!,
                );
              },
            ),
            const SizedBox(height: 12),
          ],
          if (onRules != null) ...[
            _buildMenuItem(
              icon: Icons.help_outline_rounded,
              label: l10n.howToPlay,
              gradient: const [Color(0xFF667eea), Color(0xFF5567d5)],
              onTap: () {
                Navigator.of(context).pop();
                onRules!();
              },
            ),
            const SizedBox(height: 12),
          ],
          _buildMenuItem(
            icon: Icons.refresh_rounded,
            label: l10n.restartGame,
            gradient: const [Color(0xFFFFE66D), Color(0xFFFFB347)],
            onTap: () {
              Navigator.of(context).pop();
              _showConfirmDialog(context, '${l10n.restartGame}?', l10n.allProgressLost, onRestart);
            },
          ),
          const SizedBox(height: 12),
          _buildMenuItem(
            icon: Icons.coffee_rounded,
            label: l10n.buyMeACoffee,
            gradient: const [Color(0xFFFFA07A), Color(0xFFFF8C69)],
            onTap: () {
              Navigator.of(context).pop();
              _showExternalLinkDialog(context);
            },
          ),
          const SizedBox(height: 12),
          _buildMenuItem(
            icon: Icons.exit_to_app_rounded,
            label: l10n.quitToMenu,
            gradient: const [Color(0xFFFF6B6B), Color(0xFFEE5A5A)],
            onTap: () {
              Navigator.of(context).pop();
              _showConfirmDialog(context, l10n.quitGame, l10n.allProgressLost, onQuit);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({required IconData icon, required String label, required List<Color> gradient, required VoidCallback onTap}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xFF2D1B4E).withOpacity(0.6),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: gradient),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: gradient[0].withOpacity(0.4), blurRadius: 8, offset: const Offset(0, 2))],
                ),
                child: Icon(icon, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w600),
                ),
              ),
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                child: const Icon(Icons.chevron_right_rounded, color: Colors.white54, size: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showExternalLinkDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        final l10n = AppLocalizations.of(dialogContext)!;
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 320),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF667eea), Color(0xFF764ba2)]),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 20)],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(color: const Color(0xFFFFDD00).withOpacity(0.2), shape: BoxShape.circle),
                  child: const Center(child: Text('☕', style: TextStyle(fontSize: 28))),
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.openExternalLink,
                  style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.openBuyMeACoffeeDesc,
                  style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 15),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.of(dialogContext).pop(),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: Colors.white.withOpacity(0.3)),
                          ),
                        ),
                        child: Text(
                          l10n.cancel,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          Navigator.of(dialogContext).pop();
                          final uri = Uri.parse('https://buymeacoffee.com/hao_yu');
                          await launchUrl(uri, mode: LaunchMode.externalApplication);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFDD00),
                          foregroundColor: Colors.black87,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                        ),
                        child: Text(l10n.open, style: const TextStyle(fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showConfirmDialog(BuildContext context, String title, String message, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        final l10n = AppLocalizations.of(dialogContext)!;
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 320),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF667eea), Color(0xFF764ba2)]),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 20)],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(color: const Color(0xFFFF6B6B).withOpacity(0.2), shape: BoxShape.circle),
                  child: const Icon(Icons.warning_amber_rounded, color: Color(0xFFFF6B6B), size: 32),
                ),
                const SizedBox(height: 16),
                Text(
                  title,
                  style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  message,
                  style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 15),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.of(dialogContext).pop(),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: Colors.white.withOpacity(0.3)),
                          ),
                        ),
                        child: Text(
                          l10n.cancel,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(dialogContext).pop();
                          onConfirm();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF6B6B),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                        ),
                        child: Text(l10n.confirm, style: const TextStyle(fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
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
  VoidCallback? onSave,
  VoidCallback? onLoad,
}) {
  return showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) => GameMenuDialog(
      onClose: onClose,
      onRestart: onRestart,
      onQuit: onQuit,
      onRules: onRules,
      onSave: onSave,
      onLoad: onLoad,
    ),
  ).then((_) {
    // Call onClose when dialog is dismissed (by tapping outside or "Back to Game")
    onClose();
  });
}

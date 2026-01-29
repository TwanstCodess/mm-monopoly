import 'package:flutter/material.dart';
import '../../models/board_theme.dart';
import '../../config/theme.dart';

/// Theme selection widget
class ThemeSelector extends StatelessWidget {
  final BoardTheme currentTheme;
  final int totalWins;
  final Function(BoardTheme) onThemeSelected;

  const ThemeSelector({
    super.key,
    required this.currentTheme,
    required this.totalWins,
    required this.onThemeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'Board Themes',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: BoardThemes.all.length,
            itemBuilder: (context, index) {
              final theme = BoardThemes.all[index];
              final isUnlocked = BoardThemes.isUnlocked(theme, totalWins);
              final isSelected = theme.id == currentTheme.id;

              return _ThemeCard(
                theme: theme,
                isUnlocked: isUnlocked,
                isSelected: isSelected,
                totalWins: totalWins,
                onTap: isUnlocked ? () => onThemeSelected(theme) : null,
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ThemeCard extends StatelessWidget {
  final BoardTheme theme;
  final bool isUnlocked;
  final bool isSelected;
  final int totalWins;
  final VoidCallback? onTap;

  const _ThemeCard({
    required this.theme,
    required this.isUnlocked,
    required this.isSelected,
    required this.totalWins,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 140,
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Colors.amber : Colors.transparent,
            width: isSelected ? 3 : 0,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.amber.withOpacity(0.3),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ]
              : [],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(isSelected ? 13 : 16),
          child: Stack(
            children: [
              // Theme preview
              _buildThemePreview(),
              // Locked overlay
              if (!isUnlocked) _buildLockedOverlay(),
              // Selected indicator
              if (isSelected) _buildSelectedIndicator(),
              // Theme info
              _buildThemeInfo(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThemePreview() {
    return Container(
      decoration: BoxDecoration(
        color: theme.boardColor,
      ),
      child: Column(
        children: [
          // Mini board preview
          Expanded(
            flex: 3,
            child: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: theme.centerBackground,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: theme.tileBorder, width: 2),
              ),
              child: GridView.count(
                crossAxisCount: 3,
                padding: const EdgeInsets.all(4),
                mainAxisSpacing: 2,
                crossAxisSpacing: 2,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  for (int i = 0; i < 9; i++)
                    Container(
                      decoration: BoxDecoration(
                        color: i < 8
                            ? theme.propertyColors[i]
                            : theme.tileBackground,
                        borderRadius: BorderRadius.circular(2),
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

  Widget _buildLockedOverlay() {
    final winsNeeded = (theme.unlockWins ?? 0) - totalWins;

    return Positioned.fill(
      child: Container(
        color: Colors.black.withOpacity(0.7),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.lock,
              color: Colors.white54,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              '$winsNeeded win${winsNeeded != 1 ? 's' : ''}\nto unlock',
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 11,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedIndicator() {
    return Positioned(
      top: 8,
      right: 8,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: const BoxDecoration(
          color: Colors.amber,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.check,
          color: Colors.white,
          size: 14,
        ),
      ),
    );
  }

  Widget _buildThemeInfo() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Colors.black.withOpacity(0.8),
              Colors.transparent,
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              theme.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              theme.description,
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 10,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

/// Compact theme switcher for settings/menu
class ThemeSwitcher extends StatelessWidget {
  final BoardTheme currentTheme;
  final VoidCallback onTap;

  const ThemeSwitcher({
    super.key,
    required this.currentTheme,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            // Theme preview circle
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    currentTheme.boardColor,
                    currentTheme.accentColor,
                  ],
                ),
                border: Border.all(
                  color: currentTheme.tileBorder,
                  width: 2,
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Theme info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Theme',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    currentTheme.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            // Change button
            const Icon(
              Icons.chevron_right,
              color: Colors.white54,
            ),
          ],
        ),
      ),
    );
  }
}

/// Full-screen theme selection dialog
class ThemeSelectionDialog extends StatelessWidget {
  final BoardTheme currentTheme;
  final int totalWins;
  final Function(BoardTheme) onThemeSelected;

  const ThemeSelectionDialog({
    super.key,
    required this.currentTheme,
    required this.totalWins,
    required this.onThemeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppTheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Choose Theme',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Total Wins: $totalWins',
              style: const TextStyle(
                color: Colors.amber,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 400,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.8,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                ),
                itemCount: BoardThemes.all.length,
                itemBuilder: (context, index) {
                  final theme = BoardThemes.all[index];
                  final isUnlocked = BoardThemes.isUnlocked(theme, totalWins);
                  final isSelected = theme.id == currentTheme.id;

                  return _ThemeCard(
                    theme: theme,
                    isUnlocked: isUnlocked,
                    isSelected: isSelected,
                    totalWins: totalWins,
                    onTap: isUnlocked
                        ? () {
                            onThemeSelected(theme);
                            Navigator.pop(context);
                          }
                        : null,
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white54),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Show theme selection dialog
Future<void> showThemeSelectionDialog({
  required BuildContext context,
  required BoardTheme currentTheme,
  required int totalWins,
  required Function(BoardTheme) onThemeSelected,
}) {
  return showDialog(
    context: context,
    builder: (context) => ThemeSelectionDialog(
      currentTheme: currentTheme,
      totalWins: totalWins,
      onThemeSelected: onThemeSelected,
    ),
  );
}

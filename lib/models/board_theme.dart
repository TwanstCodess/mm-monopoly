import 'package:flutter/material.dart';

/// A visual theme for the game board
class BoardTheme {
  final String id;
  final String name;
  final String description;
  final Color boardColor;
  final Color tileBackground;
  final Color tileBorder;
  final Color centerBackground;
  final Color textColor;
  final Color accentColor;
  final List<Color> propertyColors;
  final bool isDark;
  final int? unlockWins; // Number of wins required to unlock

  const BoardTheme({
    required this.id,
    required this.name,
    required this.description,
    required this.boardColor,
    required this.tileBackground,
    required this.tileBorder,
    required this.centerBackground,
    required this.textColor,
    required this.accentColor,
    required this.propertyColors,
    this.isDark = true,
    this.unlockWins,
  });

  /// Get property color by group index
  Color getPropertyColor(int groupIndex) {
    return propertyColors[groupIndex % propertyColors.length];
  }
}

/// All available board themes
class BoardThemes {
  // Classic theme (default)
  static const classic = BoardTheme(
    id: 'classic',
    name: 'Classic',
    description: 'The traditional Monopoly look',
    boardColor: Color(0xFFC8E6C9),
    tileBackground: Color(0xFFFFFFFF),
    tileBorder: Color(0xFF2E7D32),
    centerBackground: Color(0xFFA5D6A7),
    textColor: Color(0xFF1B5E20),
    accentColor: Color(0xFFC62828),
    propertyColors: [
      Color(0xFF8B4513), // Brown
      Color(0xFF87CEEB), // Light Blue
      Color(0xFFFF1493), // Pink
      Color(0xFFFFA500), // Orange
      Color(0xFFFF0000), // Red
      Color(0xFFFFFF00), // Yellow
      Color(0xFF008000), // Green
      Color(0xFF0000FF), // Blue
    ],
    isDark: false,
    unlockWins: null, // Free
  );

  // Beach theme
  static const beach = BoardTheme(
    id: 'beach',
    name: 'Beach',
    description: 'Sandy shores and ocean vibes',
    boardColor: Color(0xFFF5DEB3),
    tileBackground: Color(0xFFADD8E6),
    tileBorder: Color(0xFF20B2AA),
    centerBackground: Color(0xFFFFE4B5),
    textColor: Color(0xFF008B8B),
    accentColor: Color(0xFFFF6B6B),
    propertyColors: [
      Color(0xFFDEB887), // Tan
      Color(0xFF87CEEB), // Sky Blue
      Color(0xFFFFB6C1), // Light Pink
      Color(0xFFFFDAB9), // Peach
      Color(0xFFFF7F50), // Coral
      Color(0xFFFAFAD2), // Light Yellow
      Color(0xFF98FB98), // Pale Green
      Color(0xFF4682B4), // Steel Blue
    ],
    isDark: false,
    unlockWins: 1,
  );

  // Space theme
  static const space = BoardTheme(
    id: 'space',
    name: 'Space',
    description: 'Journey through the cosmos',
    boardColor: Color(0xFF0D0D2B),
    tileBackground: Color(0xFF1A1A3E),
    tileBorder: Color(0xFF4B0082),
    centerBackground: Color(0xFF191970),
    textColor: Color(0xFFE0E0E0),
    accentColor: Color(0xFF00FFFF),
    propertyColors: [
      Color(0xFF4A148C), // Deep Purple
      Color(0xFF00BCD4), // Cyan
      Color(0xFFE91E63), // Pink
      Color(0xFFFF5722), // Deep Orange
      Color(0xFFD32F2F), // Red
      Color(0xFFFFC107), // Amber
      Color(0xFF4CAF50), // Green
      Color(0xFF2196F3), // Blue
    ],
    isDark: true,
    unlockWins: 3,
  );

  // Candy theme
  static const candy = BoardTheme(
    id: 'candy',
    name: 'Candy',
    description: 'Sweet and colorful!',
    boardColor: Color(0xFFFFE4EC),
    tileBackground: Color(0xFFFFFFFF),
    tileBorder: Color(0xFFFF69B4),
    centerBackground: Color(0xFFFFB6C1),
    textColor: Color(0xFFD81B60),
    accentColor: Color(0xFFFF1493),
    propertyColors: [
      Color(0xFFFFB3BA), // Light Pink
      Color(0xFFBAE1FF), // Light Blue
      Color(0xFFFFDFBA), // Light Peach
      Color(0xFFBAFFBA), // Light Green
      Color(0xFFE0BBE4), // Light Purple
      Color(0xFFFFFFBA), // Light Yellow
      Color(0xFFD4A5A5), // Dusty Rose
      Color(0xFF957DAD), // Soft Purple
    ],
    isDark: false,
    unlockWins: 5,
  );

  // Halloween theme
  static const halloween = BoardTheme(
    id: 'halloween',
    name: 'Halloween',
    description: 'Spooky season vibes!',
    boardColor: Color(0xFF1A0A0A),
    tileBackground: Color(0xFF2D1B1B),
    tileBorder: Color(0xFFFF6600),
    centerBackground: Color(0xFF2A1A2A),
    textColor: Color(0xFFFF8C00),
    accentColor: Color(0xFF9932CC),
    propertyColors: [
      Color(0xFF2D1B1B), // Dark Brown
      Color(0xFF4A0E4E), // Deep Purple
      Color(0xFF8B0000), // Dark Red
      Color(0xFFFF4500), // Orange Red
      Color(0xFFFF6347), // Tomato
      Color(0xFFFFD700), // Gold
      Color(0xFF228B22), // Forest Green
      Color(0xFF191970), // Midnight Blue
    ],
    isDark: true,
    unlockWins: 7, // Or play in October
  );

  // Winter theme
  static const winter = BoardTheme(
    id: 'winter',
    name: 'Winter',
    description: 'Cozy winter wonderland',
    boardColor: Color(0xFFE8F4F8),
    tileBackground: Color(0xFFFFFFFF),
    tileBorder: Color(0xFF87CEEB),
    centerBackground: Color(0xFFB0E0E6),
    textColor: Color(0xFF2F4F4F),
    accentColor: Color(0xFFC0C0C0),
    propertyColors: [
      Color(0xFF708090), // Slate Gray
      Color(0xFF4682B4), // Steel Blue
      Color(0xFFB0C4DE), // Light Steel Blue
      Color(0xFF5F9EA0), // Cadet Blue
      Color(0xFF6495ED), // Cornflower Blue
      Color(0xFFADD8E6), // Light Blue
      Color(0xFF2E8B57), // Sea Green
      Color(0xFF1E90FF), // Dodger Blue
    ],
    isDark: false,
    unlockWins: 10, // Or play in December
  );

  /// All available themes
  static const List<BoardTheme> all = [
    classic,
    beach,
    space,
    candy,
    halloween,
    winter,
  ];

  /// Get theme by ID
  static BoardTheme? byId(String id) {
    try {
      return all.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Check if a theme is unlocked based on win count
  static bool isUnlocked(BoardTheme theme, int totalWins) {
    if (theme.unlockWins == null) return true;
    return totalWins >= theme.unlockWins!;
  }

  /// Get all unlocked themes
  static List<BoardTheme> getUnlocked(int totalWins) {
    return all.where((t) => isUnlocked(t, totalWins)).toList();
  }
}

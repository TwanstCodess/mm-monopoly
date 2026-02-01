import 'package:flutter/material.dart';
import 'serialization/serialization_helpers.dart';

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

  /// Serialize to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'boardColor': colorToJson(boardColor),
      'tileBackground': colorToJson(tileBackground),
      'tileBorder': colorToJson(tileBorder),
      'centerBackground': colorToJson(centerBackground),
      'textColor': colorToJson(textColor),
      'accentColor': colorToJson(accentColor),
      'propertyColors': propertyColors.map(colorToJson).toList(),
      'isDark': isDark,
      'unlockWins': unlockWins,
    };
  }

  /// Deserialize from JSON
  factory BoardTheme.fromJson(Map<String, dynamic> json) {
    return BoardTheme(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      boardColor: colorFromJson(json['boardColor'] as Map<String, dynamic>),
      tileBackground: colorFromJson(json['tileBackground'] as Map<String, dynamic>),
      tileBorder: colorFromJson(json['tileBorder'] as Map<String, dynamic>),
      centerBackground: colorFromJson(json['centerBackground'] as Map<String, dynamic>),
      textColor: colorFromJson(json['textColor'] as Map<String, dynamic>),
      accentColor: colorFromJson(json['accentColor'] as Map<String, dynamic>),
      propertyColors: (json['propertyColors'] as List)
          .map((c) => colorFromJson(c as Map<String, dynamic>))
          .toList(),
      isDark: json['isDark'] as bool? ?? true,
      unlockWins: json['unlockWins'] as int?,
    );
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

  // === Country-Specific Themes ===

  // USA Theme - Classic Atlantic City
  static const usa = BoardTheme(
    id: 'usa',
    name: 'USA',
    description: 'Classic Atlantic City vibes',
    boardColor: Color(0xFF1a237e), // Deep Navy Blue
    tileBackground: Color(0xFF2d3e50), // Dark Slate
    tileBorder: Color(0xFFdc143c), // Crimson Red
    centerBackground: Color(0xFF34495e), // Charcoal
    textColor: Color(0xFFE8EAF6), // Light Blue Gray
    accentColor: Color(0xFFffd700), // Gold
    propertyColors: [
      Color(0xFF795548), // Brown
      Color(0xFF4FC3F7), // Light Blue
      Color(0xFFF48FB1), // Pink
      Color(0xFFFF9800), // Orange
      Color(0xFFF44336), // Red
      Color(0xFFFFEB3B), // Yellow
      Color(0xFF4CAF50), // Green
      Color(0xFF1976D2), // Dark Blue
    ],
    isDark: true,
    unlockWins: null, // Always available
  );

  // UK Theme - Royal British
  static const uk = BoardTheme(
    id: 'uk',
    name: 'UK',
    description: 'Royal British elegance',
    boardColor: Color(0xFF1b1464), // Royal Purple Deep
    tileBackground: Color(0xFF2c1a40), // Deep Royal Purple
    tileBorder: Color(0xFFc41e3a), // British Red
    centerBackground: Color(0xFF3d2651), // Royal Purple
    textColor: Color(0xFFEDE7F6), // Light Purple
    accentColor: Color(0xFFffd700), // Royal Gold
    propertyColors: [
      Color(0xFF6D4C41), // Dark Brown
      Color(0xFF64B5F6), // Royal Blue
      Color(0xFFF48FB1), // Rose Pink
      Color(0xFFFF7043), // British Orange
      Color(0xFFE53935), // Royal Red
      Color(0xFFFFD54F), // Gold
      Color(0xFF66BB6A), // British Green
      Color(0xFF1565C0), // Navy Blue
    ],
    isDark: true,
    unlockWins: null, // Always available
  );

  // Japan Theme - Modern Tokyo
  static const japan = BoardTheme(
    id: 'japan',
    name: 'Japan',
    description: 'Modern Tokyo aesthetic',
    boardColor: Color(0xFF1a1a2e), // Deep Indigo
    tileBackground: Color(0xFF1a1a2e), // Deep Night
    tileBorder: Color(0xFFe63946), // Japanese Red
    centerBackground: Color(0xFF2d2d44), // Midnight Blue
    textColor: Color(0xFFf1faee), // Sakura White
    accentColor: Color(0xFFe63946), // Japanese Red
    propertyColors: [
      Color(0xFF5D4037), // Dark Brown
      Color(0xFF42A5F5), // Sky Blue
      Color(0xFFEC407A), // Cherry Blossom Pink
      Color(0xFFFF7043), // Sunset Orange
      Color(0xFFEF5350), // Red
      Color(0xFFFFEE58), // Yellow
      Color(0xFF66BB6A), // Green
      Color(0xFF1976D2), // Deep Blue
    ],
    isDark: true,
    unlockWins: null, // Always available
  );

  // France Theme - Parisian Elegance
  static const france = BoardTheme(
    id: 'france',
    name: 'France',
    description: 'Parisian elegance',
    boardColor: Color(0xFF1e3a5f), // French Navy
    tileBackground: Color(0xFF2c4a6e), // Deep Blue
    tileBorder: Color(0xFFe4002b), // French Red
    centerBackground: Color(0xFF3a5a7f), // Royal Blue
    textColor: Color(0xFFf8f9fa), // Ivory White
    accentColor: Color(0xFFffd700), // Gold
    propertyColors: [
      Color(0xFF6D4C41), // Brown
      Color(0xFF64B5F6), // Sky Blue
      Color(0xFFF48FB1), // Rose Pink
      Color(0xFFFF8A65), // Coral Orange
      Color(0xFFE53935), // French Red
      Color(0xFFFFD54F), // Gold
      Color(0xFF66BB6A), // Green
      Color(0xFF1565C0), // Royal Blue
    ],
    isDark: true,
    unlockWins: null, // Always available
  );

  // China Theme - Imperial Dynasty
  static const china = BoardTheme(
    id: 'china',
    name: 'China',
    description: 'Imperial dynasty',
    boardColor: Color(0xFF8B0000), // Imperial Red
    tileBackground: Color(0xFF9a1a1a), // Deep Red
    tileBorder: Color(0xFFffd700), // Gold
    centerBackground: Color(0xFFa52a2a), // Crimson
    textColor: Color(0xFFfff8dc), // Cornsilk
    accentColor: Color(0xFFffd700), // Gold
    propertyColors: [
      Color(0xFF6D4C41), // Brown
      Color(0xFF42A5F5), // Sky Blue
      Color(0xFFEC407A), // Pink
      Color(0xFFFF7043), // Orange
      Color(0xFFc62828), // Chinese Red
      Color(0xFFFFD54F), // Gold
      Color(0xFF66BB6A), // Green
      Color(0xFF1565C0), // Blue
    ],
    isDark: true,
    unlockWins: null, // Always available
  );

  // Mexico Theme - Vibrant Fiesta
  static const mexico = BoardTheme(
    id: 'mexico',
    name: 'Mexico',
    description: 'Vibrant fiesta colors',
    boardColor: Color(0xFF006341), // Mexican Green
    tileBackground: Color(0xFF0a7a4a), // Deep Green
    tileBorder: Color(0xFFce1126), // Mexican Red
    centerBackground: Color(0xFF0d8a55), // Forest Green
    textColor: Color(0xFFffffff), // White
    accentColor: Color(0xFFffd700), // Gold
    propertyColors: [
      Color(0xFF6D4C41), // Brown
      Color(0xFF42A5F5), // Sky Blue
      Color(0xFFEC407A), // Magenta Pink
      Color(0xFFFF8A65), // Coral Orange
      Color(0xFFce1126), // Mexican Red
      Color(0xFFFFD54F), // Sunshine Yellow
      Color(0xFF66BB6A), // Green
      Color(0xFF1565C0), // Blue
    ],
    isDark: true,
    unlockWins: null, // Always available
  );

  /// All available themes (including country themes)
  static const List<BoardTheme> all = [
    classic,
    beach,
    space,
    candy,
    halloween,
    winter,
    usa,
    uk,
    japan,
    france,
    china,
    mexico,
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

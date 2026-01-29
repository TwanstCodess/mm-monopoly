/// Game configuration constants
class GameConstants {
  // Board
  static const int totalTiles = 40;
  static const int tilesPerSide = 10; // Including corners

  // Starting values
  static const int defaultStartingCash = 1500;
  static const int passGoBonus = 200;

  // Property
  static const int maxHouses = 4;
  static const int hotelLevel = 5;

  // Jail
  static const int jailPosition = 10;
  static const int goToJailPosition = 30;
  static const int jailBailAmount = 50;
  static const int maxJailTurns = 3;

  // Players
  static const int minPlayers = 2;
  static const int maxPlayers = 4;
  static const int maxNameLength = 12;

  // Win conditions
  static const int defaultTargetWealth = 3000;
  static const int defaultMaxRounds = 30;

  // AI
  static const Duration aiThinkingDelay = Duration(milliseconds: 800);
  static const Duration aiActionDelay = Duration(milliseconds: 500);
}

/// Layout constants
class LayoutConstants {
  // Board proportions
  static const double cornerSizeRatio = 0.12;
  static const double tileSizeRatio = 0.088; // (1 - 2*0.12) / 9

  // Token
  static const double tokenSizeRatio = 0.35;
  static const double tokenBorderWidth = 2.0;

  // Player panel
  static const double playerPanelWidth = 200.0;
  static const double playerAvatarSize = 55.0;
  static const double playerAvatarSizeCompact = 40.0;

  // Touch targets (minimum 48dp for accessibility)
  static const double minTouchTarget = 48.0;

  // Spacing
  static const double spacingXS = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 16.0;
  static const double spacingL = 24.0;
  static const double spacingXL = 32.0;

  // Border radius
  static const double radiusS = 4.0;
  static const double radiusM = 8.0;
  static const double radiusL = 16.0;
}

/// Token stacking offsets for when multiple players are on the same tile
/// Addresses design concern #4: Player Token Stacking
class TokenStackingOffsets {
  /// Offsets for 2 players on same tile
  static const List<Offset> twoPlayers = [
    Offset(-6, 0),
    Offset(6, 0),
  ];

  /// Offsets for 3 players on same tile
  static const List<Offset> threePlayers = [
    Offset(-8, -4),
    Offset(8, -4),
    Offset(0, 6),
  ];

  /// Offsets for 4 players on same tile
  static const List<Offset> fourPlayers = [
    Offset(-6, -6),
    Offset(6, -6),
    Offset(-6, 6),
    Offset(6, 6),
  ];

  /// Get offset for a player based on how many are on the tile
  static Offset getOffset(int playerIndexOnTile, int totalPlayersOnTile) {
    switch (totalPlayersOnTile) {
      case 1:
        return Offset.zero;
      case 2:
        return twoPlayers[playerIndexOnTile.clamp(0, 1)];
      case 3:
        return threePlayers[playerIndexOnTile.clamp(0, 2)];
      case 4:
      default:
        return fourPlayers[playerIndexOnTile.clamp(0, 3)];
    }
  }
}

/// Preset player names for quick selection
class PresetNames {
  static const List<String> defaults = [
    'Player 1',
    'Player 2',
    'Player 3',
    'Player 4',
  ];

  static const List<String> family = [
    'Mom',
    'Dad',
    'Alex',
    'Sam',
    'Max',
    'Emma',
  ];

  static const List<String> fun = [
    'Super Star',
    'Champion',
    'Lucky One',
    'Winner',
    'Boss',
    'Champ',
  ];
}

/// Class to hold an Offset (since we're in a non-UI file)
class Offset {
  final double dx;
  final double dy;

  const Offset(this.dx, this.dy);

  static const Offset zero = Offset(0, 0);

  Offset operator +(Offset other) => Offset(dx + other.dx, dy + other.dy);
}

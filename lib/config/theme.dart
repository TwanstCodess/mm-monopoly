import 'package:flutter/material.dart';

/// App theme configuration
class AppTheme {
  // Primary colors (M&M branding)
  static const Color primary = Color(0xFFC41E3A); // M&M Red
  static const Color secondary = Color(0xFF1B5E20); // Board Green
  static const Color background = Color(0xFF0D2818); // Dark Green
  static const Color surface = Color(0xFF1A472A); // Medium Green

  // Board colors
  static const Color boardBackground = Color(0xFFCCE5CC); // Light green
  static const Color boardBorder = Colors.black;

  // Player colors
  static const Color player1 = Color(0xFFE53935); // Red
  static const Color player2 = Color(0xFF1E88E5); // Blue
  static const Color player3 = Color(0xFF43A047); // Green
  static const Color player4 = Color(0xFFFB8C00); // Orange

  static const List<Color> playerColors = [player1, player2, player3, player4];

  // UI accent colors
  static const Color cashGreen = Color(0xFF69F0AE);
  static const Color warning = Color(0xFFFFD54F);
  static const Color error = Color(0xFFFF5252);

  // Gradients
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [surface, background],
  );

  /// Build the app theme
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: background,
      fontFamily: 'Nunito', // Will use default if not available
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 8,
        ),
      ),
      cardTheme: const CardThemeData(
        color: surface,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
        ),
        titleLarge: TextStyle(
          fontWeight: FontWeight.bold,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
        ),
      ),
    );
  }
}

/// Animation timing constants
class AnimationDurations {
  static const Duration diceRoll = Duration(milliseconds: 800);
  static const Duration tokenHop = Duration(milliseconds: 180);
  static const Duration cardFlip = Duration(milliseconds: 400);
  static const Duration cashChange = Duration(milliseconds: 600);
  static const Duration dialogAppear = Duration(milliseconds: 300);
  static const Duration buttonPress = Duration(milliseconds: 100);
  static const Duration glow = Duration(milliseconds: 1500);
  static const Duration bounce = Duration(milliseconds: 500);
}

/// Animation curves
class AnimationCurves {
  static const Curve diceRoll = Curves.elasticOut;
  static const Curve tokenHop = Curves.bounceOut;
  static const Curve dialogAppear = Curves.easeOutBack;
  static const Curve buttonPress = Curves.easeIn;
  static const Curve cashChange = Curves.easeOut;
}

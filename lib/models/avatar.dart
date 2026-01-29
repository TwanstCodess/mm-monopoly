import 'package:flutter/material.dart';

/// Avatar categories for organization
enum AvatarCategory {
  animals,
  food,
  objects,
  characters,
}

/// Avatar data model with visual properties and animations
class Avatar {
  final String id;
  final String name;
  final String emoji;
  final AvatarCategory category;
  final Color primaryColor;
  final Color secondaryColor;
  final IconData iconData;

  const Avatar({
    required this.id,
    required this.name,
    required this.emoji,
    required this.category,
    required this.primaryColor,
    required this.secondaryColor,
    required this.iconData,
  });

  /// Get gradient colors for avatar background
  List<Color> get gradientColors => [
        primaryColor.withOpacity(0.8),
        secondaryColor.withOpacity(0.9),
      ];
}

/// Built-in avatars configuration
class Avatars {
  // Animals
  static const dog = Avatar(
    id: 'dog',
    name: 'Buddy',
    emoji: '🐕',
    category: AvatarCategory.animals,
    primaryColor: Color(0xFF8D6E63),
    secondaryColor: Color(0xFFA1887F),
    iconData: Icons.pets,
  );

  static const cat = Avatar(
    id: 'cat',
    name: 'Whiskers',
    emoji: '🐱',
    category: AvatarCategory.animals,
    primaryColor: Color(0xFFFF9800),
    secondaryColor: Color(0xFFFFB74D),
    iconData: Icons.emoji_nature,
  );

  static const penguin = Avatar(
    id: 'penguin',
    name: 'Waddles',
    emoji: '🐧',
    category: AvatarCategory.animals,
    primaryColor: Color(0xFF37474F),
    secondaryColor: Color(0xFF546E7A),
    iconData: Icons.ac_unit,
  );

  static const bunny = Avatar(
    id: 'bunny',
    name: 'Hoppy',
    emoji: '🐰',
    category: AvatarCategory.animals,
    primaryColor: Color(0xFFE91E63),
    secondaryColor: Color(0xFFF48FB1),
    iconData: Icons.cruelty_free,
  );

  // Food
  static const pizza = Avatar(
    id: 'pizza',
    name: 'Peppy',
    emoji: '🍕',
    category: AvatarCategory.food,
    primaryColor: Color(0xFFFF5722),
    secondaryColor: Color(0xFFFFCC80),
    iconData: Icons.local_pizza,
  );

  static const donut = Avatar(
    id: 'donut',
    name: 'Sprinkles',
    emoji: '🍩',
    category: AvatarCategory.food,
    primaryColor: Color(0xFFE91E63),
    secondaryColor: Color(0xFFF8BBD9),
    iconData: Icons.donut_large,
  );

  static const taco = Avatar(
    id: 'taco',
    name: 'Crunchy',
    emoji: '🌮',
    category: AvatarCategory.food,
    primaryColor: Color(0xFFFFC107),
    secondaryColor: Color(0xFF4CAF50),
    iconData: Icons.restaurant,
  );

  static const iceCream = Avatar(
    id: 'ice_cream',
    name: 'Scoops',
    emoji: '🍦',
    category: AvatarCategory.food,
    primaryColor: Color(0xFFF8BBD9),
    secondaryColor: Color(0xFF81D4FA),
    iconData: Icons.icecream,
  );

  // Objects
  static const rocket = Avatar(
    id: 'rocket',
    name: 'Blaze',
    emoji: '🚀',
    category: AvatarCategory.objects,
    primaryColor: Color(0xFF3F51B5),
    secondaryColor: Color(0xFFFF5722),
    iconData: Icons.rocket_launch,
  );

  static const star = Avatar(
    id: 'star',
    name: 'Twinkle',
    emoji: '⭐',
    category: AvatarCategory.objects,
    primaryColor: Color(0xFFFFC107),
    secondaryColor: Color(0xFFFFEB3B),
    iconData: Icons.star,
  );

  static const crown = Avatar(
    id: 'crown',
    name: 'Royal',
    emoji: '👑',
    category: AvatarCategory.objects,
    primaryColor: Color(0xFFFFD700),
    secondaryColor: Color(0xFFFFA000),
    iconData: Icons.workspace_premium,
  );

  static const diamond = Avatar(
    id: 'diamond',
    name: 'Sparkle',
    emoji: '💎',
    category: AvatarCategory.objects,
    primaryColor: Color(0xFF00BCD4),
    secondaryColor: Color(0xFF4DD0E1),
    iconData: Icons.diamond,
  );

  // Characters
  static const robot = Avatar(
    id: 'robot',
    name: 'Beep',
    emoji: '🤖',
    category: AvatarCategory.characters,
    primaryColor: Color(0xFF607D8B),
    secondaryColor: Color(0xFF90A4AE),
    iconData: Icons.smart_toy,
  );

  static const alien = Avatar(
    id: 'alien',
    name: 'Zorp',
    emoji: '👽',
    category: AvatarCategory.characters,
    primaryColor: Color(0xFF4CAF50),
    secondaryColor: Color(0xFF81C784),
    iconData: Icons.face_retouching_natural,
  );

  static const ninja = Avatar(
    id: 'ninja',
    name: 'Shadow',
    emoji: '🥷',
    category: AvatarCategory.characters,
    primaryColor: Color(0xFF212121),
    secondaryColor: Color(0xFF424242),
    iconData: Icons.sports_martial_arts,
  );

  static const superhero = Avatar(
    id: 'superhero',
    name: 'Captain',
    emoji: '🦸',
    category: AvatarCategory.characters,
    primaryColor: Color(0xFFD32F2F),
    secondaryColor: Color(0xFF1976D2),
    iconData: Icons.flash_on,
  );

  /// All available avatars
  static const List<Avatar> all = [
    // Animals
    dog,
    cat,
    penguin,
    bunny,
    // Food
    pizza,
    donut,
    taco,
    iceCream,
    // Objects
    rocket,
    star,
    crown,
    diamond,
    // Characters
    robot,
    alien,
    ninja,
    superhero,
  ];

  /// Get avatars by category
  static List<Avatar> byCategory(AvatarCategory category) {
    return all.where((a) => a.category == category).toList();
  }

  /// Get avatar by ID
  static Avatar? byId(String id) {
    try {
      return all.firstWhere((a) => a.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Get default avatar for player index
  static Avatar forPlayerIndex(int index) {
    return all[index % all.length];
  }
}

/// Extension to get category display name
extension AvatarCategoryExt on AvatarCategory {
  String get displayName {
    switch (this) {
      case AvatarCategory.animals:
        return 'Animals';
      case AvatarCategory.food:
        return 'Food';
      case AvatarCategory.objects:
        return 'Objects';
      case AvatarCategory.characters:
        return 'Characters';
    }
  }

  IconData get icon {
    switch (this) {
      case AvatarCategory.animals:
        return Icons.pets;
      case AvatarCategory.food:
        return Icons.restaurant;
      case AvatarCategory.objects:
        return Icons.category;
      case AvatarCategory.characters:
        return Icons.face;
    }
  }
}

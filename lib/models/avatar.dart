import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

/// Avatar categories for organization
enum AvatarCategory {
  animals,
  food,
  objects,
  characters,
  custom, // For camera-captured photos
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
  final String? customImagePath; // For photo avatars

  const Avatar({
    required this.id,
    required this.name,
    required this.emoji,
    required this.category,
    required this.primaryColor,
    required this.secondaryColor,
    required this.iconData,
    this.customImagePath,
  });

  /// Check if this is a custom photo avatar
  bool get isCustom => customImagePath != null;

  /// Get gradient colors for avatar background
  List<Color> get gradientColors => [
        primaryColor.withOpacity(0.8),
        secondaryColor.withOpacity(0.9),
      ];

  /// Create a custom photo avatar
  factory Avatar.custom({
    required String id,
    required String name,
    required String imagePath,
  }) {
    return Avatar(
      id: id,
      name: name,
      emoji: '', // Not used for custom avatars
      category: AvatarCategory.custom,
      primaryColor: const Color(0xFF9C27B0),
      secondaryColor: const Color(0xFFE040FB),
      iconData: Icons.person,
      customImagePath: imagePath,
    );
  }
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

  static const lion = Avatar(
    id: 'lion',
    name: 'Roary',
    emoji: '🦁',
    category: AvatarCategory.animals,
    primaryColor: Color(0xFFFF9800),
    secondaryColor: Color(0xFFFFE0B2),
    iconData: Icons.pets,
  );

  static const unicorn = Avatar(
    id: 'unicorn',
    name: 'Sparkle',
    emoji: '🦄',
    category: AvatarCategory.animals,
    primaryColor: Color(0xFFE040FB),
    secondaryColor: Color(0xFFEA80FC),
    iconData: Icons.auto_awesome,
  );

  static const panda = Avatar(
    id: 'panda',
    name: 'Bamboo',
    emoji: '🐼',
    category: AvatarCategory.animals,
    primaryColor: Color(0xFF424242),
    secondaryColor: Color(0xFFEEEEEE),
    iconData: Icons.forest,
  );

  static const fox = Avatar(
    id: 'fox',
    name: 'Foxy',
    emoji: '🦊',
    category: AvatarCategory.animals,
    primaryColor: Color(0xFFFF5722),
    secondaryColor: Color(0xFFFFCCBC),
    iconData: Icons.nature,
  );

  static const owl = Avatar(
    id: 'owl',
    name: 'Hooty',
    emoji: '🦉',
    category: AvatarCategory.animals,
    primaryColor: Color(0xFF795548),
    secondaryColor: Color(0xFFBCAAA4),
    iconData: Icons.nightlight,
  );

  static const dragon = Avatar(
    id: 'dragon',
    name: 'Blaze',
    emoji: '🐉',
    category: AvatarCategory.animals,
    primaryColor: Color(0xFF4CAF50),
    secondaryColor: Color(0xFFFF5722),
    iconData: Icons.whatshot,
  );

  static const butterfly = Avatar(
    id: 'butterfly',
    name: 'Flutter',
    emoji: '🦋',
    category: AvatarCategory.animals,
    primaryColor: Color(0xFF2196F3),
    secondaryColor: Color(0xFFE040FB),
    iconData: Icons.flutter_dash,
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

  static const cupcake = Avatar(
    id: 'cupcake',
    name: 'Frosting',
    emoji: '🧁',
    category: AvatarCategory.food,
    primaryColor: Color(0xFFFF4081),
    secondaryColor: Color(0xFFFCE4EC),
    iconData: Icons.cake,
  );

  static const cookie = Avatar(
    id: 'cookie',
    name: 'Chips',
    emoji: '🍪',
    category: AvatarCategory.food,
    primaryColor: Color(0xFF8D6E63),
    secondaryColor: Color(0xFFD7CCC8),
    iconData: Icons.cookie,
  );

  static const watermelon = Avatar(
    id: 'watermelon',
    name: 'Melon',
    emoji: '🍉',
    category: AvatarCategory.food,
    primaryColor: Color(0xFFE91E63),
    secondaryColor: Color(0xFF4CAF50),
    iconData: Icons.eco,
  );

  static const burger = Avatar(
    id: 'burger',
    name: 'Patty',
    emoji: '🍔',
    category: AvatarCategory.food,
    primaryColor: Color(0xFF8D6E63),
    secondaryColor: Color(0xFFFFC107),
    iconData: Icons.lunch_dining,
  );

  static const hotdog = Avatar(
    id: 'hotdog',
    name: 'Frank',
    emoji: '🌭',
    category: AvatarCategory.food,
    primaryColor: Color(0xFFFF5722),
    secondaryColor: Color(0xFFFFEB3B),
    iconData: Icons.fastfood,
  );

  static const candy = Avatar(
    id: 'candy',
    name: 'Sweetie',
    emoji: '🍬',
    category: AvatarCategory.food,
    primaryColor: Color(0xFFFF1744),
    secondaryColor: Color(0xFF76FF03),
    iconData: Icons.celebration,
  );

  static const popcorn = Avatar(
    id: 'popcorn',
    name: 'Poppy',
    emoji: '🍿',
    category: AvatarCategory.food,
    primaryColor: Color(0xFFFFEB3B),
    secondaryColor: Color(0xFFF44336),
    iconData: Icons.movie,
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
    name: 'Gem',
    emoji: '💎',
    category: AvatarCategory.objects,
    primaryColor: Color(0xFF00BCD4),
    secondaryColor: Color(0xFF4DD0E1),
    iconData: Icons.diamond,
  );

  static const rainbow = Avatar(
    id: 'rainbow',
    name: 'Prisma',
    emoji: '🌈',
    category: AvatarCategory.objects,
    primaryColor: Color(0xFFE91E63),
    secondaryColor: Color(0xFF2196F3),
    iconData: Icons.wb_sunny,
  );

  static const moon = Avatar(
    id: 'moon',
    name: 'Luna',
    emoji: '🌙',
    category: AvatarCategory.objects,
    primaryColor: Color(0xFF7C4DFF),
    secondaryColor: Color(0xFFB388FF),
    iconData: Icons.nightlight_round,
  );

  static const heart = Avatar(
    id: 'heart',
    name: 'Lovey',
    emoji: '❤️',
    category: AvatarCategory.objects,
    primaryColor: Color(0xFFE91E63),
    secondaryColor: Color(0xFFF48FB1),
    iconData: Icons.favorite,
  );

  static const fire = Avatar(
    id: 'fire',
    name: 'Blaze',
    emoji: '🔥',
    category: AvatarCategory.objects,
    primaryColor: Color(0xFFFF5722),
    secondaryColor: Color(0xFFFFEB3B),
    iconData: Icons.local_fire_department,
  );

  static const bolt = Avatar(
    id: 'bolt',
    name: 'Sparky',
    emoji: '⚡',
    category: AvatarCategory.objects,
    primaryColor: Color(0xFFFFEB3B),
    secondaryColor: Color(0xFFFF9800),
    iconData: Icons.bolt,
  );

  static const gameController = Avatar(
    id: 'gamepad',
    name: 'Player',
    emoji: '🎮',
    category: AvatarCategory.objects,
    primaryColor: Color(0xFF673AB7),
    secondaryColor: Color(0xFF9575CD),
    iconData: Icons.sports_esports,
  );

  static const trophy = Avatar(
    id: 'trophy',
    name: 'Champ',
    emoji: '🏆',
    category: AvatarCategory.objects,
    primaryColor: Color(0xFFFFD700),
    secondaryColor: Color(0xFFFFC107),
    iconData: Icons.emoji_events,
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

  static const wizard = Avatar(
    id: 'wizard',
    name: 'Merlin',
    emoji: '🧙',
    category: AvatarCategory.characters,
    primaryColor: Color(0xFF673AB7),
    secondaryColor: Color(0xFF9C27B0),
    iconData: Icons.auto_fix_high,
  );

  static const fairy = Avatar(
    id: 'fairy',
    name: 'Pixie',
    emoji: '🧚',
    category: AvatarCategory.characters,
    primaryColor: Color(0xFFE91E63),
    secondaryColor: Color(0xFFE040FB),
    iconData: Icons.auto_awesome,
  );

  static const pirate = Avatar(
    id: 'pirate',
    name: 'Blackbeard',
    emoji: '🏴‍☠️',
    category: AvatarCategory.characters,
    primaryColor: Color(0xFF212121),
    secondaryColor: Color(0xFFFFD700),
    iconData: Icons.anchor,
  );

  static const astronaut = Avatar(
    id: 'astronaut',
    name: 'Cosmo',
    emoji: '👨‍🚀',
    category: AvatarCategory.characters,
    primaryColor: Color(0xFF1976D2),
    secondaryColor: Color(0xFFFFFFFF),
    iconData: Icons.rocket,
  );

  static const princess = Avatar(
    id: 'princess',
    name: 'Aurora',
    emoji: '👸',
    category: AvatarCategory.characters,
    primaryColor: Color(0xFFE91E63),
    secondaryColor: Color(0xFFFFD700),
    iconData: Icons.auto_awesome,
  );

  static const vampire = Avatar(
    id: 'vampire',
    name: 'Drac',
    emoji: '🧛',
    category: AvatarCategory.characters,
    primaryColor: Color(0xFF6A1B9A),
    secondaryColor: Color(0xFFD32F2F),
    iconData: Icons.nights_stay,
  );

  static const clown = Avatar(
    id: 'clown',
    name: 'Giggles',
    emoji: '🤡',
    category: AvatarCategory.characters,
    primaryColor: Color(0xFFFF5722),
    secondaryColor: Color(0xFFFFEB3B),
    iconData: Icons.sentiment_very_satisfied,
  );

  /// All available avatars
  static const List<Avatar> all = [
    // Animals (12)
    dog,
    cat,
    penguin,
    bunny,
    lion,
    unicorn,
    panda,
    fox,
    owl,
    dragon,
    butterfly,
    // Food (12)
    pizza,
    donut,
    taco,
    iceCream,
    cupcake,
    cookie,
    watermelon,
    burger,
    hotdog,
    candy,
    popcorn,
    // Objects (12)
    rocket,
    star,
    crown,
    diamond,
    rainbow,
    moon,
    heart,
    fire,
    bolt,
    gameController,
    trophy,
    // Characters (12)
    robot,
    alien,
    ninja,
    superhero,
    wizard,
    fairy,
    pirate,
    astronaut,
    princess,
    vampire,
    clown,
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
  String localizedDisplayName(AppLocalizations l10n) {
    switch (this) {
      case AvatarCategory.animals:
        return l10n.avatarCategoryAnimals;
      case AvatarCategory.food:
        return l10n.avatarCategoryFood;
      case AvatarCategory.objects:
        return l10n.avatarCategoryObjects;
      case AvatarCategory.characters:
        return l10n.avatarCategoryCharacters;
      case AvatarCategory.custom:
        return l10n.avatarCategoryMyPhotos;
    }
  }

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
      case AvatarCategory.custom:
        return 'My Photos';
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
      case AvatarCategory.custom:
        return Icons.camera_alt;
    }
  }
}

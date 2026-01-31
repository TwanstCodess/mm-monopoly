import 'package:flutter/material.dart';

/// Types of unlockable content
enum UnlockableType {
  boardTheme,
  tokenSet,
  avatar,
  cardBack,
  soundPack,
  diceSkin,
}

/// Unlock method - how can this item be obtained
enum UnlockMethod {
  free, // Available by default
  adsOnly, // Can only be unlocked by watching ads
  purchaseOnly, // Can only be purchased
  adsOrPurchase, // Can be unlocked either way
  achievement, // Unlocked by completing achievements
}

/// Represents an unlockable item in the shop
class Unlockable {
  final String id;
  final String name;
  final String description;
  final UnlockableType type;
  final UnlockMethod method;
  final int adsRequired; // Number of ads to watch to unlock
  final double price; // Price in USD (0 if not purchasable)
  final String? previewAsset; // Asset path for preview image
  final IconData? previewIcon; // Icon for preview if no asset
  final Color? previewColor; // Color for preview background
  final Map<String, dynamic>? metadata; // Additional type-specific data

  const Unlockable({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.method,
    this.adsRequired = 0,
    this.price = 0,
    this.previewAsset,
    this.previewIcon,
    this.previewColor,
    this.metadata,
  });

  /// Check if this item can be unlocked via ads
  bool get canUnlockWithAds =>
      method == UnlockMethod.adsOnly || method == UnlockMethod.adsOrPurchase;

  /// Check if this item can be purchased
  bool get canPurchase =>
      method == UnlockMethod.purchaseOnly || method == UnlockMethod.adsOrPurchase;

  /// Check if this item is free
  bool get isFree => method == UnlockMethod.free;

  /// Get formatted price string
  String get priceString => price > 0 ? '\$${price.toStringAsFixed(2)}' : 'Free';

  /// Get progress text (e.g., "2/5 ads")
  String getProgressText(int adsWatched) {
    if (!canUnlockWithAds || adsRequired == 0) return '';
    return '$adsWatched/$adsRequired ads';
  }

  /// Check if unlocked via ads based on watch count
  bool isUnlockedViaAds(int adsWatched) {
    if (!canUnlockWithAds) return false;
    return adsWatched >= adsRequired;
  }

  /// Get progress percentage (0.0 to 1.0)
  double getProgress(int adsWatched) {
    if (!canUnlockWithAds || adsRequired == 0) return 0;
    return (adsWatched / adsRequired).clamp(0.0, 1.0);
  }
}

/// Extension for UnlockableType display properties
extension UnlockableTypeExt on UnlockableType {
  String get displayName {
    switch (this) {
      case UnlockableType.boardTheme:
        return 'Board Themes';
      case UnlockableType.tokenSet:
        return 'Token Sets';
      case UnlockableType.avatar:
        return 'Avatars';
      case UnlockableType.cardBack:
        return 'Card Backs';
      case UnlockableType.soundPack:
        return 'Sound Packs';
      case UnlockableType.diceSkin:
        return 'Dice Skins';
    }
  }

  IconData get icon {
    switch (this) {
      case UnlockableType.boardTheme:
        return Icons.dashboard;
      case UnlockableType.tokenSet:
        return Icons.extension;
      case UnlockableType.avatar:
        return Icons.face;
      case UnlockableType.cardBack:
        return Icons.style;
      case UnlockableType.soundPack:
        return Icons.music_note;
      case UnlockableType.diceSkin:
        return Icons.casino;
    }
  }

  String get singularName {
    switch (this) {
      case UnlockableType.boardTheme:
        return 'Theme';
      case UnlockableType.tokenSet:
        return 'Token Set';
      case UnlockableType.avatar:
        return 'Avatar';
      case UnlockableType.cardBack:
        return 'Card Back';
      case UnlockableType.soundPack:
        return 'Sound Pack';
      case UnlockableType.diceSkin:
        return 'Dice Skin';
    }
  }
}

/// Catalog of all unlockable items
class UnlockableCatalog {
  // ============ BOARD THEMES ============
  static const classicTheme = Unlockable(
    id: 'theme_classic',
    name: 'Classic',
    description: 'The traditional board game look',
    type: UnlockableType.boardTheme,
    method: UnlockMethod.free,
    previewIcon: Icons.grid_view,
    previewColor: Color(0xFFC8E6C9),
    metadata: {'themeId': 'classic'},
  );

  static const neonTheme = Unlockable(
    id: 'theme_neon',
    name: 'Neon Nights',
    description: 'Glowing cyberpunk vibes with pulsing neon lights',
    type: UnlockableType.boardTheme,
    method: UnlockMethod.adsOrPurchase,
    adsRequired: 5,
    price: 0.99,
    previewIcon: Icons.nightlife,
    previewColor: Color(0xFF0D0D2B),
    metadata: {'themeId': 'neon'},
  );

  static const beachTheme = Unlockable(
    id: 'theme_beach',
    name: 'Beach Paradise',
    description: 'Sandy shores and ocean vibes',
    type: UnlockableType.boardTheme,
    method: UnlockMethod.adsOrPurchase,
    adsRequired: 3,
    price: 0.99,
    previewIcon: Icons.beach_access,
    previewColor: Color(0xFFF5DEB3),
    metadata: {'themeId': 'beach'},
  );

  static const spaceTheme = Unlockable(
    id: 'theme_space',
    name: 'Cosmic Voyage',
    description: 'Journey through the stars and galaxies',
    type: UnlockableType.boardTheme,
    method: UnlockMethod.adsOrPurchase,
    adsRequired: 5,
    price: 0.99,
    previewIcon: Icons.rocket_launch,
    previewColor: Color(0xFF0D0D2B),
    metadata: {'themeId': 'space'},
  );

  static const candyTheme = Unlockable(
    id: 'theme_candy',
    name: 'Candy Land',
    description: 'Sweet and colorful sugar rush!',
    type: UnlockableType.boardTheme,
    method: UnlockMethod.adsOrPurchase,
    adsRequired: 4,
    price: 0.99,
    previewIcon: Icons.cake,
    previewColor: Color(0xFFFFE4EC),
    metadata: {'themeId': 'candy'},
  );

  static const halloweenTheme = Unlockable(
    id: 'theme_halloween',
    name: 'Spooky Season',
    description: 'Haunted mansion vibes with a spooky twist',
    type: UnlockableType.boardTheme,
    method: UnlockMethod.adsOrPurchase,
    adsRequired: 5,
    price: 1.49,
    previewIcon: Icons.celebration,
    previewColor: Color(0xFF1A0A0A),
    metadata: {'themeId': 'halloween'},
  );

  static const winterTheme = Unlockable(
    id: 'theme_winter',
    name: 'Winter Wonderland',
    description: 'Cozy snowy vibes with holiday cheer',
    type: UnlockableType.boardTheme,
    method: UnlockMethod.adsOrPurchase,
    adsRequired: 5,
    price: 1.49,
    previewIcon: Icons.ac_unit,
    previewColor: Color(0xFFE8F4F8),
    metadata: {'themeId': 'winter'},
  );

  // ============ TOKEN SETS ============
  static const classicTokens = Unlockable(
    id: 'tokens_classic',
    name: 'Classic Pawns',
    description: 'Traditional chess-style game pieces',
    type: UnlockableType.tokenSet,
    method: UnlockMethod.free,
    previewIcon: Icons.person,
    previewColor: Color(0xFF795548),
  );

  static const goldTokens = Unlockable(
    id: 'tokens_gold',
    name: 'Golden Luxury',
    description: 'Shimmering gold-plated pieces for high rollers',
    type: UnlockableType.tokenSet,
    method: UnlockMethod.adsOrPurchase,
    adsRequired: 3,
    price: 0.99,
    previewIcon: Icons.star,
    previewColor: Color(0xFFFFD700),
  );

  static const animalTokens = Unlockable(
    id: 'tokens_animals',
    name: 'Animal Kingdom',
    description: 'Cute animal-shaped game pieces',
    type: UnlockableType.tokenSet,
    method: UnlockMethod.adsOrPurchase,
    adsRequired: 3,
    price: 0.99,
    previewIcon: Icons.pets,
    previewColor: Color(0xFF8D6E63),
  );

  static const emojiTokens = Unlockable(
    id: 'tokens_emoji',
    name: 'Emoji Faces',
    description: 'Express yourself with fun emoji tokens',
    type: UnlockableType.tokenSet,
    method: UnlockMethod.adsOrPurchase,
    adsRequired: 3,
    price: 0.99,
    previewIcon: Icons.emoji_emotions,
    previewColor: Color(0xFFFFEB3B),
  );

  static const crystalTokens = Unlockable(
    id: 'tokens_crystal',
    name: 'Crystal Gems',
    description: 'Sparkling gemstone pieces',
    type: UnlockableType.tokenSet,
    method: UnlockMethod.adsOrPurchase,
    adsRequired: 4,
    price: 1.49,
    previewIcon: Icons.diamond,
    previewColor: Color(0xFF00BCD4),
  );

  // ============ DICE SKINS ============
  static const classicDice = Unlockable(
    id: 'dice_classic',
    name: 'Classic White',
    description: 'Traditional white dice with black dots',
    type: UnlockableType.diceSkin,
    method: UnlockMethod.free,
    previewIcon: Icons.casino,
    previewColor: Color(0xFFFFFFFF),
  );

  static const fireDice = Unlockable(
    id: 'dice_fire',
    name: 'Inferno',
    description: 'Blazing dice with flame effects',
    type: UnlockableType.diceSkin,
    method: UnlockMethod.adsOrPurchase,
    adsRequired: 2,
    price: 0.49,
    previewIcon: Icons.local_fire_department,
    previewColor: Color(0xFFFF5722),
  );

  static const iceDice = Unlockable(
    id: 'dice_ice',
    name: 'Frozen',
    description: 'Icy blue dice that shimmer like frost',
    type: UnlockableType.diceSkin,
    method: UnlockMethod.adsOrPurchase,
    adsRequired: 2,
    price: 0.49,
    previewIcon: Icons.ac_unit,
    previewColor: Color(0xFF03A9F4),
  );

  static const galaxyDice = Unlockable(
    id: 'dice_galaxy',
    name: 'Galaxy Swirl',
    description: 'Mesmerizing cosmic patterns',
    type: UnlockableType.diceSkin,
    method: UnlockMethod.adsOrPurchase,
    adsRequired: 3,
    price: 0.99,
    previewIcon: Icons.blur_circular,
    previewColor: Color(0xFF673AB7),
  );

  static const goldDice = Unlockable(
    id: 'dice_gold',
    name: 'Solid Gold',
    description: 'Luxurious golden dice for winners',
    type: UnlockableType.diceSkin,
    method: UnlockMethod.adsOrPurchase,
    adsRequired: 4,
    price: 1.49,
    previewIcon: Icons.casino,
    previewColor: Color(0xFFFFD700),
  );

  // ============ CARD BACKS ============
  static const classicCards = Unlockable(
    id: 'cards_classic',
    name: 'Classic',
    description: 'Traditional card back design',
    type: UnlockableType.cardBack,
    method: UnlockMethod.free,
    previewIcon: Icons.style,
    previewColor: Color(0xFF1565C0),
  );

  static const ornateCards = Unlockable(
    id: 'cards_ornate',
    name: 'Royal Ornate',
    description: 'Elegant Victorian-style patterns',
    type: UnlockableType.cardBack,
    method: UnlockMethod.adsOrPurchase,
    adsRequired: 2,
    price: 0.49,
    previewIcon: Icons.style,
    previewColor: Color(0xFF8D6E63),
  );

  static const neonCards = Unlockable(
    id: 'cards_neon',
    name: 'Neon Glow',
    description: 'Glowing cyberpunk card backs',
    type: UnlockableType.cardBack,
    method: UnlockMethod.adsOrPurchase,
    adsRequired: 2,
    price: 0.49,
    previewIcon: Icons.style,
    previewColor: Color(0xFFE040FB),
  );

  // ============ SOUND PACKS ============
  static const classicSounds = Unlockable(
    id: 'sounds_classic',
    name: 'Classic',
    description: 'Traditional board game sounds',
    type: UnlockableType.soundPack,
    method: UnlockMethod.free,
    previewIcon: Icons.music_note,
    previewColor: Color(0xFF4CAF50),
  );

  static const retroSounds = Unlockable(
    id: 'sounds_retro',
    name: 'Retro Arcade',
    description: '8-bit chiptune sound effects',
    type: UnlockableType.soundPack,
    method: UnlockMethod.adsOrPurchase,
    adsRequired: 4,
    price: 1.49,
    previewIcon: Icons.gamepad,
    previewColor: Color(0xFFFF5722),
  );

  static const chillSounds = Unlockable(
    id: 'sounds_chill',
    name: 'Chill Lofi',
    description: 'Relaxing lofi beats and soft sounds',
    type: UnlockableType.soundPack,
    method: UnlockMethod.adsOrPurchase,
    adsRequired: 5,
    price: 1.49,
    previewIcon: Icons.headphones,
    previewColor: Color(0xFF9C27B0),
  );

  /// All unlockables
  static const List<Unlockable> all = [
    // Themes
    classicTheme,
    neonTheme,
    beachTheme,
    spaceTheme,
    candyTheme,
    halloweenTheme,
    winterTheme,
    // Tokens
    classicTokens,
    goldTokens,
    animalTokens,
    emojiTokens,
    crystalTokens,
    // Dice
    classicDice,
    fireDice,
    iceDice,
    galaxyDice,
    goldDice,
    // Cards
    classicCards,
    ornateCards,
    neonCards,
    // Sounds
    classicSounds,
    retroSounds,
    chillSounds,
  ];

  /// Get all unlockables by type
  static List<Unlockable> byType(UnlockableType type) {
    return all.where((u) => u.type == type).toList();
  }

  /// Get unlockable by ID
  static Unlockable? byId(String id) {
    try {
      return all.firstWhere((u) => u.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Get all board themes
  static List<Unlockable> get themes => byType(UnlockableType.boardTheme);

  /// Get all token sets
  static List<Unlockable> get tokens => byType(UnlockableType.tokenSet);

  /// Get all dice skins
  static List<Unlockable> get dice => byType(UnlockableType.diceSkin);

  /// Get all card backs
  static List<Unlockable> get cards => byType(UnlockableType.cardBack);

  /// Get all sound packs
  static List<Unlockable> get sounds => byType(UnlockableType.soundPack);
}

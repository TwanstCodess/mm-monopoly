import 'package:flutter/material.dart';
import 'serialization/serialization_helpers.dart';

/// Event card categories
enum EventCategory {
  positive,   // Benefits most/all players
  negative,   // Costs for most/all players
  neutral,    // Mixed effects
  chaotic,    // Random/fun effects
}

/// Types of event effects
enum EventEffectType {
  // Positive events
  marketBoom,       // Properties worth more
  taxHoliday,       // No taxes
  goldRush,         // Extra GO bonus
  propertySale,     // Discount on properties
  luckyDay,         // Everyone gets cash
  housingBoom,      // Free upgrade

  // Negative events
  rentStrike,       // Reduced rents
  meteorShower,     // Random player loses cash
  communityCleanup, // Pay per house

  // Neutral events
  stockDividend,    // Cash per property
  birthdayParty,    // Current player collects

  // Chaotic events
  bankError,        // Random bonus
  marketCrash,      // Property values swing
}

/// Extension for event category
extension EventCategoryExt on EventCategory {
  String get displayName {
    switch (this) {
      case EventCategory.positive:
        return 'Good News!';
      case EventCategory.negative:
        return 'Bad News!';
      case EventCategory.neutral:
        return 'News Flash!';
      case EventCategory.chaotic:
        return 'Wild Card!';
    }
  }

  Color get color {
    switch (this) {
      case EventCategory.positive:
        return Colors.green;
      case EventCategory.negative:
        return Colors.red;
      case EventCategory.neutral:
        return Colors.blue;
      case EventCategory.chaotic:
        return Colors.purple;
    }
  }

  IconData get icon {
    switch (this) {
      case EventCategory.positive:
        return Icons.celebration;
      case EventCategory.negative:
        return Icons.warning;
      case EventCategory.neutral:
        return Icons.newspaper;
      case EventCategory.chaotic:
        return Icons.auto_awesome;
    }
  }
}

/// An event card that affects all players
class EventCard {
  final String id;
  final String name;
  final String description;
  final EventEffectType effectType;
  final EventCategory category;
  final IconData icon;
  final int? duration; // Duration in rounds, null for instant
  final int? value;    // Cash value if applicable

  const EventCard({
    required this.id,
    required this.name,
    required this.description,
    required this.effectType,
    required this.category,
    required this.icon,
    this.duration,
    this.value,
  });

  /// Serialize to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'effectType': enumToJson(effectType),
      'category': enumToJson(category),
      'icon': icon.codePoint,
      'duration': duration,
      'value': value,
    };
  }

  /// Deserialize from JSON
  factory EventCard.fromJson(Map<String, dynamic> json) {
    return EventCard(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      effectType: enumFromJson(json['effectType'] as String, EventEffectType.values),
      category: enumFromJson(json['category'] as String, EventCategory.values),
      icon: IconData(json['icon'] as int, fontFamily: 'MaterialIcons'),
      duration: json['duration'] as int?,
      value: json['value'] as int?,
    );
  }
}

/// All available event cards
class EventCards {
  // Positive events (40%)
  static const marketBoom = EventCard(
    id: 'market_boom',
    name: 'Market Boom!',
    description: 'All properties are worth 20% more for 3 rounds!',
    effectType: EventEffectType.marketBoom,
    category: EventCategory.positive,
    icon: Icons.trending_up,
    duration: 3,
  );

  static const taxHoliday = EventCard(
    id: 'tax_holiday',
    name: 'Tax Holiday!',
    description: 'No taxes this round!',
    effectType: EventEffectType.taxHoliday,
    category: EventCategory.positive,
    icon: Icons.beach_access,
    duration: 1,
  );

  static const goldRush = EventCard(
    id: 'gold_rush',
    name: 'Gold Rush!',
    description: 'Collect \$300 instead of \$200 when passing GO for 3 rounds!',
    effectType: EventEffectType.goldRush,
    category: EventCategory.positive,
    icon: Icons.monetization_on,
    duration: 3,
    value: 100,
  );

  static const propertySale = EventCard(
    id: 'property_sale',
    name: 'Property Sale!',
    description: 'All unowned properties are 25% off for 2 rounds!',
    effectType: EventEffectType.propertySale,
    category: EventCategory.positive,
    icon: Icons.local_offer,
    duration: 2,
  );

  static const luckyDay = EventCard(
    id: 'lucky_day',
    name: 'Lucky Day!',
    description: 'Everyone receives \$50!',
    effectType: EventEffectType.luckyDay,
    category: EventCategory.positive,
    icon: Icons.stars,
    value: 50,
  );

  static const housingBoom = EventCard(
    id: 'housing_boom',
    name: 'Housing Boom!',
    description: 'Free upgrade on one random property!',
    effectType: EventEffectType.housingBoom,
    category: EventCategory.positive,
    icon: Icons.home,
  );

  // Negative events (20%)
  static const rentStrike = EventCard(
    id: 'rent_strike',
    name: 'Rent Strike!',
    description: 'All rents are reduced by 50% for 2 rounds.',
    effectType: EventEffectType.rentStrike,
    category: EventCategory.negative,
    icon: Icons.gavel,
    duration: 2,
  );

  static const meteorShower = EventCard(
    id: 'meteor_shower',
    name: 'Meteor Shower!',
    description: 'A random player loses \$100!',
    effectType: EventEffectType.meteorShower,
    category: EventCategory.negative,
    icon: Icons.bolt,
    value: 100,
  );

  static const communityCleanup = EventCard(
    id: 'community_cleanup',
    name: 'Community Clean-up',
    description: 'Pay \$25 for each house you own.',
    effectType: EventEffectType.communityCleanup,
    category: EventCategory.negative,
    icon: Icons.cleaning_services,
    value: 25,
  );

  // Neutral events (25%)
  static const stockDividend = EventCard(
    id: 'stock_dividend',
    name: 'Stock Dividend',
    description: 'Each player receives \$10 per property owned.',
    effectType: EventEffectType.stockDividend,
    category: EventCategory.neutral,
    icon: Icons.show_chart,
    value: 10,
  );

  static const birthdayParty = EventCard(
    id: 'birthday_party',
    name: 'Birthday Party!',
    description: 'Current player collects \$25 from each other player!',
    effectType: EventEffectType.birthdayParty,
    category: EventCategory.neutral,
    icon: Icons.cake,
    value: 25,
  );

  // Chaotic events (15%)
  static const bankError = EventCard(
    id: 'bank_error',
    name: 'Bank Error',
    description: 'A random player receives \$200!',
    effectType: EventEffectType.bankError,
    category: EventCategory.chaotic,
    icon: Icons.account_balance,
    value: 200,
  );

  static const marketCrash = EventCard(
    id: 'market_crash',
    name: 'Market Crash!',
    description: 'Property values fluctuate wildly! Random effects for everyone!',
    effectType: EventEffectType.marketCrash,
    category: EventCategory.chaotic,
    icon: Icons.trending_down,
  );

  /// All available events
  static const List<EventCard> all = [
    // Positive (40%)
    marketBoom,
    taxHoliday,
    goldRush,
    propertySale,
    luckyDay,
    housingBoom,
    // Negative (20%)
    rentStrike,
    meteorShower,
    communityCleanup,
    // Neutral (25%)
    stockDividend,
    birthdayParty,
    // Chaotic (15%)
    bankError,
    marketCrash,
  ];

  /// Get events by category
  static List<EventCard> byCategory(EventCategory category) {
    return all.where((e) => e.category == category).toList();
  }

  /// Get a random event with weighted probabilities
  static EventCard getRandomEvent() {
    final random = DateTime.now().millisecondsSinceEpoch % 100;

    EventCategory category;
    if (random < 40) {
      category = EventCategory.positive;
    } else if (random < 60) {
      category = EventCategory.negative;
    } else if (random < 85) {
      category = EventCategory.neutral;
    } else {
      category = EventCategory.chaotic;
    }

    final events = byCategory(category);
    return events[DateTime.now().millisecond % events.length];
  }

  /// Should trigger an event? (10% chance each round, guaranteed every 10 rounds)
  static bool shouldTriggerEvent(int roundNumber) {
    if (roundNumber % 10 == 0) return true;
    return (DateTime.now().millisecondsSinceEpoch % 10) == 0;
  }
}

/// Active event affecting the game
class ActiveEvent {
  final EventCard event;
  int remainingRounds;
  final DateTime activatedAt;

  ActiveEvent({
    required this.event,
    required this.remainingRounds,
  }) : activatedAt = DateTime.now();

  bool get isExpired => remainingRounds <= 0;
  bool get isInstant => event.duration == null;

  void decrementRound() {
    if (remainingRounds > 0) {
      remainingRounds--;
    }
  }

  /// Serialize to JSON
  Map<String, dynamic> toJson() {
    return {
      'event': event.toJson(),
      'remainingRounds': remainingRounds,
      'activatedAt': activatedAt.toIso8601String(),
    };
  }

  /// Deserialize from JSON
  factory ActiveEvent.fromJson(Map<String, dynamic> json) {
    final event = ActiveEvent(
      event: EventCard.fromJson(json['event'] as Map<String, dynamic>),
      remainingRounds: json['remainingRounds'] as int,
    );
    // Note: activatedAt is set in constructor, we can't override it
    return event;
  }
}

import 'package:flutter/material.dart';

/// Statistics for a player profile
class PlayerStats {
  final String id;
  final String name;
  final String? avatarId;

  // Game stats
  int gamesPlayed;
  int gamesWon;
  int totalEarnings;
  int totalPropertiesOwned;
  int totalRentCollected;
  int totalRentPaid;

  // Records
  int highestCash;
  int mostPropertiesInGame;
  int quickestWin; // In turns, 0 if never won
  int longestWinStreak;
  int currentWinStreak;

  // Dice stats
  int totalDiceRolls;
  int totalDiceSum;
  int doublesRolled;

  // Special achievement tracking
  bool wonWithLessThan100;

  // Achievements
  Set<String> unlockedAchievements;

  // Timestamps
  DateTime createdAt;
  DateTime? lastPlayedAt;

  PlayerStats({
    required this.id,
    required this.name,
    this.avatarId,
    this.gamesPlayed = 0,
    this.gamesWon = 0,
    this.totalEarnings = 0,
    this.totalPropertiesOwned = 0,
    this.totalRentCollected = 0,
    this.totalRentPaid = 0,
    this.highestCash = 0,
    this.mostPropertiesInGame = 0,
    this.quickestWin = 0,
    this.longestWinStreak = 0,
    this.currentWinStreak = 0,
    this.totalDiceRolls = 0,
    this.totalDiceSum = 0,
    this.doublesRolled = 0,
    this.wonWithLessThan100 = false,
    Set<String>? unlockedAchievements,
    DateTime? createdAt,
    this.lastPlayedAt,
  })  : unlockedAchievements = unlockedAchievements ?? {},
        createdAt = createdAt ?? DateTime.now();

  // Calculated stats
  double get winRate =>
      gamesPlayed > 0 ? (gamesWon / gamesPlayed * 100) : 0;

  double get averageDiceRoll =>
      totalDiceRolls > 0 ? (totalDiceSum / totalDiceRolls) : 0;

  int get averageEarningsPerGame =>
      gamesPlayed > 0 ? (totalEarnings ~/ gamesPlayed) : 0;

  /// Record a game result
  void recordGame({
    required bool won,
    required int finalCash,
    required int propertiesOwned,
    required int rentCollected,
    required int rentPaid,
    required int turns,
    required int diceRolls,
    required int diceSum,
    required int doubles,
  }) {
    gamesPlayed++;
    lastPlayedAt = DateTime.now();

    if (won) {
      gamesWon++;
      currentWinStreak++;
      if (currentWinStreak > longestWinStreak) {
        longestWinStreak = currentWinStreak;
      }
      if (quickestWin == 0 || turns < quickestWin) {
        quickestWin = turns;
      }
    } else {
      currentWinStreak = 0;
    }

    totalEarnings += finalCash;
    totalPropertiesOwned += propertiesOwned;
    totalRentCollected += rentCollected;
    totalRentPaid += rentPaid;

    if (finalCash > highestCash) {
      highestCash = finalCash;
    }
    if (propertiesOwned > mostPropertiesInGame) {
      mostPropertiesInGame = propertiesOwned;
    }

    totalDiceRolls += diceRolls;
    totalDiceSum += diceSum;
    doublesRolled += doubles;
  }

  /// Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatarId': avatarId,
      'gamesPlayed': gamesPlayed,
      'gamesWon': gamesWon,
      'totalEarnings': totalEarnings,
      'totalPropertiesOwned': totalPropertiesOwned,
      'totalRentCollected': totalRentCollected,
      'totalRentPaid': totalRentPaid,
      'highestCash': highestCash,
      'mostPropertiesInGame': mostPropertiesInGame,
      'quickestWin': quickestWin,
      'longestWinStreak': longestWinStreak,
      'currentWinStreak': currentWinStreak,
      'totalDiceRolls': totalDiceRolls,
      'totalDiceSum': totalDiceSum,
      'doublesRolled': doublesRolled,
      'wonWithLessThan100': wonWithLessThan100,
      'unlockedAchievements': unlockedAchievements.toList(),
      'createdAt': createdAt.toIso8601String(),
      'lastPlayedAt': lastPlayedAt?.toIso8601String(),
    };
  }

  /// Create from JSON
  factory PlayerStats.fromJson(Map<String, dynamic> json) {
    return PlayerStats(
      id: json['id'],
      name: json['name'],
      avatarId: json['avatarId'],
      gamesPlayed: json['gamesPlayed'] ?? 0,
      gamesWon: json['gamesWon'] ?? 0,
      totalEarnings: json['totalEarnings'] ?? 0,
      totalPropertiesOwned: json['totalPropertiesOwned'] ?? 0,
      totalRentCollected: json['totalRentCollected'] ?? 0,
      totalRentPaid: json['totalRentPaid'] ?? 0,
      highestCash: json['highestCash'] ?? 0,
      mostPropertiesInGame: json['mostPropertiesInGame'] ?? 0,
      quickestWin: json['quickestWin'] ?? 0,
      longestWinStreak: json['longestWinStreak'] ?? 0,
      currentWinStreak: json['currentWinStreak'] ?? 0,
      totalDiceRolls: json['totalDiceRolls'] ?? 0,
      totalDiceSum: json['totalDiceSum'] ?? 0,
      doublesRolled: json['doublesRolled'] ?? 0,
      wonWithLessThan100: json['wonWithLessThan100'] ?? false,
      unlockedAchievements:
          Set<String>.from(json['unlockedAchievements'] ?? []),
      createdAt: DateTime.parse(json['createdAt']),
      lastPlayedAt: json['lastPlayedAt'] != null
          ? DateTime.parse(json['lastPlayedAt'])
          : null,
    );
  }
}

/// Achievement definition
class Achievement {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final Color color;
  final bool Function(PlayerStats) checkUnlock;

  const Achievement({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    required this.checkUnlock,
  });
}

/// All available achievements
class Achievements {
  static final firstWin = Achievement(
    id: 'first_win',
    name: 'First Win',
    description: 'Win your first game',
    icon: Icons.emoji_events,
    color: Colors.amber,
    checkUnlock: (stats) => stats.gamesWon >= 1,
  );

  static final hatTrick = Achievement(
    id: 'hat_trick',
    name: 'Hat Trick',
    description: 'Win 3 games in a row',
    icon: Icons.looks_3,
    color: Colors.purple,
    checkUnlock: (stats) => stats.longestWinStreak >= 3,
  );

  static final monopolyMogul = Achievement(
    id: 'monopoly_mogul',
    name: 'Monopoly Mogul',
    description: 'Own 10+ properties in a single game',
    icon: Icons.business,
    color: Colors.green,
    checkUnlock: (stats) => stats.mostPropertiesInGame >= 10,
  );

  static final cashKing = Achievement(
    id: 'cash_king',
    name: 'Cash King',
    description: 'Have \$5000+ at once',
    icon: Icons.attach_money,
    color: const Color(0xFF4CAF50),
    checkUnlock: (stats) => stats.highestCash >= 5000,
  );

  static final survivor = Achievement(
    id: 'survivor',
    name: 'Survivor',
    description: 'Win a game with less than \$100 remaining',
    icon: Icons.shield,
    color: Colors.orange,
    checkUnlock: (stats) => stats.wonWithLessThan100,
  );

  static final luckySeven = Achievement(
    id: 'lucky_seven',
    name: 'Lucky Seven',
    description: 'Roll doubles 10 times total',
    icon: Icons.casino,
    color: Colors.red,
    checkUnlock: (stats) => stats.doublesRolled >= 10,
  );

  static final speedDemon = Achievement(
    id: 'speed_demon',
    name: 'Speed Demon',
    description: 'Win a game in under 30 turns',
    icon: Icons.speed,
    color: Colors.blue,
    checkUnlock: (stats) => stats.quickestWin > 0 && stats.quickestWin < 30,
  );

  static final veteran = Achievement(
    id: 'veteran',
    name: 'Veteran',
    description: 'Play 20 games',
    icon: Icons.military_tech,
    color: Colors.brown,
    checkUnlock: (stats) => stats.gamesPlayed >= 20,
  );

  static final List<Achievement> all = [
    firstWin,
    hatTrick,
    monopolyMogul,
    cashKing,
    survivor,
    luckySeven,
    speedDemon,
    veteran,
  ];

  /// Get achievement by ID
  static Achievement? byId(String id) {
    try {
      return all.firstWhere((a) => a.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Check for new achievements
  static List<Achievement> checkNewAchievements(PlayerStats stats) {
    final newAchievements = <Achievement>[];

    for (final achievement in all) {
      if (!stats.unlockedAchievements.contains(achievement.id) &&
          achievement.checkUnlock(stats)) {
        newAchievements.add(achievement);
        stats.unlockedAchievements.add(achievement.id);
      }
    }

    return newAchievements;
  }
}

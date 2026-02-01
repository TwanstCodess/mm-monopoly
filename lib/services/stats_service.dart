import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/player_stats.dart';
import '../models/player.dart';
import '../models/game_state.dart';
import '../models/tile.dart';

/// Service for persisting and loading player statistics
class StatsService {
  static const String _statsKey = 'player_stats';
  static StatsService? _instance;

  SharedPreferences? _prefs;
  Map<String, PlayerStats> _playerStats = {};

  StatsService._();

  /// Get singleton instance
  static StatsService get instance {
    _instance ??= StatsService._();
    return _instance!;
  }

  /// Initialize the service
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    await _loadStats();
  }

  /// Load stats from storage
  Future<void> _loadStats() async {
    final json = _prefs?.getString(_statsKey);
    if (json != null) {
      try {
        final Map<String, dynamic> data = jsonDecode(json);
        _playerStats = data.map(
          (key, value) => MapEntry(key, PlayerStats.fromJson(value)),
        );
      } catch (e) {
        _playerStats = {};
      }
    }
  }

  /// Save stats to storage
  Future<void> _saveStats() async {
    final json = jsonEncode(
      _playerStats.map((key, value) => MapEntry(key, value.toJson())),
    );
    await _prefs?.setString(_statsKey, json);
  }

  /// Get or create stats for a player by name
  PlayerStats getOrCreateStats(String playerName, {String? avatarId}) {
    final normalizedName = playerName.toLowerCase().trim();

    if (!_playerStats.containsKey(normalizedName)) {
      _playerStats[normalizedName] = PlayerStats(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: playerName,
        avatarId: avatarId,
      );
      _saveStats();
    }

    return _playerStats[normalizedName]!;
  }

  /// Get all player stats sorted by wins
  List<PlayerStats> getAllStatsSortedByWins() {
    final stats = _playerStats.values.toList();
    stats.sort((a, b) => b.gamesWon.compareTo(a.gamesWon));
    return stats;
  }

  /// Get all player stats sorted by total earnings
  List<PlayerStats> getAllStatsSortedByEarnings() {
    final stats = _playerStats.values.toList();
    stats.sort((a, b) => b.totalEarnings.compareTo(a.totalEarnings));
    return stats;
  }

  /// Get all player stats sorted by win rate
  List<PlayerStats> getAllStatsSortedByWinRate() {
    final stats = _playerStats.values.where((s) => s.gamesPlayed >= 3).toList();
    stats.sort((a, b) => b.winRate.compareTo(a.winRate));
    return stats;
  }

  /// Record a completed game
  Future<List<Achievement>> recordGameResult({
    required List<Player> players,
    required Player winner,
    required GameState gameState,
    required int totalRounds,
  }) async {
    final newAchievements = <Achievement>[];

    for (final player in players) {
      // Skip AI players for stats tracking
      if (player.isAI) continue;

      final stats = getOrCreateStats(
        player.name,
        avatarId: player.avatar?.id,
      );

      // Count properties owned
      int propertiesOwned = 0;
      int rentCollected = 0;
      int rentPaid = 0;

      for (final tile in gameState.tiles) {
        if (tile is PropertyTileData && tile.ownerId == player.id) {
          propertiesOwned++;
        } else if (tile is RailroadTileData && tile.ownerId == player.id) {
          propertiesOwned++;
        } else if (tile is UtilityTileData && tile.ownerId == player.id) {
          propertiesOwned++;
        }
      }

      final won = winner.id == player.id;

      // Track Survivor achievement (win with less than $100)
      if (won && player.cash < 100) {
        stats.wonWithLessThan100 = true;
      }

      // Record the game
      stats.recordGame(
        won: won,
        finalCash: player.cash,
        propertiesOwned: propertiesOwned,
        rentCollected: rentCollected, // Would need turn-by-turn tracking
        rentPaid: rentPaid, // Would need turn-by-turn tracking
        turns: totalRounds,
        diceRolls: gameState.totalDiceRolls ~/ players.length,
        diceSum: gameState.totalDiceSum ~/ players.length,
        doubles: gameState.doublesRolledTotal ~/ players.length,
      );

      // Check for new achievements
      final achievements = Achievements.checkNewAchievements(stats);
      newAchievements.addAll(achievements);
    }

    await _saveStats();
    return newAchievements;
  }

  /// Get top players for leaderboard
  List<PlayerStats> getTopPlayers({int limit = 10}) {
    return getAllStatsSortedByWins().take(limit).toList();
  }

  /// Get player stats by name
  PlayerStats? getStatsByName(String name) {
    final normalizedName = name.toLowerCase().trim();
    return _playerStats[normalizedName];
  }

  /// Clear all stats (for testing/reset)
  Future<void> clearAllStats() async {
    _playerStats.clear();
    await _prefs?.remove(_statsKey);
  }

  /// Get total games played across all players
  int get totalGamesPlayed {
    return _playerStats.values.fold(0, (sum, s) => sum + s.gamesPlayed);
  }

  /// Get unique player count
  int get uniquePlayerCount => _playerStats.length;
}

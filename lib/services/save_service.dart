import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/game_state.dart';

/// Service for saving and loading game state
class SaveService {
  static const String _saveKey = 'saved_game';
  static SaveService? _instance;
  SharedPreferences? _prefs;

  SaveService._();

  /// Get singleton instance
  static SaveService get instance {
    _instance ??= SaveService._();
    return _instance!;
  }

  /// Initialize the service (call this at app startup)
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Save the current game state
  Future<bool> saveGame(GameState state) async {
    try {
      final saveData = {
        'version': 1,
        'savedAt': DateTime.now().toIso8601String(),
        'gameState': state.toJson(),
        'metadata': {
          'playerNames': state.players.map((p) => p.name).toList(),
          'playerCount': state.players.length,
          'roundNumber': state.roundNumber,
          'currentPlayerIndex': state.currentPlayerIndex,
          'currentPlayerName': state.currentPlayer.name,
          'mode': state.mode.name,
          'winCondition': state.winCondition.name,
        },
      };

      final jsonString = jsonEncode(saveData);
      final success = await _prefs?.setString(_saveKey, jsonString) ?? false;

      if (success) {
        debugPrint('Game saved successfully');
      } else {
        debugPrint('Failed to save game');
      }

      return success;
    } catch (e, stackTrace) {
      debugPrint('Error saving game: $e');
      debugPrint('Stack trace: $stackTrace');
      return false;
    }
  }

  /// Load the saved game state
  Future<GameState?> loadGame() async {
    try {
      final jsonString = _prefs?.getString(_saveKey);
      if (jsonString == null) {
        debugPrint('No saved game found');
        return null;
      }

      final saveData = jsonDecode(jsonString) as Map<String, dynamic>;
      final version = saveData['version'] as int;

      if (version == 1) {
        final gameState = GameState.fromJson(saveData['gameState'] as Map<String, dynamic>);
        debugPrint('Game loaded successfully');
        return gameState;
      } else {
        debugPrint('Unsupported save version: $version');
        return null;
      }
    } catch (e, stackTrace) {
      debugPrint('Error loading game: $e');
      debugPrint('Stack trace: $stackTrace');
      return null;
    }
  }

  /// Delete the saved game
  Future<void> deleteSave() async {
    try {
      await _prefs?.remove(_saveKey);
      debugPrint('Save deleted');
    } catch (e) {
      debugPrint('Error deleting save: $e');
    }
  }

  /// Check if a saved game exists
  bool hasSavedGame() {
    return _prefs?.containsKey(_saveKey) ?? false;
  }

  /// Get metadata about the saved game without loading the full state
  Map<String, dynamic>? getSaveMetadata() {
    try {
      final jsonString = _prefs?.getString(_saveKey);
      if (jsonString == null) return null;

      final saveData = jsonDecode(jsonString) as Map<String, dynamic>;
      return {
        'savedAt': saveData['savedAt'],
        'metadata': saveData['metadata'],
      };
    } catch (e) {
      debugPrint('Error getting save metadata: $e');
      return null;
    }
  }

  /// Get formatted save date string
  String? getSaveDateString() {
    final metadata = getSaveMetadata();
    if (metadata == null) return null;

    try {
      final savedAt = DateTime.parse(metadata['savedAt'] as String);
      final now = DateTime.now();
      final difference = now.difference(savedAt);

      if (difference.inMinutes < 1) {
        return 'Just now';
      } else if (difference.inHours < 1) {
        return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
      } else if (difference.inDays < 1) {
        return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
      } else if (difference.inDays < 7) {
        return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
      } else {
        return '${savedAt.year}-${savedAt.month.toString().padLeft(2, '0')}-${savedAt.day.toString().padLeft(2, '0')}';
      }
    } catch (e) {
      return null;
    }
  }
}

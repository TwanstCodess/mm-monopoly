import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/unlockable.dart';

/// Service to manage unlock state for all unlockables
class UnlockService extends ChangeNotifier {
  static const String _prefsKey = 'unlock_state';
  
  // Map of unlockable ID -> number of ads watched
  Map<String, int> _adsWatched = {};
  
  // Set of purchased item IDs
  Set<String> _purchased = {};
  
  // Set of achievement-unlocked item IDs
  Set<String> _achievementUnlocked = {};
  
  bool _initialized = false;
  
  /// Singleton instance
  static final UnlockService _instance = UnlockService._internal();
  factory UnlockService() => _instance;
  UnlockService._internal();
  
  /// Initialize the service - call this at app startup
  Future<void> init() async {
    if (_initialized) return;
    
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_prefsKey);
    
    if (data != null) {
      try {
        final json = jsonDecode(data) as Map<String, dynamic>;
        _adsWatched = Map<String, int>.from(json['adsWatched'] ?? {});
        _purchased = Set<String>.from(json['purchased'] ?? []);
        _achievementUnlocked = Set<String>.from(json['achievementUnlocked'] ?? []);
      } catch (e) {
        debugPrint('Error loading unlock state: $e');
      }
    }
    
    _initialized = true;
    notifyListeners();
  }
  
  /// Save current state to persistent storage
  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    final data = jsonEncode({
      'adsWatched': _adsWatched,
      'purchased': _purchased.toList(),
      'achievementUnlocked': _achievementUnlocked.toList(),
    });
    await prefs.setString(_prefsKey, data);
  }
  
  /// Check if an unlockable is unlocked
  bool isUnlocked(Unlockable item) {
    // Free items are always unlocked
    if (item.isFree) return true;
    
    // Check if purchased
    if (_purchased.contains(item.id)) return true;
    
    // Check if achievement unlocked
    if (_achievementUnlocked.contains(item.id)) return true;
    
    // Check if unlocked via ads
    if (item.canUnlockWithAds) {
      final watched = _adsWatched[item.id] ?? 0;
      if (watched >= item.adsRequired) return true;
    }
    
    return false;
  }
  
  /// Check if an unlockable is unlocked by ID
  bool isUnlockedById(String id) {
    final item = UnlockableCatalog.byId(id);
    if (item == null) return false;
    return isUnlocked(item);
  }
  
  /// Get number of ads watched for an item
  int getAdsWatched(String itemId) {
    return _adsWatched[itemId] ?? 0;
  }
  
  /// Get progress (0.0 to 1.0) for an item
  double getProgress(Unlockable item) {
    if (isUnlocked(item)) return 1.0;
    return item.getProgress(getAdsWatched(item.id));
  }
  
  /// Record that an ad was watched for an item
  /// Returns true if this resulted in an unlock
  Future<bool> recordAdWatched(String itemId) async {
    final item = UnlockableCatalog.byId(itemId);
    if (item == null || !item.canUnlockWithAds) return false;
    
    // Already unlocked
    if (isUnlocked(item)) return false;
    
    // Increment ad count
    _adsWatched[itemId] = ((_adsWatched[itemId] ?? 0) + 1);
    
    await _save();
    notifyListeners();
    
    // Check if this caused an unlock
    return isUnlocked(item);
  }
  
  /// Record a purchase for an item
  Future<void> recordPurchase(String itemId) async {
    _purchased.add(itemId);
    await _save();
    notifyListeners();
  }
  
  /// Record an achievement unlock
  Future<void> recordAchievementUnlock(String itemId) async {
    _achievementUnlocked.add(itemId);
    await _save();
    notifyListeners();
  }
  
  /// Get all unlocked items of a specific type
  List<Unlockable> getUnlockedByType(UnlockableType type) {
    return UnlockableCatalog.byType(type)
        .where((item) => isUnlocked(item))
        .toList();
  }
  
  /// Get all locked items of a specific type
  List<Unlockable> getLockedByType(UnlockableType type) {
    return UnlockableCatalog.byType(type)
        .where((item) => !isUnlocked(item))
        .toList();
  }
  
  /// Get total number of unlocked items
  int get totalUnlocked {
    return UnlockableCatalog.all.where((item) => isUnlocked(item)).length;
  }
  
  /// Get total number of items
  int get totalItems => UnlockableCatalog.all.length;
  
  /// Reset all unlock progress (for testing)
  Future<void> resetAll() async {
    _adsWatched.clear();
    _purchased.clear();
    _achievementUnlocked.clear();
    await _save();
    notifyListeners();
  }
  
  /// Debug: Unlock everything (for testing)
  Future<void> unlockAll() async {
    for (final item in UnlockableCatalog.all) {
      if (!item.isFree) {
        _purchased.add(item.id);
      }
    }
    await _save();
    notifyListeners();
  }
}

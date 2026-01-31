import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Sound effect types used throughout the game
enum SfxType {
  diceRoll,
  diceHit,
  tokenMove,
  tokenLand,
  buyProperty,
  payMoney,
  collectMoney,
  cardDraw,
  cardFlip,
  jailDoor,
  passGo,
  victory,
  defeat,
  powerUp,
  spinWheel,
  spinResult,
  buttonTap,
  upgrade,
  auction,
  trade,
  notification,
}

/// Audio service singleton for managing all game audio
class AudioService {
  // Singleton pattern
  static final AudioService _instance = AudioService._internal();
  static AudioService get instance => _instance;
  AudioService._internal();

  // Audio players
  final AudioPlayer _bgmPlayer = AudioPlayer();
  final AudioPlayer _sfxPlayer = AudioPlayer();
  
  // Settings
  bool _musicEnabled = true;
  bool _sfxEnabled = true;
  double _musicVolume = 0.5;
  double _sfxVolume = 0.7;
  
  // State
  bool _initialized = false;
  String? _currentBgm;

  // Getters
  bool get musicEnabled => _musicEnabled;
  bool get sfxEnabled => _sfxEnabled;
  double get musicVolume => _musicVolume;
  double get sfxVolume => _sfxVolume;
  bool get isPlaying => _bgmPlayer.state == PlayerState.playing;

  /// Initialize the audio service and load saved preferences
  Future<void> init() async {
    if (_initialized) return;
    
    final prefs = await SharedPreferences.getInstance();
    _musicEnabled = prefs.getBool('audio_music_enabled') ?? true;
    _sfxEnabled = prefs.getBool('audio_sfx_enabled') ?? true;
    _musicVolume = prefs.getDouble('audio_music_volume') ?? 0.5;
    _sfxVolume = prefs.getDouble('audio_sfx_volume') ?? 0.7;
    
    // Configure players
    await _bgmPlayer.setReleaseMode(ReleaseMode.loop);
    await _bgmPlayer.setVolume(_musicVolume);
    await _sfxPlayer.setVolume(_sfxVolume);
    
    _initialized = true;
  }

  /// Save current settings to preferences
  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('audio_music_enabled', _musicEnabled);
    await prefs.setBool('audio_sfx_enabled', _sfxEnabled);
    await prefs.setDouble('audio_music_volume', _musicVolume);
    await prefs.setDouble('audio_sfx_volume', _sfxVolume);
  }

  // ============================================================================
  // Settings Control
  // ============================================================================

  /// Toggle background music on/off
  Future<void> setMusicEnabled(bool enabled) async {
    _musicEnabled = enabled;
    if (!enabled) {
      await _bgmPlayer.pause();
    } else if (_currentBgm != null) {
      await _bgmPlayer.resume();
    }
    await _saveSettings();
  }

  /// Toggle sound effects on/off
  Future<void> setSfxEnabled(bool enabled) async {
    _sfxEnabled = enabled;
    await _saveSettings();
  }

  /// Set background music volume (0.0 - 1.0)
  Future<void> setMusicVolume(double volume) async {
    _musicVolume = volume.clamp(0.0, 1.0);
    await _bgmPlayer.setVolume(_musicVolume);
    await _saveSettings();
  }

  /// Set sound effects volume (0.0 - 1.0)
  Future<void> setSfxVolume(double volume) async {
    _sfxVolume = volume.clamp(0.0, 1.0);
    await _sfxPlayer.setVolume(_sfxVolume);
    await _saveSettings();
  }

  // ============================================================================
  // Background Music
  // ============================================================================

  /// Play background music (loops automatically)
  Future<void> playBgm(String trackName) async {
    if (!_musicEnabled) {
      _currentBgm = trackName;
      return;
    }
    
    try {
      _currentBgm = trackName;
      await _bgmPlayer.play(AssetSource('audio/music/$trackName'));
    } catch (e) {
      // Audio file not found - silently fail
      print('BGM not found: $trackName');
    }
  }

  /// Play the main menu music
  Future<void> playMenuMusic() => playBgm('menu_theme.mp3');

  /// Available game music tracks
  static const List<String> _gameThemes = [
    'game_theme.mp3',
    'game_theme_2.mp3',
    'game_theme_3.mp3',
    'game_theme_4.mp3',
  ];
  
  static final Random _random = Random();

  /// Play the in-game music (randomly selected)
  Future<void> playGameMusic() {
    final randomTheme = _gameThemes[_random.nextInt(_gameThemes.length)];
    return playBgm(randomTheme);
  }

  /// Play victory music (one-shot, not looped)
  Future<void> playVictoryMusic() async {
    if (!_musicEnabled) return;
    await _bgmPlayer.setReleaseMode(ReleaseMode.stop);
    await playBgm('victory_theme.mp3');
    await _bgmPlayer.setReleaseMode(ReleaseMode.loop);
  }

  /// Stop background music
  Future<void> stopBgm() async {
    await _bgmPlayer.stop();
    _currentBgm = null;
  }

  /// Pause background music
  Future<void> pauseBgm() async {
    await _bgmPlayer.pause();
  }

  /// Resume background music
  Future<void> resumeBgm() async {
    if (_musicEnabled && _currentBgm != null) {
      await _bgmPlayer.resume();
    }
  }

  // ============================================================================
  // Sound Effects
  // ============================================================================

  /// Play a sound effect
  Future<void> playSfx(SfxType type) async {
    if (!_sfxEnabled) return;
    
    final filename = _getSfxFilename(type);
    if (filename == null) return;
    
    try {
      await _sfxPlayer.play(AssetSource('audio/sfx/$filename'));
    } catch (e) {
      // Audio file not found - silently fail
      print('SFX not found: $filename');
    }
  }

  /// Get the filename for a sound effect type
  String? _getSfxFilename(SfxType type) {
    switch (type) {
      case SfxType.diceRoll:
        return 'dice_roll.mp3';
      case SfxType.diceHit:
        return 'dice_hit.mp3';
      case SfxType.tokenMove:
        return 'token_move.mp3';
      case SfxType.tokenLand:
        return 'token_land.mp3';
      case SfxType.buyProperty:
        return 'buy_property.mp3';
      case SfxType.payMoney:
        return 'pay_money.mp3';
      case SfxType.collectMoney:
        return 'collect_money.mp3';
      case SfxType.cardDraw:
        return 'card_draw.mp3';
      case SfxType.cardFlip:
        return 'card_flip.mp3';
      case SfxType.jailDoor:
        return 'jail_door.mp3';
      case SfxType.passGo:
        return 'pass_go.mp3';
      case SfxType.victory:
        return 'victory.mp3';
      case SfxType.defeat:
        return 'defeat.mp3';
      case SfxType.powerUp:
        return 'power_up.mp3';
      case SfxType.spinWheel:
        return 'spin_wheel.mp3';
      case SfxType.spinResult:
        return 'spin_result.mp3';
      case SfxType.buttonTap:
        return 'button_tap.mp3';
      case SfxType.upgrade:
        return 'upgrade.mp3';
      case SfxType.auction:
        return 'auction.mp3';
      case SfxType.trade:
        return 'trade.mp3';
      case SfxType.notification:
        return 'notification.mp3';
    }
  }

  // ============================================================================
  // Convenience Methods for Game Events
  // ============================================================================

  /// Called when dice are rolled
  Future<void> onDiceRoll() => playSfx(SfxType.diceRoll);

  /// Called when dice land
  Future<void> onDiceLand() => playSfx(SfxType.diceHit);

  /// Called when token moves one step
  Future<void> onTokenStep() => playSfx(SfxType.tokenMove);

  /// Called when token lands on final tile
  Future<void> onTokenLand() => playSfx(SfxType.tokenLand);

  /// Called when player buys a property
  Future<void> onBuyProperty() => playSfx(SfxType.buyProperty);

  /// Called when player pays rent/tax
  Future<void> onPayMoney() => playSfx(SfxType.payMoney);

  /// Called when player collects money (GO, rent received)
  Future<void> onCollectMoney() => playSfx(SfxType.collectMoney);

  /// Called when drawing a card
  Future<void> onDrawCard() => playSfx(SfxType.cardDraw);

  /// Called when card is revealed
  Future<void> onFlipCard() => playSfx(SfxType.cardFlip);

  /// Called when going to jail
  Future<void> onJail() => playSfx(SfxType.jailDoor);

  /// Called when passing GO
  Future<void> onPassGo() => playSfx(SfxType.passGo);

  /// Called when player wins
  Future<void> onVictory() => playSfx(SfxType.victory);

  /// Called when player loses/bankrupts
  Future<void> onDefeat() => playSfx(SfxType.defeat);

  /// Called when power-up is activated
  Future<void> onPowerUp() => playSfx(SfxType.powerUp);

  /// Called when spin wheel starts
  Future<void> onSpinWheel() => playSfx(SfxType.spinWheel);

  /// Called when spin wheel lands
  Future<void> onSpinResult() => playSfx(SfxType.spinResult);

  /// Called on button tap (optional UI feedback)
  Future<void> onButtonTap() => playSfx(SfxType.buttonTap);

  /// Called when property is upgraded
  Future<void> onUpgrade() => playSfx(SfxType.upgrade);

  /// Called during auction
  Future<void> onAuction() => playSfx(SfxType.auction);

  /// Called on successful trade
  Future<void> onTrade() => playSfx(SfxType.trade);

  /// Called for notifications/alerts
  Future<void> onNotification() => playSfx(SfxType.notification);

  // ============================================================================
  // Cleanup
  // ============================================================================

  /// Dispose of audio players (call when app closes)
  Future<void> dispose() async {
    await _bgmPlayer.dispose();
    await _sfxPlayer.dispose();
  }
}

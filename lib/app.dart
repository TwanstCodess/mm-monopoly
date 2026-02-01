import 'package:flutter/material.dart';
import 'config/theme.dart';
import 'screens/splash_screen.dart';
import 'screens/main_menu_screen.dart';
import 'screens/game_setup_screen.dart';
import 'screens/how_to_play_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/game_board_screen.dart';
import 'screens/shop_screen.dart';
import 'models/player.dart';
import 'models/game_state.dart';
import 'models/country.dart';
import 'config/board_factory.dart';
import 'services/audio_service.dart';
import 'services/unlock_service.dart';

/// Main app widget with navigation
class MonopolyApp extends StatelessWidget {
  const MonopolyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'M&M Property Tycoon', debugShowCheckedModeBanner: false, theme: AppTheme.theme, home: const AppNavigator());
  }
}

/// Navigation state for the app
enum AppScreen { splash, mainMenu, gameSetup, howToPlay, settings, shop, game }

/// Main app navigator managing screen transitions
class AppNavigator extends StatefulWidget {
  const AppNavigator({super.key});

  @override
  State<AppNavigator> createState() => _AppNavigatorState();
}

class _AppNavigatorState extends State<AppNavigator> {
  AppScreen _currentScreen = AppScreen.splash;
  AppScreen? _previousScreen; // Track where user came from
  GameState? _gameState;
  GameSettings _settings = const GameSettings();
  int _diceCount = 2; // Track dice count for the game
  Country _selectedCountry = Country.usa; // Track selected country for the board

  void _navigateTo(AppScreen screen) {
    setState(() {
      _previousScreen = _currentScreen;
      _currentScreen = screen;
    });
    _handleScreenAudio(screen);
  }

  void _handleScreenAudio(AppScreen screen) {
    final audio = AudioService.instance;
    switch (screen) {
      case AppScreen.mainMenu:
      case AppScreen.gameSetup:
      case AppScreen.howToPlay:
      case AppScreen.settings:
      case AppScreen.shop:
        // Play menu music for all menu screens
        audio.playMenuMusic();
        break;
      case AppScreen.game:
        // Play game music when entering game
        audio.playGameMusic();
        break;
      case AppScreen.splash:
        // No music on splash
        break;
    }
  }

  void _startGame(List<PlayerConfig> configs, {int diceCount = 2, Country country = Country.usa}) {
    // Create players from configs
    final players = configs.asMap().entries.map((entry) {
      final index = entry.key;
      final config = entry.value;
      return Player(id: 'player_$index', name: config.name, color: config.color, icon: config.icon, avatar: config.avatar, isAI: config.isAI, cash: _settings.startingCash);
    }).toList();

    // Create game state using factory constructor
    setState(() {
      _diceCount = diceCount;
      _selectedCountry = country;
      _gameState = GameState.initial(players: players, tiles: BoardFactory.generateTiles(country), startingCash: _settings.startingCash, diceCount: diceCount);
      _currentScreen = AppScreen.game;
    });

    // Play game music
    AudioService.instance.playGameMusic();
  }

  void _quitGame() {
    setState(() {
      _gameState = null;
      _currentScreen = AppScreen.mainMenu;
    });
    
    // Switch back to menu music
    AudioService.instance.playMenuMusic();
  }

  void _restartGame() {
    if (_gameState != null) {
      // Reset all players
      final resetPlayers = _gameState!.players.map((p) {
        return Player(id: p.id, name: p.name, color: p.color, icon: p.icon, avatar: p.avatar, isAI: p.isAI, cash: _settings.startingCash);
      }).toList();

      setState(() {
        _gameState = GameState.initial(players: resetPlayers, tiles: BoardFactory.generateTiles(_selectedCountry), startingCash: _settings.startingCash, diceCount: _diceCount);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(duration: const Duration(milliseconds: 300), child: _buildCurrentScreen());
  }

  Widget _buildCurrentScreen() {
    switch (_currentScreen) {
      case AppScreen.splash:
        return SplashScreen(key: const ValueKey('splash'), onComplete: () => _navigateTo(AppScreen.mainMenu));

      case AppScreen.mainMenu:
        return MainMenuScreen(
          key: const ValueKey('mainMenu'),
          onNewGame: () => _navigateTo(AppScreen.gameSetup),
          onContinue: _gameState != null ? () => _navigateTo(AppScreen.game) : null,
          onHowToPlay: () => _navigateTo(AppScreen.howToPlay),
          onSettings: () => _navigateTo(AppScreen.settings),
          onShop: () => _navigateTo(AppScreen.shop),
        );

      case AppScreen.gameSetup:
        return GameSetupScreen(key: const ValueKey('gameSetup'), onBack: () => _navigateTo(AppScreen.mainMenu), onStartGame: _startGame);

      case AppScreen.howToPlay:
        // Go back to where user came from (game or mainMenu)
        final returnScreen = _previousScreen == AppScreen.game ? AppScreen.game : AppScreen.mainMenu;
        return HowToPlayScreen(key: const ValueKey('howToPlay'), onBack: () => _navigateTo(returnScreen));

      case AppScreen.settings:
        return SettingsScreen(
          key: const ValueKey('settings'),
          onBack: () => _navigateTo(AppScreen.mainMenu),
          settings: _settings,
          onSettingsChanged: (newSettings) {
            setState(() {
              _settings = newSettings;
            });
          },
        );

      case AppScreen.shop:
        return ShopScreen(key: const ValueKey('shop'), onBack: () => _navigateTo(AppScreen.mainMenu));

      case AppScreen.game:
        return GameBoardScreen(
          key: ValueKey('game_${_gameState!.id}'),
          gameState: _gameState!,
          onQuit: _quitGame,
          onRestart: _restartGame,
          onHowToPlay: () => _navigateTo(AppScreen.howToPlay),
          tradingEnabled: _settings.tradingEnabled,
          bankEnabled: _settings.bankEnabled,
          auctionEnabled: _settings.auctionEnabled,
          boardTheme: BoardFactory.getTheme(_selectedCountry),
        );
    }
  }
}

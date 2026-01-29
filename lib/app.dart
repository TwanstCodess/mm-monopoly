import 'package:flutter/material.dart';
import 'config/theme.dart';
import 'screens/splash_screen.dart';
import 'screens/main_menu_screen.dart';
import 'screens/game_setup_screen.dart';
import 'screens/how_to_play_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/game_board_screen.dart';
import 'models/player.dart';
import 'models/game_state.dart';
import 'config/board_configs/classic_board.dart';

/// Main app widget with navigation
class MonopolyApp extends StatelessWidget {
  const MonopolyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'M&M Monopoly',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: const AppNavigator(),
    );
  }
}

/// Navigation state for the app
enum AppScreen {
  splash,
  mainMenu,
  gameSetup,
  howToPlay,
  settings,
  game,
}

/// Main app navigator managing screen transitions
class AppNavigator extends StatefulWidget {
  const AppNavigator({super.key});

  @override
  State<AppNavigator> createState() => _AppNavigatorState();
}

class _AppNavigatorState extends State<AppNavigator> {
  AppScreen _currentScreen = AppScreen.splash;
  GameState? _gameState;
  GameSettings _settings = const GameSettings();

  void _navigateTo(AppScreen screen) {
    setState(() {
      _currentScreen = screen;
    });
  }

  void _startGame(List<PlayerConfig> configs) {
    // Create players from configs
    final players = configs.asMap().entries.map((entry) {
      final index = entry.key;
      final config = entry.value;
      return Player(
        id: 'player_$index',
        name: config.name,
        color: config.color,
        icon: config.icon,
        avatar: config.avatar,
        isAI: config.isAI,
        cash: _settings.startingCash,
      );
    }).toList();

    // Create game state using factory constructor
    setState(() {
      _gameState = GameState.initial(
        players: players,
        tiles: ClassicBoard.generateTiles(),
        startingCash: _settings.startingCash,
      );
      _currentScreen = AppScreen.game;
    });
  }

  void _quitGame() {
    setState(() {
      _gameState = null;
      _currentScreen = AppScreen.mainMenu;
    });
  }

  void _restartGame() {
    if (_gameState != null) {
      // Reset all players
      final resetPlayers = _gameState!.players.map((p) {
        return Player(
          id: p.id,
          name: p.name,
          color: p.color,
          icon: p.icon,
          avatar: p.avatar,
          isAI: p.isAI,
          cash: _settings.startingCash,
        );
      }).toList();

      setState(() {
        _gameState = GameState.initial(
          players: resetPlayers,
          tiles: ClassicBoard.generateTiles(),
          startingCash: _settings.startingCash,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: _buildCurrentScreen(),
    );
  }

  Widget _buildCurrentScreen() {
    switch (_currentScreen) {
      case AppScreen.splash:
        return SplashScreen(
          key: const ValueKey('splash'),
          onComplete: () => _navigateTo(AppScreen.mainMenu),
        );

      case AppScreen.mainMenu:
        return MainMenuScreen(
          key: const ValueKey('mainMenu'),
          onNewGame: () => _navigateTo(AppScreen.gameSetup),
          onContinue: _gameState != null ? () => _navigateTo(AppScreen.game) : null,
          onHowToPlay: () => _navigateTo(AppScreen.howToPlay),
          onSettings: () => _navigateTo(AppScreen.settings),
        );

      case AppScreen.gameSetup:
        return GameSetupScreen(
          key: const ValueKey('gameSetup'),
          onBack: () => _navigateTo(AppScreen.mainMenu),
          onStartGame: _startGame,
        );

      case AppScreen.howToPlay:
        return HowToPlayScreen(
          key: const ValueKey('howToPlay'),
          onBack: () => _navigateTo(AppScreen.mainMenu),
        );

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

      case AppScreen.game:
        return GameBoardScreen(
          key: const ValueKey('game'),
          gameState: _gameState!,
          onQuit: _quitGame,
          onRestart: _restartGame,
          onHowToPlay: () => _navigateTo(AppScreen.howToPlay),
        );
    }
  }
}

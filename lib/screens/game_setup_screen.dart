import 'package:flutter/material.dart';
import '../models/player.dart';
import '../models/avatar.dart';
import '../config/theme.dart';
import '../config/constants.dart';
import '../widgets/avatar/avatar_selector.dart';
import '../widgets/avatar/avatar_widget.dart';

/// Game setup screen for configuring players before starting
class GameSetupScreen extends StatefulWidget {
  final VoidCallback onBack;
  final Function(List<PlayerConfig>) onStartGame;

  const GameSetupScreen({
    super.key,
    required this.onBack,
    required this.onStartGame,
  });

  @override
  State<GameSetupScreen> createState() => _GameSetupScreenState();
}

class _GameSetupScreenState extends State<GameSetupScreen> {
  int _playerCount = 2;
  final List<PlayerConfig> _playerConfigs = [];
  final List<TextEditingController> _nameControllers = [];
  int _currentStep = 0; // 0: player count, 1: player config

  // Available colors for players
  static const List<Color> _availableColors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.teal,
  ];


  @override
  void initState() {
    super.initState();
    _initializeConfigs();
  }

  void _initializeConfigs() {
    // Dispose old controllers
    for (final controller in _nameControllers) {
      controller.dispose();
    }
    _nameControllers.clear();
    _playerConfigs.clear();

    for (int i = 0; i < _playerCount; i++) {
      final name = 'Player ${i + 1}';
      _playerConfigs.add(PlayerConfig(
        name: name,
        color: _availableColors[i % _availableColors.length],
        icon: PlayerIcon.values[i % PlayerIcon.values.length],
        isAI: i > 0, // First player is human, rest are AI by default
        avatar: Avatars.forPlayerIndex(i), // Phase 3: Default avatar
      ));
      _nameControllers.add(TextEditingController(text: name));
    }
  }

  @override
  void dispose() {
    for (final controller in _nameControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _updatePlayerCount(int count) {
    setState(() {
      _playerCount = count;
      _initializeConfigs();
    });
  }

  void _nextStep() {
    if (_currentStep == 0) {
      setState(() {
        _currentStep = 1;
      });
    } else {
      // Validate and start game
      if (_validateConfigs()) {
        widget.onStartGame(_playerConfigs);
      }
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    } else {
      widget.onBack();
    }
  }

  bool _validateConfigs() {
    // Check for duplicate names
    final names = _playerConfigs.map((c) => c.name.trim()).toSet();
    if (names.length != _playerConfigs.length) {
      _showError('Each player must have a unique name');
      return false;
    }

    // Check for empty names
    if (_playerConfigs.any((c) => c.name.trim().isEmpty)) {
      _showError('All players must have a name');
      return false;
    }

    // Check for duplicate colors
    final colors = _playerConfigs.map((c) => c.color.value).toSet();
    if (colors.length != _playerConfigs.length) {
      _showError('Each player must have a unique color');
      return false;
    }

    return true;
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.error,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: _previousStep,
        ),
        title: Text(
          _currentStep == 0 ? 'How Many Players?' : 'Player Setup',
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Progress indicator
            _buildProgressIndicator(),
            // Content
            Expanded(
              child: _currentStep == 0
                  ? _buildPlayerCountStep()
                  : _buildPlayerConfigStep(),
            ),
            // Navigation buttons
            _buildNavigationButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          _buildStepIndicator(0, 'Players'),
          Expanded(
            child: Container(
              height: 2,
              color: _currentStep >= 1 ? AppTheme.primary : Colors.white24,
            ),
          ),
          _buildStepIndicator(1, 'Setup'),
        ],
      ),
    );
  }

  Widget _buildStepIndicator(int step, String label) {
    final isActive = _currentStep >= step;
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? AppTheme.primary : Colors.white24,
          ),
          child: Center(
            child: isActive
                ? const Icon(Icons.check, color: Colors.white, size: 18)
                : Text(
                    '${step + 1}',
                    style: const TextStyle(color: Colors.white),
                  ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.white54,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildPlayerCountStep() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Select the number of players',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 40),
            // Player count selector
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                GameConstants.maxPlayers - 1, // 2-6 players
                (index) {
                  final count = index + 2;
                  final isSelected = _playerCount == count;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: GestureDetector(
                      onTap: () => _updatePlayerCount(count),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppTheme.primary
                              : Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? AppTheme.primary
                                : Colors.white24,
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            '$count',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 40),
            // Player avatars preview
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _playerCount,
                (index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: AvatarWidget(
                    avatar: Avatars.forPlayerIndex(index),
                    size: 40,
                    borderColor: _availableColors[index],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerConfigStep() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _playerConfigs.length,
      itemBuilder: (context, index) => _buildPlayerConfigCard(index),
    );
  }

  Widget _buildPlayerConfigCard(int index) {
    final config = _playerConfigs[index];
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: AppTheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: config.color, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with avatar (Phase 3)
            Row(
              children: [
                // Phase 3: Avatar instead of simple icon
                GestureDetector(
                  onTap: () => _showAvatarSelector(index),
                  child: Stack(
                    children: [
                      AvatarWidget(
                        avatar: config.avatar ?? Avatars.forPlayerIndex(index),
                        size: 48,
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: config.color,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'Player ${index + 1}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // AI toggle
                Row(
                  children: [
                    const Text(
                      'AI',
                      style: TextStyle(color: Colors.white70),
                    ),
                    Switch(
                      value: config.isAI,
                      onChanged: (value) {
                        setState(() {
                          _playerConfigs[index] = config.copyWith(isAI: value);
                        });
                      },
                      activeColor: AppTheme.primary,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Name input
            TextField(
              controller: _nameControllers[index],
              onChanged: (value) {
                _playerConfigs[index] = config.copyWith(name: value);
              },
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Name',
                labelStyle: const TextStyle(color: Colors.white54),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.white24),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: config.color),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Color selector
            const Text(
              'Color',
              style: TextStyle(color: Colors.white54, fontSize: 12),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: _availableColors.map((color) {
                final isSelected = config.color == color;
                final isUsed = _playerConfigs
                    .where((c) => c != config)
                    .any((c) => c.color == color);
                return GestureDetector(
                  onTap: isUsed
                      ? null
                      : () {
                          setState(() {
                            _playerConfigs[index] =
                                config.copyWith(color: color);
                          });
                        },
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: isSelected
                          ? Border.all(color: Colors.white, width: 3)
                          : null,
                    ),
                    child: isUsed && !isSelected
                        ? const Icon(Icons.close, color: Colors.white54, size: 20)
                        : isSelected
                            ? const Icon(Icons.check, color: Colors.white, size: 20)
                            : null,
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  // Phase 3: Show avatar selector dialog
  void _showAvatarSelector(int playerIndex) {
    final config = _playerConfigs[playerIndex];
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Choose Your Avatar',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: AvatarSelector(
                  selectedAvatar: config.avatar,
                  onAvatarSelected: (avatar) {
                    setState(() {
                      _playerConfigs[playerIndex] = config.copyWith(avatar: avatar);
                    });
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: _previousStep,
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white70,
                side: const BorderSide(color: Colors.white24),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(_currentStep == 0 ? 'Back' : 'Previous'),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: _nextStep,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                _currentStep == 0 ? 'Next' : 'Start Game',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Configuration for a player before game starts
class PlayerConfig {
  final String name;
  final Color color;
  final PlayerIcon icon;
  final bool isAI;
  final Avatar? avatar; // Phase 3: Custom avatar

  const PlayerConfig({
    required this.name,
    required this.color,
    required this.icon,
    required this.isAI,
    this.avatar,
  });

  PlayerConfig copyWith({
    String? name,
    Color? color,
    PlayerIcon? icon,
    bool? isAI,
    Avatar? avatar,
  }) {
    return PlayerConfig(
      name: name ?? this.name,
      color: color ?? this.color,
      icon: icon ?? this.icon,
      isAI: isAI ?? this.isAI,
      avatar: avatar ?? this.avatar,
    );
  }
}

import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/player.dart';
import '../models/avatar.dart';
import '../config/constants.dart' hide Offset;
import '../widgets/avatar/avatar_selector.dart';
import '../widgets/avatar/avatar_widget.dart';

/// Game setup screen for configuring players before starting
class GameSetupScreen extends StatefulWidget {
  final VoidCallback onBack;
  final Function(List<PlayerConfig>, {int diceCount}) onStartGame;

  const GameSetupScreen({super.key, required this.onBack, required this.onStartGame});

  @override
  State<GameSetupScreen> createState() => _GameSetupScreenState();
}

class _GameSetupScreenState extends State<GameSetupScreen> with SingleTickerProviderStateMixin {
  int _playerCount = 2;
  int _diceCount = 2;
  final List<PlayerConfig> _playerConfigs = [];
  final List<TextEditingController> _nameControllers = [];
  int _currentStep = 0;
  late AnimationController _floatController;

  static const List<Color> _availableColors = [
    Color(0xFFFF6B6B), // Coral Red
    Color(0xFF4ECDC4), // Teal
    Color(0xFF45B7D1), // Sky Blue
    Color(0xFFFFBE0B), // Yellow
    Color(0xFFFF006E), // Pink
    Color(0xFF8338EC), // Purple
  ];

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(vsync: this, duration: const Duration(milliseconds: 3000))..repeat(reverse: true);
    _initializeConfigs();
  }

  void _initializeConfigs() {
    for (final controller in _nameControllers) {
      controller.dispose();
    }
    _nameControllers.clear();
    _playerConfigs.clear();

    for (int i = 0; i < _playerCount; i++) {
      final name = 'Player ${i + 1}';
      _playerConfigs.add(PlayerConfig(name: name, color: _availableColors[i % _availableColors.length], icon: PlayerIcon.values[i % PlayerIcon.values.length], isAI: false, avatar: Avatars.forPlayerIndex(i)));
      _nameControllers.add(TextEditingController(text: name));
    }
  }

  @override
  void dispose() {
    _floatController.dispose();
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
      setState(() => _currentStep = 1);
    } else {
      if (_validateConfigs()) {
        widget.onStartGame(_playerConfigs, diceCount: _diceCount);
      }
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    } else {
      widget.onBack();
    }
  }

  bool _validateConfigs() {
    final names = _playerConfigs.map((c) => c.name.trim()).toSet();
    if (names.length != _playerConfigs.length) {
      _showError('Each player must have a unique name');
      return false;
    }
    if (_playerConfigs.any((c) => c.name.trim().isEmpty)) {
      _showError('All players must have a name');
      return false;
    }
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
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 12),
            Text(message),
          ],
        ),
        backgroundColor: const Color(0xFFFF6B6B),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF667eea), Color(0xFF764ba2), Color(0xFFf093fb)]),
        ),
        child: Stack(
          children: [
            ...List.generate(12, (index) => _buildFloatingShape(index)),
            SafeArea(
              child: Column(
                children: [
                  _buildHeader(),
                  _buildProgressIndicator(),
                  Expanded(child: _currentStep == 0 ? _buildPlayerCountStep() : _buildPlayerConfigStep()),
                  _buildNavigationButtons(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingShape(int index) {
    final random = math.Random(index + 500);
    final size = 15.0 + random.nextDouble() * 30;
    final left = random.nextDouble();
    final top = random.nextDouble();
    final colors = [Colors.white.withOpacity(0.08), Colors.yellow.withOpacity(0.1), Colors.pink.withOpacity(0.08), Colors.cyan.withOpacity(0.08)];

    return AnimatedBuilder(
      animation: _floatController,
      builder: (context, child) {
        return Positioned(
          left: MediaQuery.of(context).size.width * left,
          top: MediaQuery.of(context).size.height * top,
          child: Transform.translate(
            offset: Offset(math.sin(_floatController.value * math.pi * 2 + index) * 6, math.cos(_floatController.value * math.pi * 2 + index * 0.5) * 6),
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(color: colors[index % colors.length], shape: index % 3 == 0 ? BoxShape.circle : BoxShape.rectangle, borderRadius: index % 3 != 0 ? BorderRadius.circular(6) : null),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          _buildBackButton(),
          const SizedBox(width: 16),
          Expanded(
            child: ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(colors: [Colors.white, Color(0xFFFFE66D)]).createShader(bounds),
              child: Text(
                _currentStep == 0 ? 'How Many Players?' : 'Player Setup',
                style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _previousStep,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.3)),
          ),
          child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 24),
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        children: [
          _buildStepIndicator(0, 'Players'),
          Expanded(
            child: Container(
              height: 3,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(2), color: _currentStep >= 1 ? const Color(0xFF4ECDC4) : Colors.white.withOpacity(0.3)),
            ),
          ),
          _buildStepIndicator(1, 'Setup'),
        ],
      ),
    );
  }

  Widget _buildStepIndicator(int step, String label) {
    final isActive = _currentStep >= step;
    final color = isActive ? const Color(0xFF4ECDC4) : Colors.white.withOpacity(0.5);
    return Column(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? color : Colors.white.withOpacity(0.2),
            border: Border.all(color: color, width: 2),
            boxShadow: isActive ? [BoxShadow(color: color.withOpacity(0.5), blurRadius: 10, spreadRadius: 2)] : null,
          ),
          child: Center(
            child: isActive
                ? const Icon(Icons.check_rounded, color: Colors.white, size: 20)
                : Text(
                    '${step + 1}',
                    style: TextStyle(color: color, fontWeight: FontWeight.bold),
                  ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(color: isActive ? Colors.white : Colors.white70, fontSize: 12, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildPlayerCountStep() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(20)),
              child: const Text(
                'Select the number of players',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(height: 32),
            // Player count selector
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(GameConstants.maxPlayers - 1, (index) {
                final count = index + 2;
                final isSelected = _playerCount == count;
                final colors = [const Color(0xFFFF6B6B), const Color(0xFF4ECDC4), const Color(0xFFFFE66D)];
                final color = colors[index % colors.length];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: GestureDetector(
                    onTap: () => _updatePlayerCount(count),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        gradient: isSelected ? LinearGradient(colors: [color, color.withOpacity(0.7)]) : null,
                        color: isSelected ? null : Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: isSelected ? color : Colors.white30, width: 2),
                        boxShadow: isSelected ? [BoxShadow(color: color.withOpacity(0.5), blurRadius: 12, offset: const Offset(0, 4))] : null,
                      ),
                      child: Center(
                        child: Text(
                          '$count',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                            shadows: isSelected ? [const Shadow(color: Colors.black26, blurRadius: 4, offset: Offset(1, 1))] : null,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 24),
            // Player avatars preview
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  _playerCount,
                  (index) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(color: _availableColors[index].withOpacity(0.5), blurRadius: 8, spreadRadius: 1)],
                      ),
                      child: AvatarWidget(avatar: Avatars.forPlayerIndex(index), size: 48, borderColor: _availableColors[index]),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            // Dice section
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(20)),
              child: const Text(
                'Number of Dice',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(height: 20),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [_buildDiceOption(1, '🎲', 'One Die', const Color(0xFF95E1D3)), const SizedBox(width: 16), _buildDiceOption(2, '🎲🎲', 'Two Dice', const Color(0xFFFFB347))]),
          ],
        ),
      ),
    );
  }

  Widget _buildDiceOption(int count, String emoji, String label, Color color) {
    final isSelected = _diceCount == count;
    return GestureDetector(
      onTap: () => setState(() => _diceCount = count),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          gradient: isSelected ? LinearGradient(colors: [color, color.withOpacity(0.7)]) : null,
          color: isSelected ? null : Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? color : Colors.white30, width: 2),
          boxShadow: isSelected ? [BoxShadow(color: color.withOpacity(0.5), blurRadius: 12, offset: const Offset(0, 4))] : null,
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 28)),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: isSelected ? FontWeight.bold : FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerConfigStep() {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate available height for player cards
        final availableHeight = constraints.maxHeight;
        final cardCount = _playerConfigs.length;
        // Distribute space evenly with small gaps
        final cardHeight = (availableHeight - (cardCount - 1) * 8 - 16) / cardCount;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            children: _playerConfigs.asMap().entries.map((entry) {
              final index = entry.key;
              return Padding(
                padding: EdgeInsets.only(bottom: index < cardCount - 1 ? 8 : 0),
                child: SizedBox(
                  height: cardHeight.clamp(100.0, 180.0),
                  child: _buildPlayerConfigCard(index),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Widget _buildPlayerConfigCard(int index) {
    final config = _playerConfigs[index];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF2D1B4E).withOpacity(0.85),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: config.color.withOpacity(0.6), width: 2),
        boxShadow: [BoxShadow(color: config.color.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Avatar
          GestureDetector(
            onTap: () => _showAvatarSelector(index),
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: config.color.withOpacity(0.5), blurRadius: 6, spreadRadius: 1)],
                  ),
                  child: AvatarWidget(avatar: config.avatar ?? Avatars.forPlayerIndex(index), size: 44, borderColor: config.color),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [config.color, config.color.withOpacity(0.7)]),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.edit_rounded, color: Colors.white, size: 10),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Name and Color in a column
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Player header row with name input
                Row(
                  children: [
                    Text(
                      'Player ${index + 1}',
                      style: TextStyle(
                        color: config.color,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    if (index > 0)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'AI',
                            style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12, fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            height: 24,
                            child: Transform.scale(
                              scale: 0.7,
                              child: Switch(
                                value: config.isAI,
                                onChanged: (value) => setState(() => _playerConfigs[index] = config.copyWith(isAI: value)),
                                activeColor: const Color(0xFF4ECDC4),
                                activeTrackColor: const Color(0xFF4ECDC4).withOpacity(0.3),
                              ),
                            ),
                          ),
                        ],
                      )
                    else
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(colors: [Color(0xFF4ECDC4), Color(0xFF44A08D)]),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.person_rounded, color: Colors.white, size: 12),
                            SizedBox(width: 2),
                            Text('You', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                // Name input - compact
                SizedBox(
                  height: 40,
                  child: TextField(
                    controller: _nameControllers[index],
                    onChanged: (value) => _playerConfigs[index] = config.copyWith(name: value),
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 14),
                    decoration: InputDecoration(
                      labelText: 'Name',
                      labelStyle: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.1),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: config.color, width: 2),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // Color selector - compact horizontal row
                Row(
                  children: [
                    Text(
                      'Color',
                      style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 11, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(width: 8),
                    ..._availableColors.map((color) {
                      final isSelected = config.color == color;
                      final isUsed = _playerConfigs.where((c) => c != config).any((c) => c.color == color);
                      return Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: GestureDetector(
                          onTap: isUsed ? null : () => setState(() => _playerConfigs[index] = config.copyWith(color: color)),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [color, color.withOpacity(0.7)]),
                              shape: BoxShape.circle,
                              border: isSelected ? Border.all(color: Colors.white, width: 2) : null,
                            ),
                            child: isUsed && !isSelected
                                ? Icon(Icons.close_rounded, color: Colors.white.withOpacity(0.5), size: 14)
                                : isSelected
                                ? const Icon(Icons.check_rounded, color: Colors.white, size: 16)
                                : null,
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

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
          decoration: const BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFF764ba2), Color(0xFF667eea)]),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.3), borderRadius: BorderRadius.circular(2)),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(colors: [Colors.white, Color(0xFFFFE66D)]).createShader(bounds),
                  child: const Text(
                    'Choose Your Avatar',
                    style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Expanded(
                child: AvatarSelector(
                  selectedAvatar: config.avatar,
                  onAvatarSelected: (avatar) {
                    setState(() => _playerConfigs[playerIndex] = config.copyWith(avatar: avatar));
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
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _previousStep,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withOpacity(0.3)),
                  ),
                  child: Center(
                    child: Text(
                      _currentStep == 0 ? 'Back' : 'Previous',
                      style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _nextStep,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: _currentStep == 0 ? [const Color(0xFF4ECDC4), const Color(0xFF44A08D)] : [const Color(0xFFFF6B6B), const Color(0xFFFF8E53)]),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: (_currentStep == 0 ? const Color(0xFF4ECDC4) : const Color(0xFFFF6B6B)).withOpacity(0.4), blurRadius: 12, offset: const Offset(0, 6))],
                  ),
                  child: Center(
                    child: Text(
                      _currentStep == 0 ? 'Next' : 'Start Game',
                      style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
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
  final Avatar? avatar;

  const PlayerConfig({required this.name, required this.color, required this.icon, required this.isAI, this.avatar});

  PlayerConfig copyWith({String? name, Color? color, PlayerIcon? icon, bool? isAI, Avatar? avatar}) {
    return PlayerConfig(name: name ?? this.name, color: color ?? this.color, icon: icon ?? this.icon, isAI: isAI ?? this.isAI, avatar: avatar ?? this.avatar);
  }
}

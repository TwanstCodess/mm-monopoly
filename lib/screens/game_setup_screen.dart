import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../models/player.dart';
import '../models/avatar.dart';
import '../models/country.dart';
import '../config/constants.dart' hide Offset;
import '../widgets/avatar/avatar_selector.dart';
import '../widgets/avatar/avatar_widget.dart';

/// Game setup screen for configuring players before starting
class GameSetupScreen extends StatefulWidget {
  final VoidCallback onBack;
  final Function(List<PlayerConfig>, {int diceCount, Country country}) onStartGame;

  const GameSetupScreen({super.key, required this.onBack, required this.onStartGame});

  @override
  State<GameSetupScreen> createState() => _GameSetupScreenState();
}

class _GameSetupScreenState extends State<GameSetupScreen> with SingleTickerProviderStateMixin {
  int _playerCount = 2;
  int _diceCount = 2;
  Country _selectedCountry = Country.usa;
  final List<PlayerConfig> _playerConfigs = [];
  final List<TextEditingController> _nameControllers = [];
  int _currentStep = 0;
  late AnimationController _floatController;
  bool _didInitConfigs = false;

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
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_didInitConfigs) {
      _didInitConfigs = true;
      _initializeConfigs();
    }
  }

  void _initializeConfigs() {
    for (final controller in _nameControllers) {
      controller.dispose();
    }
    _nameControllers.clear();
    _playerConfigs.clear();

    for (int i = 0; i < _playerCount; i++) {
      final name = AppLocalizations.of(context)!.playerN(i + 1);
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
        widget.onStartGame(_playerConfigs, diceCount: _diceCount, country: _selectedCountry);
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
      _showError(AppLocalizations.of(context)!.uniqueNameError);
      return false;
    }
    if (_playerConfigs.any((c) => c.name.trim().isEmpty)) {
      _showError(AppLocalizations.of(context)!.allPlayersNeedName);
      return false;
    }
    final colors = _playerConfigs.map((c) => c.color.value).toSet();
    if (colors.length != _playerConfigs.length) {
      _showError(AppLocalizations.of(context)!.uniqueColorError);
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
                _currentStep == 0 ? AppLocalizations.of(context)!.howManyPlayers : AppLocalizations.of(context)!.playerSetup,
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
          _buildStepIndicator(0, AppLocalizations.of(context)!.playersStep),
          Expanded(
            child: Container(
              height: 3,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(2), color: _currentStep >= 1 ? const Color(0xFF4ECDC4) : Colors.white.withOpacity(0.3)),
            ),
          ),
          _buildStepIndicator(1, AppLocalizations.of(context)!.setupStep),
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
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate available height and distribute proportionally
        final availableHeight = constraints.maxHeight;
        final isCompact = availableHeight < 500;

        // Proportional heights based on available space
        final countryHeight = isCompact ? 140.0 : (availableHeight * 0.32).clamp(140.0, 190.0);
        final playersHeight = isCompact ? 160.0 : (availableHeight * 0.38).clamp(160.0, 220.0);
        final diceHeight = isCompact ? 100.0 : (availableHeight * 0.22).clamp(100.0, 140.0);

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: isCompact ? 8 : 16),

                // Country selection section
                Container(
                  height: countryHeight,
                  width: double.infinity,
                  padding: EdgeInsets.all(isCompact ? 12 : 20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.white.withOpacity(0.15), Colors.white.withOpacity(0.05)],
                    ),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('🌍', style: TextStyle(fontSize: isCompact ? 20 : 24)),
                          const SizedBox(width: 10),
                          Text(
                            AppLocalizations.of(context)!.chooseCountry,
                            style: TextStyle(color: Colors.white, fontSize: isCompact ? 16 : 20, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(height: isCompact ? 8 : 16),
                      Expanded(
                        child: Row(
                          children: Country.values.map((country) {
                            final isSelected = _selectedCountry == country;
                            final colors = [const Color(0xFFFF6B6B), const Color(0xFF4ECDC4), const Color(0xFFFFE66D)];
                            final color = colors[country.index % colors.length];
                            return Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(
                                  left: country.index == 0 ? 0 : 4,
                                  right: country.index == Country.values.length - 1 ? 0 : 4,
                                ),
                                child: GestureDetector(
                                  onTap: () => setState(() => _selectedCountry = country),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    decoration: BoxDecoration(
                                      gradient: isSelected ? LinearGradient(colors: [color, color.withOpacity(0.7)]) : null,
                                      color: isSelected ? null : Colors.white.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(color: isSelected ? color : Colors.white24, width: isSelected ? 3 : 2),
                                      boxShadow: isSelected ? [BoxShadow(color: color.withOpacity(0.5), blurRadius: 12, offset: const Offset(0, 4))] : null,
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          country.flag,
                                          style: TextStyle(fontSize: isCompact ? 24 : 32),
                                        ),
                                        SizedBox(height: isCompact ? 2 : 6),
                                        Text(
                                          country.localizedDisplayName(AppLocalizations.of(context)!),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: isCompact ? 10 : 12,
                                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: isCompact ? 8 : 16),

                // Players section - takes most space
                Container(
                  height: playersHeight,
                  width: double.infinity,
                  padding: EdgeInsets.all(isCompact ? 12 : 20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.white.withOpacity(0.15), Colors.white.withOpacity(0.05)],
                    ),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                  ),
                  child: Column(
                    children: [
                      // Section title
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.people_alt_rounded, color: Colors.white70, size: isCompact ? 20 : 24),
                          const SizedBox(width: 10),
                          Text(
                            AppLocalizations.of(context)!.numberOfPlayers,
                            style: TextStyle(color: Colors.white, fontSize: isCompact ? 16 : 20, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),

                      SizedBox(height: isCompact ? 12 : 24),

                      // Player count buttons - fill available width
                      Expanded(
                        child: Row(
                          children: List.generate(GameConstants.maxPlayers - 1, (index) {
                            final count = index + 2;
                            final isSelected = _playerCount == count;
                            final colors = [const Color(0xFFFF6B6B), const Color(0xFF4ECDC4), const Color(0xFFFFE66D)];
                            final color = colors[index % colors.length];
                            return Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(
                                  left: index == 0 ? 0 : 6,
                                  right: index == 2 ? 0 : 6,
                                ),
                                child: GestureDetector(
                                  onTap: () => _updatePlayerCount(count),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    decoration: BoxDecoration(
                                      gradient: isSelected ? LinearGradient(colors: [color, color.withOpacity(0.7)]) : null,
                                      color: isSelected ? null : Colors.white.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(color: isSelected ? color : Colors.white24, width: isSelected ? 3 : 2),
                                      boxShadow: isSelected ? [BoxShadow(color: color.withOpacity(0.5), blurRadius: 16, offset: const Offset(0, 6))] : null,
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '$count',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: isCompact ? 36 : 48,
                                            fontWeight: FontWeight.bold,
                                            shadows: isSelected ? [const Shadow(color: Colors.black26, blurRadius: 4, offset: Offset(1, 1))] : null,
                                          ),
                                        ),
                                        SizedBox(height: isCompact ? 2 : 4),
                                        Text(
                                          AppLocalizations.of(context)!.players,
                                          style: TextStyle(
                                            color: Colors.white.withOpacity(0.7),
                                            fontSize: isCompact ? 12 : 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: isCompact ? 8 : 16),

                // Dice section - bottom card
                Container(
                  height: diceHeight,
                  width: double.infinity,
                  padding: EdgeInsets.all(isCompact ? 10 : 16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.white.withOpacity(0.15), Colors.white.withOpacity(0.05)],
                    ),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                  ),
                  child: Column(
                    children: [
                      // Section title
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('🎲', style: TextStyle(fontSize: isCompact ? 16 : 20)),
                          const SizedBox(width: 8),
                          Text(
                            AppLocalizations.of(context)!.numberOfDice,
                            style: TextStyle(color: Colors.white, fontSize: isCompact ? 14 : 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),

                      SizedBox(height: isCompact ? 8 : 12),

                      // Dice options - side by side, filling width
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(child: _buildDiceCard(1, '🎲', AppLocalizations.of(context)!.oneDie, AppLocalizations.of(context)!.classicStyle, const Color(0xFF95E1D3))),
                            const SizedBox(width: 12),
                            Expanded(child: _buildDiceCard(2, '🎲🎲', AppLocalizations.of(context)!.twoDice, AppLocalizations.of(context)!.standardRules, const Color(0xFFFFB347))),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: isCompact ? 8 : 16),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDiceCard(int count, String emoji, String label, String subtitle, Color color) {
    final isSelected = _diceCount == count;
    return GestureDetector(
      onTap: () => setState(() => _diceCount = count),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          gradient: isSelected ? LinearGradient(colors: [color, color.withOpacity(0.7)]) : null,
          color: isSelected ? null : Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? color : Colors.white24, width: isSelected ? 3 : 2),
          boxShadow: isSelected ? [BoxShadow(color: color.withOpacity(0.5), blurRadius: 12, offset: const Offset(0, 4))] : null,
        ),
        child: Center(
          child: Text(emoji, style: const TextStyle(fontSize: 36)),
        ),
      ),
    );
  }

  Widget _buildPlayerConfigStep() {
    final count = _playerConfigs.length;
    
    return Padding(
      padding: const EdgeInsets.all(12),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // 2x2 grid for 4 players, 2 columns for 2-3 players
          if (count == 4) {
            return Column(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Expanded(child: _buildPlayerCard(0)),
                      const SizedBox(width: 10),
                      Expanded(child: _buildPlayerCard(1)),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(child: _buildPlayerCard(2)),
                      const SizedBox(width: 10),
                      Expanded(child: _buildPlayerCard(3)),
                    ],
                  ),
                ),
              ],
            );
          } else if (count == 3) {
            return Column(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Expanded(child: _buildPlayerCard(0)),
                      const SizedBox(width: 10),
                      Expanded(child: _buildPlayerCard(1)),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: Row(
                    children: [
                      const Expanded(child: SizedBox()),
                      Expanded(flex: 2, child: _buildPlayerCard(2)),
                      const Expanded(child: SizedBox()),
                    ],
                  ),
                ),
              ],
            );
          } else {
            // 2 players - side by side
            return Row(
              children: [
                Expanded(child: _buildPlayerCard(0)),
                const SizedBox(width: 10),
                Expanded(child: _buildPlayerCard(1)),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildPlayerCard(int index) {
    final config = _playerConfigs[index];
    
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            config.color.withOpacity(0.3),
            const Color(0xFF2D1B4E).withOpacity(0.9),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: config.color.withOpacity(0.6), width: 2),
        boxShadow: [BoxShadow(color: config.color.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // Header row: Player number + AI toggle
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [config.color, config.color.withOpacity(0.7)]),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'P${index + 1}',
                    style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
                const Spacer(),
                if (index == 0)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Color(0xFF4ECDC4), Color(0xFF44A08D)]),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.person, color: Colors.white, size: 14),
                        const SizedBox(width: 4),
                        Text(AppLocalizations.of(context)!.you, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  )
                else
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(AppLocalizations.of(context)!.ai, style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12)),
                      SizedBox(
                        height: 28,
                        child: Transform.scale(
                          scale: 0.7,
                          child: Switch(
                            value: config.isAI,
                            onChanged: (value) => setState(() => _playerConfigs[index] = config.copyWith(isAI: value)),
                            activeColor: const Color(0xFF4ECDC4),
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
            
            const SizedBox(height: 4),
            
            // Avatar - centered and tappable, fills available space
            Expanded(
              child: GestureDetector(
                onTap: () => _showAvatarSelector(index),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    // Use most of the available space for the avatar
                    final avatarSize = (constraints.maxHeight * 0.85).clamp(60.0, 140.0);
                    return Center(
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [BoxShadow(color: config.color.withOpacity(0.6), blurRadius: 20, spreadRadius: 6)],
                            ),
                            child: AvatarWidget(
                              avatar: config.avatar ?? Avatars.forPlayerIndex(index),
                              size: avatarSize,
                              borderColor: config.color,
                            ),
                          ),
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(colors: [config.color, config.color.withOpacity(0.7)]),
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2),
                              ),
                              child: const Icon(Icons.edit, color: Colors.white, size: 14),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            
            const SizedBox(height: 4),
            
            // Name input
            SizedBox(
              height: 44,
              child: TextField(
                controller: _nameControllers[index],
                onChanged: (value) => _playerConfigs[index] = config.copyWith(name: value),
                onTap: () {
                  // Select all text when tapped so kids can easily replace the default name
                  _nameControllers[index].selection = TextSelection(
                    baseOffset: 0,
                    extentOffset: _nameControllers[index].text.length,
                  );
                },
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.name,
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.1),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: config.color, width: 2),
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 10),
            
            // Color selector row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _availableColors.map((color) {
                final isSelected = config.color == color;
                final isUsed = _playerConfigs.where((c) => c != config).any((c) => c.color == color);
                return GestureDetector(
                  onTap: isUsed ? null : () => setState(() => _playerConfigs[index] = config.copyWith(color: color)),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 28,
                    height: 28,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [color, color.withOpacity(0.7)]),
                      shape: BoxShape.circle,
                      border: isSelected ? Border.all(color: Colors.white, width: 3) : null,
                      boxShadow: isSelected ? [BoxShadow(color: color.withOpacity(0.6), blurRadius: 8)] : null,
                    ),
                    child: isUsed && !isSelected
                        ? Icon(Icons.close, color: Colors.white.withOpacity(0.5), size: 14)
                        : isSelected
                            ? const Icon(Icons.check, color: Colors.white, size: 16)
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

  void _showAvatarSelector(int playerIndex) {
    final config = _playerConfigs[playerIndex];
    final screenSize = MediaQuery.of(context).size;
    final isLandscape = screenSize.width > screenSize.height;

    if (isLandscape) {
      // Use dialog for landscape mode - better use of horizontal space
      showDialog(
        context: context,
        builder: (context) => Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: screenSize.width * 0.8,
              maxHeight: screenSize.height * 0.85,
            ),
            decoration: BoxDecoration(
              gradient: const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFF764ba2), Color(0xFF667eea)]),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(colors: [Colors.white, Color(0xFFFFE66D)]).createShader(bounds),
                          child: Text(
                            AppLocalizations.of(context)!.chooseYourAvatar,
                            style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close, color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: AvatarSelector(
                      selectedAvatar: config.avatar,
                      onAvatarSelected: (avatar) {
                        setState(() => _playerConfigs[playerIndex] = config.copyWith(avatar: avatar));
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      // Use bottom sheet for portrait mode
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
                    child: Text(
                      AppLocalizations.of(context)!.chooseYourAvatar,
                      style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
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
                      _currentStep == 0 ? AppLocalizations.of(context)!.back : AppLocalizations.of(context)!.previous,
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
                      _currentStep == 0 ? AppLocalizations.of(context)!.next : AppLocalizations.of(context)!.startGame,
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

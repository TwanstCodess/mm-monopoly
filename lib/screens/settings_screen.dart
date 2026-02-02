import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/audio_service.dart';

/// Settings screen for game options
class SettingsScreen extends StatefulWidget {
  final VoidCallback onBack;
  final GameSettings settings;
  final Function(GameSettings) onSettingsChanged;

  const SettingsScreen({super.key, required this.onBack, required this.settings, required this.onSettingsChanged});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> with SingleTickerProviderStateMixin {
  late GameSettings _settings;
  late AnimationController _floatController;

  @override
  void initState() {
    super.initState();
    _settings = widget.settings;
    _floatController = AnimationController(vsync: this, duration: const Duration(milliseconds: 3000))..repeat(reverse: true);
  }

  @override
  void dispose() {
    _floatController.dispose();
    super.dispose();
  }

  void _updateSettings(GameSettings newSettings) {
    setState(() {
      _settings = newSettings;
    });
    widget.onSettingsChanged(newSettings);
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
            // Floating shapes
            ...List.generate(12, (index) => _buildFloatingShape(index)),
            // Main content
            SafeArea(
              child: Column(
                children: [
                  // Custom app bar
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        _buildBackButton(),
                        const SizedBox(width: 16),
                        ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(colors: [Colors.white, Color(0xFFFFE66D)]).createShader(bounds),
                          child: const Text(
                            'Settings',
                            style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Content - single column layout
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // All settings in one card
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Colors.white.withValues(alpha: 0.15), Colors.white.withValues(alpha: 0.05)],
                            ),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                                  // Starting Cash row
                                  Row(
                                    children: [
                                      const Icon(Icons.attach_money, color: Color(0xFFFFE66D), size: 28),
                                      const SizedBox(width: 12),
                                      const Text('Starting Cash', style: TextStyle(color: Colors.white, fontSize: 18)),
                                      const Spacer(),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFFE66D).withValues(alpha: 0.2),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text('\$${_settings.startingCash}', style: const TextStyle(color: Color(0xFFFFE66D), fontSize: 20, fontWeight: FontWeight.bold)),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  SliderTheme(
                                    data: SliderThemeData(
                                      activeTrackColor: const Color(0xFFFFE66D),
                                      inactiveTrackColor: Colors.white.withValues(alpha: 0.2),
                                      thumbColor: const Color(0xFFFFE66D),
                                      trackHeight: 8,
                                      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 14),
                                    ),
                                    child: Slider(
                                      value: _settings.startingCash.toDouble(),
                                      min: 500,
                                      max: 3000,
                                      divisions: 10,
                                      onChanged: (v) => _updateSettings(_settings.copyWith(startingCash: v.toInt())),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  const Divider(color: Colors.white24, thickness: 1),
                                  const SizedBox(height: 8),
                                  // Game toggles
                                  _buildSettingsRow(Icons.swap_horiz, 'Player Trading', _settings.tradingEnabled, (v) => _updateSettings(_settings.copyWith(tradingEnabled: v))),
                                  _buildSettingsRow(Icons.account_balance, 'Bank Features', _settings.bankEnabled, (v) => _updateSettings(_settings.copyWith(bankEnabled: v))),
                                  _buildSettingsRow(Icons.gavel, 'Property Auctions', _settings.auctionEnabled, (v) => _updateSettings(_settings.copyWith(auctionEnabled: v))),
                                  const SizedBox(height: 8),
                                  const Divider(color: Colors.white24, thickness: 1),
                                  const SizedBox(height: 8),
                                  // Audio
                                  _buildSettingsRow(Icons.music_note, 'Background Music', _settings.musicEnabled, (v) {
                                    _updateSettings(_settings.copyWith(musicEnabled: v));
                                    AudioService.instance.setMusicEnabled(v);
                                  }),
                                  _buildSettingsRow(Icons.volume_up, 'Game Sounds', _settings.sfxEnabled, (v) {
                                    _updateSettings(_settings.copyWith(sfxEnabled: v));
                                    AudioService.instance.setSfxEnabled(v);
                                  }),
                                  const SizedBox(height: 8),
                                  const Divider(color: Colors.white24, thickness: 1),
                                  const SizedBox(height: 12),
                                  // Support row
                                  _buildSupportRow(),
                                ],
                              ),
                            ),
                        const SizedBox(height: 24),
                        // Buttons row
                        Row(
                          children: [
                            Expanded(child: _buildCompactResetButton()),
                            const SizedBox(width: 16),
                            Expanded(flex: 2, child: _buildCompactBackButton()),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: widget.onBack,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
          ),
          child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 24),
        ),
      ),
    );
  }

  Widget _buildSettingsRow(IconData icon, String label, bool value, Function(bool) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: Colors.white54, size: 26),
          const SizedBox(width: 16),
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 18)),
          const Spacer(),
          Transform.scale(
            scale: 1.2,
            child: Switch(
              value: value,
              onChanged: onChanged,
              activeThumbColor: const Color(0xFF4ECDC4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSupportRow() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () async {
          final uri = Uri.parse('https://buymeacoffee.com/hao_yu');
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          }
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [const Color(0xFFFFDD00).withValues(alpha: 0.15), const Color(0xFFFF8C00).withValues(alpha: 0.1)],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFFFDD00).withValues(alpha: 0.3)),
          ),
          child: Row(
            children: [
              const Text('☕', style: TextStyle(fontSize: 36)),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Buy me a coffee', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(
                      'Your support helps keep the game free and updated. Every coffee means a lot!',
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 14),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Icon(Icons.open_in_new, color: Colors.white.withValues(alpha: 0.5), size: 22),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompactResetButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          _updateSettings(const GameSettings());
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Settings reset', style: TextStyle(fontSize: 16)),
              backgroundColor: const Color(0xFF4ECDC4),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
          ),
          child: const Center(
            child: Text('Reset', style: TextStyle(color: Colors.white70, fontSize: 18, fontWeight: FontWeight.w600)),
          ),
        ),
      ),
    );
  }

  Widget _buildCompactBackButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: widget.onBack,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)]),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: const Color(0xFFFF6B6B).withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 6))],
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.arrow_back_rounded, color: Colors.white, size: 24),
              SizedBox(width: 10),
              Text('Back to Menu', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingShape(int index) {
    final random = math.Random(index + 300);
    final size = 15.0 + random.nextDouble() * 30;
    final left = random.nextDouble();
    final top = random.nextDouble();
    final colors = [Colors.white.withValues(alpha: 0.08), Colors.yellow.withValues(alpha: 0.1), Colors.pink.withValues(alpha: 0.08), Colors.cyan.withValues(alpha: 0.08)];

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
}

/// Game settings model
class GameSettings {
  final int startingCash;
  final bool tradingEnabled;
  final bool bankEnabled;
  final bool auctionEnabled;
  final bool musicEnabled;
  final bool sfxEnabled;
  final double musicVolume;
  final double sfxVolume;

  const GameSettings({
    this.startingCash = 2000,
    this.tradingEnabled = false,
    this.bankEnabled = false,
    this.auctionEnabled = false,
    this.musicEnabled = true,
    this.sfxEnabled = true,
    this.musicVolume = 0.5,
    this.sfxVolume = 0.7,
  });

  GameSettings copyWith({
    int? startingCash,
    bool? tradingEnabled,
    bool? bankEnabled,
    bool? auctionEnabled,
    bool? musicEnabled,
    bool? sfxEnabled,
    double? musicVolume,
    double? sfxVolume,
  }) {
    return GameSettings(
      startingCash: startingCash ?? this.startingCash,
      tradingEnabled: tradingEnabled ?? this.tradingEnabled,
      bankEnabled: bankEnabled ?? this.bankEnabled,
      auctionEnabled: auctionEnabled ?? this.auctionEnabled,
      musicEnabled: musicEnabled ?? this.musicEnabled,
      sfxEnabled: sfxEnabled ?? this.sfxEnabled,
      musicVolume: musicVolume ?? this.musicVolume,
      sfxVolume: sfxVolume ?? this.sfxVolume,
    );
  }
}

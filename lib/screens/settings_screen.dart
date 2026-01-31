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
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          // All settings in one card
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [Colors.white.withOpacity(0.15), Colors.white.withOpacity(0.05)],
                                ),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.white.withOpacity(0.2)),
                              ),
                              child: Column(
                                children: [
                                  // Starting Cash row
                                  Row(
                                    children: [
                                      const Icon(Icons.attach_money, color: Color(0xFFFFE66D), size: 20),
                                      const SizedBox(width: 8),
                                      const Text('Starting Cash', style: TextStyle(color: Colors.white, fontSize: 14)),
                                      const Spacer(),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFFE66D).withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text('\$${_settings.startingCash}', style: const TextStyle(color: Color(0xFFFFE66D), fontSize: 14, fontWeight: FontWeight.bold)),
                                      ),
                                    ],
                                  ),
                                  SliderTheme(
                                    data: SliderThemeData(
                                      activeTrackColor: const Color(0xFFFFE66D),
                                      inactiveTrackColor: Colors.white.withOpacity(0.2),
                                      thumbColor: const Color(0xFFFFE66D),
                                      trackHeight: 4,
                                      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
                                    ),
                                    child: Slider(
                                      value: _settings.startingCash.toDouble(),
                                      min: 500,
                                      max: 3000,
                                      divisions: 10,
                                      onChanged: (v) => _updateSettings(_settings.copyWith(startingCash: v.toInt())),
                                    ),
                                  ),
                                  const Divider(color: Colors.white24),
                                  // Game toggles
                                  _buildSettingsRow(Icons.swap_horiz, 'Trading', _settings.tradingEnabled, (v) => _updateSettings(_settings.copyWith(tradingEnabled: v))),
                                  _buildSettingsRow(Icons.account_balance, 'Bank', _settings.bankEnabled, (v) => _updateSettings(_settings.copyWith(bankEnabled: v))),
                                  _buildSettingsRow(Icons.gavel, 'Auctions', _settings.auctionEnabled, (v) => _updateSettings(_settings.copyWith(auctionEnabled: v))),
                                  const Divider(color: Colors.white24),
                                  // Audio
                                  _buildSettingsRow(Icons.music_note, 'Music', _settings.musicEnabled, (v) {
                                    _updateSettings(_settings.copyWith(musicEnabled: v));
                                    AudioService.instance.setMusicEnabled(v);
                                  }),
                                  _buildSettingsRow(Icons.volume_up, 'Sound FX', _settings.sfxEnabled, (v) {
                                    _updateSettings(_settings.copyWith(sfxEnabled: v));
                                    AudioService.instance.setSfxEnabled(v);
                                  }),
                                  const Spacer(),
                                  // Support row
                                  _buildSupportRow(),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          // Buttons row
                          Row(
                            children: [
                              Expanded(child: _buildCompactResetButton()),
                              const SizedBox(width: 12),
                              Expanded(flex: 2, child: _buildCompactBackButton()),
                            ],
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
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
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.3)),
          ),
          child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 24),
        ),
      ),
    );
  }

  Widget _buildSettingsRow(IconData icon, String label, bool value, Function(bool) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: Colors.white54, size: 20),
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 14)),
          const Spacer(),
          SizedBox(
            height: 28,
            child: Transform.scale(
              scale: 0.85,
              child: Switch(
                value: value,
                onChanged: onChanged,
                activeColor: const Color(0xFF4ECDC4),
              ),
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
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [const Color(0xFFFFDD00).withOpacity(0.15), const Color(0xFFFF8C00).withOpacity(0.1)],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFFFDD00).withOpacity(0.3)),
          ),
          child: Row(
            children: [
              const Text('☕', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 10),
              const Text('Buy me a coffee', style: TextStyle(color: Colors.white, fontSize: 14)),
              const Spacer(),
              Icon(Icons.open_in_new, color: Colors.white.withOpacity(0.5), size: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompactGameSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white.withOpacity(0.15), Colors.white.withOpacity(0.05)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(Icons.sports_esports_rounded, color: const Color(0xFF4ECDC4), size: 20),
              const SizedBox(width: 8),
              const Text('Game', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 16),
          // Starting cash
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Starting Cash', style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 13)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE66D).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text('\$${_settings.startingCash}', style: const TextStyle(color: Color(0xFFFFE66D), fontSize: 14, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: const Color(0xFFFFE66D),
              inactiveTrackColor: Colors.white.withOpacity(0.2),
              thumbColor: const Color(0xFFFFE66D),
              trackHeight: 4,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
            ),
            child: Slider(
              value: _settings.startingCash.toDouble(),
              min: 500,
              max: 3000,
              divisions: 10,
              onChanged: (v) => _updateSettings(_settings.copyWith(startingCash: v.toInt())),
            ),
          ),
          const Spacer(),
          // Toggles
          _buildCompactToggle('Trading', _settings.tradingEnabled, (v) => _updateSettings(_settings.copyWith(tradingEnabled: v))),
          const SizedBox(height: 8),
          _buildCompactToggle('Bank', _settings.bankEnabled, (v) => _updateSettings(_settings.copyWith(bankEnabled: v))),
          const SizedBox(height: 8),
          _buildCompactToggle('Auctions', _settings.auctionEnabled, (v) => _updateSettings(_settings.copyWith(auctionEnabled: v))),
        ],
      ),
    );
  }

  Widget _buildCompactToggle(String label, bool value, Function(bool) onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 13)),
        SizedBox(
          height: 24,
          child: Transform.scale(
            scale: 0.8,
            child: Switch(
              value: value,
              onChanged: onChanged,
              activeColor: const Color(0xFF4ECDC4),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCompactAudioSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white.withOpacity(0.15), Colors.white.withOpacity(0.05)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(Icons.headphones_rounded, color: const Color(0xFFFF6B9D), size: 20),
              const SizedBox(width: 8),
              const Text('Audio', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 16),
          // Music
          _buildCompactToggle('Music', _settings.musicEnabled, (v) {
            _updateSettings(_settings.copyWith(musicEnabled: v));
            AudioService.instance.setMusicEnabled(v);
          }),
          if (_settings.musicEnabled) ...[
            const SizedBox(height: 4),
            _buildCompactSlider(_settings.musicVolume, const Color(0xFFFF6B9D), (v) {
              _updateSettings(_settings.copyWith(musicVolume: v));
              AudioService.instance.setMusicVolume(v);
            }),
          ],
          const SizedBox(height: 12),
          // SFX
          _buildCompactToggle('Sound FX', _settings.sfxEnabled, (v) {
            _updateSettings(_settings.copyWith(sfxEnabled: v));
            AudioService.instance.setSfxEnabled(v);
          }),
          if (_settings.sfxEnabled) ...[
            const SizedBox(height: 4),
            _buildCompactSlider(_settings.sfxVolume, const Color(0xFF4ECDC4), (v) {
              _updateSettings(_settings.copyWith(sfxVolume: v));
              AudioService.instance.setSfxVolume(v);
            }),
          ],
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildCompactSlider(double value, Color color, Function(double) onChanged) {
    return SliderTheme(
      data: SliderThemeData(
        activeTrackColor: color,
        inactiveTrackColor: Colors.white.withOpacity(0.2),
        thumbColor: color,
        trackHeight: 3,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
      ),
      child: Slider(value: value, min: 0, max: 1, onChanged: onChanged),
    );
  }

  Widget _buildCompactSupportSection() {
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
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [const Color(0xFFFFDD00).withOpacity(0.2), const Color(0xFFFF8C00).withOpacity(0.15)],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFFFDD00).withOpacity(0.3)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('☕', style: TextStyle(fontSize: 24)),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Enjoying the game?', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                  Text('Buy me a coffee', style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12)),
                ],
              ),
              const Spacer(),
              Icon(Icons.arrow_forward_ios, color: Colors.white.withOpacity(0.5), size: 16),
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
              content: const Text('Settings reset'),
              backgroundColor: const Color(0xFF4ECDC4),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: const Center(
            child: Text('Reset', style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w600)),
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
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)]),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: const Color(0xFFFF6B6B).withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))],
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.arrow_back_rounded, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Text('Back to Menu', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
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

  Widget _buildSectionTitle(String title, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(color: color.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 10),
          Text(
            title,
            style: TextStyle(
              color: color,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
              shadows: [Shadow(color: color.withOpacity(0.3), blurRadius: 4)],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStartingCashCard() {
    const color = Color(0xFFFFE66D);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Colors.white.withOpacity(0.2), Colors.white.withOpacity(0.1)]),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
        boxShadow: [BoxShadow(color: color.withOpacity(0.2), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [color, color.withOpacity(0.7)]),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [BoxShadow(color: color.withOpacity(0.4), blurRadius: 8, offset: const Offset(0, 4))],
                ),
                child: const Icon(Icons.attach_money_rounded, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Starting Cash',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text('Each player begins with this amount', style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 13)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Amount display
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: color.withOpacity(0.5), width: 2),
              ),
              child: Text(
                '\$${_settings.startingCash}',
                style: TextStyle(
                  color: color,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  shadows: [Shadow(color: color.withOpacity(0.5), blurRadius: 8)],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Slider
          SliderTheme(
            data: SliderThemeData(activeTrackColor: color, inactiveTrackColor: Colors.white.withOpacity(0.2), thumbColor: color, overlayColor: color.withOpacity(0.2), trackHeight: 8, thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12)),
            child: Slider(
              value: _settings.startingCash.toDouble(),
              min: 500,
              max: 3000,
              divisions: 10,
              onChanged: (value) {
                _updateSettings(_settings.copyWith(startingCash: value.toInt()));
              },
            ),
          ),
          // Min/Max labels
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('\$500', style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12)),
                Text('\$3000', style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdvancedFeaturesSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Colors.white.withOpacity(0.15), Colors.white.withOpacity(0.08)]),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Colors.teal, Color(0xFF00796B)]),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.tune_rounded, color: Colors.white, size: 22),
              ),
              const SizedBox(width: 12),
              const Text(
                'Advanced Features',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Trading toggle
          _buildToggleOption(
            icon: Icons.swap_horiz_rounded,
            title: 'Player Trading',
            subtitle: 'Allow players to trade properties',
            value: _settings.tradingEnabled,
            onChanged: (value) {
              _updateSettings(_settings.copyWith(tradingEnabled: value));
            },
          ),
          const SizedBox(height: 12),
          // Bank toggle
          _buildToggleOption(
            icon: Icons.account_balance_rounded,
            title: 'Bank Features',
            subtitle: 'Sell properties to bank for quick cash',
            value: _settings.bankEnabled,
            onChanged: (value) {
              _updateSettings(_settings.copyWith(bankEnabled: value));
            },
          ),
          const SizedBox(height: 12),
          // Auction toggle
          _buildToggleOption(
            icon: Icons.gavel_rounded,
            title: 'Property Auctions',
            subtitle: 'Auction unclaimed properties (for older kids)',
            value: _settings.auctionEnabled,
            onChanged: (value) {
              _updateSettings(_settings.copyWith(auctionEnabled: value));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildToggleOption({required IconData icon, required String title, required String subtitle, required bool value, required Function(bool) onChanged}) {
    return Row(
      children: [
        Icon(icon, color: Colors.white.withOpacity(0.7), size: 24),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
              ),
              Text(subtitle, style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12)),
            ],
          ),
        ),
        Switch(value: value, onChanged: onChanged, activeColor: Colors.teal, activeTrackColor: Colors.teal.withOpacity(0.5), inactiveThumbColor: Colors.white.withOpacity(0.5), inactiveTrackColor: Colors.white.withOpacity(0.2)),
      ],
    );
  }

  Widget _buildAudioSection() {
    const musicColor = Color(0xFFFF6B9D);
    const sfxColor = Color(0xFF4ECDC4);
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white.withOpacity(0.15), Colors.white.withOpacity(0.08)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFFF6B9D), Color(0xFFFF8E53)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.audiotrack_rounded, color: Colors.white, size: 22),
              ),
              const SizedBox(width: 12),
              const Text(
                'Audio Settings',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // Music toggle and volume
          _buildAudioControl(
            icon: Icons.music_note_rounded,
            title: 'Background Music',
            subtitle: 'Menu and in-game music',
            color: musicColor,
            enabled: _settings.musicEnabled,
            volume: _settings.musicVolume,
            onToggle: (value) {
              _updateSettings(_settings.copyWith(musicEnabled: value));
              AudioService.instance.setMusicEnabled(value);
            },
            onVolumeChanged: (value) {
              _updateSettings(_settings.copyWith(musicVolume: value));
              AudioService.instance.setMusicVolume(value);
            },
          ),
          
          const SizedBox(height: 16),
          
          // SFX toggle and volume
          _buildAudioControl(
            icon: Icons.volume_up_rounded,
            title: 'Sound Effects',
            subtitle: 'Dice, coins, cards, and more',
            color: sfxColor,
            enabled: _settings.sfxEnabled,
            volume: _settings.sfxVolume,
            onToggle: (value) {
              _updateSettings(_settings.copyWith(sfxEnabled: value));
              AudioService.instance.setSfxEnabled(value);
            },
            onVolumeChanged: (value) {
              _updateSettings(_settings.copyWith(sfxVolume: value));
              AudioService.instance.setSfxVolume(value);
              // Play a sample sound when adjusting
              if (_settings.sfxEnabled) {
                AudioService.instance.onButtonTap();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAudioControl({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required bool enabled,
    required double volume,
    required Function(bool) onToggle,
    required Function(double) onVolumeChanged,
  }) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: color.withOpacity(enabled ? 0.2 : 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: enabled ? color : Colors.white.withOpacity(0.3),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: enabled ? Colors.white : Colors.white.withOpacity(0.5),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.white.withOpacity(enabled ? 0.6 : 0.3),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Switch(
              value: enabled,
              onChanged: onToggle,
              activeColor: color,
              activeTrackColor: color.withOpacity(0.5),
              inactiveThumbColor: Colors.white.withOpacity(0.5),
              inactiveTrackColor: Colors.white.withOpacity(0.2),
            ),
          ],
        ),
        if (enabled) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.volume_mute_rounded,
                color: Colors.white.withOpacity(0.4),
                size: 16,
              ),
              Expanded(
                child: SliderTheme(
                  data: SliderThemeData(
                    activeTrackColor: color,
                    inactiveTrackColor: Colors.white.withOpacity(0.2),
                    thumbColor: color,
                    overlayColor: color.withOpacity(0.2),
                    trackHeight: 4,
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
                  ),
                  child: Slider(
                    value: volume,
                    min: 0.0,
                    max: 1.0,
                    onChanged: onVolumeChanged,
                  ),
                ),
              ),
              Icon(
                Icons.volume_up_rounded,
                color: Colors.white.withOpacity(0.4),
                size: 16,
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildSupportSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFFFDD00).withOpacity(0.2),
            const Color(0xFFFF8C00).withOpacity(0.15),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFFDD00).withOpacity(0.3)),
      ),
      child: Column(
        children: [
          const Text(
            '☕',
            style: TextStyle(fontSize: 40),
          ),
          const SizedBox(height: 12),
          const Text(
            'Enjoying the game?',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your support helps keep this game free and updated!',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 13,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Material(
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
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFDD00), Color(0xFFFF8C00)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFFDD00).withOpacity(0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('☕', style: TextStyle(fontSize: 20)),
                    SizedBox(width: 8),
                    Text(
                      'Buy me a coffee',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComingSoonSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.15)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.construction_rounded, color: Colors.white.withOpacity(0.6), size: 24),
              const SizedBox(width: 10),
              Text(
                'Coming Soon',
                style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: [
              _buildComingSoonChip(Icons.smart_toy_rounded, 'AI Speed'),
              _buildComingSoonChip(Icons.vibration_rounded, 'Haptics'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildComingSoonChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white.withOpacity(0.5), size: 16),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildBackToMenuButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: widget.onBack,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)]),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(color: const Color(0xFFFF6B6B).withOpacity(0.4), blurRadius: 12, offset: const Offset(0, 6))],
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.arrow_back_rounded, color: Colors.white, size: 24),
              SizedBox(width: 10),
              Text(
                'Back to Menu',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResetButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          _updateSettings(const GameSettings());
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.white),
                  SizedBox(width: 12),
                  Text('Settings reset to defaults'),
                ],
              ),
              backgroundColor: const Color(0xFF4ECDC4),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          );
        },
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.refresh_rounded, color: Colors.white.withOpacity(0.9), size: 24),
              const SizedBox(width: 10),
              Text(
                'Reset to Defaults',
                style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
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

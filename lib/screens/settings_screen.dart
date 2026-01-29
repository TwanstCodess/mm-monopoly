import 'package:flutter/material.dart';
import '../config/theme.dart';

/// Settings screen for game options
class SettingsScreen extends StatefulWidget {
  final VoidCallback onBack;
  final GameSettings settings;
  final Function(GameSettings) onSettingsChanged;

  const SettingsScreen({
    super.key,
    required this.onBack,
    required this.settings,
    required this.onSettingsChanged,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late GameSettings _settings;

  @override
  void initState() {
    super.initState();
    _settings = widget.settings;
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
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(4),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
            onPressed: widget.onBack,
            style: IconButton.styleFrom(
              backgroundColor: AppTheme.primary.withOpacity(0.2),
              minimumSize: const Size(48, 48),
            ),
          ),
        ),
        title: const Text(
          'Settings',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildSectionTitle('Audio'),
          _buildSwitchTile(
            icon: Icons.music_note,
            title: 'Background Music',
            subtitle: 'Play music during the game',
            value: _settings.musicEnabled,
            onChanged: (value) {
              _updateSettings(_settings.copyWith(musicEnabled: value));
            },
          ),
          _buildSwitchTile(
            icon: Icons.volume_up,
            title: 'Sound Effects',
            subtitle: 'Play sounds for dice, moves, etc.',
            value: _settings.soundEnabled,
            onChanged: (value) {
              _updateSettings(_settings.copyWith(soundEnabled: value));
            },
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('Gameplay'),
          _buildSwitchTile(
            icon: Icons.speed,
            title: 'Fast AI Turns',
            subtitle: 'Speed up AI player decisions',
            value: _settings.fastAI,
            onChanged: (value) {
              _updateSettings(_settings.copyWith(fastAI: value));
            },
          ),
          _buildSwitchTile(
            icon: Icons.animation,
            title: 'Animations',
            subtitle: 'Show movement animations',
            value: _settings.animationsEnabled,
            onChanged: (value) {
              _updateSettings(_settings.copyWith(animationsEnabled: value));
            },
          ),
          _buildSliderTile(
            icon: Icons.attach_money,
            title: 'Starting Cash',
            subtitle: 'Each player starts with \$${_settings.startingCash}',
            value: _settings.startingCash.toDouble(),
            min: 500,
            max: 3000,
            divisions: 10,
            onChanged: (value) {
              _updateSettings(_settings.copyWith(startingCash: value.toInt()));
            },
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('Display'),
          _buildSwitchTile(
            icon: Icons.vibration,
            title: 'Haptic Feedback',
            subtitle: 'Vibrate on interactions',
            value: _settings.hapticEnabled,
            onChanged: (value) {
              _updateSettings(_settings.copyWith(hapticEnabled: value));
            },
          ),
          const SizedBox(height: 40),
          // Back to Menu button
          ElevatedButton(
            onPressed: widget.onBack,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.arrow_back),
                SizedBox(width: 8),
                Text('Back to Menu', style: TextStyle(fontSize: 16)),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Reset button
          OutlinedButton(
            onPressed: () {
              _updateSettings(const GameSettings());
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Settings reset to defaults'),
                  backgroundColor: AppTheme.primary,
                ),
              );
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white70,
              side: const BorderSide(color: Colors.white24),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.refresh),
                SizedBox(width: 8),
                Text('Reset to Defaults'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          color: AppTheme.primary,
          fontSize: 14,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white12),
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppTheme.primary.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppTheme.primary, size: 22),
        ),
        title: Text(
          title,
          style: const TextStyle(color: Colors.white),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12),
        ),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeColor: AppTheme.primary,
        ),
      ),
    );
  }

  Widget _buildSliderTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required ValueChanged<double> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white12),
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
                  color: AppTheme.primary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: AppTheme.primary, size: 22),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(color: Colors.white),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            activeColor: AppTheme.primary,
            inactiveColor: Colors.white24,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

/// Game settings model
class GameSettings {
  final bool musicEnabled;
  final bool soundEnabled;
  final bool fastAI;
  final bool animationsEnabled;
  final int startingCash;
  final bool hapticEnabled;

  const GameSettings({
    this.musicEnabled = true,
    this.soundEnabled = true,
    this.fastAI = false,
    this.animationsEnabled = true,
    this.startingCash = 2000,
    this.hapticEnabled = true,
  });

  GameSettings copyWith({
    bool? musicEnabled,
    bool? soundEnabled,
    bool? fastAI,
    bool? animationsEnabled,
    int? startingCash,
    bool? hapticEnabled,
  }) {
    return GameSettings(
      musicEnabled: musicEnabled ?? this.musicEnabled,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      fastAI: fastAI ?? this.fastAI,
      animationsEnabled: animationsEnabled ?? this.animationsEnabled,
      startingCash: startingCash ?? this.startingCash,
      hapticEnabled: hapticEnabled ?? this.hapticEnabled,
    );
  }
}

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../l10n/app_localizations.dart';
import '../services/audio_service.dart';
import '../services/locale_service.dart';
import '../services/game_content_loader.dart';
import '../utils/currency_utils.dart';

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

class _SettingsScreenState extends State<SettingsScreen>
    with SingleTickerProviderStateMixin {
  late GameSettings _settings;
  late AnimationController _floatController;

  @override
  void initState() {
    super.initState();
    _settings = widget.settings;
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat(reverse: true);
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
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF667eea), Color(0xFF764ba2), Color(0xFFf093fb)],
          ),
        ),
        child: Stack(
          children: [
            // Floating shapes
            ...List.generate(12, (index) => _buildFloatingShape(index)),
            // Main content
            SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isCompact = constraints.maxHeight < 500;
                  final horizontalPadding = isCompact ? 20.0 : 32.0;
                  final cardPadding = isCompact ? 16.0 : 24.0;

                  return Column(
                    children: [
                      // Custom app bar
                      Padding(
                        padding: EdgeInsets.all(isCompact ? 12 : 16),
                        child: Row(
                          children: [
                            _buildBackButton(),
                            const SizedBox(width: 16),
                            ShaderMask(
                              shaderCallback: (bounds) => const LinearGradient(
                                colors: [Colors.white, Color(0xFFFFE66D)],
                              ).createShader(bounds),
                              child: Text(
                                AppLocalizations.of(context)!.settings,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: isCompact ? 20 : 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Content - scrollable
                      Expanded(
                        child: SingleChildScrollView(
                          padding: EdgeInsets.symmetric(
                            horizontal: horizontalPadding,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // All settings in one card
                              Container(
                                padding: EdgeInsets.all(cardPadding),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Colors.white.withValues(alpha: 0.15),
                                      Colors.white.withValues(alpha: 0.05),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.2),
                                  ),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // Starting Cash row
                                    Row(
                                      children: [
                                        Text(
                                          CurrencyUtils.symbolForLocale(
                                            Localizations.localeOf(context),
                                          ),
                                          style: TextStyle(
                                            color: const Color(0xFFFFE66D),
                                            fontSize: isCompact ? 24 : 28,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(width: isCompact ? 8 : 12),
                                        Text(
                                          AppLocalizations.of(
                                            context,
                                          )!.startingCash,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: isCompact ? 16 : 18,
                                          ),
                                        ),
                                        const Spacer(),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: isCompact ? 12 : 16,
                                            vertical: isCompact ? 6 : 8,
                                          ),
                                          decoration: BoxDecoration(
                                            color: const Color(
                                              0xFFFFE66D,
                                            ).withValues(alpha: 0.2),
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          child: Text(
                                            CurrencyUtils.format(
                                              context,
                                              _settings.startingCash,
                                            ),
                                            style: TextStyle(
                                              color: const Color(0xFFFFE66D),
                                              fontSize: isCompact ? 16 : 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: isCompact ? 4 : 8),
                                    SliderTheme(
                                      data: SliderThemeData(
                                        activeTrackColor: const Color(
                                          0xFFFFE66D,
                                        ),
                                        inactiveTrackColor: Colors.white
                                            .withValues(alpha: 0.2),
                                        thumbColor: const Color(0xFFFFE66D),
                                        trackHeight: isCompact ? 6 : 8,
                                        thumbShape: RoundSliderThumbShape(
                                          enabledThumbRadius: isCompact
                                              ? 10
                                              : 14,
                                        ),
                                      ),
                                      child: Slider(
                                        value: _settings.startingCash
                                            .toDouble(),
                                        min: 500,
                                        max: 3000,
                                        divisions: 10,
                                        onChanged: (v) => _updateSettings(
                                          _settings.copyWith(
                                            startingCash: v.toInt(),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: isCompact ? 4 : 8),
                                    const Divider(
                                      color: Colors.white24,
                                      thickness: 1,
                                    ),
                                    SizedBox(height: isCompact ? 4 : 8),
                                    // Game toggles
                                    _buildSettingsRow(
                                      Icons.swap_horiz,
                                      AppLocalizations.of(
                                        context,
                                      )!.playerTrading,
                                      _settings.tradingEnabled,
                                      (v) => _updateSettings(
                                        _settings.copyWith(tradingEnabled: v),
                                      ),
                                      isCompact: isCompact,
                                    ),
                                    _buildSettingsRow(
                                      Icons.account_balance,
                                      AppLocalizations.of(
                                        context,
                                      )!.bankFeatures,
                                      _settings.bankEnabled,
                                      (v) => _updateSettings(
                                        _settings.copyWith(bankEnabled: v),
                                      ),
                                      isCompact: isCompact,
                                    ),
                                    _buildSettingsRow(
                                      Icons.gavel,
                                      AppLocalizations.of(
                                        context,
                                      )!.propertyAuctions,
                                      _settings.auctionEnabled,
                                      (v) => _updateSettings(
                                        _settings.copyWith(auctionEnabled: v),
                                      ),
                                      isCompact: isCompact,
                                    ),
                                    SizedBox(height: isCompact ? 4 : 8),
                                    const Divider(
                                      color: Colors.white24,
                                      thickness: 1,
                                    ),
                                    SizedBox(height: isCompact ? 4 : 8),
                                    // Audio
                                    _buildSettingsRow(
                                      Icons.music_note,
                                      AppLocalizations.of(
                                        context,
                                      )!.backgroundMusic,
                                      _settings.musicEnabled,
                                      (v) {
                                        _updateSettings(
                                          _settings.copyWith(musicEnabled: v),
                                        );
                                        AudioService.instance.setMusicEnabled(
                                          v,
                                        );
                                      },
                                      isCompact: isCompact,
                                    ),
                                    _buildSettingsRow(
                                      Icons.volume_up,
                                      AppLocalizations.of(context)!.gameSounds,
                                      _settings.sfxEnabled,
                                      (v) {
                                        _updateSettings(
                                          _settings.copyWith(sfxEnabled: v),
                                        );
                                        AudioService.instance.setSfxEnabled(v);
                                      },
                                      isCompact: isCompact,
                                    ),
                                    SizedBox(height: isCompact ? 4 : 8),
                                    const Divider(
                                      color: Colors.white24,
                                      thickness: 1,
                                    ),
                                    SizedBox(height: isCompact ? 4 : 8),
                                    // Language
                                    _buildLanguageRow(isCompact: isCompact),
                                    SizedBox(height: isCompact ? 4 : 8),
                                    const Divider(
                                      color: Colors.white24,
                                      thickness: 1,
                                    ),
                                    SizedBox(height: isCompact ? 8 : 12),
                                    // Support row
                                    _buildSupportRow(isCompact: isCompact),
                                  ],
                                ),
                              ),
                              SizedBox(height: isCompact ? 16 : 24),
                              // Buttons row
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildCompactResetButton(
                                      isCompact: isCompact,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    flex: 2,
                                    child: _buildCompactBackButton(
                                      isCompact: isCompact,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: isCompact ? 12 : 20),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
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
          child: const Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
            size: 24,
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsRow(
    IconData icon,
    String label,
    bool value,
    Function(bool) onChanged, {
    bool isCompact = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: isCompact ? 6 : 10),
      child: Row(
        children: [
          Icon(icon, color: Colors.white54, size: isCompact ? 22 : 26),
          SizedBox(width: isCompact ? 12 : 16),
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: isCompact ? 15 : 18,
            ),
          ),
          const Spacer(),
          Transform.scale(
            scale: isCompact ? 1.0 : 1.2,
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

  Widget _buildLanguageRow({bool isCompact = false}) {
    final localeService = LocaleService.instance;
    return ValueListenableBuilder<Locale>(
      valueListenable: localeService.localeNotifier,
      builder: (context, _, __) {
        final selectedCode = localeService.selectedCode;
        return Padding(
          padding: EdgeInsets.symmetric(vertical: isCompact ? 6 : 10),
          child: Row(
            children: [
              Icon(
                Icons.language,
                color: Colors.white54,
                size: isCompact ? 22 : 26,
              ),
              SizedBox(width: isCompact ? 12 : 16),
              Text(
                AppLocalizations.of(context)!.language,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isCompact ? 15 : 18,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2),
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedCode,
                    dropdownColor: const Color(0xFF764ba2),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isCompact ? 14 : 16,
                    ),
                    icon: const Icon(
                      Icons.arrow_drop_down,
                      color: Colors.white70,
                    ),
                    isDense: true,
                    items: [
                      DropdownMenuItem(
                        value: LocaleService.systemLocaleCode,
                        child: Text(
                          localeService.getDisplayName(
                            LocaleService.systemLocaleCode,
                          ),
                        ),
                      ),
                      ...LocaleService.supportedLocales.map((locale) {
                        return DropdownMenuItem(
                          value: locale.languageCode,
                          child: Text(
                            localeService.getDisplayName(locale.languageCode),
                          ),
                        );
                      }),
                    ],
                    onChanged: (code) {
                      if (code != null) {
                        GameContentLoader.instance.clearCache();
                        if (code == LocaleService.systemLocaleCode) {
                          localeService.setSystemLocale();
                        } else {
                          localeService.setLocale(Locale(code));
                        }
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSupportRow({bool isCompact = false}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          _showExternalLinkDialog(context);
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: EdgeInsets.all(isCompact ? 12 : 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFFFFDD00).withValues(alpha: 0.15),
                const Color(0xFFFF8C00).withValues(alpha: 0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFFFFDD00).withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            children: [
              Text('☕', style: TextStyle(fontSize: isCompact ? 28 : 36)),
              SizedBox(width: isCompact ? 12 : 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.buyMeACoffee,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isCompact ? 15 : 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (!isCompact) ...[
                      const SizedBox(height: 4),
                      Text(
                        AppLocalizations.of(context)!.buyMeACoffeeDesc,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.6),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              SizedBox(width: isCompact ? 8 : 12),
              Icon(
                Icons.open_in_new,
                color: Colors.white.withValues(alpha: 0.5),
                size: isCompact ? 18 : 22,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showExternalLinkDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 320),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF667eea), Color(0xFF764ba2)],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 20,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFDD00).withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text('☕', style: TextStyle(fontSize: 28)),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                AppLocalizations.of(context)!.openExternalLink,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                AppLocalizations.of(context)!.openBuyMeACoffeeDesc,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 15,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: Colors.white.withValues(alpha: 0.3),
                          ),
                        ),
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.cancel,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        Navigator.of(context).pop();
                        final uri = Uri.parse(
                          'https://buymeacoffee.com/hao_yu',
                        );
                        await launchUrl(
                          uri,
                          mode: LaunchMode.externalApplication,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFDD00),
                        foregroundColor: Colors.black87,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.open,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompactResetButton({bool isCompact = false}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          _updateSettings(const GameSettings());
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                AppLocalizations.of(context)!.settingsReset,
                style: const TextStyle(fontSize: 16),
              ),
              backgroundColor: const Color(0xFF4ECDC4),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: isCompact ? 12 : 18),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
          ),
          child: Center(
            child: Text(
              AppLocalizations.of(context)!.reset,
              style: TextStyle(
                color: Colors.white70,
                fontSize: isCompact ? 15 : 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCompactBackButton({bool isCompact = false}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: widget.onBack,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: isCompact ? 12 : 18),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFF6B6B).withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.arrow_back_rounded,
                color: Colors.white,
                size: isCompact ? 20 : 24,
              ),
              SizedBox(width: isCompact ? 8 : 10),
              Text(
                AppLocalizations.of(context)!.backToMenu,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isCompact ? 15 : 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
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
    final colors = [
      Colors.white.withValues(alpha: 0.08),
      Colors.yellow.withValues(alpha: 0.1),
      Colors.pink.withValues(alpha: 0.08),
      Colors.cyan.withValues(alpha: 0.08),
    ];

    return AnimatedBuilder(
      animation: _floatController,
      builder: (context, child) {
        return Positioned(
          left: MediaQuery.of(context).size.width * left,
          top: MediaQuery.of(context).size.height * top,
          child: Transform.translate(
            offset: Offset(
              math.sin(_floatController.value * math.pi * 2 + index) * 6,
              math.cos(_floatController.value * math.pi * 2 + index * 0.5) * 6,
            ),
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: colors[index % colors.length],
                shape: index % 3 == 0 ? BoxShape.circle : BoxShape.rectangle,
                borderRadius: index % 3 != 0 ? BorderRadius.circular(6) : null,
              ),
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

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service for managing app locale/language selection with persistence
class LocaleService {
  static final LocaleService instance = LocaleService._();
  LocaleService._();

  static const String _localeKey = 'app_locale';

  /// Special value meaning "use device language"
  static const String systemLocaleCode = 'system';

  /// Supported locales for translations
  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('zh'),
    Locale('ja'),
    Locale('es'),
    Locale('fr'),
  ];

  /// Display names for each locale (shown in their own language)
  static const Map<String, String> localeDisplayNames = {
    'system': 'System',
    'en': 'English',
    'zh': '中文',
    'ja': '日本語',
    'es': 'Español',
    'fr': 'Français',
  };

  /// Notifier that triggers app rebuild when locale changes
  final ValueNotifier<Locale> localeNotifier = ValueNotifier(const Locale('en'));

  /// Whether the user chose "System" (device default)
  bool _isSystemLocale = true;

  /// Whether using system/device locale
  bool get isSystemLocale => _isSystemLocale;

  /// Current locale
  Locale get currentLocale => localeNotifier.value;

  /// The raw selection code: 'system' or a language code
  String get selectedCode => _isSystemLocale ? systemLocaleCode : currentLocale.languageCode;

  late SharedPreferences _prefs;

  /// Initialize the service, loading saved locale from preferences
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    final savedLocale = _prefs.getString(_localeKey);
    if (savedLocale == null || savedLocale == systemLocaleCode) {
      // Use device locale, fall back to 'en' if unsupported
      _isSystemLocale = true;
      localeNotifier.value = _resolveSystemLocale();
    } else if (supportedLocales.any((l) => l.languageCode == savedLocale)) {
      _isSystemLocale = false;
      localeNotifier.value = Locale(savedLocale);
    }
  }

  /// Resolve the device locale to a supported one, falling back to English
  Locale _resolveSystemLocale() {
    final deviceLocale = WidgetsBinding.instance.platformDispatcher.locale;
    if (supportedLocales.any((l) => l.languageCode == deviceLocale.languageCode)) {
      return Locale(deviceLocale.languageCode);
    }
    return const Locale('en');
  }

  /// Change the app locale and persist the choice
  Future<void> setLocale(Locale locale) async {
    _isSystemLocale = false;
    localeNotifier.value = locale;
    await _prefs.setString(_localeKey, locale.languageCode);
  }

  /// Set to system/device locale
  Future<void> setSystemLocale() async {
    _isSystemLocale = true;
    localeNotifier.value = _resolveSystemLocale();
    await _prefs.setString(_localeKey, systemLocaleCode);
  }

  /// Get display name for a locale code (including 'system')
  String getDisplayName(String code) {
    return localeDisplayNames[code] ?? code;
  }
}

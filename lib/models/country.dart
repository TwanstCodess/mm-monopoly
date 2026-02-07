import '../l10n/app_localizations.dart';

/// Available countries for the Monopoly game board
enum Country {
  usa('United States', '🇺🇸', 'United States'),
  uk('United Kingdom', '🇬🇧', 'United Kingdom'),
  france('France', '🇫🇷', 'France'),
  japan('Japan', '🇯🇵', '日本'),
  china('China', '🇨🇳', '中国'),
  mexico('Mexico', '🇲🇽', 'México');

  final String displayName;
  final String flag;
  final String nativeName;

  const Country(this.displayName, this.flag, this.nativeName);

  /// Get localized display name using AppLocalizations
  String localizedDisplayName(AppLocalizations l10n) {
    switch (this) {
      case Country.usa:
        return l10n.countryUSA;
      case Country.uk:
        return l10n.countryUK;
      case Country.france:
        return l10n.countryFrance;
      case Country.japan:
        return l10n.countryJapan;
      case Country.china:
        return l10n.countryChina;
      case Country.mexico:
        return l10n.countryMexico;
    }
  }

  /// Get display text with flag and name
  String get displayText => '$flag $displayName';

  /// Get localized display text with flag and name
  String localizedDisplayText(AppLocalizations l10n) => '$flag ${localizedDisplayName(l10n)}';
}

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

  /// Get display text with flag and name
  String get displayText => '$flag $displayName';
}

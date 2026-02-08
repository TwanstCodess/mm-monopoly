import '../l10n/app_localizations.dart';
import 'country.dart';

/// Represents a specific city board within a country
class CityBoard {
  final Country country;
  final String cityId;
  final String displayName;
  final String nativeName;
  final String emoji;
  final bool isDefault;

  const CityBoard({
    required this.country,
    required this.cityId,
    required this.displayName,
    required this.nativeName,
    required this.emoji,
    this.isDefault = false,
  });

  /// The boardId used for localization lookups and board config dispatch.
  /// For default/existing boards, this stays as country.name (backward compatible).
  /// For new boards, this is "{country}_{cityId}" e.g. "japan_osaka"
  String get boardId => isDefault ? country.name : '${country.name}_$cityId';

  /// Get localized city name
  String localizedDisplayName(AppLocalizations l10n) {
    switch (boardId) {
      // Existing defaults
      case 'usa':
        return l10n.cityAtlanticCity;
      case 'uk':
        return l10n.cityLondon;
      case 'france':
        return l10n.cityParis;
      case 'japan':
        return l10n.cityTokyo;
      case 'china':
        return l10n.cityBeijing;
      case 'mexico':
        return l10n.cityMexicoCity;
      // USA
      case 'usa_new_york':
        return l10n.cityNewYork;
      case 'usa_los_angeles':
        return l10n.cityLosAngeles;
      // UK
      case 'uk_edinburgh':
        return l10n.cityEdinburgh;
      case 'uk_manchester':
        return l10n.cityManchester;
      // France
      case 'france_lyon':
        return l10n.cityLyon;
      case 'france_marseille':
        return l10n.cityMarseille;
      // Japan
      case 'japan_osaka':
        return l10n.cityOsaka;
      case 'japan_kyoto':
        return l10n.cityKyoto;
      // China
      case 'china_shanghai':
        return l10n.cityShanghai;
      case 'china_hong_kong':
        return l10n.cityHongKong;
      // Mexico
      case 'mexico_guadalajara':
        return l10n.cityGuadalajara;
      case 'mexico_cancun':
        return l10n.cityCancun;
      default:
        return displayName;
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is CityBoard && boardId == other.boardId;

  @override
  int get hashCode => boardId.hashCode;

  @override
  String toString() => 'CityBoard($boardId)';
}

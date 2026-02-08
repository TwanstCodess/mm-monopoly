import '../models/city_board.dart';
import '../models/country.dart';

/// Registry of all available city boards, grouped by country
class CityBoardRegistry {
  static const List<CityBoard> all = [
    // USA
    CityBoard(country: Country.usa, cityId: 'atlantic_city', displayName: 'Atlantic City', nativeName: 'Atlantic City', emoji: '🎰', isDefault: true),
    CityBoard(country: Country.usa, cityId: 'new_york', displayName: 'New York City', nativeName: 'New York City', emoji: '🗽'),
    CityBoard(country: Country.usa, cityId: 'los_angeles', displayName: 'Los Angeles', nativeName: 'Los Angeles', emoji: '🎬'),

    // UK
    CityBoard(country: Country.uk, cityId: 'london', displayName: 'London', nativeName: 'London', emoji: '💂', isDefault: true),
    CityBoard(country: Country.uk, cityId: 'edinburgh', displayName: 'Edinburgh', nativeName: 'Edinburgh', emoji: '🏰'),
    CityBoard(country: Country.uk, cityId: 'manchester', displayName: 'Manchester', nativeName: 'Manchester', emoji: '⚽'),

    // France
    CityBoard(country: Country.france, cityId: 'paris', displayName: 'Paris', nativeName: 'Paris', emoji: '🗼', isDefault: true),
    CityBoard(country: Country.france, cityId: 'lyon', displayName: 'Lyon', nativeName: 'Lyon', emoji: '🍷'),
    CityBoard(country: Country.france, cityId: 'marseille', displayName: 'Marseille', nativeName: 'Marseille', emoji: '⛵'),

    // Japan
    CityBoard(country: Country.japan, cityId: 'tokyo', displayName: 'Tokyo', nativeName: '東京', emoji: '🗼', isDefault: true),
    CityBoard(country: Country.japan, cityId: 'osaka', displayName: 'Osaka', nativeName: '大阪', emoji: '🏯'),
    CityBoard(country: Country.japan, cityId: 'kyoto', displayName: 'Kyoto', nativeName: '京都', emoji: '⛩️'),

    // China
    CityBoard(country: Country.china, cityId: 'beijing', displayName: 'Beijing', nativeName: '北京', emoji: '🏯', isDefault: true),
    CityBoard(country: Country.china, cityId: 'shanghai', displayName: 'Shanghai', nativeName: '上海', emoji: '🌃'),
    CityBoard(country: Country.china, cityId: 'hong_kong', displayName: 'Hong Kong', nativeName: '香港', emoji: '🌉'),

    // Mexico
    CityBoard(country: Country.mexico, cityId: 'mexico_city', displayName: 'Mexico City', nativeName: 'Ciudad de México', emoji: '🏛️', isDefault: true),
    CityBoard(country: Country.mexico, cityId: 'guadalajara', displayName: 'Guadalajara', nativeName: 'Guadalajara', emoji: '🎺'),
    CityBoard(country: Country.mexico, cityId: 'cancun', displayName: 'Cancún', nativeName: 'Cancún', emoji: '🏖️'),
  ];

  /// Get all city boards for a given country
  static List<CityBoard> forCountry(Country country) =>
      all.where((b) => b.country == country).toList();

  /// Get the default (existing) board for a country
  static CityBoard defaultForCountry(Country country) =>
      all.firstWhere((b) => b.country == country && b.isDefault);

  /// Look up a city board by its boardId string
  static CityBoard? byBoardId(String boardId) {
    for (final board in all) {
      if (board.boardId == boardId) return board;
    }
    return null;
  }
}

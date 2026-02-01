import '../models/tile.dart';
import '../models/country.dart';
import '../models/board_theme.dart';
import 'board_configs/classic_board.dart';
import 'board_configs/uk_board.dart';
import 'board_configs/japan_board.dart';
import 'board_configs/france_board.dart';
import 'board_configs/china_board.dart';
import 'board_configs/mexico_board.dart';

/// Factory class to generate board tiles and themes based on selected country
class BoardFactory {
  /// Generate tiles for the specified country
  static List<TileData> generateTiles(Country country) {
    switch (country) {
      case Country.usa:
        return ClassicBoard.generateTiles();
      case Country.uk:
        return UKBoard.generateTiles();
      case Country.japan:
        return JapanBoard.generateTiles();
      case Country.france:
        return FranceBoard.generateTiles();
      case Country.china:
        return ChinaBoard.generateTiles();
      case Country.mexico:
        return MexicoBoard.generateTiles();
    }
  }

  /// Get property groups for the specified country
  static Map<String, List<int>> getPropertyGroups(Country country) {
    switch (country) {
      case Country.usa:
        return ClassicBoard.propertyGroups;
      case Country.uk:
        return UKBoard.propertyGroups;
      case Country.japan:
        return JapanBoard.propertyGroups;
      case Country.france:
        return FranceBoard.propertyGroups;
      case Country.china:
        return ChinaBoard.propertyGroups;
      case Country.mexico:
        return MexicoBoard.propertyGroups;
    }
  }

  /// Get railroad positions for the specified country
  static List<int> getRailroadPositions(Country country) {
    switch (country) {
      case Country.usa:
        return ClassicBoard.railroadPositions;
      case Country.uk:
        return UKBoard.railroadPositions;
      case Country.japan:
        return JapanBoard.railroadPositions;
      case Country.france:
        return FranceBoard.railroadPositions;
      case Country.china:
        return ChinaBoard.railroadPositions;
      case Country.mexico:
        return MexicoBoard.railroadPositions;
    }
  }

  /// Get board theme for the specified country
  static BoardTheme getTheme(Country country) {
    switch (country) {
      case Country.usa:
        return BoardThemes.usa;
      case Country.uk:
        return BoardThemes.uk;
      case Country.japan:
        return BoardThemes.japan;
      case Country.france:
        return BoardThemes.france;
      case Country.china:
        return BoardThemes.china;
      case Country.mexico:
        return BoardThemes.mexico;
    }
  }
}

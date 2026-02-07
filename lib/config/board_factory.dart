import 'package:flutter/material.dart';
import '../models/tile.dart';
import '../models/country.dart';
import '../models/board_theme.dart';
import '../services/game_content_loader.dart';
import 'board_configs/classic_board.dart';
import 'board_configs/uk_board.dart';
import 'board_configs/japan_board.dart';
import 'board_configs/france_board.dart';
import 'board_configs/china_board.dart';
import 'board_configs/mexico_board.dart';

/// Factory class to generate board tiles and themes based on selected country
class BoardFactory {
  /// Generate tiles for the specified country (sync, uses default English text)
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

  /// Generate tiles with localized text overlays from JSON
  static Future<List<TileData>> generateLocalizedTiles(Country country, Locale locale) async {
    // Get the base tiles (structural data: prices, rents, colors)
    final tiles = generateTiles(country);

    // Load localized text overlays
    final boardId = country.name; // usa, uk, japan, france, china, mexico
    final overlays = await GameContentLoader.instance.loadBoardTiles(boardId, locale);

    if (overlays.isEmpty) return tiles;

    // Build lookup map by index
    final overlayMap = <int, Map<String, dynamic>>{};
    for (final overlay in overlays) {
      overlayMap[overlay['index'] as int] = overlay;
    }

    // Apply text overlays to tiles
    return tiles.map((tile) {
      final overlay = overlayMap[tile.index];
      if (overlay == null) return tile;

      final name = overlay['name'] as String? ?? tile.name;
      final subtext = overlay['subtext'] as String? ?? tile.subtext;
      final funFact = overlay['funFact'] as String? ?? tile.funFact;

      return _applyTextOverlay(tile, name, subtext, funFact);
    }).toList();
  }

  /// Apply localized text to a tile, returning a new tile of the same type
  static TileData _applyTextOverlay(TileData tile, String name, String? subtext, String? funFact) {
    if (tile is PropertyTileData) {
      return PropertyTileData(
        index: tile.index,
        name: name,
        groupId: tile.groupId,
        groupColor: tile.groupColor,
        price: tile.price,
        rentLevels: tile.rentLevels,
        funFact: funFact,
        subtext: subtext,
      );
    } else if (tile is RailroadTileData) {
      return RailroadTileData(
        index: tile.index,
        name: name,
        price: tile.price,
        funFact: funFact,
        subtext: subtext,
      );
    } else if (tile is UtilityTileData) {
      return UtilityTileData(
        index: tile.index,
        name: name,
        isElectric: tile.isElectric,
        price: tile.price,
        funFact: funFact,
      );
    } else if (tile is TaxTileData) {
      return TaxTileData(
        index: tile.index,
        name: name,
        amount: tile.amount,
        percentage: tile.percentage,
      );
    } else if (tile is CardTileData) {
      return CardTileData(
        index: tile.index,
        name: name,
        isChance: tile.isChance,
      );
    } else if (tile is CornerTileData) {
      return CornerTileData(
        index: tile.index,
        name: name,
        type: tile.type,
        color: tile.color,
        subtext: subtext,
      );
    }
    return tile;
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

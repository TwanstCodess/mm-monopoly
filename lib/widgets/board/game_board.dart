import 'package:flutter/material.dart';
import '../../models/player.dart';
import '../../models/tile.dart';
import '../../config/board_configs/classic_board.dart';
import 'tile_widget.dart';
import '../player/player_token.dart';
import '../dice/dice_widget.dart';

/// Main game board widget
class GameBoard extends StatelessWidget {
  final List<Player> players;
  final int currentPlayerIndex;
  final int? highlightedTile;
  final Animation<double> bounceAnimation;
  final AnimationController glowController;
  final Widget? centerControls;
  final List<TileData>? tiles;
  final VoidCallback? onMenuTap;

  const GameBoard({
    super.key,
    required this.players,
    required this.currentPlayerIndex,
    required this.highlightedTile,
    required this.bounceAnimation,
    required this.glowController,
    this.centerControls,
    this.tiles,
    this.onMenuTap,
  });

  @override
  Widget build(BuildContext context) {
    final boardTiles = tiles ?? ClassicBoard.generateTiles();

    return LayoutBuilder(
      builder: (context, constraints) {
        final boardSize = constraints.maxWidth;
        final cornerSize = boardSize * 0.12;
        final tileWidth = (boardSize - cornerSize * 2) / 9;
        final tileHeight = cornerSize;

        return Container(
          width: boardSize,
          height: boardSize,
          decoration: BoxDecoration(
            color: const Color(0xFFCCE5CC),
            border: Border.all(color: Colors.black, width: 3),
            borderRadius: BorderRadius.circular(6),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 20,
                offset: const Offset(5, 5),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Center area
              _CenterArea(
                boardSize: boardSize,
                cornerSize: cornerSize,
                centerControls: centerControls,
                onMenuTap: onMenuTap,
              ),
              // All tiles
              ..._buildAllTiles(boardTiles, boardSize, cornerSize, tileWidth, tileHeight),
              // All player tokens
              ..._buildAllPlayerTokens(boardSize, cornerSize, tileWidth, tileHeight),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _buildAllTiles(
    List<TileData> tileData,
    double boardSize,
    double cornerSize,
    double tileWidth,
    double tileHeight,
  ) {
    return tileData.map((data) {
      final position = _calculateTilePosition(
        data.index,
        boardSize,
        cornerSize,
        tileWidth,
        tileHeight,
      );

      // Find owner color if property is owned
      Color? ownerColor;
      if (data is PropertyTileData && data.ownerId != null) {
        final owner = players.where((p) => p.id == data.ownerId).firstOrNull;
        ownerColor = owner?.color;
      } else if (data is RailroadTileData && data.ownerId != null) {
        final owner = players.where((p) => p.id == data.ownerId).firstOrNull;
        ownerColor = owner?.color;
      } else if (data is UtilityTileData && data.ownerId != null) {
        final owner = players.where((p) => p.id == data.ownerId).firstOrNull;
        ownerColor = owner?.color;
      }

      return PositionedTileWidget(
        data: data,
        position: position,
        isHighlighted: highlightedTile == data.index,
        glowController: glowController,
        ownerColor: ownerColor,
      );
    }).toList();
  }

  TilePosition _calculateTilePosition(
    int index,
    double boardSize,
    double cornerSize,
    double tileWidth,
    double tileHeight,
  ) {
    double left, top, width, height;
    int rotation = 0;

    if (index == 0) {
      // GO corner (bottom-right)
      left = boardSize - cornerSize;
      top = boardSize - cornerSize;
      width = cornerSize;
      height = cornerSize;
    } else if (index < 10) {
      // Bottom row (right to left)
      left = boardSize - cornerSize - (index * tileWidth);
      top = boardSize - tileHeight;
      width = tileWidth;
      height = tileHeight;
    } else if (index == 10) {
      // Jail corner (bottom-left)
      left = 0;
      top = boardSize - cornerSize;
      width = cornerSize;
      height = cornerSize;
    } else if (index < 20) {
      // Left column (bottom to top)
      left = 0;
      top = boardSize - cornerSize - ((index - 10) * tileWidth);
      width = tileHeight;
      height = tileWidth;
      rotation = 1;
    } else if (index == 20) {
      // Free Parking corner (top-left)
      left = 0;
      top = 0;
      width = cornerSize;
      height = cornerSize;
    } else if (index < 30) {
      // Top row (left to right)
      left = cornerSize + ((index - 21) * tileWidth);
      top = 0;
      width = tileWidth;
      height = tileHeight;
      rotation = 2;
    } else if (index == 30) {
      // Go To Jail corner (top-right)
      left = boardSize - cornerSize;
      top = 0;
      width = cornerSize;
      height = cornerSize;
    } else {
      // Right column (top to bottom)
      left = boardSize - tileHeight;
      top = cornerSize + ((index - 31) * tileWidth);
      width = tileHeight;
      height = tileWidth;
      rotation = 3;
    }

    return TilePosition(
      index: index,
      left: left,
      top: top,
      width: width,
      height: height,
      rotation: rotation,
    );
  }

  List<Widget> _buildAllPlayerTokens(
    double boardSize,
    double cornerSize,
    double tileWidth,
    double tileHeight,
  ) {
    final calculator = TokenPositionCalculator(
      boardSize: boardSize,
      cornerSize: cornerSize,
      tileWidth: tileWidth,
      tileHeight: tileHeight,
    );

    final tokenSize = tileWidth * 0.35;

    return players.asMap().entries.map((entry) {
      final index = entry.key;
      final player = entry.value;
      final isCurrentPlayer = index == currentPlayerIndex;

      // Get position with stacking offset
      final pos = calculator.getPlayerPosition(player, players, index);

      return AnimatedPlayerToken(
        player: player,
        position: pos,
        size: tokenSize,
        isCurrentPlayer: isCurrentPlayer,
        bounceAnimation: bounceAnimation,
      );
    }).toList();
  }
}

/// Center area of the board
class _CenterArea extends StatelessWidget {
  final double boardSize;
  final double cornerSize;
  final Widget? centerControls;
  final VoidCallback? onMenuTap;

  const _CenterArea({
    required this.boardSize,
    required this.cornerSize,
    this.centerControls,
    this.onMenuTap,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: cornerSize,
      top: cornerSize,
      right: cornerSize,
      bottom: cornerSize,
      child: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(color: Color(0xFFCCE5CC)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                _buildLogo(),
                const SizedBox(height: 20),
                // Controls (dice + roll button)
                if (centerControls != null) centerControls!,
                if (centerControls != null) const SizedBox(height: 20),
                // Card decks
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    CardDeck(
                      label: 'CHANCE',
                      color: Colors.orange,
                      icon: Icons.help_outline,
                    ),
                    SizedBox(width: 16),
                    CardDeck(
                      label: 'CHEST',
                      color: Colors.blue,
                      icon: Icons.inventory_2,
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Menu button inside board (top-right of center area)
          if (onMenuTap != null)
            Positioned(
              top: 4,
              right: 4,
              child: Material(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(8),
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: onMenuTap,
                  child: const Padding(
                    padding: EdgeInsets.all(8),
                    child: Icon(Icons.menu, color: Colors.white, size: 22),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.red.shade700,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 6,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'M',
                style: TextStyle(
                  color: Colors.yellow.shade300,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                '&',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'M',
                style: TextStyle(
                  color: Colors.green.shade300,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Text(
            'MONOPOLY',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 3,
            ),
          ),
        ],
      ),
    );
  }
}

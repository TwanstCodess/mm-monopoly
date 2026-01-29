import 'package:flutter/material.dart';
import '../../models/tile.dart';

/// Widget for rendering a single tile on the board
class TileWidget extends StatelessWidget {
  final TileData data;
  final bool isCorner;
  final int rotation; // 0=bottom, 1=left, 2=top, 3=right
  final bool isHighlighted;
  final Color? ownerColor; // Color of the player who owns this property

  const TileWidget({
    super.key,
    required this.data,
    required this.isCorner,
    this.rotation = 0,
    this.isHighlighted = false,
    this.ownerColor,
  });

  @override
  Widget build(BuildContext context) {
    // Corner tiles render differently - no owner indicators
    if (isCorner) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: isHighlighted ? Colors.amber : Colors.black,
            width: isHighlighted ? 2 : 1,
          ),
        ),
        child: _buildCornerTile(),
      );
    }

    // Regular tiles with owner/house indicators
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: isHighlighted ? Colors.amber : Colors.black,
          width: isHighlighted ? 2 : 1,
        ),
      ),
      child: Stack(
        children: [
          _buildPropertyTile(),
          // Owner indicator (only for owned properties)
          if (ownerColor != null) _buildOwnerIndicator(),
          // House/hotel indicator (only for upgraded properties)
          if (data is PropertyTileData &&
              (data as PropertyTileData).upgradeLevel > 0)
            _buildHouseIndicator(),
        ],
      ),
    );
  }

  /// Build owner color dot indicator
  Widget _buildOwnerIndicator() {
    return Positioned(
      top: 2,
      right: 2,
      child: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          color: ownerColor,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 2,
            ),
          ],
        ),
      ),
    );
  }

  /// Build house/hotel indicator
  Widget _buildHouseIndicator() {
    final property = data as PropertyTileData;
    final level = property.upgradeLevel;

    if (level == 5) {
      // Hotel - red rectangle
      return Positioned(
        bottom: 2,
        left: 2,
        child: Container(
          width: 10,
          height: 6,
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(1),
            border: Border.all(color: Colors.red.shade900, width: 0.5),
          ),
        ),
      );
    } else {
      // Houses - green squares
      return Positioned(
        bottom: 2,
        left: 2,
        child: Row(
          children: List.generate(
            level,
            (_) => Container(
              width: 4,
              height: 5,
              margin: const EdgeInsets.only(right: 1),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(1),
              ),
            ),
          ),
        ),
      );
    }
  }

  Widget _buildCornerTile() {
    IconData? icon;
    Color iconColor = Colors.black;
    Color bgColor = data.color;

    switch (data.type) {
      case TileType.start:
        icon = Icons.arrow_back;
        iconColor = Colors.red;
        break;
      case TileType.jail:
        icon = Icons.gavel;
        break;
      case TileType.freeParking:
        icon = Icons.local_parking;
        iconColor = Colors.red;
        break;
      case TileType.goToJail:
        icon = Icons.warning;
        iconColor = Colors.orange;
        break;
      default:
        break;
    }

    return Container(
      color: bgColor,
      padding: const EdgeInsets.all(4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) Icon(icon, size: 28, color: iconColor),
          const SizedBox(height: 2),
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                data.name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          if (data.subtext != null)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  data.subtext!,
                  style: const TextStyle(
                    fontSize: 9,
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPropertyTile() {
    // Determine layout based on rotation
    // 0 = bottom row (color band on top, text reads normally)
    // 1 = left column (color band on right, vertical tile)
    // 2 = top row (color band on bottom, text reads normally)
    // 3 = right column (color band on left, vertical tile)

    final isVertical = rotation == 1 || rotation == 3;

    if (isVertical) {
      return _buildVerticalTile();
    } else {
      return _buildHorizontalTile();
    }
  }

  /// Build tile for bottom (rotation=0) or top (rotation=2) row
  Widget _buildHorizontalTile() {
    final colorBandOnTop = rotation == 0;
    final colorBand = _buildColorBand(isHorizontal: true);
    final content = _buildTileContent();

    return Column(
      children: colorBandOnTop
          ? [colorBand, Expanded(child: content)]
          : [Expanded(child: content), colorBand],
    );
  }

  /// Build tile for left (rotation=1) or right (rotation=3) column
  Widget _buildVerticalTile() {
    final colorBandOnRight = rotation == 1;
    final colorBand = _buildColorBand(isHorizontal: false);
    final content = _buildTileContent();

    return Row(
      children: colorBandOnRight
          ? [Expanded(child: content), colorBand]
          : [colorBand, Expanded(child: content)],
    );
  }

  Widget _buildColorBand({required bool isHorizontal}) {
    // Property tiles get a colored band
    // Other tiles get a blank spacer of the same size for alignment
    final hasColorBand = data.type == TileType.property;

    if (isHorizontal) {
      return Container(
        height: 16,
        width: double.infinity,
        decoration: hasColorBand
            ? BoxDecoration(
                color: data.color,
                border: const Border(
                  bottom: BorderSide(color: Colors.black, width: 0.5),
                ),
              )
            : null,
      );
    } else {
      return Container(
        width: 16,
        height: double.infinity,
        decoration: hasColorBand
            ? BoxDecoration(
                color: data.color,
                border: Border(
                  left: rotation == 3
                      ? const BorderSide(color: Colors.black, width: 0.5)
                      : BorderSide.none,
                  right: rotation == 1
                      ? const BorderSide(color: Colors.black, width: 0.5)
                      : BorderSide.none,
                ),
              )
            : null,
      );
    }
  }

  Widget _buildTileContent() {
    final price = _getPrice();

    // For top row (rotation=2), flip the layout so name is at bottom (toward center)
    // For bottom row (rotation=0), name at top (toward center)
    // For left/right columns, name toward center as well
    final nameAtBottom = rotation == 2;

    final nameWidget = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Text(
        _getShortName(),
        textAlign: TextAlign.center,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w800,
          height: 1.1,
          color: Colors.black,
        ),
      ),
    );

    final priceWidget = price != null
        ? Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.green.shade100,
              borderRadius: BorderRadius.circular(3),
            ),
            child: Text(
              '\$$price',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w900,
                color: Colors.green.shade800,
              ),
            ),
          )
        : const SizedBox(height: 16);

    final iconWidget = Expanded(
      child: Center(
        child: _buildTileIcon(),
      ),
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: nameAtBottom
            ? [priceWidget, iconWidget, nameWidget]
            : [nameWidget, iconWidget, priceWidget],
      ),
    );
  }

  /// Get a shortened version of the name for better readability
  String _getShortName() {
    String name = data.name;
    // Shorten common words
    name = name.replaceAll('Avenue', 'Ave');
    name = name.replaceAll('Place', 'Pl');
    name = name.replaceAll('Gardens', 'Gdns');
    name = name.replaceAll('Railroad', 'RR');
    name = name.replaceAll('Electric', 'Elec');
    name = name.replaceAll('Company', 'Co');
    name = name.replaceAll('Water Works', 'Water');
    name = name.replaceAll('Community Chest', 'Comm Chest');
    return name;
  }

  int? _getPrice() {
    if (data is PropertyTileData) {
      return (data as PropertyTileData).price;
    } else if (data is RailroadTileData) {
      return (data as RailroadTileData).price;
    } else if (data is UtilityTileData) {
      return (data as UtilityTileData).price;
    }
    return null;
  }

  Widget _buildTileIcon() {
    switch (data.type) {
      case TileType.railroad:
        return const Icon(Icons.train, size: 16, color: Colors.black87);
      case TileType.utility:
        final isElectric =
            data is UtilityTileData && (data as UtilityTileData).isElectric;
        return Icon(
          isElectric ? Icons.bolt : Icons.water_drop,
          size: 16,
          color: isElectric ? Colors.amber.shade700 : Colors.blue,
        );
      case TileType.chance:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.orange,
            borderRadius: BorderRadius.circular(3),
          ),
          child: const Text(
            '?',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        );
      case TileType.communityChest:
        return Icon(Icons.inventory_2, size: 16, color: Colors.blue.shade700);
      case TileType.tax:
        return const Icon(Icons.diamond, size: 16, color: Colors.purple);
      case TileType.property:
        // Property tiles don't need an icon - they have a color band
        return const SizedBox.shrink();
      default:
        return const SizedBox.shrink();
    }
  }
}

/// Positioned tile widget for use in the board Stack
class PositionedTileWidget extends StatelessWidget {
  final TileData data;
  final TilePosition position;
  final bool isHighlighted;
  final AnimationController? glowController;
  final Color? ownerColor;

  const PositionedTileWidget({
    super.key,
    required this.data,
    required this.position,
    this.isHighlighted = false,
    this.glowController,
    this.ownerColor,
  });

  @override
  Widget build(BuildContext context) {
    Widget tile = TileWidget(
      data: data,
      isCorner: position.isCorner,
      rotation: position.rotation,
      isHighlighted: isHighlighted,
      ownerColor: ownerColor,
    );

    // Add glow effect when highlighted
    if (isHighlighted && glowController != null) {
      tile = AnimatedBuilder(
        animation: glowController!,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.amber
                      .withAlpha((128 + glowController!.value * 127).toInt()),
                  blurRadius: 15,
                  spreadRadius: 3,
                ),
              ],
            ),
            child: AnimatedScale(
              scale: 1.03,
              duration: const Duration(milliseconds: 200),
              child: child,
            ),
          );
        },
        child: tile,
      );
    }

    return Positioned(
      left: position.left,
      top: position.top,
      width: position.width,
      height: position.height,
      child: tile,
    );
  }
}

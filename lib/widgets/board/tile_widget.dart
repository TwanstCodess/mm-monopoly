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
        child: _buildCornerTile(context),
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
          _buildPropertyTile(context),
          // Show ownership indicator:
          // - Small dot when owned but no upgrades
          // - Houses when upgraded (1-4 houses, or hotel at level 5)
          if (ownerColor != null) _buildOwnershipIndicator(),
        ],
      ),
    );
  }

  /// Build ownership indicator
  /// - Small dot when owned but no upgrades
  /// - Houses when upgraded (1-4 houses)
  /// - Hotel at level 5
  Widget _buildOwnershipIndicator() {
    int upgradeLevel = 0;
    if (data is PropertyTileData) {
      upgradeLevel = (data as PropertyTileData).upgradeLevel;
    }

    // Position indicator facing toward center of board (near color band)
    double? top, bottom, left, right;
    bool isVertical = rotation == 1 || rotation == 3;

    // Position near the color band
    switch (rotation) {
      case 0: // Bottom row - at TOP, near color band
        top = 2;
        right = 2;
        break;
      case 1: // Left column - at RIGHT, near color band
        top = 2;
        right = 2;
        break;
      case 2: // Top row - at BOTTOM, near color band
        bottom = 2;
        left = 2;
        break;
      case 3: // Right column - at LEFT, near color band
        bottom = 2;
        left = 2;
        break;
    }

    Widget indicator;

    if (upgradeLevel == 0) {
      // No upgrades - show ownership dot in player color (larger & more visible)
      indicator = Container(
        width: 14,
        height: 14,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [ownerColor!.withOpacity(0.9), ownerColor!],
          ),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
          boxShadow: [
            BoxShadow(
              color: ownerColor!.withOpacity(0.6),
              blurRadius: 4,
              spreadRadius: 1,
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 2,
              offset: const Offset(1, 1),
            ),
          ],
        ),
      );
    } else if (upgradeLevel == 5) {
      // Hotel at level 5
      indicator = _build3DHotel();
    } else {
      // Houses (1-4) in player color
      final houseCount = upgradeLevel.clamp(1, 4);
      indicator =
          isVertical
              ? Column(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  houseCount,
                  (_) => Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: _build3DHouse(ownerColor!),
                  ),
                ),
              )
              : Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  houseCount,
                  (_) => Padding(
                    padding: const EdgeInsets.only(right: 2),
                    child: _build3DHouse(ownerColor!),
                  ),
                ),
              );
    }

    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: indicator,
    );
  }

  /// Build a 3D house widget in player's color
  Widget _build3DHouse(Color playerColor) {
    const houseWidth = 14.0;
    const houseHeight = 16.0;
    const bodyHeight = 9.0;
    const roofHeight = 8.0;

    // Create color variants from the player color
    final HSLColor hsl = HSLColor.fromColor(playerColor);
    final Color darkColor =
        hsl.withLightness((hsl.lightness - 0.3).clamp(0.0, 1.0)).toColor();
    final Color lightColor =
        hsl.withLightness((hsl.lightness + 0.1).clamp(0.0, 1.0)).toColor();
    final Color roofColor =
        hsl.withLightness((hsl.lightness - 0.15).clamp(0.0, 1.0)).toColor();
    final Color roofDarkColor =
        hsl.withLightness((hsl.lightness - 0.25).clamp(0.0, 1.0)).toColor();

    return SizedBox(
      width: houseWidth,
      height: houseHeight,
      child: Stack(
        children: [
          // 3D shadow layer (offset bottom-right)
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: houseWidth - 1,
              height: bodyHeight,
              decoration: BoxDecoration(
                color: darkColor,
                borderRadius: BorderRadius.circular(1),
              ),
            ),
          ),
          // House body (main layer)
          Positioned(
            bottom: 1,
            left: 0,
            child: Container(
              width: houseWidth - 1,
              height: bodyHeight,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [lightColor, playerColor],
                ),
                borderRadius: BorderRadius.circular(1),
                border: Border.all(color: darkColor, width: 0.5),
              ),
            ),
          ),
          // Roof (triangle) - shadow
          Positioned(
            top: 1,
            left: 1,
            child: CustomPaint(
              size: Size(houseWidth - 1, roofHeight),
              painter: _RoofPainter(
                color: roofDarkColor,
                shadowColor: roofDarkColor,
              ),
            ),
          ),
          // Roof (triangle) - main
          Positioned(
            top: 0,
            left: 0,
            child: CustomPaint(
              size: Size(houseWidth - 1, roofHeight),
              painter: _RoofPainter(
                color: roofColor,
                shadowColor: roofDarkColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build a 3D hotel widget - larger and more visible
  Widget _build3DHotel() {
    const hotelWidth = 20.0;
    const hotelHeight = 18.0;
    const bodyHeight = 12.0;

    return SizedBox(
      width: hotelWidth,
      height: hotelHeight,
      child: Stack(
        children: [
          // 3D shadow layer (offset bottom-right)
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: hotelWidth - 2,
              height: bodyHeight,
              decoration: BoxDecoration(
                color: Colors.red.shade900,
                borderRadius: BorderRadius.circular(1),
              ),
            ),
          ),
          // Hotel body - main layer
          Positioned(
            bottom: 2,
            left: 0,
            child: Container(
              width: hotelWidth - 2,
              height: bodyHeight,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.red.shade400, Colors.red.shade600],
                ),
                borderRadius: BorderRadius.circular(1),
                border: Border.all(color: Colors.red.shade800, width: 0.5),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Windows row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildWindow(),
                      const SizedBox(width: 2),
                      _buildWindow(),
                      const SizedBox(width: 2),
                      _buildWindow(),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Roof top with 3D effect
          Positioned(
            top: 1,
            left: 2,
            child: Container(
              width: hotelWidth - 4,
              height: 3,
              decoration: BoxDecoration(
                color: Colors.red.shade800,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(2),
                  topRight: Radius.circular(2),
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 1,
            child: Container(
              width: hotelWidth - 4,
              height: 3,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.red.shade300, Colors.red.shade500],
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(2),
                  topRight: Radius.circular(2),
                ),
              ),
            ),
          ),
          // "H" letter indicator
          Positioned(
            bottom: 4,
            left: 0,
            right: 2,
            child: Center(
              child: Text(
                'H',
                style: TextStyle(
                  fontSize: 6,
                  fontWeight: FontWeight.bold,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWindow() {
    return Container(
      width: 3,
      height: 3,
      decoration: BoxDecoration(
        color: Colors.yellow.shade200,
        borderRadius: BorderRadius.circular(0.5),
        border: Border.all(color: Colors.yellow.shade600, width: 0.5),
      ),
    );
  }

  Widget _buildCornerTile(BuildContext context) {
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
        icon = Icons.casino;
        iconColor = Colors.amber;
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
                _getDisplayName(context),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPropertyTile(BuildContext context) {
    // Determine layout based on rotation
    // 0 = bottom row (color band on top, text reads normally)
    // 1 = left column (color band on right, vertical tile)
    // 2 = top row (color band on bottom, text reads normally)
    // 3 = right column (color band on left, vertical tile)

    final isVertical = rotation == 1 || rotation == 3;

    if (isVertical) {
      return _buildVerticalTile(context);
    } else {
      return _buildHorizontalTile(context);
    }
  }

  /// Build tile for bottom (rotation=0) or top (rotation=2) row
  Widget _buildHorizontalTile(BuildContext context) {
    final colorBandOnTop = rotation == 0;
    final colorBand = _buildColorBand(isHorizontal: true);
    final content = _buildTileContent(context);

    return Column(
      children:
          colorBandOnTop
              ? [colorBand, Expanded(child: content)]
              : [Expanded(child: content), colorBand],
    );
  }

  /// Build tile for left (rotation=1) or right (rotation=3) column
  Widget _buildVerticalTile(BuildContext context) {
    final colorBandOnRight = rotation == 1;
    final colorBand = _buildColorBand(isHorizontal: false);
    final content = _buildTileContent(context);

    return Row(
      children:
          colorBandOnRight
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
        decoration:
            hasColorBand
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
        decoration:
            hasColorBand
                ? BoxDecoration(
                  color: data.color,
                  border: Border(
                    left:
                        rotation == 3
                            ? const BorderSide(color: Colors.black, width: 0.5)
                            : BorderSide.none,
                    right:
                        rotation == 1
                            ? const BorderSide(color: Colors.black, width: 0.5)
                            : BorderSide.none,
                  ),
                )
                : null,
      );
    }
  }

  Widget _buildTileContent(BuildContext context) {
    final price = _getPrice();

    // For top row (rotation=2), flip the layout so name is at bottom (toward center)
    // For bottom row (rotation=0), name at top (toward center)
    // For left/right columns, name toward center as well
    final nameAtBottom = rotation == 2;

    final shortName = _getShortName(context);
    // Use two-line layout only if name has a natural break (space)
    // Otherwise scale down to fit on one line to avoid orphan characters
    final hasSpace = shortName.contains(' ');

    final nameWidget = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          hasSpace
              ? Text(
                shortName,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                  height: 1.1,
                  color: Colors.black,
                ),
              )
              : FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  shortName,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    height: 1.1,
                    color: Colors.black,
                  ),
                ),
              ),
        ],
      ),
    );

    final priceWidget =
        price != null
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

    final iconWidget = Expanded(child: Center(child: _buildTileIcon()));

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children:
            nameAtBottom
                ? [priceWidget, iconWidget, nameWidget]
                : [nameWidget, iconWidget, priceWidget],
      ),
    );
  }

  /// Get a shortened version of the name for better readability
  String _getShortName(BuildContext context) {
    String name = _getDisplayName(context);
    // Shorten common words
    name = name.replaceAll('Avenue', 'Ave');
    name = name.replaceAll('Place', 'Pl');
    name = name.replaceAll('Gardens', 'Gdns');
    name = name.replaceAll('Railroad', 'RR');
    name = name.replaceAll('Electric', 'Elec');
    name = name.replaceAll('Company', 'Co');
    name = name.replaceAll('Water Works', 'Water');
    name = name.replaceAll('Chance Card', 'Chance');
    return name;
  }

  /// Prefer localized subtext for CJK locales when name is left in ASCII.
  String _getDisplayName(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    final subtext = data.subtext?.trim();
    if (subtext == null || subtext.isEmpty) return data.name;

    if (locale == 'zh' || locale == 'ja') {
      final hasCjkSubtext = RegExp(
        r'[\u3040-\u30FF\u3400-\u9FFF]',
      ).hasMatch(subtext);
      final hasCjkName = RegExp(
        r'[\u3040-\u30FF\u3400-\u9FFF]',
      ).hasMatch(data.name);
      if (!hasCjkName && hasCjkSubtext) {
        return subtext;
      }
    }

    return data.name;
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
  final void Function(TileData)? onTap;

  const PositionedTileWidget({
    super.key,
    required this.data,
    required this.position,
    this.isHighlighted = false,
    this.glowController,
    this.ownerColor,
    this.onTap,
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
                  color: Colors.amber.withAlpha(
                    (128 + glowController!.value * 127).toInt(),
                  ),
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

    // Wrap with GestureDetector for tap handling
    if (onTap != null) {
      tile = GestureDetector(onTap: () => onTap!(data), child: tile);
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

/// Custom painter for 3D house roof
class _RoofPainter extends CustomPainter {
  final Color color;
  final Color shadowColor;

  _RoofPainter({required this.color, required this.shadowColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Draw shadow (offset to right)
    paint.color = shadowColor;
    final shadowPath =
        Path()
          ..moveTo(size.width / 2 + 1, 0)
          ..lineTo(size.width + 1, size.height + 1)
          ..lineTo(1, size.height + 1)
          ..close();
    canvas.drawPath(shadowPath, paint);

    // Draw main roof
    paint.color = color;
    final path =
        Path()
          ..moveTo(size.width / 2, 0)
          ..lineTo(size.width, size.height)
          ..lineTo(0, size.height)
          ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

import 'package:flutter/material.dart';
import '../../models/player.dart';
import '../../models/tile.dart';
import '../../config/theme.dart';
import '../effects/floating_cash_indicator.dart';
import '../avatar/avatar_widget.dart';

/// Full player card for landscape mode
class PlayerCard extends StatelessWidget {
  final Player player;
  final bool isCurrentPlayer;

  const PlayerCard({
    super.key,
    required this.player,
    required this.isCurrentPlayer,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isCurrentPlayer
              ? [player.color.withOpacity(0.5), player.color.withOpacity(0.3)]
              : [Colors.grey.shade800.withOpacity(0.8), Colors.grey.shade900.withOpacity(0.8)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCurrentPlayer ? player.color : Colors.grey.shade700,
          width: isCurrentPlayer ? 4 : 1,
        ),
        boxShadow: isCurrentPlayer
            ? [
                BoxShadow(color: player.color.withOpacity(0.6), blurRadius: 20, spreadRadius: 4),
                BoxShadow(color: Colors.amber.withOpacity(0.3), blurRadius: 30, spreadRadius: 2),
              ]
            : [],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 8),
            _buildCashDisplay(),
            // AI indicator under cash
            if (player.isAI) ...[
              const SizedBox(height: 6),
              const _AIBadge(),
            ],
            const SizedBox(height: 8),
            Expanded(child: _buildPropertiesSection()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        _PlayerAvatar(player: player, size: 40),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                player.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              if (isCurrentPlayer) const _TurnIndicator(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCashDisplay() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Cash', style: TextStyle(color: Colors.grey, fontSize: 12)),
          AnimatedCashDisplay(
            cash: player.cash,
            style: const TextStyle(
              color: AppTheme.cashGreen,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPropertiesSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Properties', style: TextStyle(color: Colors.grey, fontSize: 11)),
          const SizedBox(height: 6),
          Expanded(
            child: player.propertyIds.isEmpty
                ? const Center(
                    child: Text(
                      'None yet',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  )
                : SingleChildScrollView(
                    child: Wrap(
                      spacing: 5,
                      runSpacing: 5,
                      children: player.propertyIds
                          .map((p) => _PropertyChip(propertyId: p))
                          .toList(),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

/// Compact player card for portrait mode - shows properties like landscape
class PlayerCardCompact extends StatelessWidget {
  final Player player;
  final bool isCurrentPlayer;
  final List<TileData>? tiles;

  const PlayerCardCompact({
    super.key,
    required this.player,
    required this.isCurrentPlayer,
    this.tiles,
  });

  /// Get tile name for current position
  String _getTileName() {
    if (tiles == null || tiles!.isEmpty) {
      return 'Tile ${player.position}';
    }
    final tile = tiles!.firstWhere(
      (t) => t.index == player.position,
      orElse: () => tiles![0],
    );
    // Shorten common words for compact display
    String name = tile.name;
    name = name.replaceAll('Avenue', 'Ave');
    name = name.replaceAll('Place', 'Pl');
    name = name.replaceAll('Railroad', 'RR');
    return name;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isCurrentPlayer
              ? [player.color.withOpacity(0.5), player.color.withOpacity(0.3)]
              : [Colors.grey.shade800.withOpacity(0.8), Colors.grey.shade900.withOpacity(0.8)],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCurrentPlayer ? player.color : Colors.grey.shade700,
          width: isCurrentPlayer ? 3 : 1,
        ),
        boxShadow: isCurrentPlayer
            ? [
                BoxShadow(color: player.color.withOpacity(0.5), blurRadius: 15, spreadRadius: 2),
              ]
            : [],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Single row: Avatar | Name | Cash (all vertically centered)
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _PlayerAvatar(player: player, size: 36),
                const SizedBox(width: 8),
                // Name and status
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              player.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (player.isAI) ...[
                            const SizedBox(width: 6),
                            const _AIBadgeSmall(),
                          ],
                        ],
                      ),
                      if (isCurrentPlayer)
                        const Padding(
                          padding: EdgeInsets.only(top: 2),
                          child: _TurnIndicator(),
                        )
                      else
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.location_on, size: 10, color: Colors.grey.shade400),
                              const SizedBox(width: 2),
                              Flexible(
                                child: Text(
                                  _getTileName(),
                                  style: TextStyle(color: Colors.grey.shade400, fontSize: 10),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                // Cash amount
                AnimatedCashDisplay(
                  cash: player.cash,
                  style: const TextStyle(
                    color: AppTheme.cashGreen,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            // Properties section - compact
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.home, size: 14, color: Colors.grey.shade400),
                    const SizedBox(width: 4),
                    Expanded(
                      child: player.propertyIds.isEmpty
                          ? Text(
                              'No properties',
                              style: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 10,
                                fontStyle: FontStyle.italic,
                              ),
                            )
                          : Wrap(
                              spacing: 3,
                              runSpacing: 3,
                              children: player.propertyIds
                                  .map((p) => _PropertyChip(propertyId: p))
                                  .toList(),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Player avatar widget - uses the new avatar system
class _PlayerAvatar extends StatelessWidget {
  final Player player;
  final double size;

  const _PlayerAvatar({
    required this.player,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return AvatarWidget(
      avatar: player.effectiveAvatar,
      size: size,
      borderColor: player.color,
    );
  }
}

/// AI indicator badge (shown under cash amount - for landscape mode)
class _AIBadge extends StatelessWidget {
  const _AIBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.purple.shade600,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.white, width: 1),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.smart_toy, color: Colors.white, size: 12),
          SizedBox(width: 3),
          Text(
            'AI',
            style: TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

/// Small AI badge for compact cards (inline with name)
class _AIBadgeSmall extends StatelessWidget {
  const _AIBadgeSmall();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.purple.shade600,
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.smart_toy, color: Colors.white, size: 10),
          SizedBox(width: 2),
          Text(
            'AI',
            style: TextStyle(
              color: Colors.white,
              fontSize: 8,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

/// "YOUR TURN" indicator badge with pulsing glow animation
class _TurnIndicator extends StatefulWidget {
  const _TurnIndicator();

  @override
  State<_TurnIndicator> createState() => _TurnIndicatorState();
}

class _TurnIndicatorState extends State<_TurnIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.amber,
            borderRadius: BorderRadius.circular(6),
            boxShadow: [
              BoxShadow(
                color: Colors.amber.withOpacity(0.3 + _glowAnimation.value * 0.5),
                blurRadius: 6 + _glowAnimation.value * 10,
                spreadRadius: _glowAnimation.value * 3,
              ),
            ],
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Animated arrow icon
                Transform.translate(
                  offset: Offset(_glowAnimation.value * 3 - 1.5, 0),
                  child: const Icon(
                    Icons.play_arrow,
                    size: 12,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(width: 2),
                const Text(
                  'YOUR TURN',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Property chip showing owned property
class _PropertyChip extends StatelessWidget {
  final String propertyId;

  const _PropertyChip({required this.propertyId});

  Color get _color {
    // TODO: Get actual color from property data
    // For now, use a simple index-based color
    final index = int.tryParse(propertyId) ?? 0;
    const colors = [
      Color(0xFF795548), // Brown
      Color(0xFF795548),
      Color(0xFF4FC3F7), // Light Blue
      Color(0xFF4FC3F7),
      Color(0xFF4FC3F7),
      Color(0xFFF48FB1), // Pink
      Color(0xFFF48FB1),
      Color(0xFFF48FB1),
      Color(0xFFFF9800), // Orange
      Color(0xFFFF9800),
      Color(0xFFFF9800),
      Color(0xFFF44336), // Red
      Color(0xFFF44336),
      Color(0xFFF44336),
      Color(0xFFFFEB3B), // Yellow
      Color(0xFFFFEB3B),
      Color(0xFFFFEB3B),
      Color(0xFF4CAF50), // Green
      Color(0xFF4CAF50),
      Color(0xFF4CAF50),
      Color(0xFF1976D2), // Dark Blue
      Color(0xFF1976D2),
    ];
    return colors[index % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 12,
      decoration: BoxDecoration(
        color: _color,
        borderRadius: BorderRadius.circular(2),
        border: Border.all(color: Colors.white.withOpacity(0.5), width: 0.5),
      ),
    );
  }
}

/// Vertical player panel (for landscape mode)
class VerticalPlayerPanel extends StatelessWidget {
  final Player player1;
  final Player player2;
  final int currentPlayerIndex;

  const VerticalPlayerPanel({
    super.key,
    required this.player1,
    required this.player2,
    required this.currentPlayerIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      margin: const EdgeInsets.all(8),
      child: Column(
        children: [
          Expanded(
            child: PlayerCard(
              player: player1,
              isCurrentPlayer: player1.id == (currentPlayerIndex + 1).toString(),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: PlayerCard(
              player: player2,
              isCurrentPlayer: player2.id == (currentPlayerIndex + 1).toString(),
            ),
          ),
        ],
      ),
    );
  }
}

/// Horizontal player panel (for portrait mode)
class HorizontalPlayerPanel extends StatelessWidget {
  final Player player1;
  final Player player2;
  final int currentPlayerIndex;
  final List<TileData>? tiles;

  const HorizontalPlayerPanel({
    super.key,
    required this.player1,
    required this.player2,
    required this.currentPlayerIndex,
    this.tiles,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: PlayerCardCompact(
              player: player1,
              isCurrentPlayer: player1.id == (currentPlayerIndex + 1).toString(),
              tiles: tiles,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: PlayerCardCompact(
              player: player2,
              isCurrentPlayer: player2.id == (currentPlayerIndex + 1).toString(),
              tiles: tiles,
            ),
          ),
        ],
      ),
    );
  }
}

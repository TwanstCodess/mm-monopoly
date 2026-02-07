import 'dart:math';
import 'package:flutter/material.dart';
import '../../models/player.dart';
import '../../l10n/app_localizations.dart';
import '../avatar/avatar_widget.dart';
import 'fireworks.dart';
import 'trophy_animation.dart';

/// Full victory celebration sequence
class VictoryCelebration extends StatefulWidget {
  final Player winner;
  final int finalCash;
  final int propertiesOwned;
  final VoidCallback? onComplete;

  const VictoryCelebration({super.key, required this.winner, required this.finalCash, required this.propertiesOwned, this.onComplete});

  @override
  State<VictoryCelebration> createState() => _VictoryCelebrationState();
}

class _VictoryCelebrationState extends State<VictoryCelebration> with TickerProviderStateMixin {
  late AnimationController _sequenceController;
  late AnimationController _statsController;

  // Sequence phases
  int _phase = 0;
  // 0: Dim screen
  // 1: Winner reveal
  // 2: Celebration explosion
  // 3: Trophy
  // 4: Stats

  @override
  void initState() {
    super.initState();
    _sequenceController = AnimationController(duration: const Duration(seconds: 8), vsync: this);

    _statsController = AnimationController(duration: const Duration(milliseconds: 500), vsync: this);

    _startSequence();
  }

  void _startSequence() async {
    // Phase 0: Dim (0.5s)
    setState(() => _phase = 0);
    await Future.delayed(const Duration(milliseconds: 500));

    // Phase 1: Winner reveal (1s)
    setState(() => _phase = 1);
    await Future.delayed(const Duration(milliseconds: 1000));

    // Phase 2: Celebration (2s)
    setState(() => _phase = 2);
    await Future.delayed(const Duration(milliseconds: 2000));

    // Phase 3: Trophy (1.5s)
    setState(() => _phase = 3);
    await Future.delayed(const Duration(milliseconds: 1500));

    // Phase 4: Stats (2s)
    setState(() => _phase = 4);
    _statsController.forward();
    await Future.delayed(const Duration(milliseconds: 2000));

    widget.onComplete?.call();
  }

  @override
  void dispose() {
    _sequenceController.dispose();
    _statsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Dimmed background
        AnimatedOpacity(
          duration: const Duration(milliseconds: 500),
          opacity: _phase >= 0 ? 0.85 : 0,
          child: Container(color: Colors.black),
        ),

        // Fireworks (phase 2+)
        if (_phase >= 2) Positioned.fill(child: FireworksWidget(duration: const Duration(seconds: 5), burstCount: 10)),

        // Confetti (phase 2+)
        if (_phase >= 2) Positioned.fill(child: _ContinuousConfetti()),

        // Center content
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Winner text (phase 1+)
              AnimatedOpacity(
                duration: const Duration(milliseconds: 500),
                opacity: _phase >= 1 ? 1 : 0,
                child: AnimatedScale(
                  duration: const Duration(milliseconds: 500),
                  scale: _phase >= 1 ? 1 : 0.5,
                  curve: Curves.elasticOut,
                  child: Text(
                    AppLocalizations.of(context)!.winnerTitle,
                    style: TextStyle(
                      color: Colors.amber,
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      shadows: [Shadow(color: Colors.black, offset: Offset(2, 2), blurRadius: 4)],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Winner avatar (phase 1+)
              AnimatedOpacity(
                duration: const Duration(milliseconds: 500),
                opacity: _phase >= 1 ? 1 : 0,
                child: AnimatedScale(
                  duration: const Duration(milliseconds: 700),
                  scale: _phase >= 1 ? 1 : 0,
                  curve: Curves.bounceOut,
                  child: _phase >= 1 ? VictoryAvatarWidget(avatar: widget.winner.effectiveAvatar, size: 120) : const SizedBox.shrink(),
                ),
              ),
              const SizedBox(height: 16),

              // Winner name (phase 1+)
              AnimatedOpacity(
                duration: const Duration(milliseconds: 500),
                opacity: _phase >= 1 ? 1 : 0,
                child: Text(
                  widget.winner.name,
                  style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 32),

              // Trophy (phase 3+)
              if (_phase >= 3) TrophyAnimation(winnerName: widget.winner.name, delay: Duration.zero),

              const SizedBox(height: 24),

              // Stats (phase 4)
              AnimatedOpacity(
                duration: const Duration(milliseconds: 500),
                opacity: _phase >= 4 ? 1 : 0,
                child: AnimatedSlide(duration: const Duration(milliseconds: 500), offset: _phase >= 4 ? Offset.zero : const Offset(0, 0.5), child: _buildStats()),
              ),
            ],
          ),
        ),

        // Sparkles around trophy (phase 3+)
        if (_phase >= 3) const Center(child: TrophySparkles(size: 300)),
      ],
    );
  }

  Widget _buildStats() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.amber.withOpacity(0.5)),
      ),
      child: Column(
        children: [
          _StatRow(icon: Icons.attach_money, label: AppLocalizations.of(context)!.finalCash, value: '\$${widget.finalCash}', color: Colors.green),
          const SizedBox(height: 12),
          _StatRow(icon: Icons.home, label: AppLocalizations.of(context)!.properties, value: '${widget.propertiesOwned}', color: Colors.blue),
        ],
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatRow({required this.icon, required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(width: 12),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 16)),
        const SizedBox(width: 16),
        Text(
          value,
          style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

/// Continuous confetti stream
class _ContinuousConfetti extends StatefulWidget {
  @override
  State<_ContinuousConfetti> createState() => _ContinuousConfettiState();
}

class _ContinuousConfettiState extends State<_ContinuousConfetti> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_ConfettiPiece> _pieces = [];
  final Random _random = Random();

  static const List<Color> _colors = [Colors.red, Colors.blue, Colors.green, Colors.yellow, Colors.purple, Colors.orange, Colors.pink, Colors.cyan, Colors.amber];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(seconds: 10), vsync: this);

    _controller.addListener(() {
      setState(() {
        // Add new pieces
        if (_random.nextDouble() < 0.4) {
          _addPiece();
        }

        // Update pieces
        for (final piece in _pieces) {
          piece.update(1 / 60);
        }
        _pieces.removeWhere((p) => p.y > MediaQuery.of(context).size.height + 50);
      });
    });

    _controller.repeat();
  }

  void _addPiece() {
    final screenWidth = MediaQuery.of(context).size.width;
    _pieces.add(
      _ConfettiPiece(
        x: _random.nextDouble() * screenWidth,
        y: -20,
        velocityX: (_random.nextDouble() - 0.5) * 100,
        velocityY: 100 + _random.nextDouble() * 150,
        rotation: _random.nextDouble() * 2 * pi,
        rotationSpeed: (_random.nextDouble() - 0.5) * 10,
        color: _colors[_random.nextInt(_colors.length)],
        width: 8 + _random.nextDouble() * 8,
        height: 6 + _random.nextDouble() * 6,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _ContinuousConfettiPainter(pieces: _pieces),
      size: Size.infinite,
    );
  }
}

class _ConfettiPiece {
  double x, y;
  double velocityX, velocityY;
  double rotation, rotationSpeed;
  Color color;
  double width, height;

  _ConfettiPiece({required this.x, required this.y, required this.velocityX, required this.velocityY, required this.rotation, required this.rotationSpeed, required this.color, required this.width, required this.height});

  void update(double dt) {
    // Sway
    velocityX += (Random().nextDouble() - 0.5) * 50 * dt;
    velocityX = velocityX.clamp(-80, 80);

    x += velocityX * dt;
    y += velocityY * dt;
    rotation += rotationSpeed * dt;
  }
}

class _ContinuousConfettiPainter extends CustomPainter {
  final List<_ConfettiPiece> pieces;

  _ContinuousConfettiPainter({required this.pieces});

  @override
  void paint(Canvas canvas, Size size) {
    for (final piece in pieces) {
      final paint = Paint()
        ..color = piece.color
        ..style = PaintingStyle.fill;

      canvas.save();
      canvas.translate(piece.x, piece.y);
      canvas.rotate(piece.rotation);

      final rect = Rect.fromCenter(center: Offset.zero, width: piece.width, height: piece.height);
      canvas.drawRect(rect, paint);

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ContinuousConfettiPainter oldDelegate) => true;
}

/// Manager for showing victory celebration overlay
class VictoryCelebrationManager {
  static OverlayEntry? _currentEntry;

  static void show(BuildContext context, {required Player winner, required int finalCash, required int propertiesOwned, VoidCallback? onComplete}) {
    _currentEntry?.remove();

    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (context) => Material(
        color: Colors.transparent,
        child: VictoryCelebration(
          winner: winner,
          finalCash: finalCash,
          propertiesOwned: propertiesOwned,
          onComplete: () {
            // Don't auto-dismiss, let user close it
            onComplete?.call();
          },
        ),
      ),
    );

    _currentEntry = entry;
    Overlay.of(context).insert(entry);
  }

  static void dismiss() {
    _currentEntry?.remove();
    _currentEntry = null;
  }
}

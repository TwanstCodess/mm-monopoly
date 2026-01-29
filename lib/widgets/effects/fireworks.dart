import 'dart:math';
import 'package:flutter/material.dart';

/// A single firework particle
class FireworkParticle {
  Offset position;
  Offset velocity;
  Color color;
  double life;
  double size;
  bool isTrail;

  FireworkParticle({
    required this.position,
    required this.velocity,
    required this.color,
    this.life = 1.0,
    this.size = 3.0,
    this.isTrail = false,
  });

  void update(double dt) {
    // Apply gravity
    velocity = Offset(velocity.dx, velocity.dy + 200 * dt);
    // Apply drag
    velocity = velocity * (1 - 0.5 * dt);
    // Update position
    position = position + velocity * dt;
    // Decrease life
    life -= dt * (isTrail ? 2.0 : 0.8);
  }

  bool get isDead => life <= 0;
}

/// A single firework burst
class FireworkBurst {
  final List<FireworkParticle> particles = [];
  final Random _random = Random();
  bool hasExploded = false;

  // Launch particle
  Offset launchPosition;
  Offset launchVelocity;
  Color color;
  double launchProgress = 0;

  FireworkBurst({
    required this.launchPosition,
    required this.launchVelocity,
    required this.color,
  });

  void update(double dt) {
    if (!hasExploded) {
      // Update launch
      launchProgress += dt * 2;
      launchPosition = launchPosition + launchVelocity * dt;
      launchVelocity = Offset(launchVelocity.dx, launchVelocity.dy + 100 * dt);

      // Explode when velocity slows
      if (launchVelocity.dy > -50 || launchProgress > 1.5) {
        _explode();
      }
    } else {
      // Update particles
      for (final particle in particles) {
        particle.update(dt);
      }
      particles.removeWhere((p) => p.isDead);
    }
  }

  void _explode() {
    hasExploded = true;
    final particleCount = 40 + _random.nextInt(30);

    for (int i = 0; i < particleCount; i++) {
      final angle = _random.nextDouble() * 2 * pi;
      final speed = 100 + _random.nextDouble() * 200;

      particles.add(FireworkParticle(
        position: launchPosition,
        velocity: Offset(cos(angle) * speed, sin(angle) * speed),
        color: _getVariedColor(),
        size: 2 + _random.nextDouble() * 3,
      ));
    }

    // Add some trail particles
    for (int i = 0; i < 15; i++) {
      final angle = _random.nextDouble() * 2 * pi;
      final speed = 50 + _random.nextDouble() * 100;

      particles.add(FireworkParticle(
        position: launchPosition,
        velocity: Offset(cos(angle) * speed, sin(angle) * speed),
        color: Colors.white,
        size: 1.5,
        isTrail: true,
      ));
    }
  }

  Color _getVariedColor() {
    final hsl = HSLColor.fromColor(color);
    return hsl
        .withLightness((hsl.lightness + _random.nextDouble() * 0.3).clamp(0, 1))
        .withSaturation((hsl.saturation + _random.nextDouble() * 0.2).clamp(0, 1))
        .toColor();
  }

  bool get isDead => hasExploded && particles.isEmpty;
}

/// Fireworks display widget
class FireworksWidget extends StatefulWidget {
  final Duration duration;
  final int burstCount;
  final VoidCallback? onComplete;

  const FireworksWidget({
    super.key,
    this.duration = const Duration(seconds: 5),
    this.burstCount = 8,
    this.onComplete,
  });

  @override
  State<FireworksWidget> createState() => _FireworksWidgetState();
}

class _FireworksWidgetState extends State<FireworksWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<FireworkBurst> _bursts = [];
  final Random _random = Random();
  int _burstsLaunched = 0;
  double _lastLaunchTime = 0;

  static const List<Color> _colors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.purple,
    Colors.orange,
    Colors.pink,
    Colors.cyan,
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _controller.addListener(_update);
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onComplete?.call();
      }
    });

    _controller.forward();
  }

  void _update() {
    setState(() {
      // Launch new fireworks
      final currentTime = _controller.value * widget.duration.inMilliseconds / 1000;
      if (_burstsLaunched < widget.burstCount &&
          currentTime - _lastLaunchTime > 0.4) {
        _launchFirework();
        _lastLaunchTime = currentTime;
        _burstsLaunched++;
      }

      // Update all bursts
      for (final burst in _bursts) {
        burst.update(1 / 60);
      }
      _bursts.removeWhere((b) => b.isDead);
    });
  }

  void _launchFirework() {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    _bursts.add(FireworkBurst(
      launchPosition: Offset(
        screenWidth * (0.2 + _random.nextDouble() * 0.6),
        screenHeight,
      ),
      launchVelocity: Offset(
        (_random.nextDouble() - 0.5) * 100,
        -(400 + _random.nextDouble() * 200),
      ),
      color: _colors[_random.nextInt(_colors.length)],
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _FireworksPainter(bursts: _bursts),
      size: Size.infinite,
    );
  }
}

class _FireworksPainter extends CustomPainter {
  final List<FireworkBurst> bursts;

  _FireworksPainter({required this.bursts});

  @override
  void paint(Canvas canvas, Size size) {
    for (final burst in bursts) {
      if (!burst.hasExploded) {
        // Draw launch trail
        final paint = Paint()
          ..color = burst.color
          ..style = PaintingStyle.fill;

        canvas.drawCircle(burst.launchPosition, 4, paint);

        // Trail
        final trailPaint = Paint()
          ..color = burst.color.withOpacity(0.5)
          ..style = PaintingStyle.fill;
        canvas.drawCircle(
          burst.launchPosition - burst.launchVelocity * 0.02,
          3,
          trailPaint,
        );
      } else {
        // Draw particles
        for (final particle in burst.particles) {
          final paint = Paint()
            ..color = particle.color.withOpacity(particle.life.clamp(0, 1))
            ..style = PaintingStyle.fill;

          canvas.drawCircle(particle.position, particle.size, paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(_FireworksPainter oldDelegate) => true;
}

/// Manager for showing fireworks overlay
class FireworksManager {
  static OverlayEntry? _currentEntry;

  static void show(
    BuildContext context, {
    Duration duration = const Duration(seconds: 5),
    int burstCount = 8,
    VoidCallback? onComplete,
  }) {
    _currentEntry?.remove();

    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (context) => Positioned.fill(
        child: IgnorePointer(
          child: FireworksWidget(
            duration: duration,
            burstCount: burstCount,
            onComplete: () {
              entry.remove();
              if (_currentEntry == entry) {
                _currentEntry = null;
              }
              onComplete?.call();
            },
          ),
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

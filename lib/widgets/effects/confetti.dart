import 'dart:math';
import 'package:flutter/material.dart';

/// A single confetti particle
class ConfettiParticle {
  Offset position;
  Offset velocity;
  Color color;
  double rotation;
  double rotationSpeed;
  double size;
  double life;
  final double maxLife;

  ConfettiParticle({
    required this.position,
    required this.velocity,
    required this.color,
    required this.rotation,
    required this.rotationSpeed,
    required this.size,
    this.life = 1.0,
    this.maxLife = 1.0,
  });

  void update(double dt) {
    // Apply gravity
    velocity = Offset(velocity.dx * 0.99, velocity.dy + 400 * dt);
    // Apply air resistance
    velocity = Offset(velocity.dx * 0.98, velocity.dy * 0.98);
    // Update position
    position = position + velocity * dt;
    // Update rotation
    rotation += rotationSpeed * dt;
    // Decrease life
    life -= dt / maxLife;
  }

  bool get isDead => life <= 0;
}

/// Confetti explosion widget
class ConfettiExplosion extends StatefulWidget {
  final Color primaryColor;
  final List<Color>? additionalColors;
  final int particleCount;
  final VoidCallback? onComplete;
  final Duration duration;

  const ConfettiExplosion({
    super.key,
    required this.primaryColor,
    this.additionalColors,
    this.particleCount = 30,
    this.onComplete,
    this.duration = const Duration(milliseconds: 1500),
  });

  @override
  State<ConfettiExplosion> createState() => _ConfettiExplosionState();
}

class _ConfettiExplosionState extends State<ConfettiExplosion>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<ConfettiParticle> _particles = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _initializeParticles();

    _controller.addListener(() {
      setState(() {
        _updateParticles(1 / 60); // Approximate 60fps
      });
    });

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onComplete?.call();
      }
    });

    _controller.forward();
  }

  void _initializeParticles() {
    final colors = [
      widget.primaryColor,
      widget.primaryColor.withOpacity(0.8),
      Colors.white,
      Colors.amber,
      ...?widget.additionalColors,
    ];

    for (int i = 0; i < widget.particleCount; i++) {
      // Random angle in upward cone (between -60 and 60 degrees from vertical)
      final angle = -pi / 2 + (_random.nextDouble() - 0.5) * pi * 0.8;
      final speed = 200 + _random.nextDouble() * 300;

      _particles.add(ConfettiParticle(
        position: Offset.zero,
        velocity: Offset(cos(angle) * speed, sin(angle) * speed),
        color: colors[_random.nextInt(colors.length)],
        rotation: _random.nextDouble() * 2 * pi,
        rotationSpeed: (_random.nextDouble() - 0.5) * 10,
        size: 4 + _random.nextDouble() * 6,
        maxLife: 1.2 + _random.nextDouble() * 0.5,
      ));
    }
  }

  void _updateParticles(double dt) {
    for (final particle in _particles) {
      particle.update(dt);
    }
    _particles.removeWhere((p) => p.isDead);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _ConfettiPainter(particles: _particles),
      size: Size.infinite,
    );
  }
}

class _ConfettiPainter extends CustomPainter {
  final List<ConfettiParticle> particles;

  _ConfettiPainter({required this.particles});

  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      final paint = Paint()
        ..color = particle.color.withOpacity(particle.life.clamp(0, 1))
        ..style = PaintingStyle.fill;

      canvas.save();
      canvas.translate(
        size.width / 2 + particle.position.dx,
        size.height / 2 + particle.position.dy,
      );
      canvas.rotate(particle.rotation);

      // Draw rectangle confetti
      final rect = Rect.fromCenter(
        center: Offset.zero,
        width: particle.size,
        height: particle.size * 0.6,
      );
      canvas.drawRect(rect, paint);

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter oldDelegate) => true;
}

/// Overlay manager for showing confetti
class ConfettiManager {
  static OverlayEntry? _currentEntry;

  /// Show confetti explosion at the given position
  static void show(
    BuildContext context, {
    required Offset position,
    required Color primaryColor,
    List<Color>? additionalColors,
    int particleCount = 35,
  }) {
    _currentEntry?.remove();

    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (context) => Positioned(
        left: position.dx - 100,
        top: position.dy - 100,
        width: 200,
        height: 200,
        child: IgnorePointer(
          child: ConfettiExplosion(
            primaryColor: primaryColor,
            additionalColors: additionalColors,
            particleCount: particleCount,
            onComplete: () {
              entry.remove();
              if (_currentEntry == entry) {
                _currentEntry = null;
              }
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

/// A button that shows confetti when pressed
class ConfettiButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Widget child;
  final Color confettiColor;
  final bool enabled;

  const ConfettiButton({
    super.key,
    required this.onPressed,
    required this.child,
    required this.confettiColor,
    this.enabled = true,
  });

  @override
  State<ConfettiButton> createState() => _ConfettiButtonState();
}

class _ConfettiButtonState extends State<ConfettiButton> {
  final GlobalKey _key = GlobalKey();

  void _handlePress() {
    // Show confetti at button position
    final renderBox = _key.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      final position = renderBox.localToGlobal(Offset.zero);
      final size = renderBox.size;
      ConfettiManager.show(
        context,
        position: Offset(position.dx + size.width / 2, position.dy + size.height / 2),
        primaryColor: widget.confettiColor,
      );
    }
    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: _key,
      onTap: widget.enabled ? _handlePress : null,
      child: widget.child,
    );
  }
}

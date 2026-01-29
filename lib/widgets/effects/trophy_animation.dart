import 'dart:math';
import 'package:flutter/material.dart';

/// Animated trophy presentation widget
class TrophyAnimation extends StatefulWidget {
  final String winnerName;
  final Duration delay;
  final VoidCallback? onComplete;

  const TrophyAnimation({
    super.key,
    required this.winnerName,
    this.delay = Duration.zero,
    this.onComplete,
  });

  @override
  State<TrophyAnimation> createState() => _TrophyAnimationState();
}

class _TrophyAnimationState extends State<TrophyAnimation>
    with TickerProviderStateMixin {
  late AnimationController _descendController;
  late AnimationController _shineController;
  late AnimationController _bounceController;
  late Animation<double> _descendAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _shineAnimation;
  late Animation<double> _bounceAnimation;

  bool _started = false;

  @override
  void initState() {
    super.initState();

    // Descend from top animation
    _descendController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _descendAnimation = Tween<double>(begin: -200, end: 0).animate(
      CurvedAnimation(parent: _descendController, curve: Curves.bounceOut),
    );
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _descendController, curve: Curves.easeOut),
    );

    // Shine/glow animation
    _shineController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _shineAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _shineController, curve: Curves.easeInOut),
    );

    // Gentle bounce
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _bounceAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.easeInOut),
    );

    _descendController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _shineController.repeat();
        _bounceController.repeat();
        widget.onComplete?.call();
      }
    });

    // Start after delay
    Future.delayed(widget.delay, () {
      if (mounted) {
        setState(() => _started = true);
        _descendController.forward();
      }
    });
  }

  @override
  void dispose() {
    _descendController.dispose();
    _shineController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_started) return const SizedBox.shrink();

    return AnimatedBuilder(
      animation:
          Listenable.merge([_descendAnimation, _shineAnimation, _bounceAnimation]),
      builder: (context, child) {
        final bounce = sin(_bounceAnimation.value * pi) * 5;

        return Transform.translate(
          offset: Offset(0, _descendAnimation.value - bounce),
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Trophy
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // Glow effect
                    Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.amber
                                .withOpacity(0.3 + _shineAnimation.value * 0.4),
                            blurRadius: 30 + _shineAnimation.value * 20,
                            spreadRadius: 10 + _shineAnimation.value * 10,
                          ),
                        ],
                      ),
                    ),
                    // Trophy icon
                    ShaderMask(
                      shaderCallback: (bounds) {
                        return LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.amber.shade300,
                            Colors.amber.shade600,
                            Colors.amber.shade300,
                          ],
                          stops: [
                            0,
                            _shineAnimation.value,
                            1,
                          ],
                        ).createShader(bounds);
                      },
                      child: const Icon(
                        Icons.emoji_events,
                        size: 120,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Winner name plate
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.amber.shade700,
                        Colors.amber.shade500,
                        Colors.amber.shade700,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.amber.shade300, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.amber.withOpacity(0.5),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Text(
                    widget.winnerName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          color: Colors.black38,
                          offset: Offset(1, 1),
                          blurRadius: 2,
                        ),
                      ],
                    ),
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

/// Sparkle particles around trophy
class TrophySparkles extends StatefulWidget {
  final double size;
  final Duration duration;

  const TrophySparkles({
    super.key,
    this.size = 200,
    this.duration = const Duration(seconds: 10),
  });

  @override
  State<TrophySparkles> createState() => _TrophySparklesState();
}

class _TrophySparklesState extends State<TrophySparkles>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_Sparkle> _sparkles = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _controller.addListener(() {
      setState(() {
        // Add new sparkles
        if (_random.nextDouble() < 0.3) {
          _addSparkle();
        }

        // Update existing sparkles
        for (final sparkle in _sparkles) {
          sparkle.life -= 1 / 60;
        }
        _sparkles.removeWhere((s) => s.life <= 0);
      });
    });

    _controller.repeat();
  }

  void _addSparkle() {
    final angle = _random.nextDouble() * 2 * pi;
    final distance = widget.size / 2 * (0.3 + _random.nextDouble() * 0.7);

    _sparkles.add(_Sparkle(
      position: Offset(
        cos(angle) * distance,
        sin(angle) * distance,
      ),
      size: 2 + _random.nextDouble() * 4,
      life: 0.5 + _random.nextDouble() * 0.5,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: CustomPaint(
        painter: _SparklesPainter(sparkles: _sparkles, centerOffset: Offset(widget.size / 2, widget.size / 2)),
      ),
    );
  }
}

class _Sparkle {
  final Offset position;
  final double size;
  double life;

  _Sparkle({
    required this.position,
    required this.size,
    required this.life,
  });
}

class _SparklesPainter extends CustomPainter {
  final List<_Sparkle> sparkles;
  final Offset centerOffset;

  _SparklesPainter({required this.sparkles, required this.centerOffset});

  @override
  void paint(Canvas canvas, Size size) {
    for (final sparkle in sparkles) {
      final opacity = sparkle.life.clamp(0, 1);
      final paint = Paint()
        ..color = Colors.amber.withOpacity(opacity * 0.8)
        ..style = PaintingStyle.fill;

      // Draw star shape
      final path = _createStarPath(
        centerOffset + sparkle.position,
        sparkle.size,
        sparkle.size / 2,
        4,
      );
      canvas.drawPath(path, paint);

      // Add glow
      final glowPaint = Paint()
        ..color = Colors.amber.withOpacity(opacity * 0.3)
        ..style = PaintingStyle.fill
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
      canvas.drawPath(path, glowPaint);
    }
  }

  Path _createStarPath(Offset center, double outerRadius, double innerRadius, int points) {
    final path = Path();
    final angle = pi / points;

    for (int i = 0; i < points * 2; i++) {
      final radius = i.isEven ? outerRadius : innerRadius;
      final x = center.dx + cos(i * angle - pi / 2) * radius;
      final y = center.dy + sin(i * angle - pi / 2) * radius;

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    return path;
  }

  @override
  bool shouldRepaint(_SparklesPainter oldDelegate) => true;
}

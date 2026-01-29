import 'dart:math';
import 'package:flutter/material.dart';
import '../../models/player.dart';

/// Chess pawn-style 3D Player Token with avatar on the head
/// Enhanced with better proportions, smoother curves, and polished 3D effects
class PlayerToken3D extends StatelessWidget {
  final Player player;
  final double size;
  final bool isCurrentPlayer;
  final double rotationX;
  final double rotationY;
  final double rotationZ;

  const PlayerToken3D({super.key, required this.player, required this.size, this.isCurrentPlayer = false, this.rotationX = 0, this.rotationY = 0, this.rotationZ = 0});

  @override
  Widget build(BuildContext context) {
    // Refined pawn proportions - more elegant chess piece shape
    final totalHeight = size * 1.5;
    final headSize = size * 0.75; // Larger head for better avatar visibility
    final collarWidth = size * 0.52;
    final collarHeight = size * 0.12;
    final neckWidth = size * 0.22;
    final neckHeight = size * 0.18;
    final bodyWidth = size * 0.72;
    final bodyHeight = size * 0.38;
    final baseRimWidth = size * 0.88;
    final baseRimHeight = size * 0.1;
    final baseWidth = size * 0.8;
    final baseHeight = size * 0.18;

    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.003)
        ..rotateX(rotationX)
        ..rotateY(rotationY)
        ..rotateZ(rotationZ),
      child: SizedBox(
        width: size,
        height: totalHeight,
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            // Ground shadow (ellipse on ground)
            Positioned(
              bottom: -4,
              child: Container(
                width: baseRimWidth * 0.85,
                height: 8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(baseRimWidth / 2),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 10, spreadRadius: 1)],
                ),
              ),
            ),
            // Base rim (bottom-most wide part)
            Positioned(bottom: 0, child: _buildBaseRim(baseRimWidth, baseRimHeight)),
            // Base (main pedestal)
            Positioned(bottom: baseRimHeight - 1, child: _buildBase(baseWidth, baseHeight)),
            // Body (elegant curved shape)
            Positioned(bottom: baseRimHeight + baseHeight - 3, child: _buildBody(bodyWidth, bodyHeight)),
            // Neck (narrow elegant stem)
            Positioned(bottom: baseRimHeight + baseHeight + bodyHeight - 6, child: _buildNeck(neckWidth, neckHeight)),
            // Collar (decorative ring under head)
            Positioned(bottom: baseRimHeight + baseHeight + bodyHeight + neckHeight - 9, child: _buildCollar(collarWidth, collarHeight)),
            // Head (polished sphere with avatar)
            Positioned(bottom: baseRimHeight + baseHeight + bodyHeight + neckHeight + collarHeight - 14, child: _buildHead(headSize)),
            // Specular highlight on the whole piece
            Positioned(bottom: baseRimHeight + baseHeight + bodyHeight + neckHeight + collarHeight - 10, child: _buildSpecularHighlight(headSize)),
            // Glow effect for current player
            if (isCurrentPlayer)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(size / 2),
                    boxShadow: [
                      BoxShadow(color: player.color.withOpacity(0.5), blurRadius: 20, spreadRadius: 5),
                      BoxShadow(color: player.color.withOpacity(0.3), blurRadius: 35, spreadRadius: 10),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Build the bottom rim of the base
  Widget _buildBaseRim(double width, double height) {
    return CustomPaint(
      size: Size(width, height),
      painter: _PawnBaseRimPainter(color: player.color),
    );
  }

  /// Build the main base pedestal
  Widget _buildBase(double width, double height) {
    return CustomPaint(
      size: Size(width, height),
      painter: _PawnBasePainter(color: player.color),
    );
  }

  /// Build the elegant curved body
  Widget _buildBody(double width, double height) {
    return CustomPaint(
      size: Size(width, height),
      painter: _PawnBodyPainter(color: player.color),
    );
  }

  /// Build the narrow neck/stem
  Widget _buildNeck(double width, double height) {
    return CustomPaint(
      size: Size(width, height),
      painter: _PawnNeckPainter(color: player.color),
    );
  }

  /// Build the decorative collar under the head
  Widget _buildCollar(double width, double height) {
    return CustomPaint(
      size: Size(width, height),
      painter: _PawnCollarPainter(color: player.color),
    );
  }

  /// Build the spherical head with avatar
  Widget _buildHead(double headSize) {
    return Container(
      width: headSize,
      height: headSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          center: const Alignment(-0.35, -0.35),
          radius: 0.85,
          colors: [Color.lerp(player.color, Colors.white, 0.65)!, Color.lerp(player.color, Colors.white, 0.25)!, player.color, Color.lerp(player.color, Colors.black, 0.3)!, Color.lerp(player.color, Colors.black, 0.45)!],
          stops: const [0.0, 0.25, 0.5, 0.8, 1.0],
        ),
        boxShadow: [
          // Inner glow
          BoxShadow(color: Color.lerp(player.color, Colors.white, 0.3)!.withOpacity(0.3), blurRadius: 2, spreadRadius: 0),
          // Drop shadow
          BoxShadow(color: Colors.black.withOpacity(0.35), blurRadius: 6, offset: const Offset(2, 3)),
        ],
      ),
      child: Stack(
        children: [
          // Glossy reflection on head
          Positioned(
            top: headSize * 0.08,
            left: headSize * 0.15,
            child: Container(
              width: headSize * 0.35,
              height: headSize * 0.2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(headSize),
                gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.white.withOpacity(0.6), Colors.white.withOpacity(0.0)]),
              ),
            ),
          ),
          // Avatar emoji centered
          Center(
            child: Text(
              player.effectiveAvatar.emoji,
              style: TextStyle(
                fontSize: headSize * 0.75, // Larger emoji for better visibility
                shadows: [Shadow(color: Colors.black.withOpacity(0.4), offset: const Offset(1, 1), blurRadius: 3)],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build a specular highlight on top
  Widget _buildSpecularHighlight(double headSize) {
    return IgnorePointer(
      child: Container(
        width: headSize * 0.25,
        height: headSize * 0.15,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(headSize),
          gradient: RadialGradient(colors: [Colors.white.withOpacity(0.0), Colors.white.withOpacity(0.0)]),
        ),
      ),
    );
  }
}

/// Painter for the base rim (bottom-most part)
class _PawnBaseRimPainter extends CustomPainter {
  final Color color;

  _PawnBaseRimPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);

    // 3D rim with metallic look
    final rimPaint = Paint()..shader = LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color.lerp(color, Colors.white, 0.4)!, color, Color.lerp(color, Colors.black, 0.5)!], stops: const [0.0, 0.4, 1.0]).createShader(rect);

    canvas.drawOval(rect, rimPaint);

    // Top edge highlight
    final highlightPaint = Paint()..shader = LinearGradient(begin: Alignment.topCenter, end: Alignment.center, colors: [Colors.white.withOpacity(0.5), Colors.white.withOpacity(0.0)]).createShader(rect);

    canvas.drawOval(Rect.fromLTWH(size.width * 0.15, 0, size.width * 0.7, size.height * 0.5), highlightPaint);

    // Border
    final borderPaint = Paint()
      ..color = Color.lerp(color, Colors.black, 0.4)!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawOval(rect, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Painter for the main base pedestal
class _PawnBasePainter extends CustomPainter {
  final Color color;

  _PawnBasePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;

    // Create a tapered base shape (wider at bottom)
    final path = Path()
      ..moveTo(centerX - size.width * 0.35, size.height)
      ..quadraticBezierTo(centerX - size.width * 0.45, size.height * 0.3, centerX - size.width * 0.3, 0)
      ..lineTo(centerX + size.width * 0.3, 0)
      ..quadraticBezierTo(centerX + size.width * 0.45, size.height * 0.3, centerX + size.width * 0.35, size.height)
      ..close();

    // 3D gradient
    final basePaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [Color.lerp(color, Colors.black, 0.4)!, Color.lerp(color, Colors.white, 0.2)!, color, Color.lerp(color, Colors.black, 0.3)!],
        stops: const [0.0, 0.35, 0.6, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawPath(path, basePaint);

    // Highlight stripe
    final highlightPath = Path()
      ..moveTo(centerX - size.width * 0.15, 0)
      ..quadraticBezierTo(centerX - size.width * 0.2, size.height * 0.3, centerX - size.width * 0.1, size.height)
      ..lineTo(centerX - size.width * 0.25, size.height)
      ..quadraticBezierTo(centerX - size.width * 0.35, size.height * 0.3, centerX - size.width * 0.22, 0)
      ..close();

    final highlightPaint = Paint()..shader = LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.white.withOpacity(0.4), Colors.white.withOpacity(0.15)]).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawPath(highlightPath, highlightPaint);

    // Subtle border
    final borderPaint = Paint()
      ..color = Color.lerp(color, Colors.black, 0.35)!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Painter for the pawn body (elegant curved shape)
class _PawnBodyPainter extends CustomPainter {
  final Color color;

  _PawnBodyPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;

    // Create elegant curved body shape - narrower at top, curved sides
    final path = Path()
      ..moveTo(centerX - size.width * 0.4, size.height)
      ..cubicTo(centerX - size.width * 0.45, size.height * 0.6, centerX - size.width * 0.25, size.height * 0.2, centerX - size.width * 0.15, 0)
      ..lineTo(centerX + size.width * 0.15, 0)
      ..cubicTo(centerX + size.width * 0.25, size.height * 0.2, centerX + size.width * 0.45, size.height * 0.6, centerX + size.width * 0.4, size.height)
      ..close();

    // Rich 3D gradient
    final bodyPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [Color.lerp(color, Colors.black, 0.45)!, Color.lerp(color, Colors.black, 0.15)!, Color.lerp(color, Colors.white, 0.25)!, color, Color.lerp(color, Colors.black, 0.25)!],
        stops: const [0.0, 0.2, 0.4, 0.65, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawPath(path, bodyPaint);

    // Curved highlight stripe
    final highlightPath = Path()
      ..moveTo(centerX - size.width * 0.05, 0)
      ..cubicTo(centerX - size.width * 0.1, size.height * 0.2, centerX - size.width * 0.2, size.height * 0.6, centerX - size.width * 0.12, size.height)
      ..lineTo(centerX - size.width * 0.28, size.height)
      ..cubicTo(centerX - size.width * 0.35, size.height * 0.6, centerX - size.width * 0.18, size.height * 0.2, centerX - size.width * 0.12, 0)
      ..close();

    final highlightPaint = Paint()..shader = LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.white.withOpacity(0.45), Colors.white.withOpacity(0.1)]).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawPath(highlightPath, highlightPaint);

    // Subtle border
    final borderPaint = Paint()
      ..color = Color.lerp(color, Colors.black, 0.3)!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Painter for the pawn neck (narrow elegant stem)
class _PawnNeckPainter extends CustomPainter {
  final Color color;

  _PawnNeckPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;

    // Slightly tapered neck
    final path = Path()
      ..moveTo(centerX - size.width * 0.45, size.height)
      ..lineTo(centerX - size.width * 0.4, 0)
      ..lineTo(centerX + size.width * 0.4, 0)
      ..lineTo(centerX + size.width * 0.45, size.height)
      ..close();

    // 3D cylinder gradient
    final neckPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [Color.lerp(color, Colors.black, 0.4)!, Color.lerp(color, Colors.white, 0.2)!, color, Color.lerp(color, Colors.black, 0.3)!],
        stops: const [0.0, 0.35, 0.6, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawPath(path, neckPaint);

    // Highlight
    final highlightPaint = Paint()
      ..shader = LinearGradient(begin: Alignment.centerLeft, end: Alignment.center, colors: [Colors.white.withOpacity(0.0), Colors.white.withOpacity(0.35), Colors.white.withOpacity(0.1)], stops: const [0.0, 0.4, 1.0]).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawPath(path, highlightPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Painter for the decorative collar under the head
class _PawnCollarPainter extends CustomPainter {
  final Color color;

  _PawnCollarPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);

    // Decorative collar with 3D effect
    final collarPaint = Paint()..shader = LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color.lerp(color, Colors.white, 0.35)!, color, Color.lerp(color, Colors.black, 0.35)!], stops: const [0.0, 0.4, 1.0]).createShader(rect);

    canvas.drawOval(rect, collarPaint);

    // Top highlight
    final highlightPaint = Paint()..shader = LinearGradient(begin: Alignment.topCenter, end: Alignment.center, colors: [Colors.white.withOpacity(0.5), Colors.white.withOpacity(0.0)]).createShader(rect);

    canvas.drawOval(Rect.fromLTWH(size.width * 0.15, 0, size.width * 0.7, size.height * 0.6), highlightPaint);

    // Border
    final borderPaint = Paint()
      ..color = Color.lerp(color, Colors.black, 0.35)!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;
    canvas.drawOval(rect, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// 3D Animated player token with tumbling effect during movement
class ArcAnimatedPlayerToken3D extends StatefulWidget {
  final Player player;
  final Offset targetPosition;
  final double size;
  final bool isCurrentPlayer;
  final bool isMoving;
  final VoidCallback? onMoveComplete;

  const ArcAnimatedPlayerToken3D({super.key, required this.player, required this.targetPosition, required this.size, required this.isCurrentPlayer, this.isMoving = false, this.onMoveComplete});

  @override
  State<ArcAnimatedPlayerToken3D> createState() => _ArcAnimatedPlayerToken3DState();
}

class _ArcAnimatedPlayerToken3DState extends State<ArcAnimatedPlayerToken3D> with TickerProviderStateMixin {
  late AnimationController _moveController;
  late AnimationController _bounceController;
  late AnimationController _idleBounceController;
  late AnimationController _idleRotateController;

  late Animation<double> _moveAnimation;
  late Animation<double> _arcAnimation;
  late Animation<double> _tumbleAnimation;
  late Animation<double> _landingBounceAnimation;
  late Animation<double> _landingSquashAnimation;
  late Animation<double> _idleBounceAnimation;
  late Animation<double> _idleRotateAnimation;

  Offset _startPosition = Offset.zero;
  Offset _currentPosition = Offset.zero;
  bool _hasLanded = false;

  @override
  void initState() {
    super.initState();
    _currentPosition = widget.targetPosition;
    _startPosition = widget.targetPosition;

    // Movement controller for arc animation
    _moveController = AnimationController(duration: const Duration(milliseconds: 400), vsync: this);

    // Landing bounce controller
    _bounceController = AnimationController(duration: const Duration(milliseconds: 300), vsync: this);

    // Idle bounce for current player
    _idleBounceController = AnimationController(duration: const Duration(milliseconds: 1500), vsync: this);

    // Idle rotation wobble for current player
    _idleRotateController = AnimationController(duration: const Duration(milliseconds: 2000), vsync: this);

    _setupAnimations();

    if (widget.isCurrentPlayer) {
      _idleBounceController.repeat();
      _idleRotateController.repeat();
    }
  }

  void _setupAnimations() {
    // Horizontal/position movement
    _moveAnimation = CurvedAnimation(parent: _moveController, curve: Curves.easeInOut);

    // Arc height (parabola)
    _arcAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 0, end: 1).chain(CurveTween(curve: Curves.easeOut)), weight: 50),
      TweenSequenceItem(tween: Tween<double>(begin: 1, end: 0).chain(CurveTween(curve: Curves.easeIn)), weight: 50),
    ]).animate(_moveController);

    // 3D tumble during movement (2 full rotations)
    _tumbleAnimation = Tween<double>(begin: 0, end: 4 * pi).animate(CurvedAnimation(parent: _moveController, curve: Curves.easeInOut));

    // Landing bounce (up then settle)
    _landingBounceAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 0, end: -8).chain(CurveTween(curve: Curves.easeOut)), weight: 30),
      TweenSequenceItem(tween: Tween<double>(begin: -8, end: 3).chain(CurveTween(curve: Curves.easeInOut)), weight: 35),
      TweenSequenceItem(tween: Tween<double>(begin: 3, end: 0).chain(CurveTween(curve: Curves.easeInOut)), weight: 35),
    ]).animate(_bounceController);

    // Squash on landing
    _landingSquashAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 1.15).chain(CurveTween(curve: Curves.easeOut)), weight: 20),
      TweenSequenceItem(tween: Tween<double>(begin: 1.15, end: 0.9).chain(CurveTween(curve: Curves.easeInOut)), weight: 30),
      TweenSequenceItem(tween: Tween<double>(begin: 0.9, end: 1.0).chain(CurveTween(curve: Curves.easeOut)), weight: 50),
    ]).animate(_bounceController);

    // Gentle idle bounce
    _idleBounceAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _idleBounceController, curve: Curves.easeInOut));

    // Gentle idle rotation wobble
    _idleRotateAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _idleRotateController, curve: Curves.easeInOut));

    _moveController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _currentPosition = widget.targetPosition;
        _hasLanded = true;
        _bounceController.forward(from: 0);
      }
    });

    _bounceController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _hasLanded = false;
        widget.onMoveComplete?.call();
        if (widget.isCurrentPlayer) {
          _idleBounceController.repeat();
          _idleRotateController.repeat();
        }
      }
    });
  }

  @override
  void didUpdateWidget(ArcAnimatedPlayerToken3D oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Handle movement
    if (widget.targetPosition != _currentPosition && widget.isMoving) {
      _startPosition = _currentPosition;
      _idleBounceController.stop();
      _idleRotateController.stop();
      _moveController.forward(from: 0);
    }

    // Handle current player changes
    if (widget.isCurrentPlayer != oldWidget.isCurrentPlayer) {
      if (widget.isCurrentPlayer && !_moveController.isAnimating && !_bounceController.isAnimating) {
        _idleBounceController.repeat();
        _idleRotateController.repeat();
      } else if (!widget.isCurrentPlayer) {
        _idleBounceController.stop();
        _idleBounceController.value = 0;
        _idleRotateController.stop();
        _idleRotateController.value = 0;
      }
    }
  }

  @override
  void dispose() {
    _moveController.dispose();
    _bounceController.dispose();
    _idleBounceController.dispose();
    _idleRotateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_moveAnimation, _arcAnimation, _tumbleAnimation, _landingBounceAnimation, _landingSquashAnimation, _idleBounceAnimation, _idleRotateAnimation]),
      builder: (context, child) {
        // Calculate position and rotation
        double x, y;
        double scaleX = 1.0;
        double scaleY = 1.0;
        double rotationX = 0;
        double rotationY = 0;
        double rotationZ = 0;

        if (_moveController.isAnimating) {
          // Arc movement with tumbling
          x = _startPosition.dx + (_moveAnimation.value * (widget.targetPosition.dx - _startPosition.dx));
          y = _startPosition.dy + (_moveAnimation.value * (widget.targetPosition.dy - _startPosition.dy)) - (_arcAnimation.value * 35); // Arc height of 35 pixels

          // 3D tumbling during movement
          rotationX = _tumbleAnimation.value * 0.5; // Roll forward
          rotationY = sin(_tumbleAnimation.value) * 0.3; // Side wobble
          rotationZ = sin(_tumbleAnimation.value * 2) * 0.2; // Spin
        } else if (_hasLanded && _bounceController.isAnimating) {
          // Landing bounce
          x = widget.targetPosition.dx;
          y = widget.targetPosition.dy + _landingBounceAnimation.value;
          scaleX = _landingSquashAnimation.value;
          scaleY = 2.0 - _landingSquashAnimation.value; // Inverse for squash
        } else {
          // Idle position with gentle bounce and wobble
          x = widget.targetPosition.dx;
          final idleBounce = widget.isCurrentPlayer ? sin(_idleBounceAnimation.value * pi) * 6 : 0.0;
          y = widget.targetPosition.dy - idleBounce;

          // Subtle idle wobble for current player
          if (widget.isCurrentPlayer) {
            rotationY = sin(_idleRotateAnimation.value * pi * 2) * 0.08;
            rotationZ = sin(_idleRotateAnimation.value * pi * 2 + pi / 2) * 0.05;
          }
        }

        // Pawn height is 1.5x size, anchor at bottom center
        final pawnHeight = widget.size * 1.5;
        return Positioned(
          left: x - widget.size / 2,
          top: y - pawnHeight + widget.size * 0.35, // Offset to place base at position
          child: Transform.scale(
            scaleX: scaleX,
            scaleY: scaleY,
            alignment: Alignment.bottomCenter,
            child: PlayerToken3D(player: widget.player, size: widget.size, isCurrentPlayer: widget.isCurrentPlayer, rotationX: rotationX, rotationY: rotationY, rotationZ: rotationZ),
          ),
        );
      },
    );
  }
}

/// Simple 3D token that hops between positions with tumbling
class HoppingPlayerToken3D extends StatefulWidget {
  final Player player;
  final Offset position;
  final double size;
  final bool isCurrentPlayer;
  final bool shouldAnimate;

  const HoppingPlayerToken3D({super.key, required this.player, required this.position, required this.size, required this.isCurrentPlayer, this.shouldAnimate = true});

  @override
  State<HoppingPlayerToken3D> createState() => _HoppingPlayerToken3DState();
}

class _HoppingPlayerToken3DState extends State<HoppingPlayerToken3D> with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _idleController;
  late Animation<double> _hopAnimation;
  late Animation<double> _squashAnimation;
  late Animation<double> _tumbleAnimation;
  late Animation<double> _idleRotation;

  Offset _previousPosition = Offset.zero;
  Offset _currentPosition = Offset.zero;
  bool _isHopping = false;

  @override
  void initState() {
    super.initState();
    _currentPosition = widget.position;
    _previousPosition = widget.position;

    _controller = AnimationController(duration: const Duration(milliseconds: 250), vsync: this);

    _idleController = AnimationController(duration: const Duration(milliseconds: 2000), vsync: this);

    _hopAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 0, end: 1).chain(CurveTween(curve: Curves.easeOut)), weight: 50),
      TweenSequenceItem(tween: Tween<double>(begin: 1, end: 0).chain(CurveTween(curve: Curves.bounceOut)), weight: 50),
    ]).animate(_controller);

    _squashAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 0.85), weight: 10),
      TweenSequenceItem(tween: Tween<double>(begin: 0.85, end: 1.1), weight: 40),
      TweenSequenceItem(tween: Tween<double>(begin: 1.1, end: 1.0).chain(CurveTween(curve: Curves.elasticOut)), weight: 50),
    ]).animate(_controller);

    // Tumble during hop
    _tumbleAnimation = Tween<double>(begin: 0, end: 2 * pi).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // Idle wobble
    _idleRotation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _idleController, curve: Curves.easeInOut));

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _isHopping = false;
          _previousPosition = _currentPosition;
        });
        if (widget.isCurrentPlayer) {
          _idleController.repeat();
        }
      }
    });

    if (widget.isCurrentPlayer) {
      _idleController.repeat();
    }
  }

  @override
  void didUpdateWidget(HoppingPlayerToken3D oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.position != _currentPosition && widget.shouldAnimate) {
      _previousPosition = _currentPosition;
      _currentPosition = widget.position;
      _isHopping = true;
      _idleController.stop();
      _controller.forward(from: 0);
    } else if (widget.position != _currentPosition) {
      _currentPosition = widget.position;
      _previousPosition = widget.position;
    }

    if (widget.isCurrentPlayer != oldWidget.isCurrentPlayer) {
      if (widget.isCurrentPlayer && !_isHopping) {
        _idleController.repeat();
      } else if (!widget.isCurrentPlayer) {
        _idleController.stop();
        _idleController.value = 0;
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _idleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_controller, _idleController]),
      builder: (context, child) {
        double x, y;
        double scale = 1.0;
        double rotationX = 0;
        double rotationY = 0;
        double rotationZ = 0;

        if (_isHopping) {
          // Interpolate position
          final progress = _controller.value;
          x = _previousPosition.dx + (progress * (_currentPosition.dx - _previousPosition.dx));
          y = _previousPosition.dy + (progress * (_currentPosition.dy - _previousPosition.dy));

          // Add hop arc
          y -= _hopAnimation.value * 20;

          // Apply squash
          scale = _squashAnimation.value;

          // 3D tumble
          rotationX = _tumbleAnimation.value * 0.4;
          rotationY = sin(_tumbleAnimation.value) * 0.3;
        } else {
          x = widget.position.dx;
          y = widget.position.dy;

          // Subtle idle effects for current player
          if (widget.isCurrentPlayer) {
            final time = DateTime.now().millisecondsSinceEpoch / 1000.0;
            y -= sin(time * 3) * 3;
            rotationY = sin(_idleRotation.value * pi * 2) * 0.06;
            rotationZ = sin(_idleRotation.value * pi * 2 + pi / 2) * 0.04;
          }
        }

        // Pawn height is 1.5x size, anchor at bottom center
        final pawnHeight = widget.size * 1.5;
        return Positioned(
          left: x - widget.size / 2,
          top: y - pawnHeight + widget.size * 0.35, // Offset to place base at position
          child: Transform.scale(
            scale: scale,
            alignment: Alignment.bottomCenter,
            child: PlayerToken3D(player: widget.player, size: widget.size, isCurrentPlayer: widget.isCurrentPlayer, rotationX: rotationX, rotationY: rotationY, rotationZ: rotationZ),
          ),
        );
      },
    );
  }
}

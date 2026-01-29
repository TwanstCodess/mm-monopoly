import 'package:flutter/material.dart';

/// A 3D button widget with press/release depth effect using Matrix4 transforms.
/// Can be reused for any button in the app.
class Button3D extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final Color color;
  final Color? shadowColor;
  final double depth;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final bool enabled;

  const Button3D({
    super.key,
    required this.child,
    this.onPressed,
    this.color = Colors.red,
    this.shadowColor,
    this.depth = 6.0,
    this.borderRadius = 16.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 48, vertical: 18),
    this.enabled = true,
  });

  @override
  State<Button3D> createState() => _Button3DState();
}

class _Button3DState extends State<Button3D>
    with SingleTickerProviderStateMixin {
  late AnimationController _pressController;
  late Animation<double> _pressAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _pressController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );

    _pressAnimation = CurvedAnimation(
      parent: _pressController,
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (!widget.enabled || widget.onPressed == null) return;
    setState(() => _isPressed = true);
    _pressController.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    if (!widget.enabled || widget.onPressed == null) return;
    setState(() => _isPressed = false);
    _pressController.reverse();
    widget.onPressed?.call();
  }

  void _handleTapCancel() {
    if (!widget.enabled || widget.onPressed == null) return;
    setState(() => _isPressed = false);
    _pressController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final isDisabled = !widget.enabled || widget.onPressed == null;
    final baseColor = isDisabled ? Colors.grey.shade600 : widget.color;
    final darkColor = Color.lerp(baseColor, Colors.black, 0.3)!;
    final shadowColor = widget.shadowColor ?? darkColor;

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: AnimatedBuilder(
        animation: _pressAnimation,
        builder: (context, child) {
          final pressDepth = _pressAnimation.value * widget.depth;
          final remainingDepth = widget.depth - pressDepth;

          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001) // perspective
              ..translate(0.0, pressDepth, 0.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                boxShadow: [
                  // Bottom shadow (3D depth effect)
                  BoxShadow(
                    color: shadowColor,
                    offset: Offset(0, remainingDepth),
                    blurRadius: 0,
                    spreadRadius: 0,
                  ),
                  // Soft ambient shadow
                  if (!isDisabled)
                    BoxShadow(
                      color: shadowColor.withValues(alpha: 0.4),
                      offset: Offset(0, remainingDepth + 4),
                      blurRadius: 8,
                      spreadRadius: 0,
                    ),
                ],
              ),
              child: Container(
                padding: widget.padding,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color.lerp(baseColor, Colors.white, 0.1)!,
                      baseColor,
                      Color.lerp(baseColor, Colors.black, 0.1)!,
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                  border: Border.all(
                    color: Color.lerp(baseColor, Colors.white, 0.2)!,
                    width: 1,
                  ),
                ),
                child: child,
              ),
            ),
          );
        },
        child: widget.child,
      ),
    );
  }
}

/// 3D Roll Dice button specifically styled for the game
class RollButton3D extends StatefulWidget {
  final VoidCallback? onPressed;
  final bool isRolling;
  final bool isMoving;
  final AnimationController glowController;

  const RollButton3D({
    super.key,
    required this.onPressed,
    required this.isRolling,
    required this.isMoving,
    required this.glowController,
  });

  @override
  State<RollButton3D> createState() => _RollButton3DState();
}

class _RollButton3DState extends State<RollButton3D>
    with SingleTickerProviderStateMixin {
  late AnimationController _pressController;
  late Animation<double> _pressAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _pressController = AnimationController(
      duration: const Duration(milliseconds: 80),
      vsync: this,
    );

    _pressAnimation = CurvedAnimation(
      parent: _pressController,
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  bool get _isDisabled => widget.isRolling || widget.isMoving;

  void _handleTapDown(TapDownDetails details) {
    if (_isDisabled || widget.onPressed == null) return;
    setState(() => _isPressed = true);
    _pressController.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    if (_isDisabled || widget.onPressed == null) return;
    setState(() => _isPressed = false);
    _pressController.reverse();
    widget.onPressed?.call();
  }

  void _handleTapCancel() {
    if (_isDisabled || widget.onPressed == null) return;
    setState(() => _isPressed = false);
    _pressController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final baseColor = _isDisabled ? Colors.grey.shade600 : Colors.red.shade700;
    final darkColor = Color.lerp(baseColor, Colors.black, 0.4)!;
    const depth = 6.0;

    return AnimatedBuilder(
      animation: Listenable.merge([_pressAnimation, widget.glowController]),
      builder: (context, child) {
        final glow = 0.3 + widget.glowController.value * 0.3;
        final pressDepth = _pressAnimation.value * depth;
        final remainingDepth = depth - pressDepth;

        return GestureDetector(
          onTapDown: _handleTapDown,
          onTapUp: _handleTapUp,
          onTapCancel: _handleTapCancel,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: _isDisabled
                  ? []
                  : [
                      // Glow effect
                      BoxShadow(
                        color: Colors.amber.withValues(alpha: glow),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
            ),
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..translate(0.0, pressDepth, 0.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    // 3D depth shadow
                    BoxShadow(
                      color: darkColor,
                      offset: Offset(0, remainingDepth),
                      blurRadius: 0,
                      spreadRadius: 0,
                    ),
                    // Soft shadow
                    if (!_isDisabled)
                      BoxShadow(
                        color: darkColor.withValues(alpha: 0.5),
                        offset: Offset(0, remainingDepth + 4),
                        blurRadius: 8,
                        spreadRadius: 0,
                      ),
                  ],
                ),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 48, vertical: 18),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color.lerp(baseColor, Colors.white, 0.15)!,
                        baseColor,
                        Color.lerp(baseColor, Colors.black, 0.1)!,
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ),
                    border: Border.all(
                      color: Color.lerp(baseColor, Colors.white, 0.2)!,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    widget.isRolling
                        ? 'ROLLING...'
                        : widget.isMoving
                            ? 'MOVING...'
                            : 'ROLL DICE',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black26,
                          offset: Offset(1, 1),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

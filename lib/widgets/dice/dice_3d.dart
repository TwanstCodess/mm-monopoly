import 'dart:math';
import 'package:flutter/material.dart';

/// A 3D dice widget using Matrix4 transforms to create a rotating cube effect.
/// This technique can be reused for buttons, cards, and other 3D UI elements.
class Dice3D extends StatelessWidget {
  final int value;
  final bool isRolling;
  final AnimationController? animationController;
  final double size;

  const Dice3D({
    super.key,
    required this.value,
    this.isRolling = false,
    this.animationController,
    this.size = 56.0,
  });

  @override
  Widget build(BuildContext context) {
    if (isRolling && animationController != null) {
      return _AnimatedDice3D(
        controller: animationController!,
        size: size,
        targetValue: value,
      );
    }

    return _StaticDice3D(value: value, size: size);
  }
}

/// Static 3D dice with clean depth effect using layered shadows and highlights
class _StaticDice3D extends StatefulWidget {
  final int value;
  final double size;

  const _StaticDice3D({required this.value, required this.size});

  @override
  State<_StaticDice3D> createState() => _StaticDice3DState();
}

class _StaticDice3DState extends State<_StaticDice3D>
    with SingleTickerProviderStateMixin {
  late AnimationController _idleController;
  late Animation<double> _idleAnimation;

  @override
  void initState() {
    super.initState();
    // Subtle idle float animation
    _idleController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _idleAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _idleController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _idleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = widget.size;
    final depth = size * 0.12; // 3D depth amount

    return AnimatedBuilder(
      animation: _idleAnimation,
      builder: (context, child) {
        // Subtle floating effect
        final float = sin(_idleAnimation.value * pi) * 2;

        return Transform.translate(
          offset: Offset(0, -float),
          child: SizedBox(
            width: size + depth,
            height: size + depth,
            child: Stack(
              children: [
                // Drop shadow on ground
                Positioned(
                  bottom: 0,
                  left: depth / 2,
                  child: Container(
                    width: size * 0.85,
                    height: size * 0.12,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(size * 0.4),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.25 - float * 0.02),
                          blurRadius: 10 + float,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                ),
                // Bottom edge (3D depth - darker)
                Positioned(
                  left: depth,
                  top: depth,
                  child: Container(
                    width: size,
                    height: size,
                    decoration: BoxDecoration(
                      color: const Color(0xFFB0B0B0),
                      borderRadius: BorderRadius.circular(size * 0.15),
                    ),
                  ),
                ),
                // Right edge (3D depth - medium)
                Positioned(
                  left: depth * 0.6,
                  top: depth * 0.6,
                  child: Container(
                    width: size,
                    height: size,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD0D0D0),
                      borderRadius: BorderRadius.circular(size * 0.15),
                    ),
                  ),
                ),
                // Main face (top - brightest)
                Positioned(
                  left: 0,
                  top: 0,
                  child: _DiceFace(
                    value: widget.value,
                    size: size,
                    color: Colors.white,
                    isTop: true,
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

/// Animated 3D dice that tumbles through space
class _AnimatedDice3D extends StatelessWidget {
  final AnimationController controller;
  final double size;
  final int targetValue;
  final Random _random = Random();

  _AnimatedDice3D({
    required this.controller,
    required this.size,
    required this.targetValue,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        // Calculate rotation angles for tumbling effect
        final progress = controller.value;
        final rotationX = progress * 4 * pi; // 2 full rotations on X
        final rotationY = progress * 6 * pi; // 3 full rotations on Y
        final rotationZ = progress * 2 * pi; // 1 full rotation on Z

        // Add bounce scale effect
        final scale = 1.0 + sin(progress * pi) * 0.15;

        // Determine which face to show based on rotation
        final displayValue = progress < 0.9 ? _random.nextInt(6) + 1 : targetValue;

        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.002) // stronger perspective during animation
            ..multiply(Matrix4.diagonal3Values(scale, scale, scale))
            ..rotateX(rotationX)
            ..rotateY(rotationY)
            ..rotateZ(rotationZ * 0.3),
          child: _DiceCube(
            size: size,
            displayValue: displayValue,
            glowIntensity: 0.6 + sin(progress * pi * 2) * 0.4,
          ),
        );
      },
    );
  }
}

/// A full 3D cube with all 6 faces
class _DiceCube extends StatelessWidget {
  final double size;
  final int displayValue;
  final double glowIntensity;

  const _DiceCube({
    required this.size,
    required this.displayValue,
    this.glowIntensity = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    final halfSize = size / 2;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.amber.withValues(alpha: glowIntensity),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Front face (value shown)
          _buildFace(
            value: displayValue,
            transform: Matrix4.identity()..setTranslationRaw(0.0, 0.0, halfSize),
          ),
          // Back face
          _buildFace(
            value: 7 - displayValue, // opposite face
            transform: Matrix4.identity()
              ..setTranslationRaw(0.0, 0.0, -halfSize)
              ..rotateY(pi),
          ),
          // Right face
          _buildFace(
            value: _getAdjacentValue(displayValue, 'right'),
            transform: Matrix4.identity()
              ..setTranslationRaw(halfSize, 0.0, 0.0)
              ..rotateY(pi / 2),
          ),
          // Left face
          _buildFace(
            value: _getAdjacentValue(displayValue, 'left'),
            transform: Matrix4.identity()
              ..setTranslationRaw(-halfSize, 0.0, 0.0)
              ..rotateY(-pi / 2),
          ),
          // Top face
          _buildFace(
            value: _getAdjacentValue(displayValue, 'top'),
            transform: Matrix4.identity()
              ..setTranslationRaw(0.0, -halfSize, 0.0)
              ..rotateX(pi / 2),
          ),
          // Bottom face
          _buildFace(
            value: _getAdjacentValue(displayValue, 'bottom'),
            transform: Matrix4.identity()
              ..setTranslationRaw(0.0, halfSize, 0.0)
              ..rotateX(-pi / 2),
          ),
        ],
      ),
    );
  }

  Widget _buildFace({required int value, required Matrix4 transform}) {
    return Transform(
      alignment: Alignment.center,
      transform: transform,
      child: _DiceFace(value: value, size: size, color: Colors.white),
    );
  }

  // Standard dice: opposite faces sum to 7
  // Adjacent faces follow a specific pattern
  int _getAdjacentValue(int front, String position) {
    // Standard dice layout when 1 is front and 2 is top:
    // Front=1, Back=6, Top=2, Bottom=5, Right=3, Left=4
    final Map<int, Map<String, int>> adjacencyMap = {
      1: {'right': 3, 'left': 4, 'top': 2, 'bottom': 5},
      2: {'right': 3, 'left': 4, 'top': 6, 'bottom': 1},
      3: {'right': 6, 'left': 1, 'top': 2, 'bottom': 5},
      4: {'right': 1, 'left': 6, 'top': 2, 'bottom': 5},
      5: {'right': 3, 'left': 4, 'top': 1, 'bottom': 6},
      6: {'right': 4, 'left': 3, 'top': 2, 'bottom': 5},
    };
    return adjacencyMap[front]?[position] ?? 1;
  }
}

/// A single face of the dice with dots
class _DiceFace extends StatelessWidget {
  final int value;
  final double size;
  final Color color;
  final bool isTop;

  const _DiceFace({
    required this.value,
    required this.size,
    required this.color,
    this.isTop = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(size * 0.15),
        border: Border.all(
          color: Colors.grey.shade300,
          width: 1,
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color,
            Color.lerp(color, Colors.grey.shade200, 0.3)!,
          ],
        ),
        boxShadow: isTop
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(2, 4),
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 2,
                ),
              ],
      ),
      child: value == 0
          ? Center(
              child: Text(
                '?',
                style: TextStyle(
                  fontSize: size * 0.5,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            )
          : _DotPattern3D(value: value, size: size),
    );
  }
}

/// Displays traditional dice dot pattern with 3D-styled dots
class _DotPattern3D extends StatelessWidget {
  final int value;
  final double size;

  const _DotPattern3D({required this.value, required this.size});

  double get _dotSize => size * 0.16;
  Color get _dotColor => Colors.red.shade700;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(size * 0.14),
      child: _buildPattern(),
    );
  }

  Widget _buildPattern() {
    switch (value) {
      case 1:
        return _buildOne();
      case 2:
        return _buildTwo();
      case 3:
        return _buildThree();
      case 4:
        return _buildFour();
      case 5:
        return _buildFive();
      case 6:
        return _buildSix();
      default:
        return const SizedBox();
    }
  }

  Widget _dot() {
    return Container(
      width: _dotSize,
      height: _dotSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            _dotColor.withValues(alpha: 0.8),
            _dotColor,
            Color.lerp(_dotColor, Colors.black, 0.3)!,
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
        boxShadow: [
          // Inner highlight (top-left)
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.3),
            blurRadius: 1,
            offset: Offset(-_dotSize * 0.1, -_dotSize * 0.1),
          ),
          // Drop shadow
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 2,
            offset: Offset(_dotSize * 0.1, _dotSize * 0.15),
          ),
        ],
      ),
    );
  }

  Widget _emptyDot() {
    return SizedBox(width: _dotSize, height: _dotSize);
  }

  Widget _buildOne() {
    return Center(child: _dot());
  }

  Widget _buildTwo() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [_dot(), _emptyDot()],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [_emptyDot(), _dot()],
        ),
      ],
    );
  }

  Widget _buildThree() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [_dot(), _emptyDot()],
        ),
        Center(child: _dot()),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [_emptyDot(), _dot()],
        ),
      ],
    );
  }

  Widget _buildFour() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [_dot(), _dot()],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [_dot(), _dot()],
        ),
      ],
    );
  }

  Widget _buildFive() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [_dot(), _dot()],
        ),
        Center(child: _dot()),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [_dot(), _dot()],
        ),
      ],
    );
  }

  Widget _buildSix() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [_dot(), _dot()],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [_dot(), _dot()],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [_dot(), _dot()],
        ),
      ],
    );
  }
}

/// Pair of 3D dice
class DicePair3D extends StatelessWidget {
  final int die1;
  final int die2;
  final bool isRolling;
  final AnimationController? animationController;
  final double diceSize;
  final int diceCount;

  const DicePair3D({
    super.key,
    required this.die1,
    required this.die2,
    this.isRolling = false,
    this.animationController,
    this.diceSize = 56.0,
    this.diceCount = 2,
  });

  @override
  Widget build(BuildContext context) {
    // Single die mode
    if (diceCount == 1) {
      return Center(
        child: Dice3D(
          value: die1,
          isRolling: isRolling,
          animationController: animationController,
          size: diceSize,
        ),
      );
    }

    // Two dice mode
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Dice3D(
          value: die1,
          isRolling: isRolling,
          animationController: animationController,
          size: diceSize,
        ),
        SizedBox(width: diceSize * 0.3),
        Dice3D(
          value: die2,
          isRolling: isRolling,
          animationController: animationController,
          size: diceSize,
        ),
      ],
    );
  }
}

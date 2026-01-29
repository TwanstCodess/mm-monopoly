import 'dart:math';
import 'package:flutter/material.dart';

/// Single die widget
class DieWidget extends StatelessWidget {
  final int value;
  final bool isRolling;
  final AnimationController? animationController;

  const DieWidget({
    super.key,
    required this.value,
    this.isRolling = false,
    this.animationController,
  });

  @override
  Widget build(BuildContext context) {
    if (isRolling && animationController != null) {
      return _AnimatedDie(
        controller: animationController!,
      );
    }

    return _StaticDie(value: value);
  }
}

class _StaticDie extends StatelessWidget {
  final int value;

  const _StaticDie({required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 5,
          ),
        ],
      ),
      child: value == 0
          ? const Center(
              child: Text(
                '?',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            )
          : _DotPattern(value: value),
    );
  }
}

/// Displays traditional dice dot pattern
class _DotPattern extends StatelessWidget {
  final int value;
  static const double _dotSize = 10.0;
  static final Color _dotColor = Colors.red.shade700;

  const _DotPattern({required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
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
        color: _dotColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: _dotColor.withOpacity(0.3),
            blurRadius: 2,
            offset: const Offset(1, 1),
          ),
        ],
      ),
    );
  }

  Widget _emptyDot() {
    return SizedBox(width: _dotSize, height: _dotSize);
  }

  // Pattern: center dot only
  Widget _buildOne() {
    return Center(child: _dot());
  }

  // Pattern: top-left and bottom-right
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

  // Pattern: top-left, center, bottom-right (diagonal)
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

  // Pattern: all four corners
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

  // Pattern: all four corners + center
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

  // Pattern: two columns of three dots
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

class _AnimatedDie extends StatelessWidget {
  final AnimationController controller;
  final Random _random = Random();

  _AnimatedDie({required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final rotation = controller.value * 4 * pi;
        final scale = 1.0 + sin(controller.value * pi) * 0.2;
        final randomValue = _random.nextInt(6) + 1;

        return Transform.scale(
          scale: scale,
          child: Transform.rotate(
            angle: rotation,
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.amber.withOpacity(0.6),
                    blurRadius: 15,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: _DotPattern(value: randomValue),
            ),
          ),
        );
      },
    );
  }
}

/// Pair of dice widget
class DicePair extends StatelessWidget {
  final int die1;
  final int die2;
  final bool isRolling;
  final AnimationController? animationController;

  const DicePair({
    super.key,
    required this.die1,
    required this.die2,
    this.isRolling = false,
    this.animationController,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        DieWidget(
          value: die1,
          isRolling: isRolling,
          animationController: animationController,
        ),
        const SizedBox(width: 16),
        DieWidget(
          value: die2,
          isRolling: isRolling,
          animationController: animationController,
        ),
      ],
    );
  }
}

/// Roll button with glow effect
class RollButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isRolling;
  final bool isMoving;
  final AnimationController glowController;

  const RollButton({
    super.key,
    required this.onPressed,
    required this.isRolling,
    required this.isMoving,
    required this.glowController,
  });

  @override
  Widget build(BuildContext context) {
    final isDisabled = isRolling || isMoving;

    return AnimatedBuilder(
      animation: glowController,
      builder: (context, child) {
        final glow = 0.3 + glowController.value * 0.3;

        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: isDisabled
                ? []
                : [
                    BoxShadow(
                      color: Colors.amber.withOpacity(glow),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
          ),
          child: ElevatedButton(
            onPressed: isDisabled ? null : onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade700,
              foregroundColor: Colors.white,
              disabledBackgroundColor: Colors.grey.shade600,
              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 8,
            ),
            child: Text(
              isRolling
                  ? 'ROLLING...'
                  : isMoving
                      ? 'MOVING...'
                      : 'ROLL DICE',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Center controls widget containing dice and roll button with improved animations
class CenterControls extends StatefulWidget {
  final int die1;
  final int die2;
  final bool isRolling;
  final bool isMoving;
  final VoidCallback? onRoll;
  final AnimationController diceController;
  final AnimationController glowController;

  const CenterControls({
    super.key,
    required this.die1,
    required this.die2,
    required this.isRolling,
    required this.isMoving,
    required this.onRoll,
    required this.diceController,
    required this.glowController,
  });

  @override
  State<CenterControls> createState() => _CenterControlsState();
}

class _CenterControlsState extends State<CenterControls>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final canRoll = !widget.isRolling && !widget.isMoving && widget.onRoll != null;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Dice area with subtle bounce animation when idle
        AnimatedBuilder(
          animation: _pulseController,
          builder: (context, child) {
            final scale = canRoll ? 1.0 + _pulseController.value * 0.02 : 1.0;
            return Transform.scale(
              scale: scale,
              child: DicePair(
                die1: widget.die1,
                die2: widget.die2,
                isRolling: widget.isRolling,
                animationController: widget.diceController,
              ),
            );
          },
        ),
        const SizedBox(height: 16),
        // Roll button
        RollButton(
          onPressed: widget.onRoll,
          isRolling: widget.isRolling,
          isMoving: widget.isMoving,
          glowController: widget.glowController,
        ),
      ],
    );
  }
}

/// Card deck display widget with stacked cards effect
class CardDeck extends StatefulWidget {
  final String label;
  final Color color;
  final IconData icon;

  const CardDeck({
    super.key,
    required this.label,
    required this.color,
    required this.icon,
  });

  @override
  State<CardDeck> createState() => _CardDeckState();
}

class _CardDeckState extends State<CardDeck>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _hoverController,
      builder: (context, child) {
        final float = sin(_hoverController.value * pi) * 2;
        return Transform.translate(
          offset: Offset(0, -float),
          child: SizedBox(
            width: 70,
            height: 55,
            child: Stack(
              children: [
                // Back cards (stacked effect)
                Positioned(
                  left: 4,
                  top: 4,
                  child: _buildCard(opacity: 0.3),
                ),
                Positioned(
                  left: 2,
                  top: 2,
                  child: _buildCard(opacity: 0.5),
                ),
                // Front card
                _buildCard(opacity: 1.0, isTop: true),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCard({required double opacity, bool isTop = false}) {
    // Use solid background with the theme color for better readability
    final bgColor = isTop ? widget.color : widget.color.withOpacity(0.7 * opacity);

    return Container(
      width: 66,
      height: 50,
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(
          color: isTop ? Colors.white.withOpacity(0.5) : widget.color.withOpacity(opacity),
          width: isTop ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(8),
        boxShadow: isTop
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: isTop
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(widget.icon, color: Colors.white, size: 18),
                const SizedBox(height: 2),
                Text(
                  widget.label,
                  style: const TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            )
          : null,
    );
  }
}

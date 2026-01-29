import 'dart:math';
import 'package:flutter/material.dart';
import '../../models/spin_prize.dart';

/// Animated spin wheel widget
class SpinWheelWidget extends StatefulWidget {
  final List<SpinPrize> prizes;
  final Function(SpinPrize) onPrizeWon;
  final double size;

  const SpinWheelWidget({
    super.key,
    required this.prizes,
    required this.onPrizeWon,
    this.size = 300,
  });

  @override
  State<SpinWheelWidget> createState() => SpinWheelWidgetState();
}

class SpinWheelWidgetState extends State<SpinWheelWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;

  bool _isSpinning = false;
  SpinPrize? _selectedPrize;
  double _currentRotation = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() => _isSpinning = false);
        if (_selectedPrize != null) {
          widget.onPrizeWon(_selectedPrize!);
        }
      }
    });
  }

  void spin() {
    if (_isSpinning) return;

    setState(() {
      _isSpinning = true;
      _selectedPrize = _selectRandomPrize();
    });

    // Calculate target rotation
    final prizeIndex = widget.prizes.indexOf(_selectedPrize!);
    final sliceAngle = 2 * pi / widget.prizes.length;
    final prizeAngle = prizeIndex * sliceAngle + sliceAngle / 2;

    // Spin multiple rotations plus land on prize
    // We want the pointer (at top) to land on the prize
    // So we need to rotate so the prize is at the top
    final targetRotation =
        _currentRotation + (5 * 2 * pi) + (2 * pi - prizeAngle) - (_currentRotation % (2 * pi));

    _rotationAnimation = Tween<double>(
      begin: _currentRotation,
      end: targetRotation,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _currentRotation = targetRotation;
    _controller.forward(from: 0);
  }

  SpinPrize _selectRandomPrize() {
    final random = Random();
    final totalWeight =
        widget.prizes.fold<double>(0, (sum, p) => sum + p.weight);
    final randomValue = random.nextDouble() * totalWeight;

    double cumulative = 0;
    for (final prize in widget.prizes) {
      cumulative += prize.weight;
      if (randomValue <= cumulative) {
        return prize;
      }
    }
    return widget.prizes.last;
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
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Wheel
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final rotation = _isSpinning
                  ? _rotationAnimation.value
                  : _currentRotation;
              return Transform.rotate(
                angle: rotation,
                child: CustomPaint(
                  size: Size(widget.size, widget.size),
                  painter: _WheelPainter(prizes: widget.prizes),
                ),
              );
            },
          ),

          // Center button
          GestureDetector(
            onTap: _isSpinning ? null : spin,
            child: Container(
              width: widget.size * 0.25,
              height: widget.size * 0.25,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.amber.shade300,
                    Colors.amber.shade700,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
                border: Border.all(color: Colors.white, width: 3),
              ),
              child: Center(
                child: _isSpinning
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 3,
                      )
                    : const Text(
                        'SPIN',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
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
            ),
          ),

          // Pointer
          Positioned(
            top: 0,
            child: CustomPaint(
              size: const Size(30, 40),
              painter: _PointerPainter(),
            ),
          ),
        ],
      ),
    );
  }
}

class _WheelPainter extends CustomPainter {
  final List<SpinPrize> prizes;

  _WheelPainter({required this.prizes});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;
    final sliceAngle = 2 * pi / prizes.length;

    // Draw outer ring
    final outerRingPaint = Paint()
      ..color = Colors.amber.shade700
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8;
    canvas.drawCircle(center, radius + 4, outerRingPaint);

    // Draw slices
    for (int i = 0; i < prizes.length; i++) {
      final startAngle = i * sliceAngle - pi / 2;
      final prize = prizes[i];

      // Slice fill
      final slicePaint = Paint()
        ..color = prize.color
        ..style = PaintingStyle.fill;

      final path = Path()
        ..moveTo(center.dx, center.dy)
        ..arcTo(
          Rect.fromCircle(center: center, radius: radius),
          startAngle,
          sliceAngle,
          false,
        )
        ..close();

      canvas.drawPath(path, slicePaint);

      // Slice border
      final borderPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      canvas.drawPath(path, borderPaint);

      // Draw icon and text
      final iconAngle = startAngle + sliceAngle / 2;
      final iconRadius = radius * 0.65;
      final iconCenter = Offset(
        center.dx + cos(iconAngle) * iconRadius,
        center.dy + sin(iconAngle) * iconRadius,
      );

      // Draw icon
      final iconPainter = TextPainter(
        text: TextSpan(
          text: String.fromCharCode(prize.icon.codePoint),
          style: TextStyle(
            fontSize: 24,
            fontFamily: prize.icon.fontFamily,
            color: Colors.white,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      iconPainter.layout();
      iconPainter.paint(
        canvas,
        Offset(
          iconCenter.dx - iconPainter.width / 2,
          iconCenter.dy - iconPainter.height / 2,
        ),
      );

      // Draw prize name (smaller, closer to edge)
      final textRadius = radius * 0.85;
      final textCenter = Offset(
        center.dx + cos(iconAngle) * textRadius,
        center.dy + sin(iconAngle) * textRadius,
      );

      canvas.save();
      canvas.translate(textCenter.dx, textCenter.dy);
      canvas.rotate(iconAngle + pi / 2);

      final textPainter = TextPainter(
        text: TextSpan(
          text: prize.name,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(-textPainter.width / 2, -textPainter.height / 2),
      );

      canvas.restore();
    }

    // Draw decorative pegs
    final pegCount = prizes.length;
    for (int i = 0; i < pegCount; i++) {
      final angle = i * sliceAngle - pi / 2;
      final pegCenter = Offset(
        center.dx + cos(angle) * radius,
        center.dy + sin(angle) * radius,
      );

      // Peg shadow
      canvas.drawCircle(
        pegCenter + const Offset(1, 1),
        5,
        Paint()..color = Colors.black38,
      );

      // Peg
      canvas.drawCircle(
        pegCenter,
        5,
        Paint()..color = Colors.amber.shade300,
      );
      canvas.drawCircle(
        pegCenter,
        3,
        Paint()..color = Colors.white,
      );
    }
  }

  @override
  bool shouldRepaint(_WheelPainter oldDelegate) => false;
}

class _PointerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(size.width / 2, size.height)
      ..lineTo(0, 0)
      ..lineTo(size.width, 0)
      ..close();

    // Shadow
    canvas.drawPath(
      path.shift(const Offset(2, 2)),
      Paint()..color = Colors.black38,
    );

    // Pointer
    canvas.drawPath(
      path,
      Paint()..color = Colors.red.shade700,
    );

    // Highlight
    canvas.drawPath(
      path,
      Paint()
        ..color = Colors.red.shade400
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }

  @override
  bool shouldRepaint(_PointerPainter oldDelegate) => false;
}

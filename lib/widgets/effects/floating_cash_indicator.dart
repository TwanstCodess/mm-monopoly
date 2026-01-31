import 'package:flutter/material.dart';
import '../../config/theme.dart';

/// Floating cash change indicator that animates upward and fades out
class FloatingCashIndicator extends StatefulWidget {
  final int amount;
  final VoidCallback onComplete;

  const FloatingCashIndicator({super.key, required this.amount, required this.onComplete});

  @override
  State<FloatingCashIndicator> createState() => _FloatingCashIndicatorState();
}

class _FloatingCashIndicatorState extends State<FloatingCashIndicator> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _floatAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 1500), vsync: this);

    // Float upward animation
    _floatAnimation = Tween<double>(begin: 0, end: -80).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    // Fade out animation (starts fading at 60% progress)
    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0, curve: Curves.easeIn),
      ),
    );

    // Scale animation - slight pop at start
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 0.5, end: 1.2).chain(CurveTween(curve: Curves.easeOut)), weight: 20),
      TweenSequenceItem(tween: Tween<double>(begin: 1.2, end: 1.0).chain(CurveTween(curve: Curves.easeInOut)), weight: 20),
      TweenSequenceItem(tween: ConstantTween<double>(1.0), weight: 60),
    ]).animate(_controller);

    _controller.forward();
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        widget.onComplete();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isGain = widget.amount > 0;
    final color = isGain ? AppTheme.cashGreen : AppTheme.error;
    final prefix = isGain ? '+' : '';
    final icon = isGain ? Icons.arrow_upward : Icons.arrow_downward;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _floatAnimation.value),
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: color.withOpacity(0.4), blurRadius: 8, spreadRadius: 1)],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icon, color: Colors.white, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      '$prefix\$${widget.amount.abs()}',
                      style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Manager class to show floating cash indicators using overlay
class CashIndicatorManager {
  static OverlayEntry? _currentEntry;

  /// Show a floating cash indicator at the given position
  static void show(BuildContext context, {required int amount, required Offset position}) {
    // Remove any existing indicator
    _currentEntry?.remove();

    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (context) => Positioned(
        left: position.dx - 50, // Center horizontally
        top: position.dy - 20,
        child: Material(
          color: Colors.transparent,
          child: FloatingCashIndicator(
            amount: amount,
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

  /// Remove any active indicator
  static void dismiss() {
    _currentEntry?.remove();
    _currentEntry = null;
  }
}

/// Widget that wraps a cash display and shows floating indicators on changes
class AnimatedCashDisplay extends StatefulWidget {
  final int cash;
  final TextStyle? style;
  final bool showIndicator;

  const AnimatedCashDisplay({super.key, required this.cash, this.style, this.showIndicator = true});

  @override
  State<AnimatedCashDisplay> createState() => _AnimatedCashDisplayState();
}

class _AnimatedCashDisplayState extends State<AnimatedCashDisplay> {
  // ignore: unused_field - tracks state for didUpdateWidget
  int _previousCash = 0;
  final GlobalKey _key = GlobalKey();

  @override
  void initState() {
    super.initState();
    _previousCash = widget.cash;
  }

  @override
  void didUpdateWidget(AnimatedCashDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.showIndicator && widget.cash != oldWidget.cash) {
      final difference = widget.cash - oldWidget.cash;
      _showFloatingIndicator(difference);
      _previousCash = widget.cash;
    }
  }

  void _showFloatingIndicator(int amount) {
    // Schedule the overlay insertion for after the current build phase
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final renderBox = _key.currentContext?.findRenderObject() as RenderBox?;
      if (renderBox != null) {
        final position = renderBox.localToGlobal(Offset.zero);
        final size = renderBox.size;
        // Position the indicator above the cash display
        CashIndicatorManager.show(context, amount: amount, position: Offset(position.dx + size.width / 2, position.dy));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      '\$${widget.cash}',
      key: _key,
      style: widget.style ?? const TextStyle(color: AppTheme.cashGreen, fontSize: 18, fontWeight: FontWeight.bold),
    );
  }
}

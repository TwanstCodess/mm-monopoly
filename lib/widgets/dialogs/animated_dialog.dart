import 'package:flutter/material.dart';

/// Animated dialog wrapper with scale + fade entrance
class AnimatedGameDialog extends StatefulWidget {
  final Widget child;
  final Duration enterDuration;
  final Curve enterCurve;

  const AnimatedGameDialog({
    super.key,
    required this.child,
    this.enterDuration = const Duration(milliseconds: 300),
    this.enterCurve = Curves.easeOutBack,
  });

  @override
  State<AnimatedGameDialog> createState() => _AnimatedGameDialogState();
}

class _AnimatedGameDialogState extends State<AnimatedGameDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.enterDuration,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: widget.enterCurve),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: widget.child,
          ),
        );
      },
    );
  }
}

/// Slide up dialog animation (for rent/tax dialogs)
class SlideUpGameDialog extends StatefulWidget {
  final Widget child;
  final Duration enterDuration;

  const SlideUpGameDialog({
    super.key,
    required this.child,
    this.enterDuration = const Duration(milliseconds: 350),
  });

  @override
  State<SlideUpGameDialog> createState() => _SlideUpGameDialogState();
}

class _SlideUpGameDialogState extends State<SlideUpGameDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.enterDuration,
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: SlideTransition(
            position: _slideAnimation,
            child: widget.child,
          ),
        );
      },
    );
  }
}

/// Card flip dialog animation (for Chance/Community Chest cards)
class CardFlipGameDialog extends StatefulWidget {
  final Widget child;
  final Duration enterDuration;

  const CardFlipGameDialog({
    super.key,
    required this.child,
    this.enterDuration = const Duration(milliseconds: 500),
  });

  @override
  State<CardFlipGameDialog> createState() => _CardFlipGameDialogState();
}

class _CardFlipGameDialogState extends State<CardFlipGameDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _flipAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.enterDuration,
      vsync: this,
    );

    _flipAnimation = Tween<double>(begin: 0.5, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value.clamp(0.0, 1.0),
          child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001) // Perspective
              ..rotateY(_flipAnimation.value * 3.14159),
            child: widget.child,
          ),
        );
      },
    );
  }
}

/// Helper function to show animated dialog
Future<T?> showAnimatedDialog<T>({
  required BuildContext context,
  required Widget Function(BuildContext) builder,
  bool barrierDismissible = true,
  DialogAnimationType animationType = DialogAnimationType.scale,
}) {
  return showGeneralDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Colors.black54,
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (context, animation, secondaryAnimation) {
      final child = builder(context);

      switch (animationType) {
        case DialogAnimationType.scale:
          return AnimatedGameDialog(child: child);
        case DialogAnimationType.slideUp:
          return SlideUpGameDialog(child: child);
        case DialogAnimationType.cardFlip:
          return CardFlipGameDialog(child: child);
      }
    },
  );
}

enum DialogAnimationType {
  scale,
  slideUp,
  cardFlip,
}

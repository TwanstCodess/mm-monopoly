import 'package:flutter/material.dart';
import '../../models/event_card.dart';
import '../../config/theme.dart';
import 'animated_dialog.dart';

/// Dialog for announcing a random event
class EventDialog extends StatefulWidget {
  final EventCard event;
  final VoidCallback onDismiss;

  const EventDialog({
    super.key,
    required this.event,
    required this.onDismiss,
  });

  @override
  State<EventDialog> createState() => _EventDialogState();
}

class _EventDialogState extends State<EventDialog>
    with TickerProviderStateMixin {
  late AnimationController _entranceController;
  late AnimationController _pulseController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    _entranceController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: 1.15)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 60,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.15, end: 1.0)
            .chain(CurveTween(curve: Curves.elasticOut)),
        weight: 40,
      ),
    ]).animate(_entranceController);

    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _entranceController.forward().then((_) {
      _pulseController.repeat(reverse: true);
    });
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: AnimatedBuilder(
        animation: Listenable.merge([_scaleAnimation, _pulseAnimation]),
        builder: (context, child) {
          final scale = _entranceController.isCompleted
              ? _pulseAnimation.value
              : _scaleAnimation.value;

          return Transform.scale(
            scale: scale,
            child: _buildCard(),
          );
        },
      ),
    );
  }

  Widget _buildCard() {
    final category = widget.event.category;

    return Container(
      constraints: const BoxConstraints(maxWidth: 340),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: category.color.withOpacity(0.5), width: 3),
        boxShadow: [
          BoxShadow(
            color: category.color.withOpacity(0.4),
            blurRadius: 30,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(),
          _buildContent(),
          _buildDuration(),
          _buildAction(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final category = widget.event.category;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            category.color.withOpacity(0.8),
            category.color,
          ],
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(21)),
      ),
      child: Column(
        children: [
          // Category icon with glow
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.2),
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Icon(
              category.icon,
              size: 40,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          // Category label
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              category.displayName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Event icon
          Icon(
            widget.event.icon,
            size: 48,
            color: widget.event.category.color,
          ),
          const SizedBox(height: 16),
          // Event name
          Text(
            widget.event.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          // Event description
          Text(
            widget.event.description,
            style: TextStyle(
              color: Colors.white.withOpacity(0.85),
              fontSize: 16,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDuration() {
    if (widget.event.duration == null) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: widget.event.category.color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.timer,
            color: widget.event.category.color,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            'Lasts ${widget.event.duration} round${widget.event.duration! > 1 ? 's' : ''}',
            style: TextStyle(
              color: widget.event.category.color,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAction() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            widget.onDismiss();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: widget.event.category.color,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            'Got it!',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

/// Show the event dialog
Future<void> showEventDialog({
  required BuildContext context,
  required EventCard event,
  required VoidCallback onDismiss,
}) {
  return showAnimatedDialog(
    context: context,
    barrierDismissible: false,
    animationType: DialogAnimationType.scale,
    builder: (context) => EventDialog(
      event: event,
      onDismiss: onDismiss,
    ),
  );
}

/// Active event indicator widget (shown on game board)
class ActiveEventIndicator extends StatefulWidget {
  final ActiveEvent activeEvent;
  final VoidCallback? onTap;

  const ActiveEventIndicator({
    super.key,
    required this.activeEvent,
    this.onTap,
  });

  @override
  State<ActiveEventIndicator> createState() => _ActiveEventIndicatorState();
}

class _ActiveEventIndicatorState extends State<ActiveEventIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final event = widget.activeEvent.event;
    final category = event.category;

    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _pulseAnimation.value,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: category.color.withOpacity(0.9),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: category.color.withOpacity(0.5),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(event.icon, color: Colors.white, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    event.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (!widget.activeEvent.isInstant) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${widget.activeEvent.remainingRounds}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

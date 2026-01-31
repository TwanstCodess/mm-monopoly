import 'package:flutter/material.dart';
import '../../config/theme.dart';

/// Dialog for displaying Chance and Community Chest cards with flip animation
class CardDialog extends StatefulWidget {
  final bool isChance;
  final String cardText;
  final String effect;
  final VoidCallback onDismiss;

  const CardDialog({super.key, required this.isChance, required this.cardText, required this.effect, required this.onDismiss});

  @override
  State<CardDialog> createState() => _CardDialogState();
}

class _CardDialogState extends State<CardDialog> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _flipAnimation;
  late Animation<double> _scaleAnimation;
  // ignore: unused_field - used for setState triggers
  bool _showFront = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 600), vsync: this);

    _flipAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    // Start with card appearing, then flip after a moment
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _controller.forward();
        Future.delayed(const Duration(milliseconds: 300), () {
          if (mounted) {
            setState(() {
              _showFront = false;
            });
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color get cardColor => widget.isChance ? Colors.orange : Colors.blue;
  Color get cardColorDark => widget.isChance ? Colors.orange.shade800 : Colors.blue.shade800;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Card with flip animation
            AnimatedBuilder(
              animation: _flipAnimation,
              builder: (context, child) {
                final angle = _flipAnimation.value * 3.14159;
                final showBack = angle > 1.5708; // > 90 degrees

                return Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..rotateY(angle),
                  child: showBack ? Transform(alignment: Alignment.center, transform: Matrix4.identity()..rotateY(3.14159), child: _buildCardBack()) : _buildCardFront(),
                );
              },
            ),
            const SizedBox(height: 24),
            // OK button
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                widget.onDismiss();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: cardColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('OK', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardFront() {
    return Container(
      width: 280,
      height: 380,
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [cardColor, cardColorDark]),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: cardColor.withAlpha(128), blurRadius: 20, spreadRadius: 5)],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Card type icon
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(color: Colors.white.withAlpha(51), shape: BoxShape.circle),
            child: Icon(widget.isChance ? Icons.help_outline : Icons.inventory_2, size: 48, color: Colors.white),
          ),
          const SizedBox(height: 24),
          // Card type text
          Text(
            widget.isChance ? 'CHANCE' : 'COMMUNITY\nCHEST',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: 3),
          ),
          const SizedBox(height: 16),
          // Decorative element
          Container(
            width: 100,
            height: 4,
            decoration: BoxDecoration(color: Colors.white.withAlpha(128), borderRadius: BorderRadius.circular(2)),
          ),
          const SizedBox(height: 16),
          Text(widget.isChance ? '?' : '\u2665', style: TextStyle(color: Colors.white.withAlpha(128), fontSize: 48)),
        ],
      ),
    );
  }

  Widget _buildCardBack() {
    return Container(
      width: 280,
      height: 380,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cardColor, width: 4),
        boxShadow: [BoxShadow(color: cardColor.withAlpha(128), blurRadius: 20, spreadRadius: 5)],
      ),
      child: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Text(
              widget.isChance ? 'CHANCE' : 'COMMUNITY CHEST',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 2),
            ),
          ),
          // Card content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Effect icon
                  _buildEffectIcon(),
                  const SizedBox(height: 24),
                  // Card text
                  Text(
                    widget.cardText,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey.shade800, fontSize: 20, fontWeight: FontWeight.w600, height: 1.4),
                  ),
                  const SizedBox(height: 16),
                  // Effect description
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: _getEffectColor().withAlpha(26),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: _getEffectColor()),
                    ),
                    child: Text(
                      widget.effect,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: _getEffectColor(), fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEffectIcon() {
    IconData icon;
    Color color;

    if (widget.effect.contains('+')) {
      icon = Icons.arrow_upward;
      color = AppTheme.cashGreen;
    } else if (widget.effect.contains('-')) {
      icon = Icons.arrow_downward;
      color = AppTheme.error;
    } else if (widget.effect.toLowerCase().contains('go')) {
      icon = Icons.directions_run;
      color = Colors.blue;
    } else if (widget.effect.toLowerCase().contains('jail')) {
      icon = Icons.gavel;
      color = Colors.orange;
    } else {
      icon = Icons.shuffle;
      color = Colors.purple;
    }

    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: color.withAlpha(26),
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 2),
      ),
      child: Icon(icon, size: 32, color: color),
    );
  }

  Color _getEffectColor() {
    if (widget.effect.contains('+')) {
      return AppTheme.cashGreen;
    } else if (widget.effect.contains('-')) {
      return AppTheme.error;
    }
    return Colors.blue;
  }
}

/// Show the card dialog with animation
Future<void> showCardDialog({required BuildContext context, required bool isChance, required String cardText, required String effect, required VoidCallback onDismiss}) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black87,
    builder: (context) => CardDialog(isChance: isChance, cardText: cardText, effect: effect, onDismiss: onDismiss),
  );
}

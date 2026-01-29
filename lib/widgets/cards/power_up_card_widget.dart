import 'dart:math';
import 'package:flutter/material.dart';
import '../../models/power_up_card.dart';

/// Visual representation of a power-up card
class PowerUpCardWidget extends StatefulWidget {
  final PowerUpCard card;
  final double width;
  final bool isFlipped;
  final bool isUsable;
  final VoidCallback? onTap;
  final VoidCallback? onUse;

  const PowerUpCardWidget({
    super.key,
    required this.card,
    this.width = 120,
    this.isFlipped = false,
    this.isUsable = true,
    this.onTap,
    this.onUse,
  });

  @override
  State<PowerUpCardWidget> createState() => _PowerUpCardWidgetState();
}

class _PowerUpCardWidgetState extends State<PowerUpCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _shineController;
  late Animation<double> _shineAnimation;

  @override
  void initState() {
    super.initState();
    _shineController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _shineAnimation = Tween<double>(begin: -1, end: 2).animate(
      CurvedAnimation(parent: _shineController, curve: Curves.easeInOut),
    );

    // Animate legendary cards
    if (widget.card.rarity == CardRarity.legendary ||
        widget.card.rarity == CardRarity.rare) {
      _shineController.repeat();
    }
  }

  @override
  void dispose() {
    _shineController.dispose();
    super.dispose();
  }

  double get _height => widget.width * 1.4;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _shineAnimation,
        builder: (context, child) {
          return Container(
            width: widget.width,
            height: _height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: widget.card.rarity.glowColor,
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                children: [
                  // Card background
                  _buildCardBackground(),
                  // Shine effect
                  if (widget.card.rarity == CardRarity.legendary ||
                      widget.card.rarity == CardRarity.rare)
                    _buildShineEffect(),
                  // Card content
                  _buildCardContent(),
                  // Disabled overlay
                  if (!widget.isUsable)
                    Container(
                      color: Colors.black.withOpacity(0.5),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCardBackground() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            widget.card.primaryColor.withOpacity(0.9),
            widget.card.primaryColor.withOpacity(0.7),
            widget.card.primaryColor.withOpacity(0.8),
          ],
        ),
      ),
    );
  }

  Widget _buildShineEffect() {
    return Positioned.fill(
      child: ShaderMask(
        shaderCallback: (bounds) {
          return LinearGradient(
            begin: Alignment(-1 + _shineAnimation.value, -1),
            end: Alignment(_shineAnimation.value, 1),
            colors: [
              Colors.transparent,
              Colors.white.withOpacity(0.3),
              Colors.transparent,
            ],
            stops: const [0.0, 0.5, 1.0],
          ).createShader(bounds);
        },
        blendMode: BlendMode.srcOver,
        child: Container(color: Colors.transparent),
      ),
    );
  }

  Widget _buildCardContent() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          // Rarity indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: widget.card.rarity.color,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              widget.card.rarity.displayName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 9,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Spacer(),
          // Icon
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              widget.card.icon,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(height: 8),
          // Name
          Text(
            widget.card.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          // Description
          Text(
            widget.card.description,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 9,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),
          // Use button
          if (widget.isUsable && widget.onUse != null)
            GestureDetector(
              onTap: widget.onUse,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'USE',
                  style: TextStyle(
                    color: widget.card.primaryColor,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Card flip reveal animation
class CardFlipReveal extends StatefulWidget {
  final PowerUpCard card;
  final double width;
  final VoidCallback? onRevealComplete;

  const CardFlipReveal({
    super.key,
    required this.card,
    this.width = 150,
    this.onRevealComplete,
  });

  @override
  State<CardFlipReveal> createState() => _CardFlipRevealState();
}

class _CardFlipRevealState extends State<CardFlipReveal>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _flipAnimation;
  bool _showFront = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _flipAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.addListener(() {
      if (_flipAnimation.value >= 0.5 && !_showFront) {
        setState(() => _showFront = true);
      }
    });

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onRevealComplete?.call();
      }
    });

    // Start flip after brief delay
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _flipAnimation,
      builder: (context, child) {
        final angle = _flipAnimation.value * pi;

        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(angle),
          child: _showFront ? _buildFront() : _buildBack(),
        );
      },
    );
  }

  Widget _buildBack() {
    return Container(
      width: widget.width,
      height: widget.width * 1.4,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF5C6BC0),
            Color(0xFF3949AB),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white24, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Center(
        child: Icon(
          Icons.question_mark,
          size: widget.width * 0.4,
          color: Colors.white54,
        ),
      ),
    );
  }

  Widget _buildFront() {
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()..rotateY(pi),
      child: PowerUpCardWidget(
        card: widget.card,
        width: widget.width,
        isUsable: false,
      ),
    );
  }
}

/// Player's hand of power-up cards
class PowerUpHand extends StatelessWidget {
  final List<PowerUpCard> cards;
  final Function(PowerUpCard)? onCardTap;
  final Function(PowerUpCard)? onCardUse;
  final int maxCards;

  const PowerUpHand({
    super.key,
    required this.cards,
    this.onCardTap,
    this.onCardUse,
    this.maxCards = 5,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (int i = 0; i < maxCards; i++)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: i < cards.length
                  ? _CardSlot(
                      card: cards[i],
                      onTap: () => onCardTap?.call(cards[i]),
                      onUse: () => onCardUse?.call(cards[i]),
                    )
                  : _EmptySlot(),
            ),
        ],
      ),
    );
  }
}

class _CardSlot extends StatelessWidget {
  final PowerUpCard card;
  final VoidCallback? onTap;
  final VoidCallback? onUse;

  const _CardSlot({
    required this.card,
    this.onTap,
    this.onUse,
  });

  @override
  Widget build(BuildContext context) {
    return PowerUpCardWidget(
      card: card,
      width: 60,
      onTap: onTap,
      onUse: onUse,
    );
  }
}

class _EmptySlot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 84,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          style: BorderStyle.solid,
        ),
      ),
      child: Icon(
        Icons.add,
        color: Colors.white.withOpacity(0.2),
        size: 24,
      ),
    );
  }
}

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../l10n/app_localizations.dart';

/// Quick tap mini-game - tap coins, avoid bombs
class QuickTapGame extends StatefulWidget {
  final VoidCallback onComplete;
  final Function(int) onScoreEarned;

  const QuickTapGame({
    super.key,
    required this.onComplete,
    required this.onScoreEarned,
  });

  @override
  State<QuickTapGame> createState() => _QuickTapGameState();
}

class _QuickTapGameState extends State<QuickTapGame>
    with TickerProviderStateMixin {
  static const int _timeLimit = 15;
  static const int _coinValue = 10;
  static const int _bombPenalty = 30;

  final List<_TapTarget> _targets = [];
  final Random _random = Random();

  int _score = 0;
  int _streak = 0;
  int _timeRemaining = _timeLimit;
  Timer? _gameTimer;
  Timer? _spawnTimer;
  bool _gameOver = false;

  @override
  void initState() {
    super.initState();
    _startGame();
  }

  void _startGame() {
    // Game timer
    _gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _timeRemaining--;
        if (_timeRemaining <= 0) {
          _endGame();
        }
      });
    });

    // Spawn timer
    _spawnTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (!_gameOver && _targets.length < 8) {
        _spawnTarget();
      }
    });

    // Initial targets
    for (int i = 0; i < 3; i++) {
      Future.delayed(Duration(milliseconds: i * 200), () {
        if (mounted && !_gameOver) _spawnTarget();
      });
    }
  }

  void _spawnTarget() {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final gameAreaTop = 150.0;
    final gameAreaBottom = screenHeight - 150;

    // Random position
    final x = 50 + _random.nextDouble() * (screenWidth - 150);
    final y = gameAreaTop + _random.nextDouble() * (gameAreaBottom - gameAreaTop - 100);

    // 20% chance of bomb
    final isBomb = _random.nextDouble() < 0.2;

    // Random lifetime
    final lifetime = 1.5 + _random.nextDouble() * 1.5;

    final target = _TapTarget(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      position: Offset(x, y),
      isBomb: isBomb,
      lifetime: lifetime,
      createdAt: DateTime.now(),
    );

    setState(() => _targets.add(target));

    // Remove after lifetime
    Future.delayed(Duration(milliseconds: (lifetime * 1000).toInt()), () {
      if (mounted) {
        setState(() => _targets.removeWhere((t) => t.id == target.id));
      }
    });
  }

  void _onTargetTap(_TapTarget target) {
    if (_gameOver) return;

    setState(() {
      _targets.remove(target);

      if (target.isBomb) {
        // Hit bomb - penalty and reset streak
        _score = max(0, _score - _bombPenalty);
        _streak = 0;
      } else {
        // Hit coin - add score with streak bonus
        final streakBonus = _streak >= 3 ? (_streak - 2) * 5 : 0;
        _score += _coinValue + streakBonus;
        _streak++;
      }
    });
  }

  void _endGame() {
    _gameTimer?.cancel();
    _spawnTimer?.cancel();
    setState(() => _gameOver = true);

    widget.onScoreEarned(_score);

    // Show result
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _showResultDialog();
      }
    });
  }

  void _showResultDialog() {
    final l10n = AppLocalizations.of(context)!;
    String rating;
    Color ratingColor;

    if (_score >= 150) {
      rating = l10n.quickTapAmazing;
      ratingColor = Colors.amber;
    } else if (_score >= 100) {
      rating = l10n.quickTapGreat;
      ratingColor = Colors.green;
    } else if (_score >= 50) {
      rating = l10n.quickTapGood;
      ratingColor = Colors.blue;
    } else {
      rating = l10n.quickTapTryAgain;
      ratingColor = Colors.orange;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.timer_off, color: Colors.orange, size: 32),
            const SizedBox(width: 12),
            Text(
              l10n.timeUp,
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              rating,
              style: TextStyle(
                color: ratingColor,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.scoreAmount(_score),
              style: TextStyle(
                color: AppTheme.cashGreen,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                widget.onComplete();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
              child: Text(l10n.continueGame),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _gameTimer?.cancel();
    _spawnTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Stack(
          children: [
            // Stats bar at top
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: _buildStatsBar(),
            ),

            // Instructions
            Positioned(
              top: 100,
              left: 16,
              right: 16,
              child: Text(
                AppLocalizations.of(context)!.quickTapInstruction,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            // Targets
            ..._targets.map((target) => _TapTargetWidget(
                  key: ValueKey(target.id),
                  target: target,
                  onTap: () => _onTargetTap(target),
                )),

            // Streak indicator
            if (_streak >= 3)
              Positioned(
                bottom: 100,
                left: 0,
                right: 0,
                child: Center(
                  child: _StreakIndicator(streak: _streak),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Score
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: AppTheme.cashGreen.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.cashGreen.withOpacity(0.5)),
          ),
          child: Row(
            children: [
              const Icon(Icons.attach_money, color: AppTheme.cashGreen),
              const SizedBox(width: 8),
              Text(
                '$_score',
                style: const TextStyle(
                  color: AppTheme.cashGreen,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),

        // Timer
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: (_timeRemaining <= 5 ? Colors.red : Colors.blue)
                .withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: (_timeRemaining <= 5 ? Colors.red : Colors.blue)
                  .withOpacity(0.5),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.timer,
                color: _timeRemaining <= 5 ? Colors.red : Colors.blue,
              ),
              const SizedBox(width: 8),
              Text(
                '$_timeRemaining',
                style: TextStyle(
                  color: _timeRemaining <= 5 ? Colors.red : Colors.blue,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TapTarget {
  final String id;
  final Offset position;
  final bool isBomb;
  final double lifetime;
  final DateTime createdAt;

  _TapTarget({
    required this.id,
    required this.position,
    required this.isBomb,
    required this.lifetime,
    required this.createdAt,
  });

  double get remainingLifetime {
    final elapsed = DateTime.now().difference(createdAt).inMilliseconds / 1000;
    return (lifetime - elapsed).clamp(0, lifetime);
  }
}

class _TapTargetWidget extends StatefulWidget {
  final _TapTarget target;
  final VoidCallback onTap;

  const _TapTargetWidget({
    super.key,
    required this.target,
    required this.onTap,
  });

  @override
  State<_TapTargetWidget> createState() => _TapTargetWidgetState();
}

class _TapTargetWidgetState extends State<_TapTargetWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: (widget.target.lifetime * 1000).toInt()),
      vsync: this,
    );

    // Pop in, then fade out
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: 1.2)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 10,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.2, end: 1.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 10,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 1.0),
        weight: 60,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 0.0)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 20,
      ),
    ]).animate(_controller);

    _opacityAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 10),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.0), weight: 70),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 20),
    ]).animate(_controller);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.target.position.dx,
      top: widget.target.position.dy,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Opacity(
            opacity: _opacityAnimation.value.clamp(0, 1),
            child: Transform.scale(
              scale: _scaleAnimation.value.clamp(0, 2),
              child: GestureDetector(
                onTap: widget.onTap,
                child: widget.target.isBomb
                    ? _buildBomb()
                    : _buildCoin(),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCoin() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.amber.shade300,
            Colors.amber.shade600,
          ],
        ),
        border: Border.all(color: Colors.amber.shade200, width: 3),
        boxShadow: [
          BoxShadow(
            color: Colors.amber.withOpacity(0.5),
            blurRadius: 12,
            spreadRadius: 2,
          ),
        ],
      ),
      child: const Center(
        child: Text(
          '\$',
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildBomb() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.grey.shade700,
            Colors.grey.shade900,
          ],
        ),
        border: Border.all(color: Colors.red.shade400, width: 3),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.3),
            blurRadius: 12,
            spreadRadius: 2,
          ),
        ],
      ),
      child: const Center(
        child: Icon(
          Icons.close,
          color: Colors.red,
          size: 32,
        ),
      ),
    );
  }
}

class _StreakIndicator extends StatelessWidget {
  final int streak;

  const _StreakIndicator({required this.streak});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.8),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.local_fire_department, color: Colors.white),
          const SizedBox(width: 8),
          Text(
            AppLocalizations.of(context)!.streakCount(streak),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

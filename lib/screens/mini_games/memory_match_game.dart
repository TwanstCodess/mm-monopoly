import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../l10n/app_localizations.dart';

/// Memory card matching mini-game
class MemoryMatchGame extends StatefulWidget {
  final VoidCallback onComplete;
  final Function(int) onScoreEarned;

  const MemoryMatchGame({super.key, required this.onComplete, required this.onScoreEarned});

  @override
  State<MemoryMatchGame> createState() => _MemoryMatchGameState();
}

class _MemoryMatchGameState extends State<MemoryMatchGame> {
  static const int _timeLimit = 30; // 4x3 grid = 6 pairs

  final List<_MemoryCard> _cards = [];
  int? _firstFlippedIndex;
  int? _secondFlippedIndex;
  bool _canFlip = true;
  int _pairsFound = 0;
  int _timeRemaining = _timeLimit;
  Timer? _timer;
  bool _gameOver = false;

  // Card icons (6 pairs)
  static const List<IconData> _cardIcons = [Icons.home, Icons.attach_money, Icons.directions_car, Icons.train, Icons.casino, Icons.star];

  @override
  void initState() {
    super.initState();
    _initializeCards();
    _startTimer();
  }

  void _initializeCards() {
    _cards.clear();
    final icons = <IconData>[];

    // Add pairs
    for (final icon in _cardIcons) {
      icons.add(icon);
      icons.add(icon);
    }

    // Shuffle
    icons.shuffle(Random());

    // Create cards
    for (int i = 0; i < icons.length; i++) {
      _cards.add(_MemoryCard(icon: icons[i]));
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _timeRemaining--;
        if (_timeRemaining <= 0) {
          _endGame();
        }
      });
    });
  }

  void _onCardTap(int index) {
    if (!_canFlip || _gameOver) return;
    if (_cards[index].isFlipped || _cards[index].isMatched) return;

    setState(() {
      _cards[index].isFlipped = true;

      if (_firstFlippedIndex == null) {
        _firstFlippedIndex = index;
      } else {
        _secondFlippedIndex = index;
        _canFlip = false;

        // Check for match
        if (_cards[_firstFlippedIndex!].icon == _cards[_secondFlippedIndex!].icon) {
          // Match found!
          _cards[_firstFlippedIndex!].isMatched = true;
          _cards[_secondFlippedIndex!].isMatched = true;
          _pairsFound++;

          _firstFlippedIndex = null;
          _secondFlippedIndex = null;
          _canFlip = true;

          // Check win
          if (_pairsFound == _cardIcons.length) {
            _endGame();
          }
        } else {
          // No match - flip back after delay
          Future.delayed(const Duration(milliseconds: 800), () {
            if (mounted) {
              setState(() {
                _cards[_firstFlippedIndex!].isFlipped = false;
                _cards[_secondFlippedIndex!].isFlipped = false;
                _firstFlippedIndex = null;
                _secondFlippedIndex = null;
                _canFlip = true;
              });
            }
          });
        }
      }
    });
  }

  void _endGame() {
    _timer?.cancel();
    setState(() => _gameOver = true);

    // Calculate score based on pairs found and time remaining
    final baseScore = _pairsFound * 25;
    final timeBonus = _pairsFound == _cardIcons.length ? _timeRemaining * 5 : 0;
    final totalScore = baseScore + timeBonus;

    widget.onScoreEarned(totalScore);

    // Show result after brief delay
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        _showResultDialog(totalScore);
      }
    });
  }

  void _showResultDialog(int score) {
    final l10n = AppLocalizations.of(context)!;
    final isWin = _pairsFound == _cardIcons.length;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(isWin ? Icons.emoji_events : Icons.timer_off, color: isWin ? Colors.amber : Colors.orange, size: 32),
            const SizedBox(width: 12),
            Text(isWin ? l10n.greatJob : l10n.timeUp, style: const TextStyle(color: Colors.white)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.pairsFound(_pairsFound, _cardIcons.length), style: const TextStyle(color: Colors.white70, fontSize: 16)),
            const SizedBox(height: 12),
            Text(
              l10n.scoreAmount(score),
              style: TextStyle(color: AppTheme.cashGreen, fontSize: 28, fontWeight: FontWeight.bold),
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
              style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primary, padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12)),
              child: Text(l10n.continueGame),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, title: Text(AppLocalizations.of(context)!.memoryMatchTitle), automaticallyImplyLeading: false),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Stats bar
              _buildStatsBar(),
              const SizedBox(height: 24),
              // Game grid
              Expanded(child: _buildGameGrid()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Pairs found
        _StatChip(icon: Icons.check_circle, label: AppLocalizations.of(context)!.pairs, value: '$_pairsFound/${_cardIcons.length}', color: Colors.green),
        // Timer
        _StatChip(icon: Icons.timer, label: AppLocalizations.of(context)!.timeLabel, value: AppLocalizations.of(context)!.secondsShort(_timeRemaining), color: _timeRemaining <= 10 ? Colors.red : Colors.blue),
      ],
    );
  }

  Widget _buildGameGrid() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, mainAxisSpacing: 10, crossAxisSpacing: 10),
      itemCount: _cards.length,
      itemBuilder: (context, index) {
        return _MemoryCardWidget(card: _cards[index], onTap: () => _onCardTap(index));
      },
    );
  }
}

class _MemoryCard {
  final IconData icon;
  bool isFlipped = false;
  bool isMatched = false;

  _MemoryCard({required this.icon});
}

class _MemoryCardWidget extends StatefulWidget {
  final _MemoryCard card;
  final VoidCallback onTap;

  const _MemoryCardWidget({required this.card, required this.onTap});

  @override
  State<_MemoryCardWidget> createState() => _MemoryCardWidgetState();
}

class _MemoryCardWidgetState extends State<_MemoryCardWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _flipAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 300), vsync: this);
    _flipAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void didUpdateWidget(_MemoryCardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.card.isFlipped != oldWidget.card.isFlipped) {
      if (widget.card.isFlipped) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _flipAnimation,
        builder: (context, child) {
          final angle = _flipAnimation.value * pi;
          final showFront = angle < pi / 2;

          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(angle),
            child: showFront ? _buildBack() : _buildFront(),
          );
        },
      ),
    );
  }

  Widget _buildBack() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [AppTheme.primary, AppTheme.primary.withOpacity(0.7)]),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white24, width: 2),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 6, offset: const Offset(0, 3))],
      ),
      child: const Center(child: Icon(Icons.question_mark, color: Colors.white54, size: 32)),
    );
  }

  Widget _buildFront() {
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()..rotateY(pi),
      child: Container(
        decoration: BoxDecoration(
          color: widget.card.isMatched ? Colors.green.withOpacity(0.3) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: widget.card.isMatched ? Colors.green : Colors.grey.shade300, width: 2),
          boxShadow: [BoxShadow(color: widget.card.isMatched ? Colors.green.withOpacity(0.3) : Colors.black.withOpacity(0.2), blurRadius: 6, offset: const Offset(0, 3))],
        ),
        child: Center(child: Icon(widget.card.icon, color: widget.card.isMatched ? Colors.green : AppTheme.primary, size: 36)),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatChip({required this.icon, required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(color: color.withOpacity(0.8), fontSize: 12)),
              Text(
                value,
                style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

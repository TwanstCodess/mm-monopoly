import 'package:flutter/material.dart';

/// How to play screen - swipeable card carousel
class HowToPlayScreen extends StatefulWidget {
  final VoidCallback onBack;

  const HowToPlayScreen({super.key, required this.onBack});

  @override
  State<HowToPlayScreen> createState() => _HowToPlayScreenState();
}

class _HowToPlayScreenState extends State<HowToPlayScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<_TutorialCard> _cards = const [
    _TutorialCard(
      emoji: '🎲',
      title: 'Roll & Move',
      description: 'Tap the dice to roll!\nMove around the board.',
      color: Color(0xFF4ECDC4),
    ),
    _TutorialCard(
      emoji: '🏠',
      title: 'Buy Properties',
      description: 'Land on an empty spot?\nBuy it and own it!',
      color: Color(0xFFFFE66D),
    ),
    _TutorialCard(
      emoji: '💰',
      title: 'Collect Rent',
      description: 'Others land on your property?\nThey pay YOU!',
      color: Color(0xFF95E1D3),
    ),
    _TutorialCard(
      emoji: '⭐',
      title: 'Special Spaces',
      description: 'Chance cards, jail, trains...\nSurprises everywhere!',
      color: Color(0xFFDDA0DD),
    ),
    _TutorialCard(
      emoji: '🏆',
      title: 'Win the Game!',
      description: 'Last player with money wins!\nBankrupt your friends!',
      color: Color(0xFFFF6B6B),
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF667eea), Color(0xFF764ba2)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    _buildBackButton(),
                    const Spacer(),
                    const Text(
                      'How to Play',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    const SizedBox(width: 48), // Balance back button
                  ],
                ),
              ),

              // Page indicator
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_cards.length, (index) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: _currentPage == index ? 24 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _currentPage == index
                            ? Colors.white
                            : Colors.white.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    );
                  }),
                ),
              ),

              // Swipeable cards
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() => _currentPage = index);
                  },
                  itemCount: _cards.length,
                  itemBuilder: (context, index) {
                    return _buildCard(_cards[index]);
                  },
                ),
              ),

              // Navigation arrows & button
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    // Navigation row with arrows
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Left arrow
                          _buildNavArrow(
                            icon: Icons.arrow_back_ios_rounded,
                            enabled: _currentPage > 0,
                            onTap: () {
                              _pageController.previousPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                          ),
                          const SizedBox(width: 16),
                          // Page info text
                          Text(
                            '${_currentPage + 1} / ${_cards.length}',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Right arrow
                          _buildNavArrow(
                            icon: Icons.arrow_forward_ios_rounded,
                            enabled: _currentPage < _cards.length - 1,
                            onTap: () {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                    // Got it button (always visible, emphasized on last page)
                    _buildGotItButton(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(_TutorialCard card) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: card.color.withOpacity(0.4),
              blurRadius: 30,
              offset: const Offset(0, 15),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Big emoji
            Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [card.color, card.color.withOpacity(0.7)],
                ),
                borderRadius: BorderRadius.circular(40),
                boxShadow: [
                  BoxShadow(
                    color: card.color.withOpacity(0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  card.emoji,
                  style: const TextStyle(fontSize: 72),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Title
            Text(
              card.title,
              style: TextStyle(
                color: card.color.withOpacity(0.9),
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            // Description
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                card.description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: widget.onBack,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.3)),
          ),
          child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 24),
        ),
      ),
    );
  }

  Widget _buildNavArrow({
    required IconData icon,
    required bool enabled,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: enabled
                ? Colors.white.withOpacity(0.2)
                : Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: enabled
                  ? Colors.white.withOpacity(0.3)
                  : Colors.white.withOpacity(0.1),
            ),
          ),
          child: Icon(
            icon,
            color: enabled ? Colors.white : Colors.white.withOpacity(0.3),
            size: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildGotItButton() {
    final isLastPage = _currentPage == _cards.length - 1;
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: widget.onBack,
        borderRadius: BorderRadius.circular(24),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 48),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isLastPage
                  ? [const Color(0xFF4ECDC4), const Color(0xFF44A08D)]
                  : [Colors.white.withOpacity(0.2), Colors.white.withOpacity(0.1)],
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isLastPage ? Colors.transparent : Colors.white.withOpacity(0.3),
            ),
            boxShadow: isLastPage
                ? [
                    BoxShadow(
                      color: const Color(0xFF4ECDC4).withOpacity(0.4),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : [],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isLastPage ? "Let's Play!" : "Got it!",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (isLastPage) ...[
                const SizedBox(width: 8),
                const Text('🎮', style: TextStyle(fontSize: 20)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _TutorialCard {
  final String emoji;
  final String title;
  final String description;
  final Color color;

  const _TutorialCard({
    required this.emoji,
    required this.title,
    required this.description,
    required this.color,
  });
}

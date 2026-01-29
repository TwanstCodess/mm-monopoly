import 'dart:math' as math;
import 'package:flutter/material.dart';

/// How to play screen with game rules
class HowToPlayScreen extends StatefulWidget {
  final VoidCallback onBack;

  const HowToPlayScreen({super.key, required this.onBack});

  @override
  State<HowToPlayScreen> createState() => _HowToPlayScreenState();
}

class _HowToPlayScreenState extends State<HowToPlayScreen> with SingleTickerProviderStateMixin {
  late AnimationController _floatController;

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(vsync: this, duration: const Duration(milliseconds: 3000))..repeat(reverse: true);
  }

  @override
  void dispose() {
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF667eea), Color(0xFF764ba2), Color(0xFFf093fb)]),
        ),
        child: Stack(
          children: [
            // Floating shapes
            ...List.generate(12, (index) => _buildFloatingShape(index)),
            // Main content
            SafeArea(
              child: Column(
                children: [
                  // Custom app bar
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        _buildBackButton(),
                        const SizedBox(width: 16),
                        ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(colors: [Colors.white, Color(0xFFFFE66D)]).createShader(bounds),
                          child: const Text(
                            'How to Play',
                            style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Content
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.all(20),
                      children: [
                        _buildSection(icon: Icons.flag_rounded, title: 'Goal', content: 'Be the last player standing! Collect properties, charge rent, and bankrupt your opponents.', color: const Color(0xFFFF6B6B)),
                        _buildSection(icon: Icons.casino_rounded, title: 'Your Turn', content: 'Roll the dice and move your token around the board. Land on properties to buy or pay rent.', color: const Color(0xFF4ECDC4)),
                        _buildSection(icon: Icons.home_rounded, title: 'Properties', content: 'When you land on an unowned property, you can buy it. Own all properties in a color group to charge double rent!', color: const Color(0xFFFFE66D)),
                        _buildSection(icon: Icons.attach_money_rounded, title: 'Rent', content: 'When you land on another player\'s property, you must pay them rent. The more properties they own, the higher the rent!', color: const Color(0xFF95E1D3)),
                        _buildSection(icon: Icons.train_rounded, title: 'Railroads & Utilities', content: 'Railroads charge rent based on how many you own. Utilities charge rent based on your dice roll.', color: const Color(0xFFA8E6CF)),
                        _buildSection(icon: Icons.lock_rounded, title: 'Jail', content: 'Land on "Go to Jail" and you\'ll be sent to jail. Pay \$50 to get out on your next turn.', color: const Color(0xFFDDA0DD)),
                        _buildSection(icon: Icons.style_rounded, title: 'Chance & Community Chest', content: 'Draw a card and follow its instructions. You might win money, pay fees, or move to a new space!', color: const Color(0xFFFFB347)),
                        _buildSection(icon: Icons.money_off_rounded, title: 'Bankruptcy', content: 'If you can\'t pay rent or taxes, you\'re bankrupt and out of the game. Your properties return to the bank.', color: const Color(0xFFFF6B6B)),
                        _buildSection(
                          icon: Icons.family_restroom_rounded,
                          title: 'Family Rules',
                          content:
                              'This is a simplified version for families:\n'
                              '• No property upgrades (houses/hotels)\n'
                              '• No mortgaging\n'
                              '• No auctions\n'
                              '• Doubles don\'t give extra turns\n'
                              '• Simple jail rules (\$50 to exit)',
                          color: const Color(0xFF87CEEB),
                        ),
                        const SizedBox(height: 20),
                        _buildGotItButton(),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
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

  Widget _buildFloatingShape(int index) {
    final random = math.Random(index + 200);
    final size = 15.0 + random.nextDouble() * 30;
    final left = random.nextDouble();
    final top = random.nextDouble();
    final colors = [Colors.white.withOpacity(0.08), Colors.yellow.withOpacity(0.1), Colors.pink.withOpacity(0.08), Colors.cyan.withOpacity(0.08)];

    return AnimatedBuilder(
      animation: _floatController,
      builder: (context, child) {
        return Positioned(
          left: MediaQuery.of(context).size.width * left,
          top: MediaQuery.of(context).size.height * top,
          child: Transform.translate(
            offset: Offset(math.sin(_floatController.value * math.pi * 2 + index) * 6, math.cos(_floatController.value * math.pi * 2 + index * 0.5) * 6),
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(color: colors[index % colors.length], shape: index % 3 == 0 ? BoxShape.circle : BoxShape.rectangle, borderRadius: index % 3 != 0 ? BorderRadius.circular(6) : null),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSection({required IconData icon, required String title, required String content, required Color color}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        // Darker, more opaque background for better text contrast
        color: const Color(0xFF2D1B4E).withOpacity(0.85),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.4), width: 1.5),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [color, color.withOpacity(0.8)]),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [BoxShadow(color: color.withOpacity(0.5), blurRadius: 8, offset: const Offset(0, 4))],
            ),
            child: Icon(icon, color: Colors.white, size: 26),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title with better contrast
                Text(
                  title,
                  style: TextStyle(
                    color: color,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                    shadows: [
                      Shadow(color: Colors.black.withOpacity(0.5), blurRadius: 4, offset: const Offset(1, 1)),
                      Shadow(color: color.withOpacity(0.5), blurRadius: 8),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                // Content with pure white and better readability
                Text(
                  content,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    height: 1.5,
                    shadows: [Shadow(color: Colors.black26, blurRadius: 2, offset: Offset(0.5, 0.5))],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGotItButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: widget.onBack,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Color(0xFF4ECDC4), Color(0xFF44A08D)]),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(color: const Color(0xFF4ECDC4).withOpacity(0.4), blurRadius: 12, offset: const Offset(0, 6))],
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle_rounded, color: Colors.white, size: 28),
              SizedBox(width: 12),
              Text(
                'Got it!',
                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 1),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

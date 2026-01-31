import 'dart:math' as math;
import 'package:flutter/material.dart';

/// How to play screen with game rules - kid-friendly version
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
            ...List.generate(15, (index) => _buildFloatingShape(index)),
            // Main content
            SafeArea(
              child: Column(
                children: [
                  // Custom app bar with fun title
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        _buildBackButton(),
                        const SizedBox(width: 16),
                        const Text('🎲', style: TextStyle(fontSize: 28)),
                        const SizedBox(width: 8),
                        ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(colors: [Colors.white, Color(0xFFFFE66D)]).createShader(bounds),
                          child: const Text(
                            'How to Play!',
                            style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text('🎲', style: TextStyle(fontSize: 28)),
                      ],
                    ),
                  ),
                  // Content
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      children: [
                        // Fun intro
                        _buildFunIntro(),
                        const SizedBox(height: 16),

                        // Basic rules
                        _buildSectionHeader('📚 The Basics'),
                        _buildRuleCard(emoji: '🏆', title: 'Win the Game!', content: 'Be the LAST player with money! Collect properties and make your friends pay rent when they visit.', color: const Color(0xFFFF6B6B)),
                        _buildRuleCard(emoji: '🎲', title: 'Roll & Move', content: 'Tap the dice to roll! Move your token around the board and see where you land.', color: const Color(0xFF4ECDC4)),
                        _buildRuleCard(emoji: '🏠', title: 'Buy Properties', content: 'Land on a property with no owner? You can BUY it! Collect all the same colors to charge MORE rent!', color: const Color(0xFFFFE66D)),
                        _buildRuleCard(emoji: '💰', title: 'Collect Rent', content: 'When someone lands on YOUR property, they pay YOU! Ka-ching!', color: const Color(0xFF95E1D3)),

                        const SizedBox(height: 20),
                        _buildSectionHeader('🗺️ Special Spaces'),
                        _buildRuleCard(emoji: '🚂', title: 'Trains & Utilities', content: 'Buy the trains! Own more trains = more money when others land on them!', color: const Color(0xFFA8E6CF)),
                        _buildRuleCard(emoji: '🔒', title: 'Uh Oh... Jail!', content: 'Land on "Go to Jail" and you\'re stuck! Pay \$50 to get out on your next turn.', color: const Color(0xFFDDA0DD)),
                        _buildRuleCard(emoji: '❓', title: 'Surprise Cards!', content: 'Land on Chance or Community Chest? Draw a card for a SURPRISE! You might win money or... pay some!', color: const Color(0xFFFFB347)),
                        _buildRuleCard(emoji: '😢', title: 'Going Broke', content: 'Can\'t pay? Oh no! You\'re out of the game. Don\'t worry, you can cheer for your friends!', color: const Color(0xFFFF6B6B)),

                        const SizedBox(height: 20),
                        _buildSectionHeader('⭐ Advanced Features'),
                        _buildAdvancedFeatureCard(
                          emoji: '🤝',
                          title: 'Trading (Optional)',
                          content:
                              'Want to swap properties with a friend? Turn on Trading in Settings!\n\n'
                              '• Pick a player to trade with\n'
                              '• Choose which properties to swap\n'
                              '• Add money to make the deal fair\n'
                              '• They can say YES or NO!',
                          color: Colors.teal,
                          settingName: 'Player Trading',
                        ),
                        _buildAdvancedFeatureCard(
                          emoji: '🏦',
                          title: 'Bank (Optional)',
                          content:
                              'Need money fast? Turn on Bank in Settings!\n\n'
                              '• Sell a property to the bank\n'
                              '• Get half the price as cash\n'
                              '• Buy it back later (costs a bit more!)\n'
                              '• Great when you need money quick!',
                          color: Colors.deepPurple,
                          settingName: 'Bank Features',
                        ),

                        const SizedBox(height: 20),
                        _buildFamilyRulesCard(),

                        const SizedBox(height: 24),
                        _buildGotItButton(),
                        const SizedBox(height: 30),
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

  Widget _buildFunIntro() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Colors.amber.shade400, Colors.orange.shade400]),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.orange.withOpacity(0.4), blurRadius: 15, offset: const Offset(0, 8))],
      ),
      child: Column(
        children: [
          const Text(
            '🎉 Welcome to Property Tycoon! 🎉',
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'Roll the dice, buy cool properties, and become the RICHEST player!',
            style: TextStyle(color: Colors.white.withOpacity(0.95), fontSize: 15, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 8),
      child: Row(
        children: [
          Container(
            height: 4,
            width: 30,
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.5), borderRadius: BorderRadius.circular(2)),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: TextStyle(color: Colors.white.withOpacity(0.95), fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 0.5),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              height: 4,
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.5), borderRadius: BorderRadius.circular(2)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRuleCard({required String emoji, required String title, required String content, required Color color}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF2D1B4E).withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.5), width: 2),
        boxShadow: [BoxShadow(color: color.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Emoji bubble
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [color, color.withOpacity(0.7)]),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: color.withOpacity(0.4), blurRadius: 8, offset: const Offset(0, 4))],
              ),
              child: Center(child: Text(emoji, style: const TextStyle(fontSize: 28))),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(color: color, fontSize: 17, fontWeight: FontWeight.bold, letterSpacing: 0.3),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    content,
                    style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 14, fontWeight: FontWeight.w500, height: 1.4),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdvancedFeatureCard({required String emoji, required String title, required String content, required Color color, required String settingName}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E).withOpacity(0.95),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.6), width: 2),
        boxShadow: [BoxShadow(color: color.withOpacity(0.2), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          // Header with "Optional" badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
            ),
            child: Row(
              children: [
                Text(emoji, style: const TextStyle(fontSize: 32)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: color.withOpacity(0.5)),
                  ),
                  child: const Text(
                    '⚙️ In Settings',
                    style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              content,
              style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 14, fontWeight: FontWeight.w500, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFamilyRulesCard() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [const Color(0xFF87CEEB).withOpacity(0.3), const Color(0xFF98D8C8).withOpacity(0.3)]),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('👨‍👩‍👧‍👦', style: TextStyle(fontSize: 32)),
                const SizedBox(width: 12),
                const Text(
                  'Family-Friendly Rules!',
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 12),
                const Text('🎈', style: TextStyle(fontSize: 32)),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'This game is made easy and fun for everyone!',
              style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 15, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            _buildFamilyRule('✓', 'Simple rules - just roll and play!'),
            _buildFamilyRule('✓', 'No confusing house upgrades'),
            _buildFamilyRule('✓', 'Quick games for short attention spans'),
            _buildFamilyRule('✓', 'Easy jail rules - just pay \$50'),
            _buildFamilyRule('✓', 'Fun for ages 6 and up!'),
          ],
        ),
      ),
    );
  }

  Widget _buildFamilyRule(String check, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(color: Colors.green.withOpacity(0.3), borderRadius: BorderRadius.circular(8)),
            child: Center(
              child: Text(
                check,
                style: const TextStyle(color: Colors.greenAccent, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
        ],
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
    final size = 15.0 + random.nextDouble() * 35;
    final left = random.nextDouble();
    final top = random.nextDouble();
    final shapes = ['⭐', '💎', '🌟', '✨', '💫', '🎯', '🎪', '🎨'];
    final useEmoji = random.nextBool();

    return AnimatedBuilder(
      animation: _floatController,
      builder: (context, child) {
        return Positioned(
          left: MediaQuery.of(context).size.width * left,
          top: MediaQuery.of(context).size.height * top,
          child: Transform.translate(
            offset: Offset(math.sin(_floatController.value * math.pi * 2 + index) * 8, math.cos(_floatController.value * math.pi * 2 + index * 0.5) * 8),
            child: Opacity(
              opacity: 0.3,
              child: useEmoji
                  ? Text(shapes[index % shapes.length], style: TextStyle(fontSize: size * 0.8))
                  : Container(
                      width: size,
                      height: size,
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), shape: index % 3 == 0 ? BoxShape.circle : BoxShape.rectangle, borderRadius: index % 3 != 0 ? BorderRadius.circular(6) : null),
                    ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildGotItButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: widget.onBack,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Color(0xFF4ECDC4), Color(0xFF44A08D)]),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [BoxShadow(color: const Color(0xFF4ECDC4).withOpacity(0.4), blurRadius: 15, offset: const Offset(0, 8))],
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('👍', style: TextStyle(fontSize: 28)),
              SizedBox(width: 12),
              Text(
                "Got it! Let's Play!",
                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 0.5),
              ),
              SizedBox(width: 12),
              Text('🎮', style: TextStyle(fontSize: 28)),
            ],
          ),
        ),
      ),
    );
  }
}

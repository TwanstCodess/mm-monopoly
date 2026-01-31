import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Main menu screen with game options
class MainMenuScreen extends StatefulWidget {
  final VoidCallback onNewGame;
  final VoidCallback? onContinue;
  final VoidCallback onHowToPlay;
  final VoidCallback onSettings;
  final VoidCallback? onShop;

  const MainMenuScreen({super.key, required this.onNewGame, this.onContinue, required this.onHowToPlay, required this.onSettings, this.onShop});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _floatController;
  late Animation<double> _titleAnimation;
  late Animation<double> _buttonsAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _floatController = AnimationController(vsync: this, duration: const Duration(milliseconds: 2000))..repeat(reverse: true);

    _titleAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 0.5, curve: Curves.easeOut),
      ),
    );

    _buttonsAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 1, curve: Curves.easeOut),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
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
            // Decorative floating shapes
            ...List.generate(15, (index) => _buildFloatingShape(index)),
            // Main content
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const Spacer(flex: 2),
                    // Title section
                    FadeTransition(
                      opacity: _titleAnimation,
                      child: SlideTransition(
                        position: Tween<Offset>(begin: const Offset(0, -0.3), end: Offset.zero).animate(_titleAnimation),
                        child: _buildTitle(),
                      ),
                    ),
                    const Spacer(flex: 2),
                    // Menu buttons
                    FadeTransition(
                      opacity: _buttonsAnimation,
                      child: SlideTransition(
                        position: Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(_buttonsAnimation),
                        child: _buildMenuButtons(),
                      ),
                    ),
                    const Spacer(),
                    // Version info
                    Text('v1.0.0 - Demo', style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingShape(int index) {
    final random = math.Random(index + 100);
    final size = 15.0 + random.nextDouble() * 35;
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
            offset: Offset(math.sin(_floatController.value * math.pi * 2 + index) * 8, math.cos(_floatController.value * math.pi * 2 + index * 0.5) * 8),
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

  Widget _buildTitle() {
    return Column(
      children: [
        // Floating Logo
        AnimatedBuilder(
          animation: _floatController,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, math.sin(_floatController.value * math.pi) * 6),
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.25), blurRadius: 20, offset: const Offset(0, 10)),
                    BoxShadow(color: Colors.white.withOpacity(0.1), blurRadius: 15, spreadRadius: -5),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Image.asset('assets/icon/icon.png', width: 120, height: 120, fit: BoxFit.cover),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 24),
        // M&M Title
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [_buildColorfulLetter('M', const Color(0xFFFF6B6B)), _buildColorfulLetter('&', const Color(0xFFFFE66D), fontSize: 32), _buildColorfulLetter('M', const Color(0xFF4ECDC4))]),
        const SizedBox(height: 4),
        // PROPERTY TYCOON
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(colors: [Color(0xFFFFFFFF), Color(0xFFFFE66D), Color(0xFFFFFFFF)]).createShader(bounds),
          child: const Text(
            'PROPERTY TYCOON',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w900,
              letterSpacing: 2,
              shadows: [Shadow(color: Colors.black26, offset: Offset(2, 2), blurRadius: 4)],
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Family Edition badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [Colors.white.withOpacity(0.25), Colors.white.withOpacity(0.1)]),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.4), width: 2),
          ),
          child: const Text(
            'FAMILY EDITION',
            style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 3),
          ),
        ),
      ],
    );
  }

  Widget _buildColorfulLetter(String letter, Color color, {double fontSize = 40}) {
    return Text(
      letter,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontWeight: FontWeight.w900,
        shadows: [
          Shadow(color: color.withOpacity(0.5), offset: const Offset(2, 2), blurRadius: 8),
          const Shadow(color: Colors.black26, offset: Offset(1, 1), blurRadius: 2),
        ],
      ),
    );
  }

  Widget _buildMenuButtons() {
    return Column(
      children: [
        _buildFunButton(icon: Icons.play_arrow_rounded, label: 'New Game', onTap: widget.onNewGame, gradient: const [Color(0xFFFF6B6B), Color(0xFFFF8E53)]),
        const SizedBox(height: 14),
        if (widget.onContinue != null) ...[
          _buildFunButton(icon: Icons.refresh_rounded, label: 'Continue', onTap: widget.onContinue!, gradient: const [Color(0xFF4ECDC4), Color(0xFF44A08D)]),
          const SizedBox(height: 14),
        ],
        _buildFunButton(icon: Icons.lightbulb_outline_rounded, label: 'How to Play', onTap: widget.onHowToPlay, gradient: const [Color(0xFFFFE66D), Color(0xFFFFA502)], textColor: Colors.brown.shade800),
        const SizedBox(height: 14),
        // Shop hidden for initial release
        // if (widget.onShop != null) ...[
        //   _buildFunButton(icon: Icons.shopping_bag_rounded, label: 'Shop', onTap: widget.onShop!, gradient: const [Color(0xFFE040FB), Color(0xFF9C27B0)]),
        //   const SizedBox(height: 14),
        // ],
        _buildFunButton(icon: Icons.settings_rounded, label: 'Settings', onTap: widget.onSettings, gradient: const [Color(0xFF667eea), Color(0xFF764ba2)]),
      ],
    );
  }

  Widget _buildFunButton({required IconData icon, required String label, required VoidCallback onTap, required List<Color> gradient, Color textColor = Colors.white}) {
    return SizedBox(
      width: double.infinity,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: gradient, begin: Alignment.centerLeft, end: Alignment.centerRight),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: gradient[0].withOpacity(0.4), blurRadius: 12, offset: const Offset(0, 6))],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 28, color: textColor),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textColor, letterSpacing: 1),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

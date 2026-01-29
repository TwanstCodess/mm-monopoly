import 'package:flutter/material.dart';
import '../config/theme.dart';

/// Main menu screen with game options
class MainMenuScreen extends StatefulWidget {
  final VoidCallback onNewGame;
  final VoidCallback? onContinue;
  final VoidCallback onHowToPlay;
  final VoidCallback onSettings;

  const MainMenuScreen({
    super.key,
    required this.onNewGame,
    this.onContinue,
    required this.onHowToPlay,
    required this.onSettings,
  });

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _titleAnimation;
  late Animation<double> _buttonsAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(flex: 2),
              // Title section
              FadeTransition(
                opacity: _titleAnimation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, -0.3),
                    end: Offset.zero,
                  ).animate(_titleAnimation),
                  child: _buildTitle(),
                ),
              ),
              const Spacer(flex: 2),
              // Menu buttons
              FadeTransition(
                opacity: _buttonsAnimation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.3),
                    end: Offset.zero,
                  ).animate(_buttonsAnimation),
                  child: _buildMenuButtons(),
                ),
              ),
              const Spacer(),
              // Version info
              Text(
                'v1.0.0 - Demo',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.3),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Column(
      children: [
        // Logo
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppTheme.primary,
                AppTheme.primary.withOpacity(0.7),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primary.withOpacity(0.3),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: const Icon(
            Icons.dashboard,
            color: Colors.white,
            size: 50,
          ),
        ),
        const SizedBox(height: 24),
        // Title
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'M',
              style: TextStyle(
                color: Colors.red.shade400,
                fontSize: 36,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            const Text(
              '&',
              style: TextStyle(
                color: Colors.amber,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'M',
              style: TextStyle(
                color: Colors.green.shade400,
                fontSize: 36,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
        const Text(
          'MONOPOLY',
          style: TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.bold,
            letterSpacing: 6,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: AppTheme.cashGreen.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(
            'FAMILY EDITION',
            style: TextStyle(
              color: AppTheme.cashGreen,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuButtons() {
    return Column(
      children: [
        // New Game button (primary)
        _buildMenuButton(
          icon: Icons.play_arrow,
          label: 'New Game',
          onTap: widget.onNewGame,
          isPrimary: true,
        ),
        const SizedBox(height: 12),
        // Continue button (if available)
        if (widget.onContinue != null) ...[
          _buildMenuButton(
            icon: Icons.replay,
            label: 'Continue',
            onTap: widget.onContinue!,
          ),
          const SizedBox(height: 12),
        ],
        // How to Play button
        _buildMenuButton(
          icon: Icons.help_outline,
          label: 'How to Play',
          onTap: widget.onHowToPlay,
        ),
        const SizedBox(height: 12),
        // Settings button
        _buildMenuButton(
          icon: Icons.settings,
          label: 'Settings',
          onTap: widget.onSettings,
        ),
      ],
    );
  }

  Widget _buildMenuButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isPrimary = false,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary ? AppTheme.primary : AppTheme.surface,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: isPrimary
                ? BorderSide.none
                : const BorderSide(color: Colors.white12),
          ),
          elevation: isPrimary ? 8 : 0,
          shadowColor: isPrimary ? AppTheme.primary.withOpacity(0.5) : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 24),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 18,
                fontWeight: isPrimary ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../config/theme.dart';

/// How to play screen with game rules
class HowToPlayScreen extends StatelessWidget {
  final VoidCallback onBack;

  const HowToPlayScreen({
    super.key,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: onBack,
        ),
        title: const Text(
          'How to Play',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildSection(
            icon: Icons.flag,
            title: 'Goal',
            content:
                'Be the last player standing! Collect properties, charge rent, and bankrupt your opponents.',
          ),
          _buildSection(
            icon: Icons.casino,
            title: 'Your Turn',
            content:
                'Roll the dice and move your token around the board. Land on properties to buy or pay rent.',
          ),
          _buildSection(
            icon: Icons.home,
            title: 'Properties',
            content:
                'When you land on an unowned property, you can buy it. Own all properties in a color group to charge double rent!',
          ),
          _buildSection(
            icon: Icons.attach_money,
            title: 'Rent',
            content:
                'When you land on another player\'s property, you must pay them rent. The more properties they own, the higher the rent!',
          ),
          _buildSection(
            icon: Icons.train,
            title: 'Railroads & Utilities',
            content:
                'Railroads charge rent based on how many you own. Utilities charge rent based on your dice roll.',
          ),
          _buildSection(
            icon: Icons.lock,
            title: 'Jail',
            content:
                'Land on "Go to Jail" and you\'ll be sent to jail. Pay \$50 to get out on your next turn.',
          ),
          _buildSection(
            icon: Icons.style,
            title: 'Chance & Community Chest',
            content:
                'Draw a card and follow its instructions. You might win money, pay fees, or move to a new space!',
          ),
          _buildSection(
            icon: Icons.money_off,
            title: 'Bankruptcy',
            content:
                'If you can\'t pay rent or taxes, you\'re bankrupt and out of the game. Your properties return to the bank.',
          ),
          _buildSection(
            icon: Icons.family_restroom,
            title: 'Family Rules',
            content:
                'This is a simplified version for families:\n'
                '• No property upgrades (houses/hotels)\n'
                '• No mortgaging\n'
                '• No auctions\n'
                '• Doubles don\'t give extra turns\n'
                '• Simple jail rules (\$50 to exit)',
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: onBack,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Got it!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppTheme.primary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppTheme.primary, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

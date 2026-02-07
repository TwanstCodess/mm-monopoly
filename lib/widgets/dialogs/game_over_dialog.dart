import 'package:flutter/material.dart';
import '../../models/player.dart';
import '../../models/tile.dart';
import '../../config/theme.dart';
import '../../l10n/app_localizations.dart';

/// Dialog showing game over and winner
class GameOverDialog extends StatelessWidget {
  final Player winner;
  final List<Player> allPlayers;
  final List<TileData> tiles;
  final int totalRounds;
  final VoidCallback onPlayAgain;
  final VoidCallback onMainMenu;

  const GameOverDialog({
    super.key,
    required this.winner,
    required this.allPlayers,
    required this.tiles,
    required this.totalRounds,
    required this.onPlayAgain,
    required this.onMainMenu,
  });

  @override
  Widget build(BuildContext context) {
    // Sort players by net worth for rankings
    final sortedPlayers = List<Player>.from(allPlayers)
      ..sort((a, b) => b.calculateNetWorth(tiles).compareTo(a.calculateNetWorth(tiles)));

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.amber, width: 3),
          boxShadow: [
            BoxShadow(
              color: Colors.amber.withOpacity(0.3),
              blurRadius: 30,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(context),
            _buildWinnerSection(context),
            _buildRankings(context, sortedPlayers),
            _buildStats(context),
            _buildActions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.amber.shade700, Colors.amber.shade500],
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(17)),
      ),
      child: Column(
        children: [
          const Icon(Icons.emoji_events, color: Colors.white, size: 50),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.gameOver,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWinnerSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            AppLocalizations.of(context)!.winner,
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: winner.color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: winner.color, width: 2),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: winner.color,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: winner.color.withOpacity(0.5),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      winner.effectiveAvatar.emoji,
                      style: const TextStyle(fontSize: 30),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      winner.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '\$${winner.calculateNetWorth(tiles)}',
                      style: const TextStyle(
                        color: AppTheme.cashGreen,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRankings(BuildContext context, List<Player> sortedPlayers) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.finalStandings,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ...sortedPlayers.asMap().entries.map((entry) {
            final index = entry.key;
            final player = entry.value;
            return _buildRankingRow(context, index + 1, player);
          }),
        ],
      ),
    );
  }

  Widget _buildRankingRow(BuildContext context, int rank, Player player) {
    final isBankrupt = player.status == PlayerStatus.bankrupt;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.black26,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 24,
              child: Text(
                '#$rank',
                style: TextStyle(
                  color: rank == 1 ? Colors.amber : Colors.white70,
                  fontWeight: rank == 1 ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: isBankrupt ? Colors.grey : player.color,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  player.effectiveAvatar.emoji,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                player.name,
                style: TextStyle(
                  color: isBankrupt ? Colors.grey : Colors.white,
                  decoration: isBankrupt ? TextDecoration.lineThrough : null,
                ),
              ),
            ),
            if (isBankrupt)
              Text(
                AppLocalizations.of(context)!.bankrupt,
                style: TextStyle(color: AppTheme.error, fontSize: 12),
              )
            else
              Text(
                '\$${player.calculateNetWorth(tiles)}',
                style: const TextStyle(
                  color: AppTheme.cashGreen,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStats(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.black26,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStat(AppLocalizations.of(context)!.rounds, totalRounds.toString()),
            _buildStat(AppLocalizations.of(context)!.properties, winner.propertyIds.length.toString()),
            _buildStat(AppLocalizations.of(context)!.finalCash, '\$${winner.cash}'),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white54, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                Navigator.of(context).pop();
                onMainMenu();
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white70,
                side: const BorderSide(color: Colors.white24),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(AppLocalizations.of(context)!.mainMenu, style: const TextStyle(fontSize: 16)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                onPlayAgain();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.cashGreen,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                AppLocalizations.of(context)!.playAgain,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Show the game over dialog
Future<void> showGameOverDialog({
  required BuildContext context,
  required Player winner,
  required List<Player> allPlayers,
  required List<TileData> tiles,
  required int totalRounds,
  required VoidCallback onPlayAgain,
  required VoidCallback onMainMenu,
}) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => GameOverDialog(
      winner: winner,
      allPlayers: allPlayers,
      tiles: tiles,
      totalRounds: totalRounds,
      onPlayAgain: onPlayAgain,
      onMainMenu: onMainMenu,
    ),
  );
}

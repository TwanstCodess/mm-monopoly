import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../l10n/app_localizations.dart';
import '../models/player_stats.dart';
import '../models/avatar.dart';
import '../widgets/avatar/avatar_widget.dart';

/// Leaderboard and stats screen
class LeaderboardScreen extends StatefulWidget {
  final List<PlayerStats> players;

  const LeaderboardScreen({
    super.key,
    required this.players,
  });

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _sortBy = 'wins';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<PlayerStats> get _sortedPlayers {
    final sorted = List<PlayerStats>.from(widget.players);

    switch (_sortBy) {
      case 'wins':
        sorted.sort((a, b) => b.gamesWon.compareTo(a.gamesWon));
        break;
      case 'winRate':
        sorted.sort((a, b) => b.winRate.compareTo(a.winRate));
        break;
      case 'earnings':
        sorted.sort((a, b) => b.totalEarnings.compareTo(a.totalEarnings));
        break;
      case 'games':
        sorted.sort((a, b) => b.gamesPlayed.compareTo(a.gamesPlayed));
        break;
    }

    return sorted;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(AppLocalizations.of(context)!.familyLeaderboard),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.amber,
          labelColor: Colors.amber,
          unselectedLabelColor: Colors.white54,
          tabs: [
            Tab(text: AppLocalizations.of(context)!.rankings, icon: const Icon(Icons.leaderboard, size: 20)),
            Tab(text: AppLocalizations.of(context)!.records, icon: const Icon(Icons.emoji_events, size: 20)),
            Tab(text: AppLocalizations.of(context)!.achievements, icon: const Icon(Icons.star, size: 20)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildRankingsTab(),
          _buildRecordsTab(),
          _buildAchievementsTab(),
        ],
      ),
    );
  }

  Widget _buildRankingsTab() {
    return Column(
      children: [
        // Sort options
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Text(
                AppLocalizations.of(context)!.sortBy,
                style: TextStyle(color: Colors.white70),
              ),
              _SortChip(
                label: AppLocalizations.of(context)!.wins,
                isSelected: _sortBy == 'wins',
                onTap: () => setState(() => _sortBy = 'wins'),
              ),
              _SortChip(
                label: AppLocalizations.of(context)!.winPercent,
                isSelected: _sortBy == 'winRate',
                onTap: () => setState(() => _sortBy = 'winRate'),
              ),
              _SortChip(
                label: AppLocalizations.of(context)!.earnings,
                isSelected: _sortBy == 'earnings',
                onTap: () => setState(() => _sortBy = 'earnings'),
              ),
              _SortChip(
                label: AppLocalizations.of(context)!.games,
                isSelected: _sortBy == 'games',
                onTap: () => setState(() => _sortBy = 'games'),
              ),
            ],
          ),
        ),

        // Rankings list
        Expanded(
          child: widget.players.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _sortedPlayers.length,
                  itemBuilder: (context, index) {
                    return _RankingCard(
                      rank: index + 1,
                      player: _sortedPlayers[index],
                      sortBy: _sortBy,
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildRecordsTab() {
    if (widget.players.isEmpty) {
      return _buildEmptyState();
    }

    // Find record holders
    final mostWins = widget.players.reduce(
      (a, b) => a.gamesWon > b.gamesWon ? a : b,
    );
    final highestCash = widget.players.reduce(
      (a, b) => a.highestCash > b.highestCash ? a : b,
    );
    final mostProperties = widget.players.reduce(
      (a, b) => a.mostPropertiesInGame > b.mostPropertiesInGame ? a : b,
    );
    final longestStreak = widget.players.reduce(
      (a, b) => a.longestWinStreak > b.longestWinStreak ? a : b,
    );
    final quickestWinner = widget.players
        .where((p) => p.quickestWin > 0)
        .fold<PlayerStats?>(null, (prev, p) {
      if (prev == null) return p;
      return p.quickestWin < prev.quickestWin ? p : prev;
    });
    final luckiest = widget.players
        .where((p) => p.totalDiceRolls > 10)
        .fold<PlayerStats?>(null, (prev, p) {
      if (prev == null) return p;
      return p.averageDiceRoll > prev.averageDiceRoll ? p : prev;
    });

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _RecordCard(
          title: AppLocalizations.of(context)!.mostWins,
          icon: Icons.emoji_events,
          color: Colors.amber,
          player: mostWins,
          value: '${mostWins.gamesWon} ${AppLocalizations.of(context)!.wins.toLowerCase()}',
        ),
        _RecordCard(
          title: AppLocalizations.of(context)!.highestCash,
          icon: Icons.attach_money,
          color: Colors.green,
          player: highestCash,
          value: '\$${highestCash.highestCash}',
        ),
        _RecordCard(
          title: AppLocalizations.of(context)!.propertyTycoonRecord,
          icon: Icons.business,
          color: Colors.blue,
          player: mostProperties,
          value: '${mostProperties.mostPropertiesInGame} ${AppLocalizations.of(context)!.properties.toLowerCase()}',
        ),
        _RecordCard(
          title: AppLocalizations.of(context)!.longestWinStreak,
          icon: Icons.local_fire_department,
          color: Colors.orange,
          player: longestStreak,
          value: AppLocalizations.of(context)!.inARow(longestStreak.longestWinStreak),
        ),
        if (quickestWinner != null)
          _RecordCard(
            title: AppLocalizations.of(context)!.speedChampion,
            icon: Icons.speed,
            color: Colors.purple,
            player: quickestWinner,
            value: AppLocalizations.of(context)!.turnsCount(quickestWinner.quickestWin),
          ),
        if (luckiest != null)
          _RecordCard(
            title: AppLocalizations.of(context)!.luckiestRoller,
            icon: Icons.casino,
            color: Colors.red,
            player: luckiest,
            value: AppLocalizations.of(context)!.avgValue(luckiest.averageDiceRoll.toStringAsFixed(1)),
          ),
      ],
    );
  }

  Widget _buildAchievementsTab() {
    if (widget.players.isEmpty) {
      return _buildEmptyState();
    }

    // Get all unlocked achievements across all players
    final allUnlocked = <String, List<PlayerStats>>{};
    for (final player in widget.players) {
      for (final achievementId in player.unlockedAchievements) {
        allUnlocked.putIfAbsent(achievementId, () => []).add(player);
      }
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        for (final achievement in Achievements.all)
          _AchievementCard(
            achievement: achievement,
            unlockedBy: allUnlocked[achievement.id] ?? [],
            totalPlayers: widget.players.length,
          ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.people_outline,
            size: 64,
            color: Colors.white24,
          ),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.noPlayersYet,
            style: TextStyle(
              color: Colors.white54,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.playToSeeStats,
            style: TextStyle(
              color: Colors.white38,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class _SortChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _SortChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isSelected ? Colors.amber : Colors.white12,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.black : Colors.white70,
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}

class _RankingCard extends StatelessWidget {
  final int rank;
  final PlayerStats player;
  final String sortBy;

  const _RankingCard({
    required this.rank,
    required this.player,
    required this.sortBy,
  });

  String _mainValue(BuildContext context) {
    switch (sortBy) {
      case 'wins':
        return '${player.gamesWon} ${AppLocalizations.of(context)!.wins.toLowerCase()}';
      case 'winRate':
        return '${player.winRate.toStringAsFixed(1)}%';
      case 'earnings':
        return '\$${player.totalEarnings}';
      case 'games':
        return '${player.gamesPlayed} ${AppLocalizations.of(context)!.games.toLowerCase()}';
      default:
        return '';
    }
  }

  Color get _rankColor {
    if (rank == 1) return Colors.amber;
    if (rank == 2) return Colors.grey.shade400;
    if (rank == 3) return Colors.brown.shade400;
    return Colors.white54;
  }

  @override
  Widget build(BuildContext context) {
    final avatar = player.avatarId != null
        ? Avatars.byId(player.avatarId!)
        : Avatars.forPlayerIndex(0);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: rank <= 3
            ? Border.all(color: _rankColor.withOpacity(0.3))
            : null,
      ),
      child: Row(
        children: [
          // Rank
          SizedBox(
            width: 40,
            child: rank <= 3
                ? Icon(Icons.emoji_events, color: _rankColor, size: 28)
                : Text(
                    '#$rank',
                    style: TextStyle(
                      color: _rankColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
          // Avatar
          if (avatar != null)
            AvatarWidget(avatar: avatar, size: 44)
          else
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white24,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.person, color: Colors.white54),
            ),
          const SizedBox(width: 12),
          // Name and stats
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  player.name,
                  style: TextStyle(
                    color: rank == 1 ? Colors.amber : Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${player.gamesWon}W - ${player.gamesPlayed - player.gamesWon}L',
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          // Main value
          Text(
            _mainValue(context),
            style: TextStyle(
              color: rank == 1 ? Colors.amber : Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _RecordCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final PlayerStats player;
  final String value;

  const _RecordCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.player,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final avatar = player.avatarId != null
        ? Avatars.byId(player.avatarId!)
        : Avatars.forPlayerIndex(0);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 16),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    if (avatar != null)
                      AvatarWidget(avatar: avatar, size: 24, showBorder: false)
                    else
                      const Icon(Icons.person, size: 24, color: Colors.white54),
                    const SizedBox(width: 8),
                    Text(
                      player.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Value
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _AchievementCard extends StatelessWidget {
  final Achievement achievement;
  final List<PlayerStats> unlockedBy;
  final int totalPlayers;

  const _AchievementCard({
    required this.achievement,
    required this.unlockedBy,
    required this.totalPlayers,
  });

  @override
  Widget build(BuildContext context) {
    final isUnlocked = unlockedBy.isNotEmpty;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isUnlocked
            ? achievement.color.withOpacity(0.1)
            : Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isUnlocked
              ? achievement.color.withOpacity(0.3)
              : Colors.white12,
        ),
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: isUnlocked
                  ? achievement.color.withOpacity(0.2)
                  : Colors.white12,
              shape: BoxShape.circle,
            ),
            child: Icon(
              achievement.icon,
              color: isUnlocked ? achievement.color : Colors.white24,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  achievement.name,
                  style: TextStyle(
                    color: isUnlocked ? Colors.white : Colors.white54,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  achievement.description,
                  style: TextStyle(
                    color: isUnlocked ? Colors.white70 : Colors.white38,
                    fontSize: 12,
                  ),
                ),
                if (isUnlocked) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      for (int i = 0; i < unlockedBy.length && i < 5; i++)
                        Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: CircleAvatar(
                            radius: 12,
                            backgroundColor: achievement.color.withOpacity(0.3),
                            child: Text(
                              unlockedBy[i].name[0].toUpperCase(),
                              style: TextStyle(
                                color: achievement.color,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      if (unlockedBy.length > 5)
                        Text(
                          '+${unlockedBy.length - 5}',
                          style: TextStyle(
                            color: achievement.color,
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          // Unlock status
          if (!isUnlocked)
            const Icon(
              Icons.lock_outline,
              color: Colors.white24,
              size: 24,
            )
          else
            Text(
              '${unlockedBy.length}/$totalPlayers',
              style: TextStyle(
                color: achievement.color,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
    );
  }
}

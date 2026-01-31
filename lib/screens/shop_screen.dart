import 'package:flutter/material.dart';
import '../models/unlockable.dart';
import '../services/unlock_service.dart';

/// Shop screen for browsing and unlocking cosmetics
class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  final UnlockService _unlockService = UnlockService();

  final List<UnlockableType> _tabs = [
    UnlockableType.boardTheme,
    UnlockableType.tokenSet,
    UnlockableType.diceSkin,
    UnlockableType.cardBack,
    UnlockableType.soundPack,
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _unlockService.addListener(_onUnlockStateChanged);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _unlockService.removeListener(_onUnlockStateChanged);
    super.dispose();
  }

  void _onUnlockStateChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1a1a2e), Color(0xFF16213e), Color(0xFF0f3460)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              _buildTabBar(),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: _tabs.map((type) => _buildItemGrid(type)).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Back button
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          ),
          const SizedBox(width: 8),
          // Title
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '🛍️ Shop',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Unlock themes, tokens & more!',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const Spacer(),
          // Unlock progress
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(Icons.lock_open, color: Colors.amber, size: 18),
                const SizedBox(width: 6),
                Text(
                  '${_unlockService.totalUnlocked}/${_unlockService.totalItems}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: const LinearGradient(
            colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
          ),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white60,
        labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
        padding: const EdgeInsets.all(4),
        tabs: _tabs.map((type) {
          return Tab(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(type.icon, size: 18),
                  const SizedBox(width: 6),
                  Text(type.displayName),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildItemGrid(UnlockableType type) {
    final items = UnlockableCatalog.byType(type);

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.85,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) => _buildItemCard(items[index]),
    );
  }

  Widget _buildItemCard(Unlockable item) {
    final isUnlocked = _unlockService.isUnlocked(item);
    final adsWatched = _unlockService.getAdsWatched(item.id);
    final progress = item.getProgress(adsWatched);

    return GestureDetector(
      onTap: () => _showItemDetails(item),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isUnlocked
                ? [Colors.white.withOpacity(0.2), Colors.white.withOpacity(0.1)]
                : [Colors.white.withOpacity(0.1), Colors.white.withOpacity(0.05)],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isUnlocked
                ? Colors.amber.withOpacity(0.5)
                : Colors.white.withOpacity(0.2),
            width: isUnlocked ? 2 : 1,
          ),
        ),
        child: Stack(
          children: [
            // Main content
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Preview
                  Expanded(
                    child: Center(
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: item.previewColor?.withOpacity(0.3) ??
                              Colors.grey.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: (item.previewColor ?? Colors.grey)
                                  .withOpacity(0.3),
                              blurRadius: 12,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Icon(
                          item.previewIcon ?? Icons.help_outline,
                          color: item.previewColor ?? Colors.white,
                          size: 40,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Name
                  Text(
                    item.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  // Status/Price
                  if (isUnlocked)
                    Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.green[400], size: 16),
                        const SizedBox(width: 4),
                        Text(
                          'Unlocked',
                          style: TextStyle(color: Colors.green[400], fontSize: 12),
                        ),
                      ],
                    )
                  else if (item.isFree)
                    const Text(
                      'Free',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    )
                  else
                    _buildUnlockInfo(item, adsWatched, progress),
                ],
              ),
            ),
            // Lock overlay
            if (!isUnlocked && !item.isFree)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.lock, color: Colors.white70, size: 16),
                ),
              ),
            // Unlocked badge
            if (isUnlocked && !item.isFree)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.star, color: Colors.white, size: 16),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildUnlockInfo(Unlockable item, int adsWatched, double progress) {
    if (item.canUnlockWithAds) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.white.withOpacity(0.2),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFF6B6B)),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                '$adsWatched/${item.adsRequired} 🎬',
                style: const TextStyle(color: Colors.white70, fontSize: 11),
              ),
              const Spacer(),
              Text(
                item.priceString,
                style: const TextStyle(color: Colors.amber, fontSize: 11, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      );
    } else {
      return Text(
        item.priceString,
        style: const TextStyle(color: Colors.amber, fontSize: 12, fontWeight: FontWeight.bold),
      );
    }
  }

  void _showItemDetails(Unlockable item) {
    final isUnlocked = _unlockService.isUnlocked(item);
    final adsWatched = _unlockService.getAdsWatched(item.id);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _ItemDetailsSheet(
        item: item,
        isUnlocked: isUnlocked,
        adsWatched: adsWatched,
        onWatchAd: () => _handleWatchAd(item),
        onPurchase: () => _handlePurchase(item),
      ),
    );
  }

  Future<void> _handleWatchAd(Unlockable item) async {
    Navigator.pop(context); // Close bottom sheet

    // Show loading/ad placeholder
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Loading ad...'),
              ],
            ),
          ),
        ),
      ),
    );

    // Simulate ad (replace with real ad SDK later)
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;
    Navigator.pop(context); // Close loading dialog

    // Record ad watched
    final unlocked = await _unlockService.recordAdWatched(item.id);

    if (!mounted) return;

    if (unlocked) {
      // Show unlock celebration
      _showUnlockCelebration(item);
    } else {
      // Show progress update
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Progress: ${_unlockService.getAdsWatched(item.id)}/${item.adsRequired} ads watched!',
          ),
          backgroundColor: const Color(0xFF4CAF50),
        ),
      );
    }
  }

  Future<void> _handlePurchase(Unlockable item) async {
    Navigator.pop(context); // Close bottom sheet

    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Purchase ${item.name}?'),
        content: Text('Unlock for ${item.priceString}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF6B6B),
            ),
            child: Text('Buy ${item.priceString}'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    // TODO: Implement real IAP
    // For now, simulate purchase
    await _unlockService.recordPurchase(item.id);

    if (!mounted) return;
    _showUnlockCelebration(item);
  }

  void _showUnlockCelebration(Unlockable item) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF667eea), Color(0xFF764ba2)],
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('🎉', style: TextStyle(fontSize: 64)),
              const SizedBox(height: 16),
              const Text(
                'UNLOCKED!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                item.name,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF764ba2),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                child: const Text('Awesome!', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Bottom sheet for item details
class _ItemDetailsSheet extends StatelessWidget {
  final Unlockable item;
  final bool isUnlocked;
  final int adsWatched;
  final VoidCallback onWatchAd;
  final VoidCallback onPurchase;

  const _ItemDetailsSheet({
    required this.item,
    required this.isUnlocked,
    required this.adsWatched,
    required this.onWatchAd,
    required this.onPurchase,
  });

  @override
  Widget build(BuildContext context) {
    final progress = item.getProgress(adsWatched);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1a1a2e), Color(0xFF16213e)],
        ),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Preview and info
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Preview
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: item.previewColor?.withOpacity(0.3) ??
                      Colors.grey.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: (item.previewColor ?? Colors.grey).withOpacity(0.3),
                      blurRadius: 16,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                child: Icon(
                  item.previewIcon ?? Icons.help_outline,
                  color: item.previewColor ?? Colors.white,
                  size: 50,
                ),
              ),
              const SizedBox(width: 20),
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          item.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (isUnlocked)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              '✓ Owned',
                              style: TextStyle(color: Colors.green, fontSize: 12),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        item.type.singularName,
                        style: const TextStyle(color: Colors.white60, fontSize: 12),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      item.description,
                      style: const TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Unlock options (if not unlocked)
          if (!isUnlocked && !item.isFree) ...[
            // Progress bar for ads
            if (item.canUnlockWithAds) ...[
              Row(
                children: [
                  const Text(
                    'Watch ads to unlock',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  Text(
                    '$adsWatched/${item.adsRequired}',
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.white.withOpacity(0.2),
                  valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFF6B6B)),
                  minHeight: 12,
                ),
              ),
              const SizedBox(height: 16),
            ],
            // Action buttons
            Row(
              children: [
                if (item.canUnlockWithAds)
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: onWatchAd,
                      icon: const Icon(Icons.play_circle_outline),
                      label: const Text('Watch Ad'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4CAF50),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                if (item.canUnlockWithAds && item.canPurchase)
                  const SizedBox(width: 12),
                if (item.canPurchase)
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: onPurchase,
                      icon: const Icon(Icons.shopping_cart),
                      label: Text(item.priceString),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF6B6B),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                item.canUnlockWithAds && item.canPurchase
                    ? 'Watch ${item.adsRequired} ads or pay to unlock instantly'
                    : item.canUnlockWithAds
                        ? 'Watch ${item.adsRequired} ads to unlock'
                        : 'Purchase to unlock',
                style: const TextStyle(color: Colors.white54, fontSize: 12),
              ),
            ),
          ],
          // Equipped/Select button (if unlocked)
          if (isUnlocked) ...[
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  // TODO: Implement equip functionality
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${item.name} selected!')),
                  );
                },
                icon: const Icon(Icons.check_circle),
                label: const Text('Use This'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

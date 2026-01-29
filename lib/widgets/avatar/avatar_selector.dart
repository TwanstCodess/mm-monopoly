import 'package:flutter/material.dart';
import '../../models/avatar.dart';
import '../../config/theme.dart';
import 'avatar_widget.dart';

/// Avatar selection widget with category tabs
class AvatarSelector extends StatefulWidget {
  final Avatar? selectedAvatar;
  final List<String> usedAvatarIds;
  final Function(Avatar) onAvatarSelected;
  final double avatarSize;

  const AvatarSelector({
    super.key,
    this.selectedAvatar,
    this.usedAvatarIds = const [],
    required this.onAvatarSelected,
    this.avatarSize = 64,
  });

  @override
  State<AvatarSelector> createState() => _AvatarSelectorState();
}

class _AvatarSelectorState extends State<AvatarSelector>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  AvatarCategory _selectedCategory = AvatarCategory.animals;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: AvatarCategory.values.length,
      vsync: this,
    );
    _tabController.addListener(() {
      setState(() {
        _selectedCategory = AvatarCategory.values[_tabController.index];
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  bool _isAvatarAvailable(Avatar avatar) {
    return !widget.usedAvatarIds.contains(avatar.id);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Category tabs
        Container(
          decoration: BoxDecoration(
            color: Colors.black26,
            borderRadius: BorderRadius.circular(12),
          ),
          child: TabBar(
            controller: _tabController,
            indicatorSize: TabBarIndicatorSize.tab,
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: AppTheme.primary,
            ),
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white54,
            tabs: AvatarCategory.values.map((category) {
              return Tab(
                icon: Icon(category.icon, size: 20),
                text: category.displayName,
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 16),
        // Avatar grid
        SizedBox(
          height: 180,
          child: TabBarView(
            controller: _tabController,
            children: AvatarCategory.values.map((category) {
              final avatars = Avatars.byCategory(category);
              return GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                ),
                itemCount: avatars.length,
                itemBuilder: (context, index) {
                  final avatar = avatars[index];
                  final isAvailable = _isAvatarAvailable(avatar);
                  final isSelected = widget.selectedAvatar?.id == avatar.id;

                  return _AvatarOption(
                    avatar: avatar,
                    size: widget.avatarSize,
                    isSelected: isSelected,
                    isAvailable: isAvailable,
                    onTap: isAvailable
                        ? () => widget.onAvatarSelected(avatar)
                        : null,
                  );
                },
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _AvatarOption extends StatefulWidget {
  final Avatar avatar;
  final double size;
  final bool isSelected;
  final bool isAvailable;
  final VoidCallback? onTap;

  const _AvatarOption({
    required this.avatar,
    required this.size,
    required this.isSelected,
    required this.isAvailable,
    this.onTap,
  });

  @override
  State<_AvatarOption> createState() => _AvatarOptionState();
}

class _AvatarOptionState extends State<_AvatarOption>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.isAvailable ? (_) => _controller.forward() : null,
      onTapUp: widget.isAvailable
          ? (_) {
              _controller.reverse();
              widget.onTap?.call();
            }
          : null,
      onTapCancel: widget.isAvailable ? () => _controller.reverse() : null,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Avatar
                Opacity(
                  opacity: widget.isAvailable ? 1.0 : 0.4,
                  child: AvatarWidget(
                    avatar: widget.avatar,
                    size: widget.size,
                    isSelected: widget.isSelected,
                  ),
                ),
                // Selected checkmark
                if (widget.isSelected)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 14,
                      ),
                    ),
                  ),
                // Unavailable X
                if (!widget.isAvailable)
                  Container(
                    width: widget.size,
                    height: widget.size,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black45,
                    ),
                    child: const Icon(
                      Icons.block,
                      color: Colors.white54,
                      size: 24,
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Compact avatar selector for quick selection
class CompactAvatarSelector extends StatelessWidget {
  final Avatar? selectedAvatar;
  final List<String> usedAvatarIds;
  final Function(Avatar) onAvatarSelected;

  const CompactAvatarSelector({
    super.key,
    this.selectedAvatar,
    this.usedAvatarIds = const [],
    required this.onAvatarSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: Avatars.all.length,
        itemBuilder: (context, index) {
          final avatar = Avatars.all[index];
          final isAvailable = !usedAvatarIds.contains(avatar.id);
          final isSelected = selectedAvatar?.id == avatar.id;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: GestureDetector(
              onTap: isAvailable ? () => onAvatarSelected(avatar) : null,
              child: Opacity(
                opacity: isAvailable ? 1.0 : 0.4,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AvatarWidget(
                      avatar: avatar,
                      size: 48,
                      isSelected: isSelected,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      avatar.name,
                      style: TextStyle(
                        color: isSelected ? Colors.amber : Colors.white70,
                        fontSize: 10,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Dialog for avatar selection
class AvatarSelectionDialog extends StatefulWidget {
  final Avatar? currentAvatar;
  final List<String> usedAvatarIds;

  const AvatarSelectionDialog({
    super.key,
    this.currentAvatar,
    this.usedAvatarIds = const [],
  });

  @override
  State<AvatarSelectionDialog> createState() => _AvatarSelectionDialogState();
}

class _AvatarSelectionDialogState extends State<AvatarSelectionDialog> {
  Avatar? _selectedAvatar;

  @override
  void initState() {
    super.initState();
    _selectedAvatar = widget.currentAvatar;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppTheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Choose Your Avatar',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Pick a character to represent you!',
              style: TextStyle(color: Colors.white60, fontSize: 14),
            ),
            const SizedBox(height: 20),
            AvatarSelector(
              selectedAvatar: _selectedAvatar,
              usedAvatarIds: widget.usedAvatarIds,
              onAvatarSelected: (avatar) {
                setState(() => _selectedAvatar = avatar);
              },
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.white54),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _selectedAvatar != null
                      ? () => Navigator.pop(context, _selectedAvatar)
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                  ),
                  child: const Text('Select'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Show avatar selection dialog
Future<Avatar?> showAvatarSelectionDialog({
  required BuildContext context,
  Avatar? currentAvatar,
  List<String> usedAvatarIds = const [],
}) {
  return showDialog<Avatar>(
    context: context,
    builder: (context) => AvatarSelectionDialog(
      currentAvatar: currentAvatar,
      usedAvatarIds: usedAvatarIds,
    ),
  );
}

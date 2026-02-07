import 'package:flutter/material.dart';
import '../../models/avatar.dart';
import '../../config/theme.dart';
import '../../l10n/app_localizations.dart';
import '../../services/custom_avatar_service.dart';
import 'avatar_widget.dart';

/// Avatar selection widget with category tabs including custom photos
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
  List<CustomAvatar> _customAvatars = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: AvatarCategory.values.length,
      vsync: this,
    );
    _loadCustomAvatars();
  }

  Future<void> _loadCustomAvatars() async {
    await CustomAvatarService.instance.initialize();
    if (mounted) {
      setState(() {
        _customAvatars = CustomAvatarService.instance.customAvatars;
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  bool _isAvatarAvailable(Avatar avatar) {
    return !widget.usedAvatarIds.contains(avatar.id);
  }

  Future<void> _capturePhoto() async {
    final customAvatar = await CustomAvatarService.instance.captureFromCamera();

    if (customAvatar != null && mounted) {
      setState(() {
        _customAvatars = CustomAvatarService.instance.customAvatars;
      });

      // Auto-select the new avatar
      final avatar = Avatar.custom(
        id: customAvatar.id,
        name: customAvatar.name,
        imagePath: customAvatar.imagePath,
      );
      widget.onAvatarSelected(avatar);
    }
  }

  Future<void> _pickFromGallery() async {
    final customAvatar = await CustomAvatarService.instance.pickFromGallery();

    if (customAvatar != null && mounted) {
      setState(() {
        _customAvatars = CustomAvatarService.instance.customAvatars;
      });

      // Auto-select the new avatar
      final avatar = Avatar.custom(
        id: customAvatar.id,
        name: customAvatar.name,
        imagePath: customAvatar.imagePath,
      );
      widget.onAvatarSelected(avatar);
    }
  }

  Future<void> _deleteCustomAvatar(CustomAvatar customAvatar) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          AppLocalizations.of(context)!.deletePhotoTitle,
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          AppLocalizations.of(context)!.deletePhotoMessage,
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(AppLocalizations.of(context)!.delete),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await CustomAvatarService.instance.deleteAvatar(customAvatar.id);
      if (mounted) {
        setState(() {
          _customAvatars = CustomAvatarService.instance.customAvatars;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Category tabs - full width
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF16213E),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.1),
              width: 1,
            ),
          ),
          child: TabBar(
            controller: _tabController,
            indicatorSize: TabBarIndicatorSize.tab,
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              gradient: const LinearGradient(
                colors: [Color(0xFF7C4DFF), Color(0xFF536DFE)],
              ),
            ),
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white60,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            labelPadding: const EdgeInsets.symmetric(horizontal: 2),
            isScrollable: false,
            tabs: AvatarCategory.values.map((category) {
              return Tab(
                icon: Icon(category.icon, size: 20),
                text: category.displayName,
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 16),
        // Avatar grid - expands to fill available space
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              // Adapt grid columns based on available width
              final isWide = constraints.maxWidth > 500;
              final crossAxisCount = isWide ? 6 : 4;
              final spacing = isWide ? 12.0 : 16.0;

              return TabBarView(
                controller: _tabController,
                children: AvatarCategory.values.map((category) {
                  if (category == AvatarCategory.custom) {
                    return _buildCustomAvatarsTab(crossAxisCount: crossAxisCount, spacing: spacing);
                  }

                  final avatars = Avatars.byCategory(category);
                  return GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      mainAxisSpacing: spacing,
                      crossAxisSpacing: spacing,
                      childAspectRatio: 1.0,
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
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCustomAvatarsTab({int crossAxisCount = 4, double spacing = 16}) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF7C4DFF)),
      );
    }

    return Column(
      children: [
        // Action buttons row - colorful kid-friendly design
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            children: [
              Expanded(
                child: _ActionButton(
                  icon: Icons.camera_alt,
                  label: AppLocalizations.of(context)!.takePhoto,
                  onTap: _capturePhoto,
                  gradientColors: const [Color(0xFFFF6B9D), Color(0xFFFF8A65)],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ActionButton(
                  icon: Icons.photo_library,
                  label: AppLocalizations.of(context)!.choosePhoto,
                  onTap: _pickFromGallery,
                  gradientColors: const [Color(0xFF26C6DA), Color(0xFF00ACC1)],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        // Photo grid
        Expanded(
          child: _customAvatars.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.05),
                        ),
                        child: const Icon(Icons.add_a_photo, color: Colors.white38, size: 40),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        AppLocalizations.of(context)!.noPhotosYet,
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        AppLocalizations.of(context)!.takeSelfieOrPick,
                        style: TextStyle(
                          color: Colors.white38,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                )
              : GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    mainAxisSpacing: spacing,
                    crossAxisSpacing: spacing,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: _customAvatars.length,
                  itemBuilder: (context, index) {
                    final customAvatar = _customAvatars[index];
                    final avatar = Avatar.custom(
                      id: customAvatar.id,
                      name: customAvatar.name,
                      imagePath: customAvatar.imagePath,
                    );
                    final isAvailable = _isAvatarAvailable(avatar);
                    final isSelected = widget.selectedAvatar?.id == avatar.id;

                    return GestureDetector(
                      onLongPress: () => _deleteCustomAvatar(customAvatar),
                      child: _AvatarOption(
                        avatar: avatar,
                        size: widget.avatarSize,
                        isSelected: isSelected,
                        isAvailable: isAvailable,
                        onTap: isAvailable
                            ? () => widget.onAvatarSelected(avatar)
                            : null,
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

/// Fun, colorful action button for camera/gallery - kid-friendly design
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final List<Color>? gradientColors;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    final colors = gradientColors ?? [
      const Color(0xFF7C4DFF), // Purple
      const Color(0xFF536DFE), // Indigo
    ];

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: colors,
            ),
            boxShadow: [
              BoxShadow(
                color: colors[0].withValues(alpha: 0.4),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.25),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
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
            child: SizedBox(
              width: widget.size,
              height: widget.size,
              child: Stack(
                clipBehavior: Clip.none,
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
                  // Selected checkmark - positioned at bottom-right, slightly outside the avatar circle
                  if (widget.isSelected)
                    Positioned(
                      // Position relative to avatar: bottom-right corner, slightly outside the border
                      bottom: -4,
                      right: -4,
                      child: Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFF4CAF50), Color(0xFF2E7D32)],
                          ),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 2.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF4CAF50).withValues(alpha: 0.6),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 15,
                        ),
                      ),
                    ),
                  // Unavailable overlay
                  if (!widget.isAvailable)
                    Container(
                      width: widget.size,
                      height: widget.size,
                      decoration: const BoxDecoration(
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

/// Dialog for avatar selection - uses most of the screen for better avatar display
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

class _AvatarSelectionDialogState extends State<AvatarSelectionDialog>
    with SingleTickerProviderStateMixin {
  Avatar? _selectedAvatar;
  late TabController _tabController;
  List<CustomAvatar> _customAvatars = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _selectedAvatar = widget.currentAvatar;
    _tabController = TabController(
      length: AvatarCategory.values.length,
      vsync: this,
    );
    _loadCustomAvatars();
  }

  Future<void> _loadCustomAvatars() async {
    await CustomAvatarService.instance.initialize();
    if (mounted) {
      setState(() {
        _customAvatars = CustomAvatarService.instance.customAvatars;
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  bool _isAvatarAvailable(Avatar avatar) {
    return !widget.usedAvatarIds.contains(avatar.id);
  }

  Future<void> _capturePhoto() async {
    final customAvatar = await CustomAvatarService.instance.captureFromCamera();
    if (customAvatar != null && mounted) {
      setState(() {
        _customAvatars = CustomAvatarService.instance.customAvatars;
      });
      final avatar = Avatar.custom(
        id: customAvatar.id,
        name: customAvatar.name,
        imagePath: customAvatar.imagePath,
      );
      setState(() => _selectedAvatar = avatar);
    }
  }

  Future<void> _pickFromGallery() async {
    final customAvatar = await CustomAvatarService.instance.pickFromGallery();
    if (customAvatar != null && mounted) {
      setState(() {
        _customAvatars = CustomAvatarService.instance.customAvatars;
      });
      final avatar = Avatar.custom(
        id: customAvatar.id,
        name: customAvatar.name,
        imagePath: customAvatar.imagePath,
      );
      setState(() => _selectedAvatar = avatar);
    }
  }

  Future<void> _deleteCustomAvatar(CustomAvatar customAvatar) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(AppLocalizations.of(context)!.deletePhotoTitle, style: const TextStyle(color: Colors.white)),
        content: Text(AppLocalizations.of(context)!.deletePhotoMessage,
            style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(AppLocalizations.of(context)!.delete),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await CustomAvatarService.instance.deleteAvatar(customAvatar.id);
      if (mounted) {
        setState(() {
          _customAvatars = CustomAvatarService.instance.customAvatars;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Dialog(
      backgroundColor: const Color(0xFF1A1A2E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: screenHeight * 0.75,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: const Color(0xFF7C4DFF).withValues(alpha: 0.3),
            width: 2,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title with fun styling
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [Color(0xFFFFD54F), Color(0xFFFF8A65), Color(0xFFFF6B9D)],
                ).createShader(bounds),
                child: Text(
                  AppLocalizations.of(context)!.chooseYourAvatarFancy,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Category tabs - full width
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF16213E),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.1),
                    width: 1,
                  ),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF7C4DFF), Color(0xFF536DFE)],
                    ),
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white60,
                  labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  labelPadding: const EdgeInsets.symmetric(horizontal: 2),
                  isScrollable: false,
                  tabs: AvatarCategory.values.map((category) {
                    return Tab(
                      icon: Icon(category.icon, size: 20),
                      text: category.displayName,
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),
              // Avatar grid - centered
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: AvatarCategory.values.map((category) {
                    if (category == AvatarCategory.custom) {
                      return _buildCustomAvatarsTab();
                    }
                    return _buildAvatarGrid(category);
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),
              // Action buttons with kid-friendly styling
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white70,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.cancel,
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: _selectedAvatar != null
                          ? const LinearGradient(
                              colors: [Color(0xFF4CAF50), Color(0xFF2E7D32)],
                            )
                          : null,
                      color: _selectedAvatar == null ? Colors.grey.shade700 : null,
                      boxShadow: _selectedAvatar != null
                          ? [
                              BoxShadow(
                                color: const Color(0xFF4CAF50).withValues(alpha: 0.4),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ]
                          : null,
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: _selectedAvatar != null
                            ? () => Navigator.pop(context, _selectedAvatar)
                            : null,
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.check_circle, color: Colors.white, size: 18),
                              const SizedBox(width: 8),
                              Text(
                                AppLocalizations.of(context)!.select,
                                style: TextStyle(
                                  color: _selectedAvatar != null ? Colors.white : Colors.white54,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarGrid(AvatarCategory category) {
    final avatars = Avatars.byCategory(category);
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1.0,
      ),
      itemCount: avatars.length,
      itemBuilder: (context, index) {
        final avatar = avatars[index];
        final isAvailable = _isAvatarAvailable(avatar);
        final isSelected = _selectedAvatar?.id == avatar.id;

        return _AvatarOption(
          avatar: avatar,
          size: 64,
          isSelected: isSelected,
          isAvailable: isAvailable,
          onTap: isAvailable
              ? () => setState(() => _selectedAvatar = avatar)
              : null,
        );
      },
    );
  }

  Widget _buildCustomAvatarsTab() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(color: Color(0xFF7C4DFF)));
    }

    return Column(
      children: [
        // Action buttons row with colorful gradients
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: _ActionButton(
                  icon: Icons.camera_alt,
                  label: AppLocalizations.of(context)!.takePhoto,
                  onTap: _capturePhoto,
                  gradientColors: const [Color(0xFFFF6B9D), Color(0xFFFF8A65)],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ActionButton(
                  icon: Icons.photo_library,
                  label: AppLocalizations.of(context)!.choosePhoto,
                  onTap: _pickFromGallery,
                  gradientColors: const [Color(0xFF26C6DA), Color(0xFF00ACC1)],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        // Photo grid
        Expanded(
          child: _customAvatars.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.05),
                        ),
                        child: const Icon(Icons.add_a_photo, color: Colors.white38, size: 40),
                      ),
                      const SizedBox(height: 12),
                      Text(AppLocalizations.of(context)!.noPhotosYet,
                          style: TextStyle(color: Colors.white54, fontSize: 16, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 4),
                      Text(AppLocalizations.of(context)!.takeSelfieOrPick,
                          style: TextStyle(color: Colors.white38, fontSize: 13)),
                    ],
                  ),
                )
              : GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: _customAvatars.length,
                  itemBuilder: (context, index) {
                    final customAvatar = _customAvatars[index];
                    final avatar = Avatar.custom(
                      id: customAvatar.id,
                      name: customAvatar.name,
                      imagePath: customAvatar.imagePath,
                    );
                    final isAvailable = _isAvatarAvailable(avatar);
                    final isSelected = _selectedAvatar?.id == avatar.id;

                    return GestureDetector(
                      onLongPress: () => _deleteCustomAvatar(customAvatar),
                      child: _AvatarOption(
                        avatar: avatar,
                        size: 64,
                        isSelected: isSelected,
                        isAvailable: isAvailable,
                        onTap: isAvailable
                            ? () => setState(() => _selectedAvatar = avatar)
                            : null,
                      ),
                    );
                  },
                ),
        ),
      ],
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

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:hiweb_app_management/features/cart_checkout/screens/cart_screen.dart';
import 'package:hiweb_app_management/features/cart_checkout/services/cart_service.dart';
import 'package:hiweb_app_management/features/auth/services/auth_service.dart';
import 'package:hiweb_app_management/features/search/screens/search_screen.dart';

class VideoHeaderBar extends StatefulWidget {
  final bool isMuted;
  final VoidCallback onToggleMute;
  final ValueChanged<int>? onTabChanged;

  const VideoHeaderBar({
    super.key,
    required this.isMuted,
    required this.onToggleMute,
    this.onTabChanged,
  });

  @override
  State<VideoHeaderBar> createState() => _VideoHeaderBarState();
}

class _VideoHeaderBarState extends State<VideoHeaderBar> {
  int _selectedTabIndex = 1; // Default: 'Video cho bạn'

  final List<String> _tabs = [
    'Theo dõi',
    'Video cho bạn',
    'Xu hướng',
    'Yêu thích',
    'Đã lưu',
  ];

  Widget _buildTabItem(int index, String label) {
    final isActive = _selectedTabIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTabIndex = index;
        });
        if (widget.onTabChanged != null) {
          widget.onTabChanged!(index);
        }
      },
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Transform.translate(
            offset: const Offset(0, 2),
            child: Text(
              label,
              maxLines: 1,
              softWrap: false,
              style: TextStyle(
                color:
                    isActive
                        ? Colors.white
                        : Colors.white.withValues(alpha: 0.7),
                fontSize: isActive ? 16 : 15,
                fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 3),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: isActive ? 32 : 0,
            height: 3,
            decoration: BoxDecoration(
              color: isActive ? const Color(0xFF06B6D4) : Colors.transparent,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }

  void _openFollowingTab() {
    setState(() => _selectedTabIndex = 0);
    widget.onTabChanged?.call(0);
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: topPadding + 8,
              left: 8,
              right: 8,
              bottom: 8,
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: _openFollowingTab,
                  behavior: HitTestBehavior.opaque,
                  child: const SizedBox(
                    width: 30,
                    height: 30,
                    child: Icon(
                      LucideIcons.userPlus,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Transform.translate(
                    offset: const Offset(0, 3),
                    child: SizedBox(
                      height: 32,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        itemCount: _tabs.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 18),
                        itemBuilder:
                            (_, index) => _buildTabItem(index, _tabs[index]),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 4),

                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SearchScreen(),
                          ),
                        );
                      },
                      behavior: HitTestBehavior.opaque,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 2,
                          vertical: 4,
                        ),
                        child: Icon(
                          LucideIcons.search,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ListenableBuilder(
                      listenable: Listenable.merge([
                        CartService.instance,
                        AuthService.instance,
                      ]),
                      builder: (context, _) {
                        final count =
                            AuthService.instance.isLoggedIn
                                ? CartService.instance.totalItemCount
                                : 0;
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const CartScreen(),
                              ),
                            );
                          },
                          behavior: HitTestBehavior.opaque,
                          child: _buildCartIcon(count),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Mute / Unmute speaker icon right below header on the right
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 16, top: 4),
              child: GestureDetector(
                onTap: widget.onToggleMute,
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.4),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    widget.isMuted ? LucideIcons.volumeX : LucideIcons.volume2,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartIcon(int count) {
    return SizedBox(
      width: 30,
      height: 30,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          const Positioned(
            left: 3,
            top: 4,
            child: Icon(
              LucideIcons.shoppingCart,
              color: Colors.white,
              size: 20,
            ),
          ),
          if (count > 0)
            Positioned(
              top: -4,
              right: -3,
              child: Container(
                constraints: const BoxConstraints(minWidth: 15, minHeight: 15),
                padding: const EdgeInsets.symmetric(horizontal: 4),
                decoration: const BoxDecoration(
                  color: Color(0xFFEF4444),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  count > 99 ? '99+' : '$count',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

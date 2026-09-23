import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../screens/cart/cart_screen.dart';
import '../../screens/search/search_screen.dart';

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
          Text(
            label,
            maxLines: 1,
            softWrap: false,
            style: TextStyle(
              color: isActive
                  ? Colors.white
                  : Colors.white.withValues(alpha: 0.7),
              fontSize: isActive ? 16 : 15,
              fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
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
                      onTap: () => Navigator.of(context).maybePop(),
                      child: const SizedBox(
                        width: 26,
                        child: Icon(LucideIcons.chevronLeft, color: Colors.white, size: 21),
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
                            itemBuilder: (_, index) => _buildTabItem(index, _tabs[index]),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),

                // 2 Action Icons on the far right with 10px spacing
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const SearchScreen()),
                        );
                      },
                      behavior: HitTestBehavior.opaque,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 2, vertical: 4),
                        child: Icon(LucideIcons.search, color: Colors.white, size: 20),
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const CartScreen()),
                        );
                      },
                      behavior: HitTestBehavior.opaque,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 2, vertical: 4),
                        child: Icon(LucideIcons.shoppingCart, color: Colors.white, size: 20),
                      ),
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
}

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:hiweb_app_management/features/chat/models/message_model.dart';
import 'package:hiweb_app_management/features/product/models/product_detail_model.dart';
import 'package:hiweb_app_management/features/chat/screens/chat_detail_screen.dart';

class ShopBannerHeader extends StatefulWidget {
  final ShopProfileModel shop;

  const ShopBannerHeader({
    super.key,
    required this.shop,
  });

  @override
  State<ShopBannerHeader> createState() => _ShopBannerHeaderState();
}

class _ShopBannerHeaderState extends State<ShopBannerHeader> {
  final TextEditingController _searchController = TextEditingController();
  bool _isFollowing = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _navigateToChat() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ChatDetailScreen(
          messageItem: MessageModel(
            id: 'm1',
            shopName: widget.shop.name,
            avatarLetter: widget.shop.name.isNotEmpty
                ? widget.shop.name[0].toUpperCase()
                : 'M',
            avatarBgColor: const Color(0xFF0284C7),
            lastMessage: widget.shop.welcomeMessage,
            time: 'Vừa xong',
            unreadCount: 0,
            isOnline: true,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background Cover Photo with Dark Overlay
        Positioned.fill(
          child: Image.network(
            widget.shop.coverUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              color: const Color(0xFF1E293B),
            ),
          ),
        ),
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.55),
                  Colors.black.withValues(alpha: 0.75),
                  Colors.black.withValues(alpha: 0.85),
                ],
              ),
            ),
          ),
        ),

        // Foreground Content
        Padding(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 8,
            left: 12,
            right: 12,
            bottom: 14,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Navigation Bar: Back Button & Search Field
              Row(
                children: [
                  // Circular Back Button
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.35),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),

                  // Search Bar inside Shop
                  Expanded(
                    child: Container(
                      height: 36,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.2),
                          width: 0.8,
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            LucideIcons.search,
                            color: Colors.white70,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                              ),
                              cursorColor: Colors.white,
                              decoration: const InputDecoration(
                                hintText: 'Tìm kiếm sản phẩm trong Shop',
                                hintStyle: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12.5,
                                ),
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Shop Profile Info Box
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Avatar with "Yêu thích" Badge
                  Stack(
                    alignment: Alignment.bottomCenter,
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 58,
                        height: 58,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 2,
                          ),
                        ),
                        child: CircleAvatar(
                          backgroundColor: const Color(0xFF0284C7),
                          child: Text(
                            widget.shop.name.isNotEmpty
                                ? widget.shop.name[0].toUpperCase()
                                : 'M',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      if (widget.shop.isFavorite)
                        Positioned(
                          bottom: -6,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 1.5,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEF4444),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'Yêu thích',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: 14),

                  // Name & Ratings Column
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                widget.shop.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 2),
                            const Icon(
                              Icons.chevron_right,
                              color: Colors.white,
                              size: 18,
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              size: 14,
                              color: Color(0xFFEAB308),
                            ),
                            const SizedBox(width: 2),
                            Text(
                              '${widget.shop.rating.toStringAsFixed(1)} ',
                              style: const TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                '|  ${widget.shop.followerCount} Người theo dõi',
                                style: const TextStyle(
                                  fontSize: 11.5,
                                  color: Colors.white70,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Follow & Chat Action Buttons Column
                  Column(
                    children: [
                      // Follow Button
                      SizedBox(
                        height: 30,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _isFollowing = !_isFollowing;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _isFollowing
                                ? Colors.white.withValues(alpha: 0.25)
                                : const Color(0xFF0284C7),
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 0,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _isFollowing ? Icons.check : Icons.add,
                                color: Colors.white,
                                size: 14,
                              ),
                              const SizedBox(width: 3),
                              Text(
                                _isFollowing ? 'Đã theo dõi' : 'Theo dõi',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),

                      // Chat Button
                      SizedBox(
                        height: 30,
                        child: OutlinedButton(
                          onPressed: _navigateToChat,
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: Colors.white.withValues(alpha: 0.6),
                              width: 0.9,
                            ),
                            backgroundColor:
                                Colors.black.withValues(alpha: 0.2),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 0,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                LucideIcons.messageSquare,
                                color: Colors.white,
                                size: 13,
                              ),
                              SizedBox(width: 4),
                              Text(
                                'Chat',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // Product Video Bar Pill
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.15),
                    width: 0.8,
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      'Video sản phẩm',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${widget.shop.videoCount} Video',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(width: 2),
                    const Icon(
                      Icons.chevron_right,
                      color: Colors.white70,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

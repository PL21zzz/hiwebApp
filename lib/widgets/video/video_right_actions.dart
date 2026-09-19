import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../models/video/video_model.dart';

class VideoRightActions extends StatefulWidget {
  final VideoItemModel video;

  const VideoRightActions({
    super.key,
    required this.video,
  });

  @override
  State<VideoRightActions> createState() => _VideoRightActionsState();
}

class _VideoRightActionsState extends State<VideoRightActions> {
  late bool _isLiked;
  late bool _isSaved;
  late bool _isFollowing;

  @override
  void initState() {
    super.initState();
    _isLiked = widget.video.isLiked;
    _isSaved = widget.video.isSaved;
    _isFollowing = widget.video.isFollowing;
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 12,
      bottom: 80,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Avatar + Plus Follow Button
          SizedBox(
            width: 48,
            height: 54,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                    color: Colors.white,
                  ),
                  child: ClipOval(
                    child: Image.network(
                      widget.video.authorAvatar,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: Colors.cyan.shade600,
                        child: const Icon(LucideIcons.shoppingBag, color: Colors.white, size: 22),
                      ),
                    ),
                  ),
                ),
                if (!_isFollowing)
                  Positioned(
                    bottom: 0,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _isFollowing = true;
                          widget.video.isFollowing = true;
                        });
                      },
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: const BoxDecoration(
                          color: Color(0xFFEF4444), // Red follow button
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 14,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Like Button
          _buildActionButton(
            icon: _isLiked ? Icons.favorite : LucideIcons.heart,
            color: _isLiked ? const Color(0xFFEF4444) : Colors.white,
            label: widget.video.likes,
            onTap: () {
              setState(() {
                _isLiked = !_isLiked;
                widget.video.isLiked = _isLiked;
              });
            },
          ),
          const SizedBox(height: 16),

          // Comment Button
          _buildActionButton(
            icon: LucideIcons.messageCircle,
            color: Colors.white,
            label: widget.video.comments,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Mở bình luận'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
          ),
          const SizedBox(height: 16),

          // Bookmark Save Button
          _buildActionButton(
            icon: _isSaved ? Icons.bookmark : LucideIcons.bookmark,
            color: _isSaved ? const Color(0xFFF59E0B) : Colors.white,
            label: widget.video.saves,
            onTap: () {
              setState(() {
                _isSaved = !_isSaved;
                widget.video.isSaved = _isSaved;
              });
            },
          ),
          const SizedBox(height: 16),

          // Share Button
          _buildActionButton(
            icon: LucideIcons.share2,
            color: Colors.white,
            label: widget.video.shares,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Chia sẻ video'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
          ),
          const SizedBox(height: 16),

          // Report Button
          _buildActionButton(
            icon: LucideIcons.flag,
            color: Colors.white,
            label: 'Báo cáo',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Đã báo cáo vi phạm'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: color,
            size: 28,
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              shadows: [
                Shadow(
                  color: Colors.black45,
                  blurRadius: 4,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

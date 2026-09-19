import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../models/video/video_model.dart';

class VideoInfoSection extends StatefulWidget {
  final VideoItemModel video;
  final VoidCallback? onTapProductTag;

  const VideoInfoSection({
    super.key,
    required this.video,
    this.onTapProductTag,
  });

  @override
  State<VideoInfoSection> createState() => _VideoInfoSectionState();
}

class _VideoInfoSectionState extends State<VideoInfoSection> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 12,
      bottom: 60,
      right: 80,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Product Tag Pill Button
          GestureDetector(
            onTap: widget.onTapProductTag ??
                () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Mở danh sách ${widget.video.productTitle}'),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.55),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.2),
                  width: 0.8,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    LucideIcons.shoppingBag,
                    color: Colors.white,
                    size: 15,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    widget.video.productTitle,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    LucideIcons.chevronDown,
                    color: Colors.white,
                    size: 15,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Author Username
          Text(
            widget.video.authorName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  color: Colors.black45,
                  blurRadius: 4,
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),

          // Caption Text with Expand / Collapse ("Xem thêm" / "Thu gọn")
          GestureDetector(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.video.caption,
                  maxLines: _isExpanded ? null : 2,
                  overflow: _isExpanded
                      ? TextOverflow.visible
                      : TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.95),
                    fontSize: 13,
                    height: 1.35,
                    shadows: const [
                      Shadow(
                        color: Colors.black45,
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _isExpanded ? 'Thu gọn' : 'Xem thêm',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
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
          ),
        ],
      ),
    );
  }
}

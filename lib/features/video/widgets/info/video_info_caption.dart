import 'package:flutter/material.dart';

class VideoInfoCaption extends StatefulWidget {
  final String authorName;
  final String caption;

  const VideoInfoCaption({
    super.key,
    required this.authorName,
    required this.caption,
  });

  @override
  State<VideoInfoCaption> createState() => _VideoInfoCaptionState();
}

class _VideoInfoCaptionState extends State<VideoInfoCaption> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Author Name
        Text(
          widget.authorName,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14.5,
            fontWeight: FontWeight.bold,
            shadows: [Shadow(color: Colors.black54, blurRadius: 4)],
          ),
        ),
        const SizedBox(height: 4),

        // 2. Expandable Caption
        GestureDetector(
          onTap: () => setState(() => _isExpanded = !_isExpanded),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.caption,
                maxLines: _isExpanded ? null : 2,
                overflow:
                    _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.95),
                  fontSize: 12.5,
                  height: 1.35,
                  shadows: const [
                    Shadow(color: Colors.black54, blurRadius: 4),
                  ],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                _isExpanded ? 'Thu gọn' : 'Xem thêm',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  shadows: [Shadow(color: Colors.black54, blurRadius: 4)],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

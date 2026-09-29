import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:hiweb_app_management/features/video/models/video_model.dart';

class ShareSummaryCard extends StatelessWidget {
  final bool isVideoMode;
  final VideoItemModel? video;
  final String title;
  final String imageUrl;
  final double price;
  final double originalPrice;
  final String Function(double) formatCurrency;

  const ShareSummaryCard({
    super.key,
    required this.isVideoMode,
    this.video,
    required this.title,
    required this.imageUrl,
    required this.price,
    required this.originalPrice,
    required this.formatCurrency,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: isVideoMode && video != null
          ? Row(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: imageUrl.startsWith('http')
                          ? Image.network(
                              imageUrl,
                              width: 52,
                              height: 52,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                width: 52,
                                height: 52,
                                color: Colors.grey.shade200,
                                child: const Icon(LucideIcons.video, size: 20),
                              ),
                            )
                          : Image.asset(
                              imageUrl,
                              width: 52,
                              height: 52,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                width: 52,
                                height: 52,
                                color: Colors.grey.shade200,
                                child: const Icon(LucideIcons.video, size: 20),
                              ),
                            ),
                    ),
                    Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.play_arrow_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        video!.authorName,
                        style: const TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        video!.caption,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: imageUrl.startsWith('http')
                      ? Image.network(
                          imageUrl,
                          width: 52,
                          height: 52,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: 52,
                            height: 52,
                            color: Colors.grey.shade200,
                            child: const Icon(LucideIcons.image, size: 20),
                          ),
                        )
                      : Image.asset(
                          imageUrl,
                          width: 52,
                          height: 52,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: 52,
                            height: 52,
                            color: Colors.grey.shade200,
                            child: const Icon(LucideIcons.image, size: 20),
                          ),
                        ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1E293B),
                          height: 1.25,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            formatCurrency(price),
                            style: const TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFE53935),
                            ),
                          ),
                          if (originalPrice > price) ...[
                            const SizedBox(width: 6),
                            Text(
                              formatCurrency(originalPrice),
                              style: const TextStyle(
                                fontSize: 11,
                                color: Color(0xFF94A3B8),
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

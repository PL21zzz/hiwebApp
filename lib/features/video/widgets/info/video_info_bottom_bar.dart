import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:hiweb_app_management/core/theme/app_colors.dart';
import 'package:hiweb_app_management/features/video/models/video_model.dart';

class VideoInfoBottomBar extends StatelessWidget {
  final VideoItemModel video;
  final VoidCallback onTap;

  const VideoInfoBottomBar({
    super.key,
    required this.video,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(top: 5),
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
        decoration: BoxDecoration(
          color: const Color(0xFF141414).withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(7),
        ),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(4.5),
              ),
              child: const Center(
                child: Icon(LucideIcons.ticket, size: 12, color: Colors.white),
              ),
            ),
            const SizedBox(width: 6),
            Text(
              video.voucherDiscount,
              style: const TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 6),
            Container(width: 1, height: 11, color: Colors.white24),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                'Xem sản phẩm (${video.productCount})',
                style: const TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
            const Icon(
              LucideIcons.chevronRight,
              size: 14,
              color: Colors.white70,
            ),
          ],
        ),
      ),
    );
  }
}

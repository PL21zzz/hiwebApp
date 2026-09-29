import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:hiweb_app_management/core/theme/app_colors.dart';
import 'package:hiweb_app_management/features/video/models/video_model.dart';

class VideoInfoProductCard extends StatelessWidget {
  final VideoItemModel video;
  final VoidCallback onOpenProductDetail;
  final VoidCallback onCloseCard;
  final VoidCallback onAddToCart;
  final VoidCallback onBuyNow;

  const VideoInfoProductCard({
    super.key,
    required this.video,
    required this.onOpenProductDetail,
    required this.onCloseCard,
    required this.onAddToCart,
    required this.onBuyNow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.22),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Left Thumbnail with Discount Badge
          GestureDetector(
            onTap: onOpenProductDetail,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: () {
                    final imgUrl =
                        video.authorAvatar.isNotEmpty
                            ? video.authorAvatar
                            : video.thumbnailUrl;
                    if (imgUrl.startsWith('http')) {
                      return Image.network(
                        imgUrl,
                        width: 72,
                        height: 72,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (_, __, ___) => Container(
                              width: 72,
                              height: 72,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Icon(
                                LucideIcons.package,
                                color: Color(0xFF94A3B8),
                                size: 26,
                              ),
                            ),
                      );
                    }
                    return Image.asset(
                      imgUrl,
                      width: 72,
                      height: 72,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (_, __, ___) => Container(
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Icon(
                              LucideIcons.package,
                              color: Color(0xFF94A3B8),
                              size: 26,
                            ),
                          ),
                    );
                  }(),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4.5,
                      vertical: 1.5,
                    ),
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(6),
                        bottomRight: Radius.circular(6),
                      ),
                    ),
                    child: Text(
                      video.discountPercentage,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 8.5,
                        fontWeight: FontWeight.bold,
                        height: 1.1,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),

          // 2. Right Info & Action Buttons
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Line 1: MALL Badge + Title + Close Button
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 3.5,
                        vertical: 1,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(2.5),
                      ),
                      child: const Text(
                        'MALL',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 7.5,
                          fontWeight: FontWeight.w900,
                          height: 1.1,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: GestureDetector(
                        onTap: onOpenProductDetail,
                        child: Text(
                          video.productName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: onCloseCard,
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        width: 18,
                        height: 18,
                        decoration: const BoxDecoration(
                          color: Color(0xFFF1F5F9),
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Icon(
                            LucideIcons.x,
                            size: 10.5,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),

                // Line 2: Badges (Star 4.9 + Độc quyền + Giảm 25%)
                Row(
                  children: [
                    // Rating Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4.5,
                        vertical: 1,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF9C3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.star,
                            size: 9.5,
                            color: Color(0xFFEAB308),
                          ),
                          const SizedBox(width: 2),
                          Text(
                            video.rating,
                            style: const TextStyle(
                              fontSize: 8.5,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF854D0E),
                              height: 1.1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 4),

                    // "Độc quyền" Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4.5,
                        vertical: 1,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0F7FA),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Độc quyền',
                        style: TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                          height: 1.1,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),

                    // "Giảm 25%" Outline Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4.5,
                        vertical: 0.8,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppColors.primary,
                          width: 0.7,
                        ),
                      ),
                      child: Text(
                        video.voucherDiscount,
                        style: const TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primary,
                          height: 1.1,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2.5),

                // Line 3: Price & Sold Count
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      video.price,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        color: AppColors.primary,
                      ),
                    ),
                    Text(
                      video.soldCount,
                      style: const TextStyle(
                        fontSize: 9,
                        color: Color(0xFF64748B),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3.5),

                // Line 4: Cart Button + "Mua ngay" Button
                Row(
                  children: [
                    // Cart Button
                    InkWell(
                      onTap: onAddToCart,
                      borderRadius: BorderRadius.circular(5),
                      child: Container(
                        height: 26,
                        width: 34,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0F9FF),
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            width: 0.8,
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            LucideIcons.shoppingCart,
                            size: 14,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),

                    // "Mua ngay" Button
                    Expanded(
                      child: InkWell(
                        onTap: onBuyNow,
                        borderRadius: BorderRadius.circular(5),
                        child: Container(
                          height: 26,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            'Mua ngay',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
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
        ],
      ),
    );
  }
}

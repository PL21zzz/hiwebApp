import 'package:flutter/material.dart';
import 'package:hiweb_app_management/core/theme/app_colors.dart';
import 'package:hiweb_app_management/features/product/models/product_detail_model.dart';
import 'package:hiweb_app_management/features/product/screens/shop_detail_screen.dart';

class ShopProfileSummaryCard extends StatelessWidget {
  final ShopProfileModel shopProfile;

  const ShopProfileSummaryCard({
    super.key,
    required this.shopProfile,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      child: Row(
        children: [
          CircleAvatar(
            radius: 17,
            backgroundColor: AppColors.primary,
            child: Text(
              shopProfile.name.isNotEmpty
                  ? shopProfile.name[0].toUpperCase()
                  : 'P',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  shopProfile.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 2),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      Text(
                        '${shopProfile.followerCount} Theo dõi  ·  ${shopProfile.totalSold} Đã bán  ·  ${shopProfile.rating.toStringAsFixed(1)}',
                        style: const TextStyle(
                          fontSize: 9.5,
                          color: Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(width: 2),
                      const Icon(
                        Icons.star_rounded,
                        size: 14,
                        color: Color(0xFFEAB308),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Icon(
                      Icons.access_time,
                      size: 10,
                      color: Color(0xFF94A3B8),
                    ),
                    const SizedBox(width: 3),
                    Text(
                      'Tham gia: ${shopProfile.joinedDuration}',
                      style: const TextStyle(
                        fontSize: 9.5,
                        color: Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          OutlinedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ShopDetailScreen(shop: shopProfile),
                ),
              );
            },
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.primary),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              minimumSize: Size.zero,
              padding: const EdgeInsets.symmetric(
                horizontal: 9,
                vertical: 5,
              ),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text(
              'Xem Shop',
              style: TextStyle(
                fontSize: 9.5,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

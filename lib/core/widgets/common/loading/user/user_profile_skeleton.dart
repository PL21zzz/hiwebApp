import 'package:flutter/material.dart';
import 'package:hiweb_app_management/core/widgets/common/loading/shimmer_box.dart';
import 'package:hiweb_app_management/core/widgets/common/loading/product/product_card_skeleton.dart';

class UserProfileSkeleton extends StatelessWidget {
  const UserProfileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        children: [
          // Banner Top Skeleton
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(14),
            child: Row(
              children: const [
                ShimmerBox(width: 50, height: 50, borderRadius: BorderRadius.all(Radius.circular(25))),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerBox(height: 16, width: 130),
                      SizedBox(height: 6),
                      ShimmerBox(height: 12, width: 90),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Rewards Card Skeleton
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 14),
            child: ShimmerBox(height: 64, width: double.infinity, borderRadius: BorderRadius.all(Radius.circular(16))),
          ),
          const SizedBox(height: 8),

          // Orders Status Grid Skeleton
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 14),
            child: ShimmerBox(height: 110, width: double.infinity, borderRadius: BorderRadius.all(Radius.circular(16))),
          ),
          const SizedBox(height: 8),

          // Recommendations Skeleton Grid
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: ProductGridSkeleton(itemCount: 4),
          ),
        ],
      ),
    );
  }
}

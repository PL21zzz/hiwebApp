import 'package:flutter/material.dart';
import 'package:hiweb_app_management/core/widgets/common/loading/shimmer_box.dart';
import 'package:hiweb_app_management/core/widgets/common/loading/product/product_card_skeleton.dart';

class ShopDetailSkeleton extends StatelessWidget {
  const ShopDetailSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner Top Header Skeleton
          Container(
            height: 180,
            padding: const EdgeInsets.all(14),
            decoration: const BoxDecoration(
              color: Color(0xFF1E293B),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  children: const [
                    ShimmerBox(width: 58, height: 58, borderRadius: BorderRadius.all(Radius.circular(29))),
                    SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ShimmerBox(height: 16, width: 140),
                          SizedBox(height: 8),
                          ShimmerBox(height: 12, width: 110),
                        ],
                      ),
                    ),
                    ShimmerBox(width: 75, height: 32, borderRadius: BorderRadius.all(Radius.circular(6))),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Tabs Header Skeleton
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                ShimmerBox(height: 20, width: 70),
                ShimmerBox(height: 20, width: 90),
                ShimmerBox(height: 20, width: 90),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Product Grid Skeleton
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: ProductGridSkeleton(itemCount: 4),
          ),
        ],
      ),
    );
  }
}

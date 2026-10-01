import 'package:flutter/material.dart';
import 'package:hiweb_app_management/core/widgets/common/loading/shimmer_box.dart';

class ProductDetailSkeleton extends StatelessWidget {
  const ProductDetailSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Header Bar Skeleton
          Container(
            height: 48,
            color: const Color(0xFF0284C7),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: const [
                ShimmerBox(width: 24, height: 24, borderRadius: BorderRadius.all(Radius.circular(12))),
                Spacer(),
                ShimmerBox(width: 140, height: 20, borderRadius: BorderRadius.all(Radius.circular(4))),
                Spacer(),
                ShimmerBox(width: 24, height: 24, borderRadius: BorderRadius.all(Radius.circular(12))),
              ],
            ),
          ),

          // 2. Media Image Banner AspectRatio 1:1
          const AspectRatio(
            aspectRatio: 1.0,
            child: ShimmerBox(
              borderRadius: BorderRadius.zero,
            ),
          ),
          const SizedBox(height: 12),

          // 3. Price & Title Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                ShimmerBox(height: 22, width: 140),
                SizedBox(height: 10),
                ShimmerBox(height: 16, width: double.infinity),
                SizedBox(height: 6),
                ShimmerBox(height: 16, width: 220),
                SizedBox(height: 12),
                Row(
                  children: [
                    ShimmerBox(height: 14, width: 80),
                    SizedBox(width: 12),
                    ShimmerBox(height: 14, width: 100),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          const Divider(height: 8, thickness: 8, color: Color(0xFFF1F5F9)),
          const SizedBox(height: 12),

          // 4. Capacity Selection Options
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                ShimmerBox(height: 14, width: 110),
                SizedBox(height: 10),
                Row(
                  children: [
                    ShimmerBox(height: 34, width: 80, borderRadius: BorderRadius.all(Radius.circular(6))),
                    SizedBox(width: 8),
                    ShimmerBox(height: 34, width: 80, borderRadius: BorderRadius.all(Radius.circular(6))),
                    SizedBox(width: 8),
                    ShimmerBox(height: 34, width: 80, borderRadius: BorderRadius.all(Radius.circular(6))),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          const Divider(height: 8, thickness: 8, color: Color(0xFFF1F5F9)),
          const SizedBox(height: 12),

          // 5. Reviews Section Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ShimmerBox(height: 16, width: 130),
                    ShimmerBox(height: 14, width: 70),
                  ],
                ),
                SizedBox(height: 12),
                ShimmerBox(height: 60, width: double.infinity, borderRadius: BorderRadius.all(Radius.circular(8))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

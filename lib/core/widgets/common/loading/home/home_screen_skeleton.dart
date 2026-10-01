import 'package:flutter/material.dart';
import 'package:hiweb_app_management/core/widgets/common/loading/shimmer_box.dart';
import 'package:hiweb_app_management/core/widgets/common/loading/product/product_card_skeleton.dart';

class HomeScreenSkeleton extends StatelessWidget {
  const HomeScreenSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        children: [
          // Banner Slider Skeleton
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: ShimmerBox(
              height: 160,
              width: double.infinity,
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
          ),
          const SizedBox(height: 8),

          // Categories Grid Skeleton
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(
                5,
                (_) => const ShimmerBox(
                  width: 48,
                  height: 48,
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Product Grid Skeleton
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: ProductGridSkeleton(itemCount: 6),
          ),
        ],
      ),
    );
  }
}

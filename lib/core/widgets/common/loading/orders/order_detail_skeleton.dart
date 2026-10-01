import 'package:flutter/material.dart';
import 'package:hiweb_app_management/core/widgets/common/loading/shimmer_box.dart';

class OrderDetailSkeleton extends StatelessWidget {
  const OrderDetailSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        children: [
          // Header Back Bar Skeleton
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: const [
                ShimmerBox(height: 14, width: 120),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Stepper Section Skeleton
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                ShimmerBox(height: 16, width: 180),
                SizedBox(height: 12),
                ShimmerBox(height: 40, width: double.infinity, borderRadius: BorderRadius.all(Radius.circular(8))),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Address Card Skeleton
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                ShimmerBox(height: 14, width: 100),
                SizedBox(height: 8),
                ShimmerBox(height: 14, width: 160),
                SizedBox(height: 6),
                ShimmerBox(height: 12, width: double.infinity),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

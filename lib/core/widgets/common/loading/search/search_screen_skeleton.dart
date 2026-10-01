import 'package:flutter/material.dart';
import 'package:hiweb_app_management/core/widgets/common/loading/shimmer_box.dart';
import 'package:hiweb_app_management/core/widgets/common/loading/product/product_card_skeleton.dart';

class SearchScreenSkeleton extends StatelessWidget {
  const SearchScreenSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filter pills skeleton
          Row(
            children: const [
              ShimmerBox(height: 30, width: 70, borderRadius: BorderRadius.all(Radius.circular(15))),
              SizedBox(width: 8),
              ShimmerBox(height: 30, width: 90, borderRadius: BorderRadius.all(Radius.circular(15))),
              SizedBox(width: 8),
              ShimmerBox(height: 30, width: 80, borderRadius: BorderRadius.all(Radius.circular(15))),
            ],
          ),
          const SizedBox(height: 14),

          // Search Product Grid
          const ProductGridSkeleton(itemCount: 6),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'shimmer_box.dart';

class FlashSaleSkeleton extends StatelessWidget {
  final int itemCount;

  const FlashSaleSkeleton({super.key, this.itemCount = 4});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 175,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: itemCount,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder:
            (_, __) => Container(
              width: 125,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFF1F5F9)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AspectRatio(
                    aspectRatio: 1.0,
                    child: ShimmerBox(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        ShimmerBox(height: 14, width: 80),
                        SizedBox(height: 6),
                        ShimmerBox(height: 10, width: 110),
                      ],
                    ),
                  ),
                ],
              ),
            ),
      ),
    );
  }
}

/// Dedicated vertical card skeleton matching the exact layout of FlashSaleScreen list items
class FlashSaleCardSkeleton extends StatelessWidget {
  const FlashSaleCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left: 95x95 Image Skeleton
          const ShimmerBox(
            width: 95,
            height: 95,
            borderRadius: BorderRadius.all(Radius.circular(6)),
          ),
          const SizedBox(width: 10),

          // Right: Content Section Skeleton
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ShimmerBox(height: 13, width: double.infinity),
                const SizedBox(height: 4),
                const ShimmerBox(height: 13, width: 130),
                const SizedBox(height: 6),
                const ShimmerBox(height: 12, width: 60),
                const SizedBox(height: 6),
                const ShimmerBox(height: 16, width: 90),
                const SizedBox(height: 8),

                // Bottom Row: Progress Bar & Button Skeleton
                Row(
                  children: const [
                    Expanded(
                      child: ShimmerBox(
                        height: 22,
                        borderRadius: BorderRadius.all(Radius.circular(11)),
                      ),
                    ),
                    SizedBox(width: 8),
                    ShimmerBox(
                      width: 70,
                      height: 28,
                      borderRadius: BorderRadius.all(Radius.circular(5)),
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

class FlashSaleListSkeleton extends StatelessWidget {
  final int itemCount;

  const FlashSaleListSkeleton({super.key, this.itemCount = 4});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemCount: itemCount,
      itemBuilder: (_, __) => const FlashSaleCardSkeleton(),
    );
  }
}

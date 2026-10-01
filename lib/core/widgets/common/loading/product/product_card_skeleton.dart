import 'package:flutter/material.dart';
import 'package:hiweb_app_management/core/widgets/common/loading/shimmer_box.dart';

class ProductCardSkeleton extends StatelessWidget {
  const ProductCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1:1 Image Skeleton
          const AspectRatio(
            aspectRatio: 1.0,
            child: ShimmerBox(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const ShimmerBox(height: 12, width: double.infinity),
                  const ShimmerBox(height: 12, width: 90),
                  const ShimmerBox(height: 15, width: 75),
                  Row(
                    children: const [
                      ShimmerBox(height: 10, width: 40),
                      Spacer(),
                      ShimmerBox(height: 10, width: 50),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProductGridSkeleton extends StatelessWidget {
  final int itemCount;
  final ScrollPhysics physics;

  const ProductGridSkeleton({
    super.key,
    this.itemCount = 6,
    this.physics = const NeverScrollableScrollPhysics(),
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 900
            ? 4
            : constraints.maxWidth > 600
                ? 3
                : 2;
        const spacing = 8.0;
        final totalSpacing = spacing * (crossAxisCount - 1);
        final cardWidth = (constraints.maxWidth - totalSpacing) / crossAxisCount;
        const textSectionHeight = 104.0;
        final childAspectRatio = cardWidth / (cardWidth + textSectionHeight);

        return GridView.builder(
          shrinkWrap: true,
          physics: physics,
          itemCount: itemCount,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: childAspectRatio,
            crossAxisSpacing: spacing,
            mainAxisSpacing: spacing,
          ),
          itemBuilder: (_, __) => const ProductCardSkeleton(),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'shimmer_box.dart';

class OrderItemSkeleton extends StatelessWidget {
  const OrderItemSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Order Header Skeleton (Shop name & Status badge)
          Row(
            children: const [
              ShimmerBox(height: 14, width: 120),
              Spacer(),
              ShimmerBox(height: 14, width: 70),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          const SizedBox(height: 12),

          // Order Product Row Skeleton
          Row(
            children: [
              const ShimmerBox(
                height: 64,
                width: 64,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    ShimmerBox(height: 14, width: double.infinity),
                    SizedBox(height: 6),
                    ShimmerBox(height: 12, width: 100),
                    SizedBox(height: 8),
                    ShimmerBox(height: 14, width: 80),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          const SizedBox(height: 12),

          // Total Price & Actions Skeleton
          Row(
            children: const [
              ShimmerBox(height: 12, width: 100),
              Spacer(),
              ShimmerBox(
                height: 32,
                width: 90,
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class OrderListSkeleton extends StatelessWidget {
  final int itemCount;

  const OrderListSkeleton({super.key, this.itemCount = 3});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: itemCount,
      itemBuilder: (_, __) => const OrderItemSkeleton(),
    );
  }
}

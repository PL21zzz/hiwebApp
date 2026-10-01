import 'package:flutter/material.dart';
import 'package:hiweb_app_management/core/widgets/common/loading/shimmer_box.dart';

class NotificationSkeleton extends StatelessWidget {
  const NotificationSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.all(12),
      itemCount: 5,
      itemBuilder: (_, __) => Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFF1F5F9)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ShimmerBox(
              width: 42,
              height: 42,
              borderRadius: BorderRadius.all(Radius.circular(21)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  ShimmerBox(height: 14, width: 140),
                  SizedBox(height: 6),
                  ShimmerBox(height: 12, width: double.infinity),
                  SizedBox(height: 4),
                  ShimmerBox(height: 10, width: 80),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

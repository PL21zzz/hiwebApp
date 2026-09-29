import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class FullscreenTopBar extends StatelessWidget {
  final int currentIndex;
  final int totalCount;
  final TransformationController transformationController;
  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;

  const FullscreenTopBar({
    super.key,
    required this.currentIndex,
    required this.totalCount,
    required this.transformationController,
    required this.onZoomIn,
    required this.onZoomOut,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Close button X
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white, size: 26),
            onPressed: () => Navigator.of(context).pop(),
          ),

          // Title / Counter
          Text(
            '${currentIndex + 1}/$totalCount',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),

          // Zoom level controls (- 100% +)
          Row(
            children: [
              IconButton(
                icon: const Icon(LucideIcons.minus, color: Colors.white, size: 18),
                onPressed: onZoomOut,
              ),
              ValueListenableBuilder<Matrix4>(
                valueListenable: transformationController,
                builder: (context, value, child) {
                  final scale = value.getMaxScaleOnAxis();
                  return Text(
                    '${(scale * 100).toInt()}%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(LucideIcons.plus, color: Colors.white, size: 18),
                onPressed: onZoomIn,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

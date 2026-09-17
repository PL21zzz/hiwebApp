import 'dart:async';
import 'package:flutter/material.dart';
import '../../screens/flash_sale_screen.dart';
import '../../theme/app_colors.dart';

class FlashSaleSection extends StatefulWidget {
  const FlashSaleSection({super.key});

  @override
  State<FlashSaleSection> createState() => _FlashSaleSectionState();
}

class _FlashSaleSectionState extends State<FlashSaleSection> {
  Timer? _timer;
  int _remainingSeconds = 0;

  @override
  void initState() {
    super.initState();
    _updateRemainingTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        _updateRemainingTime();
      }
    });
  }

  void _updateRemainingTime() {
    final now = DateTime.now();
    final hour = now.hour;
    DateTime targetTime;

    if (hour >= 12 && hour < 15) {
      targetTime = DateTime(now.year, now.month, now.day, 15, 0, 0);
    } else if (hour >= 15 && hour < 19) {
      targetTime = DateTime(now.year, now.month, now.day, 19, 0, 0);
    } else if (hour >= 19) {
      targetTime = DateTime(now.year, now.month, now.day + 1, 0, 0, 0);
    } else {
      targetTime = DateTime(now.year, now.month, now.day, 12, 0, 0);
    }

    final diff = targetTime.difference(now).inSeconds;
    setState(() {
      _remainingSeconds = diff > 0 ? diff : 0;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _twoDigits(int n) => n.toString().padLeft(2, '0');

  Widget _buildTimeBox(String timeStr) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        timeStr,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }

  Widget _buildImageTile({
    required String imageUrl,
    String? badgeText,
  }) {
    return Expanded(
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Image.network(
              imageUrl,
              height: 75,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 75,
                color: Colors.grey.shade300,
                child: const Icon(Icons.broken_image, size: 20, color: Colors.grey),
              ),
            ),
          ),
          if (badgeText != null)
            Positioned(
              top: 4,
              left: 4,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFE53935),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Text(
                  badgeText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 7.5,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hours = _twoDigits(_remainingSeconds ~/ 3600);
    final minutes = _twoDigits((_remainingSeconds % 3600) ~/ 60);
    final seconds = _twoDigits(_remainingSeconds % 60);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. KHỐI BÊN TRÁI: Flash Sale
          Expanded(
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(
                  PageRouteBuilder(
                    pageBuilder: (context, animation1, animation2) =>
                        const FlashSaleScreen(),
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                  ),
                );
              },
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 24,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            const Icon(Icons.bolt_rounded,
                                color: Color(0xFFFF6D00), size: 18),
                            const SizedBox(width: 2),
                            const Text(
                              'Flash Sale',
                              style: TextStyle(
                                color: Color(0xFFD50000),
                                fontSize: 13,
                                fontWeight: FontWeight.w900,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            const SizedBox(width: 8),
                            _buildTimeBox(hours),
                            const Text(' : ',
                                style: TextStyle(
                                    fontSize: 10, fontWeight: FontWeight.bold)),
                            _buildTimeBox(minutes),
                            const Text(' : ',
                                style: TextStyle(
                                    fontSize: 10, fontWeight: FontWeight.bold)),
                            _buildTimeBox(seconds),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _buildImageTile(
                          imageUrl:
                              'https://res.cloudinary.com/dypm5avrx/image/upload/v1789549363/flash-sale1_wbuuhi.webp',
                          badgeText: 'ĐÃ BÁN 4100',
                        ),
                        const SizedBox(width: 6),
                        _buildImageTile(
                          imageUrl:
                              'https://res.cloudinary.com/dypm5avrx/image/upload/v1789549364/flash-sale2_fvgamt.webp',
                          badgeText: 'ĐÃ BÁN 2800',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),

          // 2. KHỐI BÊN PHẢI: VietMade VIDEO
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 24,
                    child: Row(
                      children: [
                        Icon(Icons.play_circle_fill_rounded,
                            color: AppColors.primary, size: 18),
                        SizedBox(width: 4),
                        Text(
                          'VietMade VIDEO',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 13,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildImageTile(
                        imageUrl:
                            'https://res.cloudinary.com/dypm5avrx/image/upload/v1789549364/video1_dqeu7c.webp',
                      ),
                      const SizedBox(width: 6),
                      _buildImageTile(
                        imageUrl:
                            'https://res.cloudinary.com/dypm5avrx/image/upload/v1789549364/video2_mazns1.webp',
                      ),
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

import 'package:flutter/material.dart';

class FlashSaleCountdownBanner extends StatelessWidget {
  final bool isCurrentSlotActive;
  final int remainingSeconds;

  const FlashSaleCountdownBanner({
    super.key,
    required this.isCurrentSlotActive,
    required this.remainingSeconds,
  });

  String _twoDigits(int n) => n.toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    final hours = _twoDigits(remainingSeconds ~/ 3600);
    final minutes = _twoDigits((remainingSeconds % 3600) ~/ 60);
    final seconds = _twoDigits(remainingSeconds % 60);
    final statusTitle = isCurrentSlotActive ? 'KẾT THÚC SAU' : 'BẮT ĐẦU SAU';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            statusTitle,
            style: const TextStyle(
              color: Color(0xFFE53935),
              fontSize: 14,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            '$hours : $minutes : $seconds',
            style: const TextStyle(
              color: Color(0xFFE53935),
              fontSize: 15,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

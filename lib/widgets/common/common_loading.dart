import 'package:flutter/material.dart';

class CommonLoading extends StatelessWidget {
  final String message;
  final Color color;
  final double size;

  const CommonLoading({
    super.key,
    this.message = 'Đang tải...',
    this.color = const Color(0xFF0097B2),
    this.size = 28,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            message,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }
}

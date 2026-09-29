import 'package:flutter/material.dart';

class ShareItemButton extends StatelessWidget {
  final Widget iconWidget;
  final String label;
  final VoidCallback onTap;

  const ShareItemButton({
    super.key,
    required this.iconWidget,
    required this.label,
    required this.onTap,
  });

  static Widget buildCircleButton({
    required Color bgColor,
    required IconData icon,
    Color iconColor = Colors.white,
  }) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
      child: Icon(icon, color: iconColor, size: 22),
    );
  }

  static Widget buildTextCircleButton({
    required Color bgColor,
    required String text,
    Color textColor = Colors.white,
  }) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 72,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(shape: BoxShape.circle),
              child: Center(child: iconWidget),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 11.5,
                color: Color(0xFF475569),
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

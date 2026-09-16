import 'package:flutter/material.dart';

class CategoryGrid extends StatelessWidget {
  const CategoryGrid({super.key});

  @override
  Widget build(BuildContext context) {
    // 5 Emoji icon chuẩn theo mã nguồn Web gốc: 💊 ✨ 💄 👶 👕
    final List<Map<String, dynamic>> categories = [
      {'emoji': '💊', 'bg': const Color(0xFFFFF0F2)},
      {'emoji': '✨', 'bg': const Color(0xFFFFF7ED)},
      {'emoji': '💄', 'bg': const Color(0xFFFDF2F8)},
      {'emoji': '👶', 'bg': const Color(0xFFFEFCE8)},
      {'emoji': '👕', 'bg': const Color(0xFFF0FDF4)},
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: categories.map((cat) {
          return Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: cat['bg'] as Color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                cat['emoji'] as String,
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

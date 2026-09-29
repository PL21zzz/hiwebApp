import 'package:flutter/material.dart';

class FlashSaleCategoryBar extends StatelessWidget {
  final List<String> categories;
  final int selectedCategoryIndex;
  final ValueChanged<int> onCategorySelected;

  const FlashSaleCategoryBar({
    super.key,
    required this.categories,
    required this.selectedCategoryIndex,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      color: Colors.white,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemBuilder: (context, index) {
          final isSelected = selectedCategoryIndex == index;
          return GestureDetector(
            onTap: () => onCategorySelected(index),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: isSelected
                    ? const Border(
                        bottom: BorderSide(
                          color: Color(0xFFE53935),
                          width: 2.5,
                        ),
                      )
                    : null,
              ),
              child: Text(
                categories[index],
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected
                      ? const Color(0xFFE53935)
                      : const Color(0xFF475569),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

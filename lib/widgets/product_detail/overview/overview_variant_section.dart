import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../models/product/product_detail_model.dart';
import '../../../theme/app_colors.dart';

class OverviewVariantSection extends StatelessWidget {
  final ProductDetailModel detail;
  final String? selectedCapacity;
  final ValueChanged<String?> onCapacitySelected;

  const OverviewVariantSection({
    super.key,
    required this.detail,
    required this.selectedCapacity,
    required this.onCapacitySelected,
  });

  Widget _capacityChip(String capacity) {
    final selected = selectedCapacity == capacity;
    return GestureDetector(
      onTap: () => onCapacitySelected(selected ? null : capacity),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: selected ? const Color(0xFFF0F9FF) : Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: selected ? AppColors.primary : const Color(0xFFCBD5E1), width: selected ? 1.5 : 1),
            ),
            child: Text(capacity, style: TextStyle(fontSize: 12, fontWeight: selected ? FontWeight.bold : FontWeight.w500, color: selected ? AppColors.primary : const Color(0xFF334155))),
          ),
          if (selected)
            Positioned(
              top: 0,
              right: 10,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.only(topRight: Radius.circular(7), bottomLeft: Radius.circular(4))),
                child: const Icon(Icons.check, size: 9, color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(detail.variantLabel, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
              if (selectedCapacity != null)
                RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(text: 'Đã chọn: ', style: TextStyle(fontSize: 11.5, color: Color(0xFF64748B))),
                      TextSpan(text: selectedCapacity, style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: AppColors.primary)),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Row(children: detail.capacityOptions.map(_capacityChip).toList()),
          const SizedBox(height: 12),
          const _PerkRow(icon: LucideIcons.truck, text: 'Miễn phí vận chuyển'),
          const SizedBox(height: 8),
          const _PerkRow(icon: LucideIcons.refreshCw, text: 'Miễn phí đổi trả trong vòng 15 ngày'),
        ],
      ),
    );
  }
}

class _PerkRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _PerkRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) => Row(children: [Icon(icon, size: 16, color: AppColors.primary), const SizedBox(width: 8), Text(text, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary))]);
}

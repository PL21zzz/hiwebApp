import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:hiweb_app_management/core/theme/app_colors.dart';

class SupportStep2Form extends StatelessWidget {
  final String? selectedType;
  final String? selectedTypeLabel;
  final TextEditingController titleController;
  final TextEditingController contentController;
  final VoidCallback onBack;
  final VoidCallback onNext;

  const SupportStep2Form({
    super.key,
    required this.selectedType,
    required this.selectedTypeLabel,
    required this.titleController,
    required this.contentController,
    required this.onBack,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Selected type summary badge
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: selectedType == 'order'
                      ? const Color(0xFFF59E0B)
                      : const Color(0xFF8B5CF6),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Icon(
                    selectedType == 'order'
                        ? LucideIcons.package
                        : LucideIcons.cog,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Loại yêu cầu',
                    style: TextStyle(fontSize: 10.5, color: Color(0xFF64748B)),
                  ),
                  Text(
                    selectedTypeLabel ?? '',
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Tiêu đề
        const Text(
          'Tiêu đề',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Color(0xFF334155),
          ),
        ),
        const SizedBox(height: 6),
        Container(
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFCBD5E1)),
          ),
          child: Center(
            child: TextField(
              controller: titleController,
              style: const TextStyle(fontSize: 13.5, color: Color(0xFF1E293B)),
              decoration: const InputDecoration(
                hintText: 'Ví dụ: Đơn hàng giao thiếu sản phẩm',
                hintStyle: TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
        ),
        const SizedBox(height: 14),

        // Nội dung cần hỗ trợ
        const Text(
          'Nội dung cần hỗ trợ',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Color(0xFF334155),
          ),
        ),
        const SizedBox(height: 6),
        Container(
          height: 110,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFCBD5E1)),
          ),
          child: TextField(
            controller: contentController,
            maxLines: null,
            keyboardType: TextInputType.multiline,
            style: const TextStyle(fontSize: 13.5, color: Color(0xFF1E293B)),
            decoration: const InputDecoration(
              hintText: 'Mô tả chi tiết vấn đề bạn đang gặp...',
              hintStyle: TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
              border: InputBorder.none,
              isDense: true,
            ),
          ),
        ),
        const SizedBox(height: 20),

        // Bottom Buttons
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onBack,
                icon: const Icon(LucideIcons.arrowLeft, size: 16),
                label: const Text('Quay lại'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 42),
                  side: const BorderSide(color: Color(0xFFCBD5E1)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: onNext,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 42),
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Tiếp tục',
                  style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

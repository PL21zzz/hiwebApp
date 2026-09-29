import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:hiweb_app_management/core/theme/app_colors.dart';

class SupportStep3Summary extends StatelessWidget {
  final String? selectedTypeLabel;
  final String titleText;
  final String contentText;
  final VoidCallback onBack;
  final VoidCallback onSubmit;

  const SupportStep3Summary({
    super.key,
    required this.selectedTypeLabel,
    required this.titleText,
    required this.contentText,
    required this.onBack,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Summary Card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Loại yêu cầu',
                style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
              ),
              Text(
                selectedTypeLabel ?? '',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              const Divider(height: 20, color: Color(0xFFE2E8F0)),

              const Text(
                'Tiêu đề',
                style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
              ),
              Text(
                titleText,
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E293B),
                ),
              ),
              const Divider(height: 20, color: Color(0xFFE2E8F0)),

              const Text(
                'Nội dung',
                style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
              ),
              Text(
                contentText,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF334155),
                  height: 1.35,
                ),
              ),
            ],
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
              child: ElevatedButton.icon(
                onPressed: onSubmit,
                icon: const Icon(LucideIcons.send, size: 16, color: Colors.white),
                label: const Text(
                  'Gửi yêu cầu',
                  style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 42),
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

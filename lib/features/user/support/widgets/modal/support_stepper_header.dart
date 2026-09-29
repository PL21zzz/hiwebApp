import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:hiweb_app_management/core/theme/app_colors.dart';

class SupportStepperHeader extends StatelessWidget {
  final int currentStep;

  const SupportStepperHeader({
    super.key,
    required this.currentStep,
  });

  Widget _buildStepCircle(int stepNumber, String label) {
    final isActive = currentStep == stepNumber;
    final isCompleted = currentStep > stepNumber;

    return Column(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive
                ? Colors.white
                : (isCompleted ? AppColors.primary : const Color(0xFFF1F5F9)),
            border: Border.all(
              color: isActive || isCompleted
                  ? AppColors.primary
                  : const Color(0xFFCBD5E1),
              width: 1.8,
            ),
          ),
          child: Center(
            child: isCompleted
                ? const Icon(LucideIcons.check, size: 14, color: Colors.white)
                : Text(
                    '$stepNumber',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isActive ? AppColors.primary : const Color(0xFF64748B),
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10.5,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            color: isActive ? AppColors.primary : const Color(0xFF64748B),
          ),
        ),
      ],
    );
  }

  Widget _buildStepLine(bool isFinished) {
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.only(bottom: 16),
        color: isFinished ? AppColors.primary : const Color(0xFFE2E8F0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStepCircle(1, 'Chọn loại'),
            _buildStepLine(currentStep >= 2),
            _buildStepCircle(2, 'Chi tiết'),
            _buildStepLine(currentStep >= 3),
            _buildStepCircle(3, 'Gửi'),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

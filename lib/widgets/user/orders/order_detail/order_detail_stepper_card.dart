import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../models/user/orders/order_detail_model.dart';
import '../../../../theme/app_colors.dart';

class OrderDetailStepperCard extends StatelessWidget {
  final OrderDetailModel detail;

  const OrderDetailStepperCard({
    super.key,
    required this.detail,
  });

  Widget _buildStepItem({
    required IconData icon,
    required String label,
    required bool isCompleted,
    required bool isActive,
  }) {
    final circleBg = isCompleted || isActive ? AppColors.primary : const Color(0xFFE2E8F0);
    final iconColor = isCompleted || isActive ? Colors.white : const Color(0xFF94A3B8);
    final textColor = isCompleted || isActive ? const Color(0xFF0F172A) : const Color(0xFF94A3B8);

    return Column(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: circleBg,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Icon(icon, size: 18, color: iconColor),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: isCompleted || isActive ? FontWeight.w600 : FontWeight.w400,
            color: textColor,
          ),
        ),
      ],
    );
  }

  Widget _buildConnectorLine(bool isCompleted) {
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.only(bottom: 20),
        color: isCompleted ? AppColors.primary : const Color(0xFFE2E8F0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final steps = [
      {'label': 'Đặt hàng', 'icon': LucideIcons.fileText},
      {'label': 'Tiếp nhận', 'icon': LucideIcons.mail},
      {'label': 'Vận chuyển', 'icon': LucideIcons.truck},
      {'label': 'Đã nhận', 'icon': LucideIcons.package},
    ];

    return Column(
      children: [
        // Alert Warning Banner
        Container(
          width: double.infinity,
          color: const Color(0xFFFEF2F2),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                LucideIcons.alertCircle,
                size: 16,
                color: Color(0xFFEF4444),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 11,
                      height: 1.35,
                      color: Color(0xFFEF4444),
                    ),
                    children: [
                      const TextSpan(
                        text: 'TUYỆT ĐỐI không chuyển khoản trước ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: detail.warningAlert.replaceFirst('TUYỆT ĐỐI không chuyển khoản trước ', ''),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
          child: Column(
            children: [
              // Order ID & Status Badge Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                      children: [
                        const TextSpan(text: 'Đơn hàng: '),
                        TextSpan(
                          text: detail.orderCode,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      detail.statusLabel,
                      style: const TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Horizontal Stepper Progress Bar
              Row(
                children: [
                  _buildStepItem(
                    icon: steps[0]['icon'] as IconData,
                    label: steps[0]['label'] as String,
                    isCompleted: detail.currentStepIndex >= 0,
                    isActive: detail.currentStepIndex == 0,
                  ),
                  _buildConnectorLine(detail.currentStepIndex >= 1),
                  _buildStepItem(
                    icon: steps[1]['icon'] as IconData,
                    label: steps[1]['label'] as String,
                    isCompleted: detail.currentStepIndex >= 1,
                    isActive: detail.currentStepIndex == 1,
                  ),
                  _buildConnectorLine(detail.currentStepIndex >= 2),
                  _buildStepItem(
                    icon: steps[2]['icon'] as IconData,
                    label: steps[2]['label'] as String,
                    isCompleted: detail.currentStepIndex >= 2,
                    isActive: detail.currentStepIndex == 2,
                  ),
                  _buildConnectorLine(detail.currentStepIndex >= 3),
                  _buildStepItem(
                    icon: steps[3]['icon'] as IconData,
                    label: steps[3]['label'] as String,
                    isCompleted: detail.currentStepIndex >= 3,
                    isActive: detail.currentStepIndex == 3,
                  ),
                ],
              ),
            ],
          ),
        ),

        // Shipping Origin & Estimated Delivery Box
        Container(
          width: double.infinity,
          color: const Color(0xFFF0F9FF),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(LucideIcons.mapPin, size: 15, color: Color(0xFF0284C7)),
                  const SizedBox(width: 6),
                  const Text(
                    'Được gửi từ',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0284C7),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                detail.shippingOrigin,
                style: const TextStyle(fontSize: 11.5, color: Color(0xFF334155)),
              ),
              const SizedBox(height: 2),
              RichText(
                text: TextSpan(
                  style: const TextStyle(fontSize: 11.5, color: Color(0xFF475569)),
                  children: [
                    const TextSpan(text: 'Dự kiến nhận: '),
                    TextSpan(
                      text: detail.estimatedDelivery,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

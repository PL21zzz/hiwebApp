import 'package:flutter/material.dart';
import 'package:hiweb_app_management/core/core.dart';

class CheckoutBottomBar extends StatelessWidget {
  final String totalLabel;
  final String savingsLabel;
  final bool isValid;
  final bool isSubmitting;
  final VoidCallback onPlaceOrder;

  const CheckoutBottomBar({
    super.key,
    required this.totalLabel,
    required this.savingsLabel,
    required this.isValid,
    this.isSubmitting = false,
    required this.onPlaceOrder,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        minimum: const EdgeInsets.only(bottom: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  totalLabel,
                  style: const TextStyle(
                    fontSize: 16.5,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFEF4444),
                  ),
                ),
                Text(
                  savingsLabel,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),
            PrimaryButton(
              width: 140,
              height: 42,
              text: 'ĐẶT HÀNG',
              fontSize: 13.5,
              backgroundColor:
                  isValid ? AppColors.primary : const Color(0xFFCBD5E1),
              onPressed: isValid ? onPlaceOrder : null,
              isLoading: isSubmitting,
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:hiweb_app_management/core/theme/app_colors.dart';

class PaymentMethodCard extends StatelessWidget {
  final String paymentMethod;
  final ValueChanged<String> onPaymentMethodChanged;

  const PaymentMethodCard({super.key, required this.paymentMethod, required this.onPaymentMethodChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Phương thức thanh toán', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
        const SizedBox(height: 8),
        _option('cod', LucideIcons.package, 'Thanh toán khi nhận hàng'),
        const Divider(height: 1, color: Color(0xFFF1F5F9)),
        _option('bank', LucideIcons.creditCard, 'Thanh toán chuyển khoản'),
      ]),
    );
  }

  Widget _option(String value, IconData icon, String label) {
    return InkWell(
      onTap: () => onPaymentMethodChanged(value),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(children: [
          Icon(icon, color: AppColors.primary, size: 18),
          const SizedBox(width: 10),
          Expanded(child: Text(label, style: const TextStyle(fontSize: 13, color: Color(0xFF1E293B)))),
          Radio<String>(value: value, groupValue: paymentMethod, activeColor: AppColors.primary, onChanged: (next) { if (next != null) onPaymentMethodChanged(next); }),
        ]),
      ),
    );
  }
}

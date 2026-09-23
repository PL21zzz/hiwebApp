import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../models/checkout/checkout_mock_data.dart';
import '../../theme/app_colors.dart';

class VoucherCoinsCard extends StatelessWidget {
  final bool useCoins;
  final ValueChanged<bool> onUseCoinsChanged;
  final VoidCallback? onVoucherPressed;

  const VoucherCoinsCard({super.key, required this.useCoins, required this.onUseCoinsChanged, this.onVoucherPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Column(children: [
        InkWell(
          onTap: onVoucherPressed,
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Row(children: [Icon(LucideIcons.ticket, color: AppColors.primary, size: 18), SizedBox(width: 8), Text('VietMade Voucher', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, color: Color(0xFF0F172A)))]),
            const Row(children: [
              Text(CheckoutMockData.vietMadeVoucherLabel, style: TextStyle(fontSize: 11, color: AppColors.primary)),
              SizedBox(width: 3),
              Icon(LucideIcons.chevronRight, size: 14, color: AppColors.primary),
            ]),
          ]),
        ),
        const SizedBox(height: 12),
        const Divider(height: 1, color: Color(0xFFF1F5F9)),
        const SizedBox(height: 8),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Row(children: [Icon(Icons.monetization_on, color: Color(0xFFF59E0B), size: 20), SizedBox(width: 8), Text(CheckoutMockData.coinsLabel, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF0F172A)))]),
          Switch.adaptive(value: useCoins, activeColor: AppColors.primary, onChanged: onUseCoinsChanged),
        ]),
      ]),
    );
  }
}

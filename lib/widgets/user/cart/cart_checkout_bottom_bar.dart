import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../services/user/cart_service.dart';

class CartCheckoutBottomBar extends StatelessWidget {
  final VoidCallback? onCheckoutPressed;

  const CartCheckoutBottomBar({
    super.key,
    this.onCheckoutPressed,
  });

  String _formatPrice(int value) {
    return '${value.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (match) => '${match.group(1)}.')}đ';
  }

  String _formatSavings(int value) {
    if (value >= 1000) {
      final k = (value / 1000).round();
      return 'Tiết kiệm ${k}k';
    }
    return 'Tiết kiệm $valueđ';
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: CartService.instance,
      builder: (context, _) {
        final cart = CartService.instance;
        final selectedCount = cart.totalSelectedCount;
        final isAllSelected = cart.isAllSelected;

        return Container(
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Row 1: VietMade Voucher
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                child: Row(
                  children: [
                    const Icon(LucideIcons.ticket, size: 16, color: Color(0xFF0097B2)),
                    const SizedBox(width: 8),
                    const Text(
                      'VietMade Voucher',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F9FF),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFF0284C7), width: 0.8),
                      ),
                      child: const Row(
                        children: [
                          Text(
                            'Miễn phí vận chuyển',
                            style: TextStyle(fontSize: 11, color: Color(0xFF0284C7)),
                          ),
                          SizedBox(width: 2),
                          Icon(LucideIcons.chevronRight, size: 13, color: Color(0xFF0284C7)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, color: Color(0xFFF1F5F9)),

              // Row 2: Dùng 150 VietMade Xu Switch
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                child: Row(
                  children: [
                    Container(
                      width: 22,
                      height: 22,
                      decoration: const BoxDecoration(
                        color: Color(0xFFEAB308),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        'V',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Dùng ${cart.xuBalance} VietMade Xu',
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: Color(0xFF334155),
                      ),
                    ),
                    const Spacer(),
                    Transform.scale(
                      scale: 0.8,
                      child: Switch(
                        value: cart.useXu,
                        activeColor: const Color(0xFF0097B2),
                        onChanged: (val) {
                          CartService.instance.toggleUseXu(val);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, color: Color(0xFFE2E8F0)),

              // Row 3: Bottom Calculation & THANH TOÁN Button
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 14, 12),
                child: Row(
                  children: [
                    // Checkbox Select All
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 28,
                          height: 28,
                          child: Checkbox(
                            value: isAllSelected,
                            activeColor: const Color(0xFF0097B2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            onChanged: (val) {
                              CartService.instance.toggleSelectAll(val ?? false);
                            },
                          ),
                        ),
                        const SizedBox(width: 2),
                        const Text(
                          'Tất cả',
                          style: TextStyle(
                            fontSize: 12.5,
                            color: Color(0xFF334155),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),

                    // Total & Savings Note
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          _formatPrice(cart.finalTotal),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFEF4444),
                          ),
                        ),
                        if (cart.totalSavings > 0)
                          Text(
                            _formatSavings(cart.totalSavings),
                            style: const TextStyle(
                              fontSize: 10.5,
                              color: Color(0xFF94A3B8),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(width: 12),

                    // Checkout Button (THANH TOÁN (1))
                    SizedBox(
                      height: 40,
                      child: ElevatedButton(
                        onPressed: selectedCount > 0
                            ? (onCheckoutPressed ?? () {})
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFEF4444),
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: const Color(0xFFCBD5E1),
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'THANH TOÁN ($selectedCount)',
                          style: const TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

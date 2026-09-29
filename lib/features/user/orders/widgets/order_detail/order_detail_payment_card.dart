import 'package:flutter/material.dart';
import 'package:hiweb_app_management/features/user/orders/models/order_detail_model.dart';

import 'package:hiweb_app_management/core/utils/currency_formatter.dart';

class OrderDetailPaymentCard extends StatelessWidget {
  final OrderDetailModel detail;

  const OrderDetailPaymentCard({
    super.key,
    required this.detail,
  });

  String _formatPrice(int value) {
    return CurrencyFormatter.format(value);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(14),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Thành tiền hàng',
                style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
              ),
              Text(
                _formatPrice(detail.itemsTotal),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Phí vận chuyển',
                style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
              ),
              Text(
                _formatPrice(detail.shippingFee),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(height: 1, color: Color(0xFFF1F5F9)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Tổng số tiền',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              Text(
                _formatPrice(detail.grandTotal),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFEF4444),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Thanh toán',
                style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
              ),
              Text(
                detail.paymentMethod,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

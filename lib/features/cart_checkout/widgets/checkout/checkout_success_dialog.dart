import 'package:flutter/material.dart';
import 'package:hiweb_app_management/core/theme/app_colors.dart';
import 'package:hiweb_app_management/features/cart_checkout/models/checkout_mock_data.dart';
import 'package:hiweb_app_management/features/user/orders/models/order_model.dart';

class CheckoutSuccessDialog extends StatelessWidget {
  final OrderModel order;
  final String recipientName;
  final String productName;
  final String? selectedVariant;
  final int quantity;
  final String formattedTotalPrice;
  final String fullAddress;

  const CheckoutSuccessDialog({
    super.key,
    required this.order,
    required this.recipientName,
    required this.productName,
    required this.selectedVariant,
    required this.quantity,
    required this.formattedTotalPrice,
    required this.fullAddress,
  });

  static Future<void> show(
    BuildContext context, {
    required OrderModel order,
    required String recipientName,
    required String productName,
    required String? selectedVariant,
    required int quantity,
    required String formattedTotalPrice,
    required String fullAddress,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => CheckoutSuccessDialog(
            order: order,
            recipientName: recipientName,
            productName: productName,
            selectedVariant: selectedVariant,
            quantity: quantity,
            formattedTotalPrice: formattedTotalPrice,
            fullAddress: fullAddress,
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: const Row(
        children: [
          Icon(Icons.check_circle, color: Color(0xFF10B981), size: 28),
          SizedBox(width: 8),
          Text(
            'Đặt hàng thành công!',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Cảm ơn $recipientName đã mua sắm tại VietMade.',
          ),
          const SizedBox(height: 8),
          Text(
            'Sản phẩm: $productName',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          Text(
            '${CheckoutMockData.productVariantPrefix}${selectedVariant ?? 'Chưa chọn'} | SL: $quantity',
            style: const TextStyle(color: Color(0xFF64748B)),
          ),
          Text(
            'Tổng thanh toán: $formattedTotalPrice',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFFEF4444),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Mã đơn: ${order.id}',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          Text(
            'Địa chỉ giao: $fullAddress',
            style: const TextStyle(color: Color(0xFF64748B)),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
          child: const Text(
            'VỀ TRANG CHỦ',
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

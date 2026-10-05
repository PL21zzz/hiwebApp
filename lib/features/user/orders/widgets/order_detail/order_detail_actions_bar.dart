import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:hiweb_app_management/features/user/orders/models/order_detail_model.dart';
import 'package:hiweb_app_management/features/user/orders/services/order_service.dart';
import 'package:hiweb_app_management/features/user/support/screens/support_request_screen.dart';
import 'package:hiweb_app_management/core/widgets/common/dialogs/confirm_dialog.dart';
import 'package:hiweb_app_management/core/widgets/common/dialogs/top_notification.dart';

import 'package:hiweb_app_management/features/product/screens/write_review_screen.dart';

class OrderDetailActionsBar extends StatelessWidget {
  final OrderDetailModel detail;

  const OrderDetailActionsBar({
    super.key,
    required this.detail,
  });

  void _handleSupportTap(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const SupportRequestScreen()),
    );
  }

  void _handleWriteReviewTap(BuildContext context) {
    final firstItem = detail.items.first;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => WriteReviewScreen(
          productName: firstItem.name,
          productImage: firstItem.imageUrl,
        ),
      ),
    );
  }

  void _handleCancelOrderTap(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => ConfirmDialog(
        title: 'Xác nhận hủy đơn hàng',
        message: 'Bạn có chắc chắn muốn hủy đơn hàng ${detail.orderCode} này không?',
        confirmText: 'Đồng ý hủy',
        cancelText: 'Quay lại',
        isDangerous: true,
        primaryColor: const Color(0xFFEF4444),
        onConfirm: () {
          Navigator.of(ctx).pop();
          OrderService.instance.updateOrderStatus(detail.orderCode, 'canceled');
          TopNotification.show(
            context,
            message: 'Đã hủy đơn hàng ${detail.orderCode} thành công!',
            isError: false,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 38,
              child: OutlinedButton(
                onPressed: () => _handleSupportTap(context),
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF0284C7),
                  side: const BorderSide(color: Color(0xFF38BDF8), width: 1),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      LucideIcons.headphones,
                      size: 15,
                      color: Color(0xFF0284C7),
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Hỗ trợ',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF0284C7),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: SizedBox(
              height: 38,
              child: ElevatedButton(
                onPressed: () => _handleWriteReviewTap(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0284C7),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      LucideIcons.star,
                      size: 15,
                      color: Colors.white,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Đánh giá',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: SizedBox(
              height: 38,
              child: OutlinedButton(
                onPressed: () => _handleCancelOrderTap(context),
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF475569),
                  side: const BorderSide(color: Color(0xFFCBD5E1), width: 1),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      LucideIcons.xCircle,
                      size: 15,
                      color: Color(0xFF475569),
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Hủy đơn',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF475569),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

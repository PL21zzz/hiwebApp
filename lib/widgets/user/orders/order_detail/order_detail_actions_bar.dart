import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../models/user/orders/order_detail_model.dart';
import '../../../../services/user/order_service.dart';
import '../../../../screens/user/support/support_request_screen.dart';
import '../../../common/confirm_dialog.dart';
import '../../../common/top_notification.dart';

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
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      LucideIcons.headphones,
                      size: 16,
                      color: Color(0xFF0284C7),
                    ),
                    SizedBox(width: 6),
                    Text(
                      'Hỗ trợ',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF0284C7),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
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
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      LucideIcons.xCircle,
                      size: 16,
                      color: Color(0xFF475569),
                    ),
                    SizedBox(width: 6),
                    Text(
                      'Hủy đơn',
                      style: TextStyle(
                        fontSize: 12,
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

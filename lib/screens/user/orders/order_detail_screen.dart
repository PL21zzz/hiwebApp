import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../models/user/orders/order_detail_model.dart';
import '../../../models/user/orders/order_model.dart';
import '../../../widgets/common/vietmade_header.dart';
import '../../../widgets/user/orders/order_detail/order_detail_actions_bar.dart';
import '../../../widgets/user/orders/order_detail/order_detail_payment_card.dart';
import '../../../widgets/user/orders/order_detail/order_detail_products_card.dart';
import '../../../widgets/user/orders/order_detail/order_detail_recipient_card.dart';
import '../../../widgets/user/orders/order_detail/order_detail_stepper_card.dart';

class OrderDetailScreen extends StatelessWidget {
  final OrderModel order;

  const OrderDetailScreen({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    final detail = OrderDetailMockData.getSampleOrderDetail(order);

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: const VietmadeHeader(showMenu: false),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Back to Orders bar
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(LucideIcons.chevronLeft, size: 18, color: Color(0xFF0284C7)),
                        SizedBox(width: 4),
                        Text(
                          'Quay lại đơn mua',
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF0284C7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: Color(0xFFE2E8F0)),

            // Section 1: Warning Alert & Order ID Stepper
            OrderDetailStepperCard(detail: detail),
            const SizedBox(height: 8),

            // Section 2: Recipient Info (Name, Masked Phone, Masked Address showing city)
            OrderDetailRecipientCard(detail: detail),
            const SizedBox(height: 8),

            // Section 3: Products Card
            OrderDetailProductsCard(detail: detail),
            const SizedBox(height: 8),

            // Section 4: Payment Breakdown Summary
            OrderDetailPaymentCard(detail: detail),
            const SizedBox(height: 8),

            // Section 5: Action Buttons (Support & Cancel)
            OrderDetailActionsBar(detail: detail),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

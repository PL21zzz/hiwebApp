import 'package:flutter/material.dart';
import '../../../models/user/profile_option_model.dart';
import '../../../services/user/order_service.dart';

class ProfileUserOrdersCard extends StatelessWidget {
  final ValueChanged<int>? onStatusTap;

  const ProfileUserOrdersCard({
    super.key,
    this.onStatusTap,
  });

  Widget _buildOrderStatusItem(OrderStatusOption option) {
    final tabIndex = switch (option.id) {
      'pending_pickup' => 2,
      'shipping' => 3,
      'delivering' => 4,
      'canceled' => 7,
      _ => 0,
    };

    final count = OrderService.instance.countByStatus(option.id);

    return Expanded(
      child: InkWell(
        onTap: onStatusTap == null ? null : () => onStatusTap!(tabIndex),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                SizedBox(
                  height: 38,
                  child: Center(
                    child: Image.network(
                      option.imageUrl,
                      height: 32,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.inventory_2, size: 28, color: Colors.grey),
                    ),
                  ),
                ),
                if (count > 0)
                  Positioned(
                    top: -2,
                    right: 4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                      constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEF4444),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '$count',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          height: 1,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              option.label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF334155),
                height: 1.25,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Đơn hàng của tôi',
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              InkWell(
                onTap: onStatusTap == null ? null : () => onStatusTap!(0),
                child: const Text(
                  'Tất cả đơn >',
                  style: TextStyle(
                    fontSize: 11.5,
                    color: Color(0xFF0284C7),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: ProfileMockData.orderStatuses
                .map((status) => _buildOrderStatusItem(status))
                .toList(),
          ),
        ],
      ),
    );
  }
}

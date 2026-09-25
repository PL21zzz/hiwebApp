import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:hiweb_app_management/features/user/orders/models/order_model.dart';
import 'package:hiweb_app_management/features/user/orders/screens/order_detail_screen.dart';
import 'package:hiweb_app_management/core/theme/app_colors.dart';

class OrderCard extends StatelessWidget {
  final OrderModel order;

  const OrderCard({
    super.key,
    required this.order,
  });

  String _formatPrice(int value) {
    return '${value.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (match) => '${match.group(1)}.')}đ';
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'confirmation':
      case 'pending_pickup':
        return const Color(0xFFD97706); // Amber
      case 'shipping':
      case 'delivering':
        return const Color(0xFF0284C7); // Light Blue
      case 'delivered':
        return const Color(0xFF16A34A); // Green
      case 'returned':
      case 'canceled':
        return const Color(0xFFDC2626); // Red
      default:
        return AppColors.primary;
    }
  }

  Color _getStatusBgColor(String status) {
    switch (status) {
      case 'confirmation':
      case 'pending_pickup':
        return const Color(0xFFFFFBEB);
      case 'shipping':
      case 'delivering':
        return const Color(0xFFF0F9FF);
      case 'delivered':
        return const Color(0xFFF0FDF4);
      case 'returned':
      case 'canceled':
        return const Color(0xFFFEF2F2);
      default:
        return const Color(0xFFECFEFF);
    }
  }

  @override
  Widget build(BuildContext context) {
    final item = order.items.first;
    final statusColor = _getStatusColor(order.status);
    final statusBgColor = _getStatusBgColor(order.status);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Shop Name & Status Tag
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
            child: Row(
              children: [
                const Icon(
                  LucideIcons.store,
                  size: 16,
                  color: Color(0xFF475569),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.shopName,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        order.createdAt,
                        style: const TextStyle(
                          fontSize: 10,
                          color: Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusBgColor,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: statusColor.withValues(alpha: 0.3), width: 0.8),
                  ),
                  child: Text(
                    order.statusLabel,
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),

          // Product Details
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFE2E8F0), width: 0.8),
                  ),
                  alignment: Alignment.center,
                  child: item.imageUrl.startsWith('http')
                      ? Image.network(
                        item.imageUrl,
                        width: 52,
                        height: 52,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => const Icon(
                          LucideIcons.package,
                          size: 28,
                          color: Color(0xFFCBD5E1),
                        ),
                      )
                      : Image.asset(
                        item.imageUrl,
                        width: 52,
                        height: 52,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => const Icon(
                          LucideIcons.package,
                          size: 28,
                          color: Color(0xFFCBD5E1),
                        ),
                      ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12.5,
                          height: 1.35,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF334155),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'x${item.quantity}',
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF94A3B8),
                            ),
                          ),
                          Text(
                            _formatPrice(item.price),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Total Price summary
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            color: const Color(0xFFF8FAFC),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Thành tiền (${order.items.fold(0, (sum, i) => sum + i.quantity)} sản phẩm): ',
                  style: const TextStyle(fontSize: 11.5, color: Color(0xFF64748B)),
                ),
                Text(
                  _formatPrice(order.total),
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFEF4444),
                  ),
                ),
              ],
            ),
          ),

          // Shipping / Timeline Info
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(LucideIcons.clock, size: 13, color: AppColors.primary),
                    const SizedBox(width: 6),
                    const Text(
                      'Thời gian đặt hàng: 1 phút trước',
                      style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(LucideIcons.mapPin, size: 13, color: AppColors.primary),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'Được gửi tới: ${order.recipient} - ${order.address}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),

          // Actions Row
          InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => OrderDetailScreen(order: order),
                ),
              );
            },
            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Xem chi tiết đơn hàng',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                  Icon(LucideIcons.chevronRight, size: 16, color: AppColors.primary),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

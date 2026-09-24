import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:hiweb_app_management/features/notification/models/notification_model.dart';
import 'package:hiweb_app_management/core/theme/app_colors.dart';
import 'package:hiweb_app_management/core/widgets/common/layout/category_drawer.dart';
import 'package:hiweb_app_management/core/widgets/common/layout/vietmade_header.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const VietmadeHeader(),
      drawer: const CategoryDrawer(),
      body: Column(
        children: [
          _NotificationFilters(),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.only(top: 6, bottom: 90),
              itemCount: NotificationMockData.items.length,
              separatorBuilder: (_, __) => const Divider(height: 1, color: Color(0xFFE2E8F0)),
              itemBuilder: (context, index) => _NotificationTile(
                notification: NotificationMockData.items[index],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationFilters extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Row(
        children: const [
          _FilterChip(icon: LucideIcons.shoppingBag, label: 'Đơn hàng', color: Color(0xFF0284C7)),
          SizedBox(width: 8),
          _FilterChip(icon: LucideIcons.ticket, label: 'Khuyến mãi', color: Color(0xFF16A34A)),
          SizedBox(width: 8),
          _FilterChip(icon: LucideIcons.refreshCw, label: 'Cập nhật', color: Color(0xFFEF4444)),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _FilterChip({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 30,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 5),
            Text(label, style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600, color: color)),
          ],
        ),
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final NotificationModel notification;

  const _NotificationTile({required this.notification});

  IconData get _icon {
    switch (notification.type) {
      case NotificationType.promotion:
        return LucideIcons.gift;
      case NotificationType.voucher:
        return LucideIcons.flame;
      case NotificationType.sale:
        return LucideIcons.badgePercent;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: notification.isRead ? Colors.white : const Color(0xFFFAFDFF),
      padding: const EdgeInsets.fromLTRB(10, 10, 12, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(7),
            child: Image.network(
              notification.imageUrl,
              width: 54,
              height: 54,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 54,
                height: 54,
                color: const Color(0xFFE2E8F0),
                child: Icon(_icon, color: AppColors.primary),
              ),
            ),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(_icon, size: 13, color: const Color(0xFFEF4444)),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        notification.title,
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                      ),
                    ),
                    const Icon(LucideIcons.chevronRight, size: 15, color: Color(0xFFCBD5E1)),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  notification.message,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 10.5, color: Color(0xFF475569), height: 1.25),
                ),
                const SizedBox(height: 4),
                Text(notification.timeLabel, style: const TextStyle(fontSize: 9.5, color: Color(0xFFCBD5E1))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

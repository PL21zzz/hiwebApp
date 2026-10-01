import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:hiweb_app_management/features/notification/models/notification_model.dart';
import 'package:hiweb_app_management/core/theme/app_colors.dart';
import 'package:hiweb_app_management/core/widgets/common/layout/category_drawer.dart';
import 'package:hiweb_app_management/core/widgets/common/layout/vietmade_header.dart';

import 'package:hiweb_app_management/core/widgets/common/loading/skeletons.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  NotificationCategory _selectedCategory = NotificationCategory.order;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _simulateLoading();
  }

  Future<void> _simulateLoading() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 450));
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final notifications = NotificationMockData.getByCategory(_selectedCategory);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const VietmadeHeader(),
      drawer: const CategoryDrawer(),
      body: Column(
        children: [
          // Header Tab Filters
          _NotificationFilters(
            selectedCategory: _selectedCategory,
            onCategorySelected: (category) {
              setState(() {
                _selectedCategory = category;
              });
            },
          ),

          // Notifications List
          Expanded(
            child: _isLoading
                ? const NotificationSkeleton()
                : notifications.isEmpty
                ? const Center(
                    child: Text(
                      'Không có thông báo nào',
                      style: TextStyle(color: Color(0xFF64748B), fontSize: 13),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.only(top: 6, bottom: 90),
                    itemCount: notifications.length,
                    separatorBuilder: (_, __) =>
                        const Divider(height: 1, color: Color(0xFFE2E8F0)),
                    itemBuilder: (context, index) => _NotificationTile(
                      notification: notifications[index],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _NotificationFilters extends StatelessWidget {
  final NotificationCategory selectedCategory;
  final ValueChanged<NotificationCategory> onCategorySelected;

  const _NotificationFilters({
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    final orderCount =
        NotificationMockData.getByCategory(NotificationCategory.order).length;
    final promoCount =
        NotificationMockData.getByCategory(NotificationCategory.promotion).length;
    final updateCount =
        NotificationMockData.getByCategory(NotificationCategory.update).length;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Row(
        children: [
          _FilterTabChip(
            icon: LucideIcons.packageCheck,
            label: 'Đơn hàng',
            count: orderCount,
            isSelected: selectedCategory == NotificationCategory.order,
            color: const Color(0xFF0284C7),
            onTap: () => onCategorySelected(NotificationCategory.order),
          ),
          const SizedBox(width: 8),
          _FilterTabChip(
            icon: LucideIcons.ticket,
            label: 'Khuyến mãi',
            count: promoCount,
            isSelected: selectedCategory == NotificationCategory.promotion,
            color: const Color(0xFF16A34A),
            onTap: () => onCategorySelected(NotificationCategory.promotion),
          ),
          const SizedBox(width: 8),
          _FilterTabChip(
            icon: LucideIcons.bellRing,
            label: 'Cập nhật',
            count: updateCount,
            isSelected: selectedCategory == NotificationCategory.update,
            color: const Color(0xFFEF4444),
            onTap: () => onCategorySelected(NotificationCategory.update),
          ),
        ],
      ),
    );
  }
}

class _FilterTabChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final int count;
  final bool isSelected;
  final Color color;
  final VoidCallback onTap;

  const _FilterTabChip({
    required this.icon,
    required this.label,
    required this.count,
    required this.isSelected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final activeBg = color;
    final activeTextColor = Colors.white;
    final inactiveBg = color.withValues(alpha: 0.06);
    final inactiveTextColor = color;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          height: 34,
          padding: const EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(
            color: isSelected ? activeBg : inactiveBg,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? color : color.withValues(alpha: 0.2),
              width: isSelected ? 1.5 : 1.0,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 14,
                color: isSelected ? activeTextColor : inactiveTextColor,
              ),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                    color: isSelected ? activeTextColor : inactiveTextColor,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.white.withValues(alpha: 0.25)
                      : color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$count',
                  style: TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? activeTextColor : inactiveTextColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final NotificationModel notification;

  const _NotificationTile({required this.notification});

  IconData get _icon {
    switch (notification.category) {
      case NotificationCategory.order:
        return LucideIcons.packageCheck;
      case NotificationCategory.promotion:
        return LucideIcons.ticket;
      case NotificationCategory.update:
        return LucideIcons.bellRing;
    }
  }

  Color get _iconColor {
    switch (notification.category) {
      case NotificationCategory.order:
        return const Color(0xFF0284C7);
      case NotificationCategory.promotion:
        return const Color(0xFF16A34A);
      case NotificationCategory.update:
        return const Color(0xFFEF4444);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: notification.isRead ? Colors.white : const Color(0xFFF8FAFC),
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon Avatar / Image
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: _iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              _icon,
              size: 22,
              color: _iconColor,
            ),
          ),
          const SizedBox(width: 12),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        notification.title,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: notification.isRead
                              ? FontWeight.w600
                              : FontWeight.bold,
                          color: const Color(0xFF1E293B),
                        ),
                      ),
                    ),
                    if (!notification.isRead)
                      Container(
                        width: 7,
                        height: 7,
                        margin: const EdgeInsets.only(left: 6),
                        decoration: const BoxDecoration(
                          color: Color(0xFFEF4444),
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  notification.message,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF64748B),
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  notification.timeLabel,
                  style: const TextStyle(
                    fontSize: 10.5,
                    color: Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

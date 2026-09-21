import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class OrderStatusOption {
  final String id;
  final String label;
  final String imageUrl;
  final int badgeCount;

  const OrderStatusOption({
    required this.id,
    required this.label,
    required this.imageUrl,
    this.badgeCount = 0,
  });
}

class QuickActionOption {
  final String id;
  final String label;
  final IconData icon;

  const QuickActionOption({
    required this.id,
    required this.label,
    required this.icon,
  });
}

class ToolServiceOption {
  final String id;
  final String label;
  final IconData icon;

  const ToolServiceOption({
    required this.id,
    required this.label,
    required this.icon,
  });
}

class ProfileMockData {
  static const String orderIconPending =
      'https://res.cloudinary.com/dypm5avrx/image/upload/v1789957346/icon_cholayhang_hrrci0.webp';
  static const String orderIconShipping =
      'https://res.cloudinary.com/dypm5avrx/image/upload/v1789957346/icon_dangvanchuyen_ptak0o.webp';
  static const String orderIconDelivering =
      'https://res.cloudinary.com/dypm5avrx/image/upload/v1789957346/icon_danggiao_vz8fcq.webp';
  static const String orderIconCanceled =
      'https://res.cloudinary.com/dypm5avrx/image/upload/v1789957346/icon_dahuydatra_qiuzdo.webp';

  static const List<OrderStatusOption> orderStatuses = [
    OrderStatusOption(
      id: 'pending',
      label: 'Chờ lấy hàng',
      imageUrl: orderIconPending,
    ),
    OrderStatusOption(
      id: 'shipping',
      label: 'Đang vận\nchuyển',
      imageUrl: orderIconShipping,
    ),
    OrderStatusOption(
      id: 'delivering',
      label: 'Đang giao',
      imageUrl: orderIconDelivering,
    ),
    OrderStatusOption(
      id: 'canceled',
      label: 'Đã hủy / Trả lại',
      imageUrl: orderIconCanceled,
    ),
  ];

  static const List<QuickActionOption> quickActions = [
    QuickActionOption(
      id: 'purchased',
      label: 'Sản phẩm đã\nmua',
      icon: LucideIcons.package,
    ),
    QuickActionOption(
      id: 'viewed',
      label: 'Sản phẩm đã\nxem',
      icon: LucideIcons.eye,
    ),
    QuickActionOption(
      id: 'favorites',
      label: 'Sản phẩm yêu\nthích',
      icon: LucideIcons.heart,
    ),
    QuickActionOption(
      id: 'buy_later',
      label: 'Sản phẩm mua\nsau',
      icon: LucideIcons.bookmark,
    ),
  ];

  static const List<ToolServiceOption> toolServices = [
    ToolServiceOption(
      id: 'my_shop',
      label: 'Shop của tôi',
      icon: LucideIcons.store,
    ),
    ToolServiceOption(
      id: 'sync_store',
      label: 'Đồng bộ gian\nhàng',
      icon: LucideIcons.refreshCw,
    ),
    ToolServiceOption(
      id: 'creators',
      label: 'Người sáng tạo',
      icon: LucideIcons.video,
    ),
    ToolServiceOption(
      id: 'voucher_wallet',
      label: 'Kho voucher',
      icon: LucideIcons.tag,
    ),
    ToolServiceOption(
      id: 'review_history',
      label: 'Lịch sử đánh\ngiá',
      icon: LucideIcons.star,
    ),
    ToolServiceOption(
      id: 'referral',
      label: 'Giới thiệu nhận\nquà',
      icon: LucideIcons.gift,
    ),
    ToolServiceOption(
      id: 'blogs',
      label: 'Blogs VietMade',
      icon: LucideIcons.newspaper,
    ),
    ToolServiceOption(
      id: 'support',
      label: 'Yêu cầu hỗ trợ\ncủa tôi',
      icon: LucideIcons.helpCircle,
    ),
    ToolServiceOption(
      id: 'feedback',
      label: 'Gửi feedback',
      icon: LucideIcons.messageSquare,
    ),
    ToolServiceOption(
      id: 'app_rate',
      label: 'Đánh giá ứng\ndụng',
      icon: LucideIcons.star,
    ),
  ];
}

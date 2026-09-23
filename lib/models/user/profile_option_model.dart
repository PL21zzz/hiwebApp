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
  final String imageAsset;

  const QuickActionOption({
    required this.id,
    required this.label,
    required this.icon,
    required this.imageAsset,
  });
}

class ToolServiceOption {
  final String id;
  final String label;
  final IconData icon;
  final String imageAsset;

  const ToolServiceOption({
    required this.id,
    required this.label,
    required this.icon,
    required this.imageAsset,
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
      id: 'pending_pickup',
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
      imageAsset: 'assets/images/spdamua.webp',
    ),
    QuickActionOption(
      id: 'viewed',
      label: 'Sản phẩm đã\nxem',
      icon: LucideIcons.eye,
      imageAsset: 'assets/images/spdaxem.webp',
    ),
    QuickActionOption(
      id: 'favorites',
      label: 'Sản phẩm yêu\nthích',
      icon: LucideIcons.heart,
      imageAsset: 'assets/images/spyeuthich.webp',
    ),
    QuickActionOption(
      id: 'buy_later',
      label: 'Sản phẩm mua\nsau',
      icon: LucideIcons.bookmark,
      imageAsset: 'assets/images/spmuasau.webp',
    ),
  ];

  static const List<ToolServiceOption> toolServices = [
    ToolServiceOption(
      id: 'my_shop',
      label: 'Shop của tôi',
      icon: LucideIcons.store,
      imageAsset: 'assets/images/shopcuatoi.webp',
    ),
    ToolServiceOption(
      id: 'sync_store',
      label: 'Đồng bộ gian\nhàng',
      icon: LucideIcons.refreshCw,
      imageAsset: 'assets/images/dongbogianhang.webp',
    ),
    ToolServiceOption(
      id: 'creators',
      label: 'Người sáng tạo',
      icon: LucideIcons.video,
      imageAsset: 'assets/images/nguoisangtao.webp',
    ),
    ToolServiceOption(
      id: 'voucher_wallet',
      label: 'Kho voucher',
      icon: LucideIcons.tag,
      imageAsset: 'assets/images/khovoucher.webp',
    ),
    ToolServiceOption(
      id: 'review_history',
      label: 'Lịch sử đánh\ngiá',
      icon: LucideIcons.star,
      imageAsset: 'assets/images/lichsudanhgia.webp',
    ),
    ToolServiceOption(
      id: 'referral',
      label: 'Giới thiệu nhận\nquà',
      icon: LucideIcons.gift,
      imageAsset: 'assets/images/gioithieunhanqua.webp',
    ),
    ToolServiceOption(
      id: 'blogs',
      label: 'Blogs VietMade',
      icon: LucideIcons.newspaper,
      imageAsset: 'assets/images/blogsVietMade.webp',
    ),
    ToolServiceOption(
      id: 'support',
      label: 'Yêu cầu hỗ trợ\ncủa tôi',
      icon: LucideIcons.helpCircle,
      imageAsset: 'assets/images/yeucauhotro.webp',
    ),
    ToolServiceOption(
      id: 'feedback',
      label: 'Gửi feedback',
      icon: LucideIcons.messageSquare,
      imageAsset: 'assets/images/guifeedback.webp',
    ),
    ToolServiceOption(
      id: 'app_rate',
      label: 'Đánh giá ứng\ndụng',
      icon: LucideIcons.star,
      imageAsset: 'assets/images/danhgiaungdung.webp',
    ),
  ];
}

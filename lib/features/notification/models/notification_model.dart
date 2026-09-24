class NotificationModel {
  final String id;
  final String title;
  final String message;
  final String timeLabel;
  final String imageUrl;
  final NotificationType type;
  final bool isRead;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.timeLabel,
    required this.imageUrl,
    required this.type,
    this.isRead = false,
  });
}

enum NotificationType { promotion, voucher, sale }

class NotificationMockData {
  static const List<NotificationModel> items = [
    NotificationModel(
      id: 'promotion_1',
      title: 'Giá sản phẩm đang giảm mạnh',
      message: 'Nhiều sản phẩm bạn quan tâm đang có ưu đãi mới. Mở app để xem giá hôm nay!',
      timeLabel: '1 giờ trước',
      imageUrl: 'https://res.cloudinary.com/dypm5avrx/image/upload/v1789549363/flash-sale1_wbuuhi.webp',
      type: NotificationType.promotion,
    ),
    NotificationModel(
      id: 'voucher_1',
      title: 'Voucher của bạn vừa tăng lên 10%',
      message: 'Voucher mới đã được cập nhật. Giảm tối đa 80.000đ cho đơn đủ điều kiện. Nhận ngay kẻo hết hạn!',
      timeLabel: '16 giờ trước',
      imageUrl: 'https://res.cloudinary.com/dypm5avrx/image/upload/v1789549364/flash-sale2_fvgamt.webp',
      type: NotificationType.voucher,
    ),
    NotificationModel(
      id: 'sale_1',
      title: 'Deal đồng giá 15K mới đã lên',
      message: 'Phụ kiện, đồ dùng nhỏ và quà tặng đang có thêm nhiều mẫu mới trong hôm nay.',
      timeLabel: '19 giờ trước',
      imageUrl: 'https://res.cloudinary.com/dypm5avrx/image/upload/v1789549364/video1_dqeu7c.webp',
      type: NotificationType.sale,
    ),
  ];
}

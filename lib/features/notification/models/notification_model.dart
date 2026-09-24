enum NotificationCategory { order, promotion, update }

class NotificationModel {
  final String id;
  final String title;
  final String message;
  final String timeLabel;
  final String imageUrl;
  final NotificationCategory category;
  final bool isRead;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.timeLabel,
    required this.imageUrl,
    required this.category,
    this.isRead = false,
  });
}

class NotificationMockData {
  static const List<NotificationModel> items = [
    // --- 3 Thông báo Đơn hàng ---
    NotificationModel(
      id: 'order_1',
      title: 'Đơn hàng DH-20260908-01 đã được xác nhận',
      message: 'Shop nhathuocsuckhoe2 đang chuẩn bị hàng và sẽ giao cho đơn vị vận chuyển sớm nhất.',
      timeLabel: '10 phút trước',
      imageUrl: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=500',
      category: NotificationCategory.order,
      isRead: false,
    ),
    NotificationModel(
      id: 'order_2',
      title: 'Đơn hàng đang trên đường giao',
      message: 'Tài xế đang vận chuyển đơn hàng đến địa chỉ của bạn. Vui lòng chú ý điện thoại.',
      timeLabel: '2 giờ trước',
      imageUrl: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=500',
      category: NotificationCategory.order,
      isRead: false,
    ),
    NotificationModel(
      id: 'order_3',
      title: 'Đơn hàng đã giao thành công',
      message: 'Cảm ơn bạn đã mua sắm tại VietMade. Đánh giá sản phẩm ngay để nhận 200 Xu thưởng!',
      timeLabel: '1 ngày trước',
      imageUrl: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=500',
      category: NotificationCategory.order,
      isRead: true,
    ),

    // --- 1 Thông báo Khuyến mãi ---
    NotificationModel(
      id: 'promo_1',
      title: 'Voucher giảm 50% toàn sàn VietMade',
      message: 'Mã giảm giá cực sốc dành riêng cho bạn hôm nay. Mở app nhận ngay kẻo hết lượt!',
      timeLabel: '3 giờ trước',
      imageUrl: 'https://images.unsplash.com/photo-1607082348824-0a96f2a4b9da?w=500',
      category: NotificationCategory.promotion,
      isRead: false,
    ),

    // --- 2 Thông báo Cập nhật ---
    NotificationModel(
      id: 'update_1',
      title: 'Cập nhật ứng dụng phiên bản 2.1.0',
      message: 'Trải nghiệm giao diện mua sắm mượt mà hơn và nhiều tính năng video cực hot.',
      timeLabel: '5 giờ trước',
      imageUrl: 'https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?w=500',
      category: NotificationCategory.update,
      isRead: false,
    ),
    NotificationModel(
      id: 'update_2',
      title: 'Hệ thống bảo trì thanh toán hoàn tất',
      message: 'Tính năng thanh toán Ví điện tử và Ngân hàng đã hoạt động bình thường trở lại.',
      timeLabel: '2 ngày trước',
      imageUrl: 'https://images.unsplash.com/photo-1563986768609-322da13575f3?w=500',
      category: NotificationCategory.update,
      isRead: true,
    ),
  ];

  static List<NotificationModel> getByCategory(NotificationCategory category) {
    return items.where((item) => item.category == category).toList();
  }
}

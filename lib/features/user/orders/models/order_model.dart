class OrderItemModel {
  final String name;
  final String imageUrl;
  final int quantity;
  final int price;

  const OrderItemModel({
    required this.name,
    required this.imageUrl,
    required this.quantity,
    required this.price,
  });
}

class OrderStatusHelper {
  static String getLabel(String status) {
    switch (status) {
      case 'confirmation':
        return 'CHỜ XÁC NHẬN';
      case 'pending_pickup':
        return 'CHỜ LẤY HÀNG';
      case 'shipping':
        return 'ĐANG VẬN CHUYỂN';
      case 'delivering':
        return 'ĐANG GIAO';
      case 'delivered':
        return 'ĐÃ GIAO THÀNH CÔNG';
      case 'returned':
        return 'TRẢ HÀNG / HOÀN TIỀN';
      case 'canceled':
        return 'ĐÃ HỦY';
      default:
        return 'TẤT CẢ';
    }
  }
}

class OrderModel {
  final String id;
  final String shopName;
  final String createdAt;
  final String status;
  final String statusLabel;
  final String recipient;
  final String address;
  final int total;
  final List<OrderItemModel> items;

  const OrderModel({
    required this.id,
    required this.shopName,
    required this.createdAt,
    required this.status,
    required this.statusLabel,
    required this.recipient,
    required this.address,
    required this.total,
    required this.items,
  });

  OrderModel copyWith({
    String? id,
    String? shopName,
    String? createdAt,
    String? status,
    String? statusLabel,
    String? recipient,
    String? address,
    int? total,
    List<OrderItemModel>? items,
  }) {
    final nextStatus = status ?? this.status;
    return OrderModel(
      id: id ?? this.id,
      shopName: shopName ?? this.shopName,
      createdAt: createdAt ?? this.createdAt,
      status: nextStatus,
      statusLabel: statusLabel ?? OrderStatusHelper.getLabel(nextStatus),
      recipient: recipient ?? this.recipient,
      address: address ?? this.address,
      total: total ?? this.total,
      items: items ?? this.items,
    );
  }
}

class OrderMockData {
  static const List<OrderModel> orders = [
    OrderModel(
      id: 'DH-20260908-01',
      shopName: 'nhathuocsuckhoe2',
      createdAt: '08/09/2026 09:43',
      status: 'pending_pickup',
      statusLabel: 'CHỜ LẤY HÀNG',
      recipient: 'Thanh Xuân',
      address: 'TP. Hà Nội',
      total: 80000,
      items: [
        OrderItemModel(
          name: '[Nhập khẩu] Nước Uống Hỗ Trợ Giải Rượu Condition CJ Hàn Quốc 75ml - Giảm Đau Đầu, Giải Độc Gan, Tỉnh Táo',
          imageUrl: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=500',
          quantity: 1,
          price: 49000,
        ),
      ],
    ),
    OrderModel(
      id: 'DH-20260905-02',
      shopName: 'vietmade_official',
      createdAt: '05/09/2026 14:20',
      status: 'shipping',
      statusLabel: 'ĐANG VẬN CHUYỂN',
      recipient: 'Cầu Giấy',
      address: 'TP. Hà Nội',
      total: 245000,
      items: [
        OrderItemModel(
          name: 'Áo Phông Nam Nữ Unisex Chất Liệu Cotton 100% Co Giãn 4 Chiều Thoáng Mát',
          imageUrl: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=500',
          quantity: 2,
          price: 120000,
        ),
      ],
    ),
    OrderModel(
      id: 'DH-20260901-03',
      shopName: 'nongsantravinh',
      createdAt: '01/09/2026 10:15',
      status: 'delivered',
      statusLabel: 'ĐÃ GIAO THÀNH CÔNG',
      recipient: 'Quận 1',
      address: 'TP. Hồ Chí Minh',
      total: 150000,
      items: [
        OrderItemModel(
          name: 'Trà Sâm Đứa Đặc Sản Miền Tây Hộp 500g',
          imageUrl: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=500',
          quantity: 1,
          price: 150000,
        ),
      ],
    ),
  ];
}

import 'order_model.dart';

class OrderDetailModel {
  final String orderCode;
  final String status;
  final String statusLabel;
  final String warningAlert;
  final String shippingOrigin;
  final String estimatedDelivery;
  final String recipientName;
  final String recipientPhone;
  final String recipientAddress;
  final String orderPlacedTime;
  final String shopName;
  final List<OrderItemModel> items;
  final String productSku;
  final int itemsTotal;
  final int shippingFee;
  final int grandTotal;
  final String paymentMethod;
  final int currentStepIndex;

  const OrderDetailModel({
    required this.orderCode,
    required this.status,
    required this.statusLabel,
    this.warningAlert = 'TUYỆT ĐỐI không chuyển khoản trước qua cuộc gọi giao hàng với bất kỳ lý do gì.',
    required this.shippingOrigin,
    required this.estimatedDelivery,
    required this.recipientName,
    required this.recipientPhone,
    required this.recipientAddress,
    required this.orderPlacedTime,
    required this.shopName,
    required this.items,
    this.productSku = 'Mã: P01480201',
    required this.itemsTotal,
    required this.shippingFee,
    required this.grandTotal,
    this.paymentMethod = 'Tiền mặt khi nhận hàng',
    this.currentStepIndex = 1,
  });

  /// Masks phone number keeping first 2 and last 3 digits e.g. 09******168
  String get maskedPhone {
    if (recipientPhone.length < 6) return recipientPhone;
    final start = recipientPhone.substring(0, 2);
    final end = recipientPhone.substring(recipientPhone.length - 3);
    return '$start******$end';
  }

  /// Masks street details keeping city/province at the end e.g. 168 Bích Khê**************, Đà Nẵng
  String get maskedAddress {
    final parts = recipientAddress.split(',');
    if (parts.isNotEmpty) {
      final city = parts.last.trim();
      return '168 Bích Khê**************, $city';
    }
    return recipientAddress;
  }
}

class OrderDetailMockData {
  static OrderDetailModel getSampleOrderDetail(OrderModel order) {
    return OrderDetailModel(
      orderCode: 'RS540174712',
      status: order.status,
      statusLabel: order.statusLabel == 'CHỜ LẤY HÀNG' ? 'ĐANG XỬ LÝ' : order.statusLabel,
      shippingOrigin: 'Q.Thanh Xuân - TP. Hà Nội',
      estimatedDelivery: '10/09 - 11/09',
      recipientName: 'Trung Nguyễn Hồ Sơn',
      recipientPhone: '0912345168',
      recipientAddress: '168 Bích Khê, Phường Hòa Xuân, Quận Cẩm Lệ, Đà Nẵng',
      orderPlacedTime: '${order.createdAt} - 09:09:16',
      shopName: order.shopName,
      items: order.items,
      productSku: 'Mã: P01480201',
      itemsTotal: 49000,
      shippingFee: 31000,
      grandTotal: order.total,
      paymentMethod: 'Tiền mặt khi nhận hàng',
      currentStepIndex: 1,
    );
  }
}

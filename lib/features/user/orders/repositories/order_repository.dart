import 'package:hiweb_app_management/features/user/orders/models/order_model.dart';

abstract class OrderRepository {
  List<OrderModel> getOrders();
  void addOrder(OrderModel order);
  void updateOrderStatus(String orderId, String status);
}

class MockOrderRepository implements OrderRepository {
  final List<OrderModel> _orders = List<OrderModel>.from(OrderMockData.orders);

  @override
  List<OrderModel> getOrders() => List.unmodifiable(_orders);

  @override
  void addOrder(OrderModel order) => _orders.insert(0, order);

  @override
  void updateOrderStatus(String orderId, String status) {
    final index = _orders.indexWhere((order) => order.id == orderId);
    if (index == -1) return;
    _orders[index] = _orders[index].copyWith(
      status: status,
      statusLabel: OrderStatusHelper.getLabel(status),
    );
  }
}

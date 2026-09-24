import 'package:flutter/foundation.dart';
import 'package:hiweb_app_management/core/state/async_state.dart';
import 'package:hiweb_app_management/features/user/orders/models/order_model.dart';
import 'package:hiweb_app_management/features/user/orders/repositories/order_repository.dart';

class OrderService extends ChangeNotifier {
  OrderService._(this._repository)
      : _orders = _repository.getOrders().toList();

  static final OrderService instance = OrderService._(MockOrderRepository());

  final OrderRepository _repository;
  final List<OrderModel> _orders;

  List<OrderModel> get orders => List.unmodifiable(_orders);
  AsyncState<List<OrderModel>> get state => AsyncState.success(orders);

  int countByStatus(String status) {
    return _orders.where((order) => order.status == status).length;
  }

  void addOrder(OrderModel order) {
    _repository.addOrder(order);
    _orders.insert(0, order);
    notifyListeners();
  }

  void updateOrderStatus(String orderId, String newStatus) {
    final index = _orders.indexWhere((order) => order.id == orderId);
    if (index == -1) return;
    _repository.updateOrderStatus(orderId, newStatus);
    _orders[index] = _orders[index].copyWith(
      status: newStatus,
      statusLabel: OrderStatusHelper.getLabel(newStatus),
    );
    notifyListeners();
  }

  OrderModel createOrder({
    required String shopName,
    required String recipient,
    required String address,
    required int total,
    required List<OrderItemModel> items,
    String status = 'confirmation',
  }) {
    final now = DateTime.now();
    final formattedDate =
        '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    final orderId =
        'DH-${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}-${(_orders.length + 1).toString().padLeft(2, '0')}';

    final order = OrderModel(
      id: orderId,
      shopName: shopName,
      createdAt: formattedDate,
      status: status,
      statusLabel: OrderStatusHelper.getLabel(status),
      recipient: recipient,
      address: address,
      total: total,
      items: items,
    );

    addOrder(order);
    return order;
  }

  List<OrderModel> filterByStatus(String? status) {
    if (status == null || status == 'all') return orders;
    return _orders.where((order) => order.status == status).toList();
  }
}

import 'dart:async';
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
  final Map<String, Timer> _progressionTimers = {};

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

  /// Lên lịch tự động chuyển trạng thái đơn hàng (Mô phỏng thực tế):
  /// - Chờ xác nhận (confirmation) -> Sau 5 phút -> Chờ lấy hàng (pending_pickup)
  /// - Chờ lấy hàng (pending_pickup) -> Sau 1 ngày -> Đang vận chuyển (shipping)
  /// - Đang vận chuyển (shipping) -> Sau 1 ngày -> Đang giao (delivering)
  /// - Đang giao (delivering) -> Sau 1 ngày -> Đã giao thành công (delivered)
  void scheduleStatusProgression(String orderId, {String? currentStatus}) {
    _progressionTimers[orderId]?.cancel();

    final orderIndex = _orders.indexWhere((o) => o.id == orderId);
    if (orderIndex == -1) return;
    final status = currentStatus ?? _orders[orderIndex].status;

    Duration delay;
    String? nextStatus;

    switch (status) {
      case 'confirmation':
        delay = const Duration(minutes: 5);
        nextStatus = 'pending_pickup';
        break;
      case 'pending_pickup':
        delay = const Duration(days: 1);
        nextStatus = 'shipping';
        break;
      case 'shipping':
        delay = const Duration(days: 1);
        nextStatus = 'delivering';
        break;
      case 'delivering':
        delay = const Duration(days: 1);
        nextStatus = 'delivered';
        break;
      default:
        return;
    }

    _progressionTimers[orderId] = Timer(delay, () {
      if (nextStatus != null) {
        updateOrderStatus(orderId, nextStatus);
        scheduleStatusProgression(orderId, currentStatus: nextStatus);
      }
    });
  }

  /// Chuyển ngay đơn hàng sang trạng thái tiếp theo (dành cho Demo/Test nhanh)
  void advanceOrderNextStatus(String orderId) {
    final orderIndex = _orders.indexWhere((o) => o.id == orderId);
    if (orderIndex == -1) return;
    final currentStatus = _orders[orderIndex].status;

    String? nextStatus;
    switch (currentStatus) {
      case 'confirmation':
        nextStatus = 'pending_pickup';
        break;
      case 'pending_pickup':
        nextStatus = 'shipping';
        break;
      case 'shipping':
        nextStatus = 'delivering';
        break;
      case 'delivering':
        nextStatus = 'delivered';
        break;
    }

    if (nextStatus != null) {
      updateOrderStatus(orderId, nextStatus);
      scheduleStatusProgression(orderId, currentStatus: nextStatus);
    }
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

    // Kích hoạt mô phỏng tiến trình trạng thái đơn hàng tự động
    scheduleStatusProgression(orderId, currentStatus: status);

    return order;
  }

  List<OrderModel> filterByStatus(String? status) {
    if (status == null || status == 'all') return orders;
    return _orders.where((order) => order.status == status).toList();
  }

  @override
  void dispose() {
    for (final timer in _progressionTimers.values) {
      timer.cancel();
    }
    _progressionTimers.clear();
    super.dispose();
  }
}

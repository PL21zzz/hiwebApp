import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:hiweb_app_management/features/user/orders/models/order_model.dart';
import 'package:hiweb_app_management/features/user/orders/services/order_service.dart';
import 'package:hiweb_app_management/features/user/orders/widgets/order_card.dart';
import 'package:hiweb_app_management/features/user/orders/widgets/order_empty_state.dart';
import 'package:hiweb_app_management/features/user/orders/widgets/order_status_tabs.dart';
import 'package:hiweb_app_management/features/home/screens/home_screen.dart';

class OrdersScreen extends StatefulWidget {
  final int initialTabIndex;

  const OrdersScreen({
    super.key,
    this.initialTabIndex = 0,
  });

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  static const List<String> _statusIds = [
    'all',
    'confirmation',
    'pending_pickup',
    'shipping',
    'delivering',
    'delivered',
    'returned',
    'canceled',
  ];

  static const List<String> _statusLabels = [
    'Tất cả',
    'Chờ xác nhận',
    'Chờ lấy hàng',
    'Đang vận chuyển',
    'Đang giao',
    'Đã giao',
    'Trả hàng',
    'Đã hủy',
  ];

  late int _selectedTabIndex;

  @override
  void initState() {
    super.initState();
    _selectedTabIndex = widget.initialTabIndex.clamp(0, _statusIds.length - 1);
    OrderService.instance.addListener(_handleOrdersChanged);
  }

  void _handleOrdersChanged() {
    if (mounted) setState(() {});
  }

  List<OrderStatusTab> _buildTabs() {
    final orderService = OrderService.instance;

    return List.generate(_statusIds.length, (index) {
      final count = index == 0
          ? orderService.orders.length
          : orderService.countByStatus(_statusIds[index]);
      return OrderStatusTab(
        id: _statusIds[index],
        label: _statusLabels[index],
        count: count,
      );
    });
  }

  List<OrderModel> _ordersForTab() {
    final status = _statusIds[_selectedTabIndex];
    final orders = OrderService.instance.state.data ?? const <OrderModel>[];
    return status == 'all'
      ? orders
        : OrderService.instance.filterByStatus(status);
  }

  void _openHome() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final orders = _ordersForTab();
    final tabs = _buildTabs();

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(
            LucideIcons.chevronLeft,
            size: 22,
            color: Color(0xFF334155),
          ),
        ),
        titleSpacing: 0,
        title: const Text(
          'Đơn mua',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E293B),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              LucideIcons.search,
              size: 20,
              color: Color(0xFF475569),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          OrderStatusTabs(
            tabs: tabs,
            selectedIndex: _selectedTabIndex,
            onSelected: (index) => setState(() => _selectedTabIndex = index),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: orders.isEmpty
                ? OrderEmptyState(onContinueShopping: _openHome)
                : ListView.separated(
                    padding: const EdgeInsets.only(bottom: 24),
                    itemCount: orders.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) => OrderCard(order: orders[index]),
                  ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    OrderService.instance.removeListener(_handleOrdersChanged);
    super.dispose();
  }
}

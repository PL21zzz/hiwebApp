import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../models/user/voucher/voucher_model.dart';
import '../../../theme/app_colors.dart';
import '../../../widgets/common/layout/vietmade_header.dart';
import '../../../widgets/user/voucher/voucher_card.dart';

class VoucherVaultScreen extends StatefulWidget {
  const VoucherVaultScreen({super.key});

  @override
  State<VoucherVaultScreen> createState() => _VoucherVaultScreenState();
}

class _VoucherVaultScreenState extends State<VoucherVaultScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<VoucherItemModel> _vouchers = VoucherItemModel.mockVouchers;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<VoucherItemModel> _getFilteredVouchers(int tabIndex) {
    switch (tabIndex) {
      case 1:
        return _vouchers.where((voucher) => voucher.category == 'vietmade').toList();
      case 2:
        return _vouchers.where((voucher) => voucher.category == 'shop').toList();
      case 3:
        return _vouchers.where((voucher) => voucher.isSaved).toList();
      case 0:
      default:
        return _vouchers;
    }
  }

  Widget _buildEmptyState() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SizedBox(height: 40),
          const Icon(
            LucideIcons.tag,
            size: 48,
            color: Color(0xFFCBD5E1),
          ),
          const SizedBox(height: 12),
          const Text(
            'Chưa có voucher nào trong mục này',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVoucherList(List<VoucherItemModel> vouchers) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: vouchers
            .map(
              (voucher) => VoucherCard(
                voucher: voucher,
                onChanged: () => setState(() {}),
              ),
            )
            .toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final savedCount = _vouchers.where((voucher) => voucher.isSaved).length;

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: const VietmadeHeader(showMenu: false),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Padding(
                    padding: EdgeInsets.all(4),
                    child: Icon(
                      LucideIcons.chevronLeft,
                      size: 22,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                const Text(
                  'Kho voucher',
                  style: TextStyle(
                    fontSize: 16.5,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE2E8F0)),
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              isScrollable: false,
              indicatorColor: AppColors.primary,
              indicatorWeight: 2.5,
              labelColor: AppColors.primary,
              unselectedLabelColor: const Color(0xFF475569),
              labelStyle: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.bold,
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w500,
              ),
              onTap: (_) => setState(() {}),
              tabs: [
                Tab(text: 'Tất cả (${_vouchers.length})'),
                const Tab(text: 'VietMade (1)'),
                Tab(
                  text: 'Shop (${_vouchers.where((voucher) => voucher.category == 'shop').length})',
                ),
                Tab(text: 'Đã lưu ($savedCount)'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: List.generate(4, (tabIndex) {
                final vouchers = _getFilteredVouchers(tabIndex);
                return vouchers.isEmpty
                    ? _buildEmptyState()
                    : _buildVoucherList(vouchers);
              }),
            ),
          ),
        ],
      ),
    );
  }
}

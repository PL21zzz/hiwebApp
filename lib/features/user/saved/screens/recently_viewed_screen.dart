import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:hiweb_app_management/core/theme/app_colors.dart';
import 'package:hiweb_app_management/features/product/models/product_model.dart';
import 'package:hiweb_app_management/features/product/repositories/product_repository.dart';
import 'package:hiweb_app_management/core/widgets/common/product/product_card.dart';
import 'package:hiweb_app_management/core/widgets/common/dialogs/confirm_dialog.dart';
import 'package:hiweb_app_management/core/widgets/common/dialogs/top_notification.dart';

class RecentlyViewedScreen extends StatefulWidget {
  const RecentlyViewedScreen({super.key});

  @override
  State<RecentlyViewedScreen> createState() => _RecentlyViewedScreenState();
}

class _RecentlyViewedScreenState extends State<RecentlyViewedScreen> {
  late List<ProductModel> _todayViewed;
  late List<ProductModel> _yesterdayViewed;

  @override
  void initState() {
    super.initState();
    final all = MockProductRepository().getProducts();
    _todayViewed = List.from(all.take(4));
    _yesterdayViewed = List.from(all.skip(4).take(4));
  }

  void _clearHistory() {
    ConfirmDialog.show(
      context,
      title: 'Xóa lịch sử xem',
      message: 'Bạn có chắc chắn muốn xóa tất cả lịch sử các sản phẩm đã xem gần đây không?',
      confirmText: 'Xóa tất cả',
      primaryColor: const Color(0xFFEF4444),
      onConfirm: () {
        setState(() {
          _todayViewed.clear();
          _yesterdayViewed.clear();
        });
        TopNotification.show(
          context,
          message: 'Đã xóa toàn bộ lịch sử sản phẩm đã xem!',
          isError: false,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEmpty = _todayViewed.isEmpty && _yesterdayViewed.isEmpty;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.header,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.chevronLeft, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Sản phẩm đã xem',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.5,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          if (!isEmpty)
            IconButton(
              icon: const Icon(LucideIcons.trash2, color: Colors.white, size: 20),
              tooltip: 'Xóa lịch sử',
              onPressed: _clearHistory,
            ),
        ],
      ),
      body: isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0284C7).withValues(alpha: 0.08),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      LucideIcons.eye,
                      size: 60,
                      color: Color(0xFF0284C7),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Chưa có lịch sử sản phẩm đã xem',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Các sản phẩm bạn vừa mở xem sẽ xuất hiện tại đây',
                    style: TextStyle(
                      fontSize: 12.5,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(12),
              children: [
                if (_todayViewed.isNotEmpty) ...[
                  _buildSectionHeader('Hôm nay', _todayViewed.length),
                  const SizedBox(height: 10),
                  _buildProductGrid(_todayViewed),
                  const SizedBox(height: 20),
                ],
                if (_yesterdayViewed.isNotEmpty) ...[
                  _buildSectionHeader('Hôm qua & trước đó', _yesterdayViewed.length),
                  const SizedBox(height: 10),
                  _buildProductGrid(_yesterdayViewed),
                  const SizedBox(height: 20),
                ],
              ],
            ),
    );
  }

  Widget _buildSectionHeader(String title, int count) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 16,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          '($count sản phẩm)',
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF64748B),
          ),
        ),
      ],
    );
  }

  Widget _buildProductGrid(List<ProductModel> products) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final crossAxisCount = width > 900
            ? 4
            : width > 600
                ? 3
                : 2;
        const spacing = 10.0;
        final totalSpacing = spacing * (crossAxisCount - 1);
        final cardWidth = (width - totalSpacing) / crossAxisCount;
        final textSectionHeight = MediaQuery.textScalerOf(context).scale(122.0);
        final childAspectRatio = cardWidth / (cardWidth + textSectionHeight);

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: products.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: spacing,
            mainAxisSpacing: spacing,
            childAspectRatio: childAspectRatio,
          ),
          itemBuilder: (context, index) {
            return ProductCard(product: products[index]);
          },
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:hiweb_app_management/core/theme/app_colors.dart';
import 'package:hiweb_app_management/features/product/models/product_model.dart';
import 'package:hiweb_app_management/features/product/repositories/product_repository.dart';
import 'package:hiweb_app_management/core/widgets/common/product/product_card.dart';
import 'package:hiweb_app_management/core/widgets/common/dialogs/top_notification.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  late List<ProductModel> _savedProducts;
  final Set<String> _selectedProductIds = {};

  @override
  void initState() {
    super.initState();
    // Load mock saved products (take first 6 products as initial wishlist)
    _savedProducts = List.from(MockProductRepository().getProducts().take(6));
  }

  void _toggleSelectAll() {
    setState(() {
      if (_selectedProductIds.length == _savedProducts.length) {
        _selectedProductIds.clear();
      } else {
        _selectedProductIds.addAll(_savedProducts.map((p) => p.id));
      }
    });
  }

  void _removeSelected() {
    if (_selectedProductIds.isEmpty) return;
    setState(() {
      _savedProducts.removeWhere((p) => _selectedProductIds.contains(p.id));
      _selectedProductIds.clear();
    });
    TopNotification.show(
      context,
      message: 'Đã xóa sản phẩm khỏi danh sách yêu thích!',
      isError: false,
    );
  }

  void _addSelectedToCart() {
    if (_selectedProductIds.isEmpty) return;
    TopNotification.show(
      context,
      message: 'Đã thêm ${_selectedProductIds.length} sản phẩm vào giỏ hàng!',
      isError: false,
    );
  }

  void _removeFromWishlist(String id) {
    setState(() {
      _savedProducts.removeWhere((p) => p.id == id);
      _selectedProductIds.remove(id);
    });
    TopNotification.show(
      context,
      message: 'Đã xóa sản phẩm khỏi yêu thích',
      isError: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isAllSelected =
        _savedProducts.isNotEmpty && _selectedProductIds.length == _savedProducts.length;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.header,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.chevronLeft, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Sản phẩm yêu thích (${_savedProducts.length})',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16.5,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          if (_savedProducts.isNotEmpty)
            IconButton(
              icon: const Icon(LucideIcons.trash2, color: Colors.white, size: 20),
              tooltip: 'Xóa mục đã chọn',
              onPressed: _selectedProductIds.isEmpty ? null : _removeSelected,
            ),
        ],
      ),
      body: _savedProducts.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.08),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      LucideIcons.heart,
                      size: 60,
                      color: Color(0xFFEF4444),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Chưa có sản phẩm yêu thích nào',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Hãy thả tim sản phẩm bạn yêu thích để xem lại sau',
                    style: TextStyle(
                      fontSize: 12.5,
                      color: Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Khám phá ngay',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13.5,
                      ),
                    ),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                // Selection Action Header Bar
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  color: Colors.white,
                  child: Row(
                    children: [
                      InkWell(
                        onTap: _toggleSelectAll,
                        child: Row(
                          children: [
                            Checkbox(
                              value: isAllSelected,
                              onChanged: (_) => _toggleSelectAll(),
                              activeColor: AppColors.primary,
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              isAllSelected ? 'Bỏ chọn tất cả' : 'Chọn tất cả',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF334155),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      if (_selectedProductIds.isNotEmpty)
                        Text(
                          'Đã chọn: ${_selectedProductIds.length}',
                          style: const TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                    ],
                  ),
                ),
                const Divider(height: 1, color: Color(0xFFE2E8F0)),

                // Product Grid View
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(12),
                    child: LayoutBuilder(
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
                          itemCount: _savedProducts.length,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            crossAxisSpacing: spacing,
                            mainAxisSpacing: spacing,
                            childAspectRatio: childAspectRatio,
                          ),
                          itemBuilder: (context, index) {
                            final product = _savedProducts[index];
                            final isSelected = _selectedProductIds.contains(product.id);

                            return Stack(
                              children: [
                                ProductCard(product: product),

                                // Top Select Checkbox Overlay
                                Positioned(
                                  top: 8,
                                  left: 8,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        if (isSelected) {
                                          _selectedProductIds.remove(product.id);
                                        } else {
                                          _selectedProductIds.add(product.id);
                                        }
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(alpha: 0.9),
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withValues(alpha: 0.1),
                                            blurRadius: 4,
                                          ),
                                        ],
                                      ),
                                      child: Icon(
                                        isSelected
                                            ? LucideIcons.checkCircle2
                                            : LucideIcons.circle,
                                        size: 24,
                                        color: isSelected
                                            ? AppColors.primary
                                            : const Color(0xFF94A3B8),
                                      ),
                                    ),
                                  ),
                                ),

                                // Top Right Remove Favorite Button
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: GestureDetector(
                                    onTap: () => _removeFromWishlist(product.id),
                                    child: Container(
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(alpha: 0.9),
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withValues(alpha: 0.1),
                                            blurRadius: 4,
                                          ),
                                        ],
                                      ),
                                      child: const Icon(
                                        LucideIcons.heart,
                                        size: 16,
                                        color: Color(0xFFEF4444),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),

                // Bottom Add To Cart Action Bar
                if (_selectedProductIds.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        top: BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                    ),
                    child: SafeArea(
                      child: Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: _removeSelected,
                              icon: const Icon(LucideIcons.trash2, size: 16),
                              label: const Text('Bỏ yêu thích'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: const Color(0xFFEF4444),
                                side: const BorderSide(color: Color(0xFFEF4444)),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 2,
                            child: ElevatedButton.icon(
                              onPressed: _addSelectedToCart,
                              icon: const Icon(LucideIcons.shoppingCart, size: 16),
                              label: Text('Thêm vào giỏ (${_selectedProductIds.length})'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}

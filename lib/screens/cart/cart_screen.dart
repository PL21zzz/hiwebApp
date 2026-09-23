import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../models/product/product_detail_model.dart';
import '../../models/user/cart/cart_item_model.dart';
import '../../models/user/voucher/voucher_model.dart';
import '../../services/user/cart_service.dart';
import '../../theme/app_colors.dart';
import '../checkout/checkout_screen.dart';
import '../../widgets/user/cart/cart_checkout_bottom_bar.dart';
import '../../widgets/user/cart/cart_header_bar.dart';
import '../../widgets/user/cart/cart_shop_group_card.dart';
import '../../widgets/user/cart/cart_voucher_bottom_sheet.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool _isEditing = false;

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void _handleCheckout() {
    final selectedItem = CartService.instance.items.firstWhere(
      (item) => item.isSelected,
    );

    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => CheckoutScreen(
          productDetail: ProductDetailModel.fromCartItem(selectedItem),
          selectedVariant: selectedItem.variantInfo,
          quantity: selectedItem.quantity,
        ),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: ListenableBuilder(
        listenable: CartService.instance,
        builder: (context, _) {
          final cart = CartService.instance;
          final items = cart.items;

          return Scaffold(
            backgroundColor: const Color(0xFFF8FAFC),
            appBar: CartHeaderBar(
              isEditing: _isEditing,
              onEditPressed: _toggleEdit,
            ),
            body: items.isEmpty
                ? _buildEmptyState(context)
                : Column(
                    children: [
                      Expanded(
                        child: ListView(
                          padding: const EdgeInsets.only(top: 8, bottom: 16),
                          children: _buildShopGroups(items),
                        ),
                      ),
                      CartCheckoutBottomBar(
                        onCheckoutPressed: _handleCheckout,
                        onVoucherPressed: _showVietMadeVouchers,
                      ),
                    ],
                  ),
          );
        },
      ),
    );
  }

  List<Widget> _buildShopGroups(List<CartItemModel> items) {
    final Map<String, List<CartItemModel>> grouped = {};
    for (final item in items) {
      grouped.putIfAbsent(item.shopName, () => []).add(item);
    }

    return grouped.entries.map((entry) {
      return CartShopGroupCard(
        shopName: entry.key,
        items: entry.value,
        isEditing: _isEditing,
        onShopVoucherPressed: () => _showShopVouchers(entry.key),
      );
    }).toList();
  }

  void _showVietMadeVouchers() {
    CartVoucherBottomSheet.show(
      context,
      title: 'VietMade Voucher',
      vouchers: VoucherItemModel.mockVouchers
          .where((voucher) => voucher.category == 'vietmade')
          .toList(),
    );
  }

  void _showShopVouchers(String shopName) {
    CartVoucherBottomSheet.show(
      context,
      title: 'Voucher của $shopName',
      shopName: shopName,
      vouchers: VoucherItemModel.mockVouchers
          .where((voucher) => voucher.category == 'shop')
          .toList(),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Center(
                child: Icon(
                  LucideIcons.shoppingBag,
                  size: 36,
                  color: AppColors.primary,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Giỏ hàng đang trống',
              style: TextStyle(
                fontSize: 16.5,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Khám phá sản phẩm và thêm vào giỏ hàng để tiếp tục mua sắm.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.5,
                color: Color(0xFF64748B),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                if (Navigator.of(context).canPop()) {
                  Navigator.of(context).pop();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: const StadiumBorder(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 11,
                ),
              ),
              child: const Text(
                'Mua sắm ngay',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


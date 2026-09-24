import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:hiweb_app_management/features/product/models/product_model.dart';
import 'package:hiweb_app_management/features/cart_checkout/models/cart_item_model.dart';
import 'package:hiweb_app_management/features/auth/screens/login_screen.dart';
import 'package:hiweb_app_management/features/auth/services/auth_service.dart';
import 'package:hiweb_app_management/features/cart_checkout/services/cart_service.dart';
import 'package:hiweb_app_management/features/cart_checkout/repositories/cart_repository.dart';
import 'package:hiweb_app_management/core/widgets/common/dialogs/top_notification.dart';

enum CartButtonStyle {
  pillPlus, // Standard pill button with '+' badge (used in ProductCard)
  circleOutline, // Small circle outline icon (used in ShopProductCard)
  circleSolid, // Light blue circle icon (used in SimilarProductCard)
}

class AddToCartButton extends StatelessWidget {
  final CartButtonStyle style;
  final VoidCallback? customOnTap;
  final ProductModel? product;
  final String productId;

  const AddToCartButton({
    super.key,
    this.style = CartButtonStyle.pillPlus,
    this.customOnTap,
    this.product,
    this.productId = 'cart_omega3',
  });

  String get _targetId => product?.id ?? productId;

  Future<void> _handleDefaultTap(BuildContext context) async {
    if (CartService.instance.isSubmitting) return;
    if (!AuthService.instance.isLoggedIn) {
      TopNotification.show(
        context,
        message: 'Bạn phải đăng nhập để thêm sản phẩm vào giỏ hàng!',
        isError: true,
      );

      Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const LoginScreen(),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
        (route) => false,
      );
    } else {
      final CartItemModel itemToAdd;
      if (product != null) {
        itemToAdd = CartItemModel(
          id: product!.id,
          shopName: product!.shopName,
          name: product!.name,
          imageUrl: product!.imageUrl,
          brand: 'VietMade',
          variantInfo: 'Đã chọn: Mặc định',
          price: product!.price.toInt(),
          originalPrice: product!.originalPrice.toInt(),
          quantity: 1,
          isSelected: true,
        );
      } else {
        itemToAdd = MockCartRepository().getInitialItems().first.copyWith(
          quantity: 1,
          isSelected: true,
        );
      }

      final added = await CartService.instance.addToCart(itemToAdd);
      if (!context.mounted || !added) return;
      TopNotification.show(context, message: 'Đã thêm "${itemToAdd.name}" vào giỏ hàng', isError: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (customOnTap != null) {
          customOnTap!();
        } else {
          _handleDefaultTap(context);
        }
      },
      child: ListenableBuilder(
        listenable: Listenable.merge([CartService.instance, AuthService.instance]),
        builder: (context, _) {
          final count = AuthService.instance.isLoggedIn
              ? CartService.instance.getItemQuantity(_targetId)
              : 0;

          return _buildButtonWidget(
            count,
            isSubmitting: CartService.instance.isSubmitting,
          );
        },
      ),
    );
  }

  Widget _buildButtonWidget(int count, {bool isSubmitting = false}) {
    if (isSubmitting) {
      return const SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    }
    switch (style) {
      case CartButtonStyle.circleOutline:
        return Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF64748B),
                  width: 0.9,
                ),
              ),
              child: const Center(
                child: Icon(
                  LucideIcons.shoppingCart,
                  size: 12,
                  color: Color(0xFF475569),
                ),
              ),
            ),
            if (count > 0)
              Positioned(
                top: -4,
                right: -4,
                child: _buildBadge(count),
              ),
          ],
        );

      case CartButtonStyle.circleSolid:
        return Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 25,
              height: 25,
              decoration: const BoxDecoration(
                color: Color(0xFFE0F2FE),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(
                  LucideIcons.shoppingCart,
                  size: 13,
                  color: Color(0xFF0284C7),
                ),
              ),
            ),
            if (count > 0)
              Positioned(
                top: -4,
                right: -4,
                child: _buildBadge(count),
              ),
          ],
        );

      case CartButtonStyle.pillPlus:
        return SizedBox(
          width: 46,
          height: 30,
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 46,
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border:
                      Border.all(color: const Color(0xFF1E293B), width: 1.1),
                ),
                child: const Center(
                  child: Icon(
                    LucideIcons.shoppingCart,
                    size: 16,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ),
              if (count > 0)
                Positioned(
                  right: -2,
                  top: -3,
                  child: _buildBadge(count),
                )
              else
                Positioned(
                  right: -1,
                  bottom: 3,
                  child: Container(
                    width: 13,
                    height: 13,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text(
                        '+',
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                          height: 1.0,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
    }
  }

  Widget _buildBadge(int count) {
    return Container(
      padding: const EdgeInsets.all(2),
      constraints: const BoxConstraints(
        minWidth: 14,
        minHeight: 14,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFFEF4444),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          '$count',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 9,
            fontWeight: FontWeight.bold,
            height: 1.0,
          ),
        ),
      ),
    );
  }
}



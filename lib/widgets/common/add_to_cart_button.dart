import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../screens/auth/login_screen.dart';
import 'top_notification.dart';

enum CartButtonStyle {
  pillPlus,    // Standard pill button with '+' badge (used in ProductCard)
  circleOutline, // Small circle outline icon (used in ShopProductCard)
  circleSolid,   // Light blue circle icon (used in SimilarProductCard)
}

class AddToCartButton extends StatelessWidget {
  final CartButtonStyle style;
  final VoidCallback? customOnTap;

  const AddToCartButton({
    super.key,
    this.style = CartButtonStyle.pillPlus,
    this.customOnTap,
  });

  void _handleDefaultTap(BuildContext context) {
    TopNotification.show(
      context,
      message: 'Bạn phải đăng nhập để thêm sản phẩm vào giỏ hàng!',
      isError: true,
    );

    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const LoginScreen(),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
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
      child: _buildButtonWidget(),
    );
  }

  Widget _buildButtonWidget() {
    switch (style) {
      case CartButtonStyle.circleOutline:
        return Container(
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
        );

      case CartButtonStyle.circleSolid:
        return Container(
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
}

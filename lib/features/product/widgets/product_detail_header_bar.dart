import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:hiweb_app_management/features/product/models/product_detail_model.dart';
import 'package:hiweb_app_management/features/search/screens/search_screen.dart';
import 'package:hiweb_app_management/core/theme/app_colors.dart';
import 'package:hiweb_app_management/core/widgets/common/product/product_share_bottom_sheet.dart';
import 'package:hiweb_app_management/features/cart_checkout/screens/cart_screen.dart';
import 'package:hiweb_app_management/features/cart_checkout/services/cart_service.dart';
import 'package:hiweb_app_management/features/auth/services/auth_service.dart';

class ProductDetailHeaderBar extends StatelessWidget implements PreferredSizeWidget {
  final int selectedTabIndex;
  final ValueChanged<int> onTabHeaderTapped;
  final ProductDetailModel productDetail;

  const ProductDetailHeaderBar({
    super.key,
    required this.selectedTabIndex,
    required this.onTabHeaderTapped,
    required this.productDetail,
  });

  @override
  Size get preferredSize => const Size.fromHeight(48);

  Widget _buildTabHeaderItem(String title, int tabIndex) {
    final isSelected = selectedTabIndex == tabIndex;
    return GestureDetector(
      onTap: () => onTabHeaderTapped(tabIndex),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        height: 48,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                title,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.white70,
                  fontSize: isSelected ? 15.5 : 14.5,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                ),
              ),
            ),
            if (isSelected)
              Positioned(
                bottom: 4,
                child: Container(
                  height: 2.5,
                  width: 26,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.header,
      child: SafeArea(
        bottom: false,
        child: Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Back Button
              InkWell(
                onTap: () => Navigator.of(context).pop(),
                borderRadius: BorderRadius.circular(20),
                child: const Padding(
                  padding: EdgeInsets.all(6),
                  child: Icon(
                    LucideIcons.arrowLeft,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),

              // 3 Header Tabs inside FittedBox (Vertically centered)
              Expanded(
                child: Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _buildTabHeaderItem('Tổng quan', 0),
                        const SizedBox(width: 6),
                        _buildTabHeaderItem('Đánh giá', 1),
                        const SizedBox(width: 6),
                        _buildTabHeaderItem('Sản phẩm', 2),
                      ],
                    ),
                  ),
                ),
              ),

              // Search Button
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SearchScreen(),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(20),
                child: const Padding(
                  padding: EdgeInsets.all(6),
                  child: Icon(
                    LucideIcons.search,
                    color: Colors.white,
                    size: 19,
                  ),
                ),
              ),

              // Cart Button (Only displays red badge if user is logged in)
              ListenableBuilder(
                listenable: Listenable.merge([
                  CartService.instance,
                  AuthService.instance,
                ]),
                builder: (context, _) {
                  final count = AuthService.instance.isLoggedIn
                      ? CartService.instance.totalItemCount
                      : 0;
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CartScreen(),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: SizedBox(
                        width: 22,
                        height: 22,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            const Center(
                              child: Icon(
                                LucideIcons.shoppingCart,
                                color: Colors.white,
                                size: 19,
                              ),
                            ),
                            if (count > 0)
                              Positioned(
                                top: -4,
                                right: -4,
                                child: Container(
                                  constraints: const BoxConstraints(
                                    minWidth: 14,
                                    minHeight: 14,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 3),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFEF4444),
                                    shape: BoxShape.circle,
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    count > 99 ? '99+' : '$count',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 8,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),

              // Share Button (Custom Web SVG curved arrow share icon)
              InkWell(
                onTap: () {
                  ProductShareBottomSheet.show(
                    context,
                    productDetail: productDetail,
                  );
                },
                borderRadius: BorderRadius.circular(20),
                child: const Padding(
                  padding: EdgeInsets.all(6),
                  child: WebShareIcon(
                    size: 19,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WebShareIcon extends StatelessWidget {
  final double size;
  final Color color;

  const WebShareIcon({
    super.key,
    this.size = 20.0,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _WebShareIconPainter(color: color),
    );
  }
}

class _WebShareIconPainter extends CustomPainter {
  final Color color;

  _WebShareIconPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 32.0;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4 * scale
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    path.moveTo(5 * scale, 26 * scale);
    path.cubicTo(
      5.7 * scale, 17.5 * scale,
      10.3 * scale, 11.8 * scale,
      19 * scale, 10.4 * scale,
    );
    path.lineTo(19 * scale, 5.7 * scale);
    path.cubicTo(
      19 * scale, 5.1 * scale,
      19.7 * scale, 4.8 * scale,
      20.2 * scale, 5.2 * scale,
    );
    path.lineTo(28.2 * scale, 11.3 * scale);
    path.cubicTo(
      28.7 * scale, 11.7 * scale,
      28.7 * scale, 12.4 * scale,
      28.2 * scale, 12.8 * scale,
    );
    path.lineTo(20.2 * scale, 19 * scale);
    path.cubicTo(
      19.7 * scale, 19.4 * scale,
      19 * scale, 19.1 * scale,
      19 * scale, 18.5 * scale,
    );
    path.lineTo(19 * scale, 13.9 * scale);
    path.cubicTo(
      12.2 * scale, 14.8 * scale,
      7.6 * scale, 18.7 * scale,
      5 * scale, 26 * scale,
    );
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _WebShareIconPainter oldDelegate) =>
      oldDelegate.color != color;
}

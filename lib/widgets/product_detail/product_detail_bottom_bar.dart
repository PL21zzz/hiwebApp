import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../screens/chat/messages_screen.dart';
import '../../theme/app_colors.dart';

class ProductDetailBottomBar extends StatelessWidget {
  final ValueChanged<String> onPurchaseAction;

  const ProductDetailBottomBar({
    super.key,
    required this.onPurchaseAction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: SafeArea(
        top: false,
        minimum: const EdgeInsets.only(bottom: 6),
        child: Row(
          children: [
            // Chat Button
            InkWell(
              onTap: () {
                Navigator.of(context).push(
                  PageRouteBuilder(
                    pageBuilder: (context, anim1, anim2) =>
                        const MessagesScreen(),
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                  ),
                );
              },
              borderRadius: BorderRadius.circular(8),
              child: const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 2,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      LucideIcons.messageSquare,
                      size: 19,
                      color: AppColors.primary,
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Chat',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),

            // Add to Cart Button (Light Teal - Stacked Icon & Text matching sample)
            Expanded(
              flex: 4,
              child: SizedBox(
                height: 42,
                child: Material(
                  color: const Color(0xFFE0F2FE),
                  borderRadius: BorderRadius.circular(22),
                  child: InkWell(
                    onTap: () => onPurchaseAction('Thêm vào giỏ'),
                    borderRadius: BorderRadius.circular(22),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          LucideIcons.shoppingCart,
                          size: 15,
                          color: AppColors.primary,
                        ),
                        SizedBox(height: 1),
                        Text(
                          'Thêm vào giỏ',
                          style: TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),

            // Buy Now Button (Solid Teal - Validates Capacity Selection)
            Expanded(
              flex: 5,
              child: SizedBox(
                height: 42,
                child: Material(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(22),
                  child: InkWell(
                    onTap: () => onPurchaseAction('Mua ngay'),
                    borderRadius: BorderRadius.circular(22),
                    child: const Center(
                      child: Text(
                        'Mua ngay',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

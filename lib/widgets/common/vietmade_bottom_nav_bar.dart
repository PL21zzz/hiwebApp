import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../screens/auth/account_screen.dart';
import '../../screens/auth/login_screen.dart';
import '../../screens/cart/cart_screen.dart';
import '../../services/auth_service.dart';
import '../../theme/app_colors.dart';

class VietmadeBottomNavBar extends StatelessWidget {
  final int? selectedIndex;
  final ValueChanged<int>? onTap;

  const VietmadeBottomNavBar({
    super.key,
    this.selectedIndex,
    this.onTap,
  });

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required int index,
  }) {
    final isSelected = selectedIndex == index;
    final color = isSelected ? AppColors.primary : const Color(0xFF64748B);

    return Expanded(
      child: InkWell(
        onTap: () {
          if (onTap != null) {
            onTap!(index);
            return;
          }
          if (index == 0) {
            Navigator.of(context).popUntil((route) => route.isFirst);
          } else if (index == 3) {
            Navigator.of(context).push(
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const CartScreen(),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );
          } else if (index == 4) {
            if (!AuthService.instance.isLoggedIn) {
              Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      const LoginScreen(),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
              );
            } else {
              Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      const AccountScreen(),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
              );
            }
          } else {
            Navigator.of(context).popUntil((route) => route.isFirst);
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 20, color: color),
              const SizedBox(height: 3),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Color(0xFFE2E8F0),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 56,
          child: Row(
            children: [
              _buildNavItem(context, icon: LucideIcons.home, label: 'Trang chủ', index: 0),
              _buildNavItem(context, icon: LucideIcons.layoutGrid, label: 'Danh mục', index: 1),
              _buildNavItem(context, icon: LucideIcons.video, label: 'Video', index: 2),
              _buildNavItem(context, icon: LucideIcons.shoppingCart, label: 'Giỏ hàng', index: 3),
              _buildNavItem(context, icon: LucideIcons.user, label: 'Tài khoản', index: 4),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:hiweb_app_management/features/auth/screens/login_screen.dart';
import 'package:hiweb_app_management/features/auth/services/auth_service.dart';
import 'package:hiweb_app_management/core/theme/app_colors.dart';
import 'package:hiweb_app_management/features/navigation/screens/main_navigation_screen.dart';

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
          if (index == 4 && !AuthService.instance.isLoggedIn) {
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
            Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    MainNavigationScreen(initialIndex: index),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
              (route) => false,
            );
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
    return MediaQuery.withNoTextScaling(
      child: Container(
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
                _buildNavItem(context, icon: LucideIcons.clapperboard, label: 'Video', index: 2),
                _buildNavItem(context, icon: LucideIcons.bell, label: 'Thông báo', index: 3),
                _buildNavItem(context, icon: LucideIcons.user, label: 'Tài khoản', index: 4),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:hiweb_app_management/features/auth/models/user_model.dart';
import 'package:hiweb_app_management/features/user/address/screens/address_screen.dart';
import 'package:hiweb_app_management/features/navigation/screens/not_found_screen.dart';
import 'package:hiweb_app_management/features/auth/services/auth_service.dart';
import 'package:hiweb_app_management/core/theme/app_colors.dart';
import 'profile_user_avatar.dart';

class ProfileUserHeaderBanner extends StatelessWidget {
  final UserModel user;

  const ProfileUserHeaderBanner({
    super.key,
    required this.user,
  });

  Widget _buildPillButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF67E8F9), width: 1.2),
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 14, color: AppColors.primary),
                const SizedBox(width: 4),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFFEAFAFF),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Avatar circle with camera badge
              ListenableBuilder(
                listenable: AuthService.instance,
                builder: (context, child) {
                  final activeUser = AuthService.instance.currentUser ?? user;
                  return ProfileUserAvatar(user: activeUser);
                },
              ),
              const SizedBox(width: 12),
              // User Name & Subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.fullName,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Thành viên từ: ${user.memberSince}',
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
              // Top right grid icon
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          const NotFoundScreen(
                        title: 'Tài Khoản & Cài Đặt',
                        message: 'Trang quản lý cài đặt tài khoản\nhiện đang được nâng cấp...',
                      ),
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                    ),
                  );
                },
                child: const Icon(
                  LucideIcons.layoutGrid,
                  color: Color(0xFF64748B),
                  size: 22,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // 2 Pill Buttons
          Row(
            children: [
              _buildPillButton(
                icon: LucideIcons.mapPin,
                label: 'Địa chỉ nhận hàng',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const AddressScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(width: 8),
              _buildPillButton(
                icon: LucideIcons.shield,
                label: 'Tài khoản & An toàn',
                onTap: () {
                  Navigator.of(context).push(
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          const NotFoundScreen(
                        title: 'Bảo Mật Tài Khoản',
                        message: 'Tính năng thiết lập an toàn tài khoản\nhiện đang được nâng cấp...',
                      ),
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

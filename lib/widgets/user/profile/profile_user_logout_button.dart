import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../services/auth_service.dart';
import '../../common/dialogs/confirm_dialog.dart';
import '../../common/dialogs/top_notification.dart';
import '../../../screens/auth/login_screen.dart';

class ProfileUserLogoutButton extends StatelessWidget {
  const ProfileUserLogoutButton({super.key});

  void _showLogoutConfirm(BuildContext context) {
    ConfirmDialog.show(
      context,
      title: 'Đăng xuất tài khoản?',
      message: 'Bạn có chắc chắn muốn đăng xuất khỏi ứng dụng?',
      icon: LucideIcons.logOut,
      confirmText: 'Đồng ý',
      cancelText: 'Hủy',
      isDangerous: true,
      onConfirm: () {
        AuthService.instance.logout();
        Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const LoginScreen(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
          (route) => false,
        );
        TopNotification.show(
          context,
          message: 'Đã đăng xuất tài khoản',
          isError: false,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 10, 14, 16),
      width: double.infinity,
      height: 46,
      child: OutlinedButton.icon(
        onPressed: () => _showLogoutConfirm(context),
        icon: const Icon(LucideIcons.logOut, size: 18, color: Colors.red),
        label: const Text(
          'Đăng xuất',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          side: const BorderSide(color: Color(0xFFFCA5A5)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}

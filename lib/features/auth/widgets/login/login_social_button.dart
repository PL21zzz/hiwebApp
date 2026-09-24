import 'package:flutter/material.dart';
import 'package:hiweb_app_management/features/auth/models/user_model.dart';

class LoginSocialButton extends StatelessWidget {
  final VoidCallback onPressed;

  const LoginSocialButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 38,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Color(0xFFE2E8F0)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(7),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              UserModel.googleLogoUrl,
              width: 18,
              height: 18,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.g_mobiledata, size: 20),
            ),
            const SizedBox(width: 8),
            const Text(
              'Đăng nhập bằng Google',
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w500,
                color: Color(0xFF334155),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

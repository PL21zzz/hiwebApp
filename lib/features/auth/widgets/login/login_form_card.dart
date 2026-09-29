import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:hiweb_app_management/core/theme/app_colors.dart';
import '../auth_text_field.dart';
import 'login_social_button.dart';

class LoginFormCard extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool isPasswordVisible;
  final VoidCallback onTogglePasswordVisibility;
  final bool rememberMe;
  final ValueChanged<bool?> onRememberMeChanged;
  final String? emailError;
  final String? passwordError;
  final VoidCallback onLoginPressed;
  final VoidCallback onGoogleLoginPressed;
  final VoidCallback onRegisterTap;
  final VoidCallback? onForgotPasswordTap;

  const LoginFormCard({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.isPasswordVisible,
    required this.onTogglePasswordVisibility,
    required this.rememberMe,
    required this.onRememberMeChanged,
    this.emailError,
    this.passwordError,
    required this.onLoginPressed,
    required this.onGoogleLoginPressed,
    required this.onRegisterTap,
    this.onForgotPasswordTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Đăng nhập',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Đăng nhập vào tài khoản của bạn.',
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 18),

          // Email / Username Input
          AuthTextField(
            label: 'Email hoặc tên đăng nhập',
            hintText: 'Nhập email hoặc tên đăng nhập',
            controller: emailController,
            prefixIcon: LucideIcons.user,
            errorText: emailError,
          ),
          const SizedBox(height: 14),

          // Password Input
          AuthTextField(
            label: 'Mật khẩu',
            hintText: 'Nhập mật khẩu',
            controller: passwordController,
            obscureText: !isPasswordVisible,
            prefixIcon: LucideIcons.lock,
            errorText: passwordError,
            suffixIcon: GestureDetector(
              onTap: onTogglePasswordVisibility,
              child: Icon(
                isPasswordVisible ? LucideIcons.eye : LucideIcons.eyeOff,
                size: 18,
                color: const Color(0xFF94A3B8),
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Remember Me & Forgot Password
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: Checkbox(
                      value: rememberMe,
                      activeColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3),
                      ),
                      onChanged: onRememberMeChanged,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    'Ghi nhớ đăng nhập',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF334155),
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: onForgotPasswordTap ?? () {},
                child: const Text(
                  'Quên mật khẩu?',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Main Login Button
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton(
              onPressed: onLoginPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Đăng nhập',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Divider "HOẶC"
          const Row(
            children: [
              Expanded(
                child: Divider(color: Color(0xFFE2E8F0), thickness: 0.8),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  'HOẶC',
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF94A3B8),
                  ),
                ),
              ),
              Expanded(
                child: Divider(color: Color(0xFFE2E8F0), thickness: 0.8),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Google Button
          LoginSocialButton(onPressed: onGoogleLoginPressed),
          const SizedBox(height: 18),

          // Register Link
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Chưa có tài khoản? ',
                style: TextStyle(fontSize: 13.5, color: Color(0xFF64748B)),
              ),
              GestureDetector(
                onTap: onRegisterTap,
                child: const Text(
                  'Đăng ký',
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

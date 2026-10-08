import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:hiweb_app_management/core/core.dart';
import '../auth_text_field.dart';
import 'register_name_row.dart';
import 'register_password_note.dart';

class RegisterFormCard extends StatelessWidget {
  final TextEditingController userNameController;
  final TextEditingController lastNameController;
  final TextEditingController firstNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

  final bool isPasswordVisible;
  final bool isConfirmPasswordVisible;

  final String? userNameError;
  final String? lastNameError;
  final String? firstNameError;
  final String? emailError;
  final String? phoneError;
  final String? passwordError;
  final String? confirmPasswordError;

  final void Function(String fieldName) onClearError;
  final VoidCallback onValidateConfirmPasswordLive;
  final VoidCallback onTogglePasswordVisibility;
  final VoidCallback onToggleConfirmPasswordVisibility;
  final VoidCallback onRegisterPressed;
  final VoidCallback onLoginTap;
  final bool isLoading;

  final bool isCompact;
  final double fieldSpacing;
  final double verticalInputPadding;
  final EdgeInsets cardPadding;

  const RegisterFormCard({
    super.key,
    required this.userNameController,
    required this.lastNameController,
    required this.firstNameController,
    required this.emailController,
    required this.phoneController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.isPasswordVisible,
    required this.isConfirmPasswordVisible,
    this.userNameError,
    this.lastNameError,
    this.firstNameError,
    this.emailError,
    this.phoneError,
    this.passwordError,
    this.confirmPasswordError,
    required this.onClearError,
    required this.onValidateConfirmPasswordLive,
    required this.onTogglePasswordVisibility,
    required this.onToggleConfirmPasswordVisibility,
    required this.onRegisterPressed,
    required this.onLoginTap,
    this.isLoading = false,
    required this.isCompact,
    required this.fieldSpacing,
    required this.verticalInputPadding,
    required this.cardPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: cardPadding,
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
          // Title & Subtitle
          const Text(
            'Đăng ký tài khoản',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Tạo tài khoản VietMade.vn',
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF64748B),
            ),
          ),
          SizedBox(height: isCompact ? 10 : 14),

          // Tên đăng nhập
          AuthTextField(
            label: 'Tên đăng nhập',
            hintText: 'Nhập tên đăng nhập',
            controller: userNameController,
            errorText: userNameError,
            onTap: () => onClearError('userName'),
            onChanged: (_) {
              if (userNameError != null) onClearError('userName');
            },
            verticalPadding: verticalInputPadding,
          ),
          SizedBox(height: fieldSpacing),

          // Row: Họ và tên đệm + Tên
          RegisterNameRow(
            lastNameController: lastNameController,
            firstNameController: firstNameController,
            lastNameError: lastNameError,
            firstNameError: firstNameError,
            onLastNameTap: () => onClearError('lastName'),
            onLastNameChanged: (_) {
              if (lastNameError != null) onClearError('lastName');
            },
            onFirstNameTap: () => onClearError('firstName'),
            onFirstNameChanged: (_) {
              if (firstNameError != null) onClearError('firstName');
            },
            verticalInputPadding: verticalInputPadding,
          ),
          SizedBox(height: fieldSpacing),

          // Email
          AuthTextField(
            label: 'Email',
            hintText: 'example@gmail.com',
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            errorText: emailError,
            onTap: () => onClearError('email'),
            onChanged: (_) {
              if (emailError != null) onClearError('email');
            },
            verticalPadding: verticalInputPadding,
          ),
          SizedBox(height: fieldSpacing),

          // Số điện thoại
          AuthTextField(
            label: 'Số điện thoại',
            hintText: '0xxxxxxxxx',
            controller: phoneController,
            keyboardType: TextInputType.phone,
            errorText: phoneError,
            onTap: () => onClearError('phone'),
            onChanged: (_) {
              if (phoneError != null) onClearError('phone');
            },
            verticalPadding: verticalInputPadding,
          ),
          SizedBox(height: fieldSpacing),

          // Mật khẩu
          AuthTextField(
            label: 'Mật khẩu',
            hintText: 'Nhập mật khẩu',
            controller: passwordController,
            obscureText: !isPasswordVisible,
            errorText: passwordError,
            onTap: () => onClearError('password'),
            onChanged: (_) {
              if (passwordError != null) onClearError('password');
              if (confirmPasswordController.text.isNotEmpty || confirmPasswordError != null) {
                onValidateConfirmPasswordLive();
              }
            },
            verticalPadding: verticalInputPadding,
            suffixIcon: GestureDetector(
              onTap: onTogglePasswordVisibility,
              child: Icon(
                isPasswordVisible ? LucideIcons.eye : LucideIcons.eyeOff,
                size: 18,
                color: const Color(0xFF94A3B8),
              ),
            ),
          ),
          SizedBox(height: fieldSpacing),

          // Nhập lại mật khẩu
          AuthTextField(
            label: 'Nhập lại mật khẩu',
            hintText: 'Nhập lại mật khẩu',
            controller: confirmPasswordController,
            obscureText: !isConfirmPasswordVisible,
            errorText: confirmPasswordError,
            onTap: onValidateConfirmPasswordLive,
            onChanged: (_) => onValidateConfirmPasswordLive(),
            verticalPadding: verticalInputPadding,
            suffixIcon: GestureDetector(
              onTap: onToggleConfirmPasswordVisibility,
              child: Icon(
                isConfirmPasswordVisible ? LucideIcons.eye : LucideIcons.eyeOff,
                size: 18,
                color: const Color(0xFF94A3B8),
              ),
            ),
          ),
          SizedBox(height: isCompact ? 8 : 10),

          // Password Requirements Note Container
          RegisterPasswordNote(isCompact: isCompact),
          SizedBox(height: isCompact ? 10 : 14),

          // Primary Register Button
          PrimaryButton(
            text: 'Đăng ký',
            onPressed: onRegisterPressed,
            isLoading: isLoading,
          ),
          SizedBox(height: isCompact ? 10 : 14),

          // Footer Link to Login
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Đã có tài khoản? ',
                style: TextStyle(
                  fontSize: 13.5,
                  color: Color(0xFF64748B),
                ),
              ),
              GestureDetector(
                onTap: onLoginTap,
                child: const Text(
                  'Đăng nhập',
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

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../services/auth_service.dart';
import '../../theme/app_colors.dart';
import '../../widgets/common/top_notification.dart';
import '../main_navigation_screen.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  String? _userNameError;
  String? _lastNameError;
  String? _firstNameError;
  String? _emailError;
  String? _phoneError;
  String? _passwordError;
  String? _confirmPasswordError;

  @override
  void dispose() {
    _userNameController.dispose();
    _lastNameController.dispose();
    _firstNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  bool _validateForm() {
    setState(() {
      _userNameError = null;
      _lastNameError = null;
      _firstNameError = null;
      _emailError = null;
      _phoneError = null;
      _passwordError = null;
      _confirmPasswordError = null;
    });

    bool isValid = true;

    final userName = _userNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    final firstName = _firstNameController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    // 1. Tên đăng nhập
    if (userName.isEmpty) {
      _userNameError = 'Vui lòng nhập tên đăng nhập';
      isValid = false;
    } else if (userName.contains(' ')) {
      _userNameError = 'Tên đăng nhập không được chứa khoảng trắng';
      isValid = false;
    } else if (AuthService.instance.isUserNameTaken(userName)) {
      _userNameError = 'Tên đăng nhập đã tồn tại';
      isValid = false;
    }

    // 2. Họ & Tên
    if (lastName.isEmpty) {
      _lastNameError = 'Nhập họ và tên đệm';
      isValid = false;
    }

    if (firstName.isEmpty) {
      _firstNameError = 'Nhập tên';
      isValid = false;
    }

    // 3. Email
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (email.isEmpty) {
      _emailError = 'Vui lòng nhập email';
      isValid = false;
    } else if (!emailRegex.hasMatch(email)) {
      _emailError = 'Email không hợp lệ (VD: name@domain.com)';
      isValid = false;
    } else if (AuthService.instance.isEmailTaken(email)) {
      _emailError = 'Email này đã được đăng ký';
      isValid = false;
    }

    // 4. Số điện thoại
    final phoneRegex = RegExp(r'^0[0-9]{9}$');
    if (phone.isEmpty) {
      _phoneError = 'Vui lòng nhập số điện thoại';
      isValid = false;
    } else if (!phoneRegex.hasMatch(phone)) {
      _phoneError = 'SĐT phải đủ 10 số (bắt đầu bằng 0)';
      isValid = false;
    } else if (AuthService.instance.isPhoneTaken(phone)) {
      _phoneError = 'Số điện thoại này đã được đăng ký';
      isValid = false;
    }

    // 5. Mật khẩu
    final hasMinLength = password.length >= 8;
    final hasLower = password.contains(RegExp(r'[a-z]'));
    final hasUpper = password.contains(RegExp(r'[A-Z]'));
    final hasDigit = password.contains(RegExp(r'[0-9]'));
    final hasSpecial = password.contains(RegExp(r'[@$%^*&]'));

    if (password.isEmpty) {
      _passwordError = 'Vui lòng nhập mật khẩu';
      isValid = false;
    } else if (!hasMinLength || !hasLower || !hasUpper || !hasDigit || !hasSpecial) {
      _passwordError = 'Ít nhất 8 ký tự, gồm chữ thường, chữ hoa, số và ký tự đặc biệt @\$%^*&.';
      isValid = false;
    }

    // 6. Nhập lại mật khẩu
    if (confirmPassword.isEmpty) {
      _confirmPasswordError = 'Vui lòng nhập lại mật khẩu';
      isValid = false;
    } else if (confirmPassword != password) {
      _confirmPasswordError = 'Mật khẩu không khớp';
      isValid = false;
    }

    setState(() {});

    if (!isValid) {
      TopNotification.show(
        context,
        message: 'Vui lòng kiểm tra lại thông tin đăng ký',
        isError: true,
      );
    }

    return isValid;
  }

  void _handleRegister() {
    if (!_validateForm()) {
      return;
    }

    final result = AuthService.instance.register(
      userName: _userNameController.text,
      password: _passwordController.text,
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      phoneNumber: _phoneController.text,
      email: _emailController.text,
    );

    if (result.isSuccess) {
      TopNotification.show(
        context,
        message: 'Đăng ký tài khoản thành công!',
        isError: false,
      );
      Navigator.of(context).pushAndRemoveUntil(
        PageRouteBuilder(
          pageBuilder: (context, anim1, anim2) =>
              const MainNavigationScreen(initialIndex: 4),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
        (route) => false,
      );
    } else {
      TopNotification.show(
        context,
        message: result.message,
        isError: true,
      );
    }
  }

  void _clearError(String fieldName) {
    if (!mounted) return;
    setState(() {
      switch (fieldName) {
        case 'userName':
          _userNameError = null;
          break;
        case 'lastName':
          _lastNameError = null;
          break;
        case 'firstName':
          _firstNameError = null;
          break;
        case 'email':
          _emailError = null;
          break;
        case 'phone':
          _phoneError = null;
          break;
        case 'password':
          _passwordError = null;
          break;
        case 'confirmPassword':
          _confirmPasswordError = null;
          break;
      }
    });
  }

  void _validateConfirmPasswordLive() {
    if (!mounted) return;
    setState(() {
      final pass = _passwordController.text;
      final confirmPass = _confirmPasswordController.text;
      if (confirmPass != pass) {
        _confirmPasswordError = 'Mật khẩu không khớp';
      } else {
        _confirmPasswordError = null;
      }
    });
  }

  InputDecoration _buildInputDecoration({
    required String hintText,
    Widget? suffixIcon,
    String? errorText,
    double verticalPadding = 5.5,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(
        fontSize: 12,
        color: Color(0xFF94A3B8),
      ),
      errorText: errorText,
      errorStyle: const TextStyle(
        fontSize: 10,
        color: Colors.red,
        height: 1.1,
      ),
      suffixIcon: suffixIcon != null
          ? Padding(
              padding: const EdgeInsets.only(right: 8),
              child: suffixIcon,
            )
          : null,
      suffixIconConstraints: const BoxConstraints(
        minWidth: 28,
        minHeight: 28,
      ),
      isDense: true,
      contentPadding: EdgeInsets.symmetric(
        horizontal: 10,
        vertical: verticalPadding,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(7),
        borderSide: const BorderSide(
          color: Color(0xFFE2E8F0),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(7),
        borderSide: const BorderSide(
          color: Color(0xFFE2E8F0),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(7),
        borderSide: const BorderSide(
          color: AppColors.primary,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(7),
        borderSide: const BorderSide(
          color: Colors.red,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(7),
        borderSide: const BorderSide(
          color: Colors.red,
          width: 1.5,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isAndroid = Theme.of(context).platform == TargetPlatform.android;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        body: Column(
          children: [
            // Header Bar
            Container(
              color: AppColors.primary,
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushAndRemoveUntil(
                            PageRouteBuilder(
                              pageBuilder: (context, anim1, anim2) =>
                                  const MainNavigationScreen(),
                              transitionDuration: Duration.zero,
                              reverseTransitionDuration: Duration.zero,
                            ),
                            (route) => false,
                          );
                        },
                        child: RichText(
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                text: 'VietMade',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.5,
                                  fontWeight: FontWeight.w900,
                                  fontStyle: FontStyle.italic,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              TextSpan(
                                text: '.vn',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.5,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Form Container - Vertically Centered Card
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isCompact = isAndroid || constraints.maxHeight < 680;
                  final fieldSpacing = isCompact ? 3.0 : 6.0;
                  final verticalInputPadding = isCompact ? 3.5 : 7.0;
                  final cardPadding = isCompact
                      ? const EdgeInsets.fromLTRB(14, 8, 14, 8)
                      : const EdgeInsets.fromLTRB(16, 14, 16, 14);

                  return SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: Container(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      child: Container(
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
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              'Tạo tài khoản VietMade.vn',
                              style: TextStyle(
                                fontSize: 11,
                                color: Color(0xFF64748B),
                              ),
                            ),
                            SizedBox(height: isCompact ? 6 : 10),

                            // Tên đăng nhập
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Tên đăng nhập',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF334155),
                                ),
                              ),
                            ),
                            const SizedBox(height: 2),
                            TextField(
                              controller: _userNameController,
                              onTap: () => _clearError('userName'),
                              onChanged: (_) {
                                if (_userNameError != null) _clearError('userName');
                              },
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF1E293B),
                              ),
                              decoration: _buildInputDecoration(
                                hintText: 'Nhập tên đăng nhập',
                                errorText: _userNameError,
                                verticalPadding: verticalInputPadding,
                              ),
                            ),
                            SizedBox(height: fieldSpacing),

                            // Row: Họ và tên đệm + Tên
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Họ và tên đệm',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF334155),
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      TextField(
                                        controller: _lastNameController,
                                        onTap: () => _clearError('lastName'),
                                        onChanged: (_) {
                                          if (_lastNameError != null) _clearError('lastName');
                                        },
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF1E293B),
                                        ),
                                        decoration: _buildInputDecoration(
                                          hintText: 'Nguyễn Văn',
                                          errorText: _lastNameError,
                                          verticalPadding: verticalInputPadding,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Tên',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF334155),
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      TextField(
                                        controller: _firstNameController,
                                        onTap: () => _clearError('firstName'),
                                        onChanged: (_) {
                                          if (_firstNameError != null) _clearError('firstName');
                                        },
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF1E293B),
                                        ),
                                        decoration: _buildInputDecoration(
                                          hintText: 'An',
                                          errorText: _firstNameError,
                                          verticalPadding: verticalInputPadding,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: fieldSpacing),

                            // Email
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Email',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF334155),
                                ),
                              ),
                            ),
                            const SizedBox(height: 2),
                            TextField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              onTap: () => _clearError('email'),
                              onChanged: (_) {
                                if (_emailError != null) _clearError('email');
                              },
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF1E293B),
                              ),
                              decoration: _buildInputDecoration(
                                hintText: 'example@gmail.com',
                                errorText: _emailError,
                                verticalPadding: verticalInputPadding,
                              ),
                            ),
                            SizedBox(height: fieldSpacing),

                            // Số điện thoại
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Số điện thoại',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF334155),
                                ),
                              ),
                            ),
                            const SizedBox(height: 2),
                            TextField(
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              onTap: () => _clearError('phone'),
                              onChanged: (_) {
                                if (_phoneError != null) _clearError('phone');
                              },
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF1E293B),
                              ),
                              decoration: _buildInputDecoration(
                                hintText: '0xxxxxxxxx',
                                errorText: _phoneError,
                                verticalPadding: verticalInputPadding,
                              ),
                            ),
                            SizedBox(height: fieldSpacing),

                            // Mật khẩu
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Mật khẩu',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF334155),
                                ),
                              ),
                            ),
                            const SizedBox(height: 2),
                            TextField(
                              controller: _passwordController,
                              obscureText: !_isPasswordVisible,
                              onTap: () => _clearError('password'),
                              onChanged: (_) {
                                if (_passwordError != null) _clearError('password');
                                if (_confirmPasswordController.text.isNotEmpty || _confirmPasswordError != null) {
                                  _validateConfirmPasswordLive();
                                }
                              },
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF1E293B),
                              ),
                              decoration: _buildInputDecoration(
                                hintText: 'Nhập mật khẩu',
                                errorText: _passwordError,
                                verticalPadding: verticalInputPadding,
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _isPasswordVisible = !_isPasswordVisible;
                                    });
                                  },
                                  child: Icon(
                                    _isPasswordVisible
                                        ? LucideIcons.eye
                                        : LucideIcons.eyeOff,
                                    size: 16,
                                    color: const Color(0xFF94A3B8),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: fieldSpacing),

                            // Nhập lại mật khẩu
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Nhập lại mật khẩu',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF334155),
                                ),
                              ),
                            ),
                            const SizedBox(height: 2),
                            TextField(
                              controller: _confirmPasswordController,
                              obscureText: !_isConfirmPasswordVisible,
                              onTap: _validateConfirmPasswordLive,
                              onChanged: (_) => _validateConfirmPasswordLive(),
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF1E293B),
                              ),
                              decoration: _buildInputDecoration(
                                hintText: 'Nhập lại mật khẩu',
                                errorText: _confirmPasswordError,
                                verticalPadding: verticalInputPadding,
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _isConfirmPasswordVisible =
                                          !_isConfirmPasswordVisible;
                                    });
                                  },
                                  child: Icon(
                                    _isConfirmPasswordVisible
                                        ? LucideIcons.eye
                                        : LucideIcons.eyeOff,
                                    size: 16,
                                    color: const Color(0xFF94A3B8),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: isCompact ? 5 : 8),

                            // Password Requirements Note Container
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: isCompact ? 4 : 6,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF8FAFC),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                'Ít nhất 8 ký tự, gồm chữ thường, chữ hoa, số và ký tự đặc biệt @\$%^*&.',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Color(0xFF64748B),
                                  height: 1.25,
                                ),
                              ),
                            ),
                            SizedBox(height: isCompact ? 6 : 10),

                            // Primary Register Button
                            SizedBox(
                              width: double.infinity,
                              height: isCompact ? 36 : 40,
                              child: ElevatedButton(
                                onPressed: _handleRegister,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(7),
                                  ),
                                ),
                                child: const Text(
                                  'Đăng ký',
                                  style: TextStyle(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: isCompact ? 6 : 10),

                            // Footer Link to Login
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Đã có tài khoản? ',
                                  style: TextStyle(
                                    fontSize: 11.5,
                                    color: Color(0xFF64748B),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      PageRouteBuilder(
                                        pageBuilder: (context, anim1, anim2) =>
                                            const LoginScreen(),
                                        transitionDuration: Duration.zero,
                                        reverseTransitionDuration: Duration.zero,
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    'Đăng nhập',
                                    style: TextStyle(
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

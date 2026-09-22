import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../services/auth_service.dart';
import '../../widgets/auth/auth_header_bar.dart';
import '../../widgets/auth/register/register_form_card.dart';
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
            const AuthHeaderBar(),

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
                      child: RegisterFormCard(
                        userNameController: _userNameController,
                        lastNameController: _lastNameController,
                        firstNameController: _firstNameController,
                        emailController: _emailController,
                        phoneController: _phoneController,
                        passwordController: _passwordController,
                        confirmPasswordController: _confirmPasswordController,
                        isPasswordVisible: _isPasswordVisible,
                        isConfirmPasswordVisible: _isConfirmPasswordVisible,
                        userNameError: _userNameError,
                        lastNameError: _lastNameError,
                        firstNameError: _firstNameError,
                        emailError: _emailError,
                        phoneError: _phoneError,
                        passwordError: _passwordError,
                        confirmPasswordError: _confirmPasswordError,
                        onClearError: _clearError,
                        onValidateConfirmPasswordLive: _validateConfirmPasswordLive,
                        onTogglePasswordVisibility: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                        onToggleConfirmPasswordVisibility: () {
                          setState(() {
                            _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                          });
                        },
                        onRegisterPressed: _handleRegister,
                        onLoginTap: () {
                          Navigator.of(context).push(
                            PageRouteBuilder(
                              pageBuilder: (context, anim1, anim2) =>
                                  const LoginScreen(),
                              transitionDuration: Duration.zero,
                              reverseTransitionDuration: Duration.zero,
                            ),
                          );
                        },
                        isCompact: isCompact,
                        fieldSpacing: fieldSpacing,
                        verticalInputPadding: verticalInputPadding,
                        cardPadding: cardPadding,
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

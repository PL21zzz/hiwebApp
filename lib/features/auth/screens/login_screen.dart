import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hiweb_app_management/features/auth/services/auth_service.dart';
import 'package:hiweb_app_management/features/auth/widgets/auth_header_bar.dart';
import 'package:hiweb_app_management/features/auth/widgets/cloudflare_captcha_modal.dart';
import 'package:hiweb_app_management/features/auth/widgets/login/login_form_card.dart';
import 'package:hiweb_app_management/core/widgets/common/dialogs/top_notification.dart';
import 'package:hiweb_app_management/features/navigation/screens/main_navigation_screen.dart';
import 'package:hiweb_app_management/features/auth/screens/register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _rememberMe = true;

  String? _emailError;
  String? _passwordError;
  int _failedAttempts = 0;

  @override
  void initState() {
    super.initState();
    final remembered = AuthService.instance.getRememberedCredentials();
    if (remembered != null) {
      _emailController.text = remembered['identifier'] ?? '';
      _passwordController.text = remembered['password'] ?? '';
      _rememberMe = true;
    } else {
      _rememberMe = false;
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool _validateLoginForm() {
    setState(() {
      _emailError = null;
      _passwordError = null;
    });

    bool isValid = true;
    final identifier = _emailController.text.trim();
    final password = _passwordController.text;

    if (identifier.isEmpty) {
      _emailError = 'Vui lòng nhập email hoặc tên đăng nhập';
      isValid = false;
    } else if (identifier.contains('@')) {
      final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
      if (!emailRegex.hasMatch(identifier)) {
        _emailError = 'Email không hợp lệ (VD: name@domain.com)';
        isValid = false;
      }
    } else if (identifier.contains(' ')) {
      _emailError = 'Tên đăng nhập không được chứa khoảng trắng';
      isValid = false;
    }

    if (password.isEmpty) {
      _passwordError = 'Vui lòng nhập mật khẩu';
      isValid = false;
    }

    setState(() {});
    return isValid;
  }

  Future<void> _handleLogin() async {
    // 1. Check CAPTCHA lockout
    if (_failedAttempts >= 5) {
      final verified = await CloudflareCaptchaModal.show(context);
      if (verified == true) {
        setState(() {
          _failedAttempts = 0;
        });
      } else {
        return;
      }
    }

    // 2. Validate form
    if (!_validateLoginForm()) {
      return;
    }

    final identifier = _emailController.text.trim();
    final password = _passwordController.text;

    // 3. Authenticate
    final result = AuthService.instance.login(identifier, password);

    if (result.isSuccess) {
      if (_rememberMe) {
        AuthService.instance.saveRememberedCredentials(identifier, password);
      } else {
        AuthService.instance.clearRememberedCredentials();
      }

      setState(() {
        _failedAttempts = 0;
      });
      if (!mounted) return;
      TopNotification.show(
        context,
        message: 'Đăng nhập thành công!',
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
      setState(() {
        _failedAttempts++;
        _passwordController.clear();
      });

      if (!mounted) return;

      TopNotification.show(
        context,
        message: 'Tên đăng nhập hoặc mật khẩu không đúng.',
        isError: true,
      );

      if (_failedAttempts >= 5) {
        final verified = await CloudflareCaptchaModal.show(context);
        if (verified == true) {
          setState(() {
            _failedAttempts = 0;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
            // Header Top Bar
            const AuthHeaderBar(),

            // Main Content Area - Vertically Centered Card
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight - 24,
                      ),
                      child: Center(
                        child: LoginFormCard(
                          emailController: _emailController,
                          passwordController: _passwordController,
                          isPasswordVisible: _isPasswordVisible,
                          onTogglePasswordVisibility: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                          rememberMe: _rememberMe,
                          onRememberMeChanged: (val) {
                            setState(() {
                              _rememberMe = val ?? false;
                            });
                          },
                          emailError: _emailError,
                          passwordError: _passwordError,
                          onLoginPressed: _handleLogin,
                          onGoogleLoginPressed: () {},
                          onRegisterTap: () {
                            Navigator.of(context).push(
                              PageRouteBuilder(
                                pageBuilder: (context, anim1, anim2) =>
                                    const RegisterScreen(),
                                transitionDuration: Duration.zero,
                                reverseTransitionDuration: Duration.zero,
                              ),
                            );
                          },
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

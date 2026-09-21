import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../models/auth/user_model.dart';
import '../../services/auth_service.dart';
import '../../theme/app_colors.dart';
import '../../widgets/auth/cloudflare_captcha_modal.dart';
import '../../widgets/common/top_notification.dart';
import '../main_navigation_screen.dart';
import 'register_screen.dart';

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

  InputDecoration _buildInputDecoration({
    required String hintText,
    required IconData prefixIcon,
    Widget? suffixIcon,
    String? errorText,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
      errorText: errorText,
      errorStyle: const TextStyle(fontSize: 10.5, color: Colors.red, height: 1.1),
      prefixIcon: Icon(prefixIcon, size: 16, color: const Color(0xFF94A3B8)),
      suffixIcon: suffixIcon,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(7),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(7),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(7),
        borderSide: const BorderSide(color: AppColors.primary),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(7),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(7),
        borderSide: const BorderSide(color: Colors.red, width: 1.5),
      ),
    );
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
                        child: Container(
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
                                  fontSize: 18.5,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1E293B),
                                ),
                              ),
                              const SizedBox(height: 3),
                              const Text(
                                'Đăng nhập vào tài khoản của bạn.',
                                style: TextStyle(
                                  fontSize: 11.5,
                                  color: Color(0xFF64748B),
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Email / Username Input
                              const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Email hoặc tên đăng nhập',
                                  style: TextStyle(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF334155),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              TextField(
                                controller: _emailController,
                                style: const TextStyle(
                                  fontSize: 12.5,
                                  color: Color(0xFF1E293B),
                                ),
                                decoration: _buildInputDecoration(
                                  hintText: 'Nhập email hoặc tên đăng nhập',
                                  prefixIcon: LucideIcons.user,
                                  errorText: _emailError,
                                ),
                              ),
                              const SizedBox(height: 12),

                              // Password Input
                              const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Mật khẩu',
                                  style: TextStyle(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF334155),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              TextField(
                                controller: _passwordController,
                                obscureText: !_isPasswordVisible,
                                style: const TextStyle(
                                  fontSize: 12.5,
                                  color: Color(0xFF1E293B),
                                ),
                                decoration: _buildInputDecoration(
                                  hintText: 'Nhập mật khẩu',
                                  prefixIcon: LucideIcons.lock,
                                  errorText: _passwordError,
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
                              const SizedBox(height: 6),

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
                                          value: _rememberMe,
                                          activeColor: AppColors.primary,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(3),
                                          ),
                                          onChanged: (val) {
                                            setState(() {
                                              _rememberMe = val ?? false;
                                            });
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      const Text(
                                        'Ghi nhớ đăng nhập',
                                        style: TextStyle(
                                          fontSize: 11.5,
                                          color: Color(0xFF334155),
                                        ),
                                      ),
                                    ],
                                  ),
                                   GestureDetector(
                                     onTap: () {},
                                     child: const Text(
                                       'Quên mật khẩu?',
                                       style: TextStyle(
                                         fontSize: 11.5,
                                         fontWeight: FontWeight.w600,
                                         color: Color(0xFF116B81),
                                       ),
                                     ),
                                   ),
                                ],
                              ),
                              const SizedBox(height: 14),

                              // Main Login Button
                              SizedBox(
                                width: double.infinity,
                                height: 40,
                                child: ElevatedButton(
                                  onPressed: _handleLogin,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(7),
                                    ),
                                  ),
                                  child: const Text(
                                    'Đăng nhập',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 14),

                              // Divider "HOẶC"
                              const Row(
                                children: [
                                  Expanded(
                                    child: Divider(color: Color(0xFFE2E8F0), thickness: 0.8),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 8),
                                    child: Text(
                                      'HOẶC',
                                      style: TextStyle(
                                        fontSize: 10,
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
                              const SizedBox(height: 14),

                              // Google Button
                              SizedBox(
                                width: double.infinity,
                                height: 38,
                                child: OutlinedButton(
                                  onPressed: () {},
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
                              ),
                              const SizedBox(height: 16),

                              // Register Link
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Chưa có tài khoản? ',
                                    style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        PageRouteBuilder(
                                          pageBuilder: (context, anim1, anim2) =>
                                              const RegisterScreen(),
                                          transitionDuration: Duration.zero,
                                          reverseTransitionDuration: Duration.zero,
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      'Đăng ký',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF116B81),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
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

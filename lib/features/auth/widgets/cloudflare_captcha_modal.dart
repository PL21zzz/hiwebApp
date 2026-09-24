import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:hiweb_app_management/core/theme/app_colors.dart';

class CloudflareCaptchaModal extends StatefulWidget {
  const CloudflareCaptchaModal({super.key});

  static Future<bool?> show(BuildContext context) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const CloudflareCaptchaModal(),
    );
  }

  @override
  State<CloudflareCaptchaModal> createState() => _CloudflareCaptchaModalState();
}

class _CloudflareCaptchaModalState extends State<CloudflareCaptchaModal> {
  bool _isChecking = false;
  bool _isVerified = false;
  Timer? _verifyTimer;

  @override
  void dispose() {
    _verifyTimer?.cancel();
    super.dispose();
  }

  void _onCheckboxTap() {
    if (_isChecking || _isVerified) return;

    setState(() {
      _isChecking = true;
    });

    _verifyTimer = Timer(const Duration(milliseconds: 1400), () {
      if (mounted) {
        setState(() {
          _isChecking = false;
          _isVerified = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 10,
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Cloudflare Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF6821F).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    LucideIcons.shieldCheck,
                    color: Color(0xFFF6821F),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Cloudflare Turnstile',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      Text(
                        'Xác minh bảo mật đăng nhập',
                        style: TextStyle(
                          fontSize: 11.5,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 20, color: Color(0xFF94A3B8)),
                  onPressed: () => Navigator.of(context).pop(false),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Warning Notice
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFBEB),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFFCD34D)),
              ),
              child: const Row(
                children: [
                  Icon(LucideIcons.alertTriangle, size: 16, color: Color(0xFFD97706)),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Bạn đã đăng nhập sai 5 lần. Vui lòng tick chọn xác minh bên dưới.',
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFF92400E),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Turnstile Widget Box
            GestureDetector(
              onTap: _onCheckboxTap,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: _isVerified
                        ? const Color(0xFF22C55E)
                        : const Color(0xFFCBD5E1),
                    width: _isVerified ? 1.5 : 1.0,
                  ),
                ),
                child: Row(
                  children: [
                    // Checkbox or Spinner or Checkmark
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: _isChecking
                          ? const SizedBox(
                              key: ValueKey('checking'),
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Color(0xFFF6821F),
                                ),
                              ),
                            )
                          : _isVerified
                              ? Container(
                                  key: const ValueKey('verified'),
                                  width: 24,
                                  height: 24,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF22C55E),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.check,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                )
                              : Container(
                                  key: const ValueKey('unchecked'),
                                  width: 22,
                                  height: 22,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(
                                      color: const Color(0xFF94A3B8),
                                      width: 1.8,
                                    ),
                                  ),
                                ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        _isVerified
                            ? 'Xác minh thành công!'
                            : _isChecking
                                ? 'Đang xác minh bảo mật...'
                                : 'Tôi không phải là người máy',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: _isVerified ? FontWeight.bold : FontWeight.w500,
                          color: _isVerified
                              ? const Color(0xFF15803D)
                              : const Color(0xFF334155),
                        ),
                      ),
                    ),
                    // Cloudflare mini logo tag
                    Column(
                      children: [
                        const Icon(
                          LucideIcons.cloud,
                          size: 16,
                          color: Color(0xFFF6821F),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Cloudflare',
                          style: TextStyle(
                            fontSize: 8.5,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 40,
              child: ElevatedButton(
                onPressed: _isVerified
                    ? () {
                        Navigator.of(context).pop(true);
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  disabledBackgroundColor: const Color(0xFFCBD5E1),
                  foregroundColor: Colors.white,
                  disabledForegroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Xác nhận & Tiếp tục',
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

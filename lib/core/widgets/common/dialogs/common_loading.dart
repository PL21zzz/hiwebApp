import 'package:flutter/material.dart';
import 'package:hiweb_app_management/core/theme/app_colors.dart';

class CommonLoading extends StatelessWidget {
  final String message;
  final Color color;
  final double size;
  final bool isOverlay;

  const CommonLoading({
    super.key,
    this.message = 'Đang tải...',
    this.color = AppColors.primary,
    this.size = 32,
    this.isOverlay = false,
  });

  /// Static helper to quickly show a non-dismissible loading dialog overlay over the current screen
  static void showOverlay(BuildContext context, {String message = 'Đang xử lý...'}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.35),
      builder: (_) => PopScope(
        canPop: false,
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: CommonLoading(message: message, isOverlay: true),
          ),
        ),
      ),
    );
  }

  /// Static helper to hide the loading overlay dialog
  static void hideOverlay(BuildContext context) {
    if (Navigator.of(context, rootNavigator: true).canPop()) {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: size,
                height: size,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    color.withValues(alpha: 0.2),
                  ),
                ),
              ),
              SizedBox(
                width: size,
                height: size,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
              ),
            ],
          ),
        ),
        if (message.isNotEmpty) ...[
          const SizedBox(height: 12),
          Text(
            message,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF475569),
              decoration: TextDecoration.none,
            ),
          ),
        ],
      ],
    );

    if (isOverlay) {
      return content;
    }

    return Center(child: content);
  }
}

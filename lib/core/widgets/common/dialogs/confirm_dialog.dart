import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class ConfirmDialog extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final Color? primaryColor;
  final String cancelText;
  final String confirmText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final bool isDangerous;

  const ConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    this.icon = LucideIcons.alertTriangle,
    this.primaryColor,
    this.cancelText = 'Hủy',
    this.confirmText = 'Đồng ý',
    this.onConfirm,
    this.onCancel,
    this.isDangerous = false,
  });

  static Future<bool?> show(
    BuildContext context, {
    required String title,
    required String message,
    IconData icon = LucideIcons.alertTriangle,
    Color? primaryColor,
    String cancelText = 'Hủy',
    String confirmText = 'Đồng ý',
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    bool isDangerous = false,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (context) => ConfirmDialog(
        title: title,
        message: message,
        icon: icon,
        primaryColor: primaryColor,
        cancelText: cancelText,
        confirmText: confirmText,
        onConfirm: onConfirm,
        onCancel: onCancel,
        isDangerous: isDangerous,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = primaryColor ??
        (isDangerous ? const Color(0xFFEF4444) : const Color(0xFFEF4444));

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 6,
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top Decorative Icon Badge
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF2F2),
                    shape: BoxShape.circle,
                  ),
                ),
                // Decorative sparkles / crosses matching sample image
                Positioned(
                  top: 4,
                  right: 8,
                  child: Icon(
                    Icons.add,
                    size: 10,
                    color: themeColor.withValues(alpha: 0.6),
                  ),
                ),
                Positioned(
                  bottom: 8,
                  left: 6,
                  child: Icon(
                    Icons.add,
                    size: 10,
                    color: themeColor.withValues(alpha: 0.6),
                  ),
                ),
                Positioned(
                  top: 14,
                  left: 10,
                  child: Container(
                    width: 4,
                    height: 4,
                    decoration: BoxDecoration(
                      color: themeColor.withValues(alpha: 0.5),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 12,
                  right: 12,
                  child: Container(
                    width: 4,
                    height: 4,
                    decoration: BoxDecoration(
                      color: themeColor.withValues(alpha: 0.5),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                // Main Centered Icon
                Icon(
                  icon,
                  size: 32,
                  color: themeColor,
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Title Text
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 17.5,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),

            const SizedBox(height: 8),

            // Description Message
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF64748B),
                height: 1.4,
              ),
            ),

            const SizedBox(height: 22),

            // Action Buttons Row
            Row(
              children: [
                // Cancel Button ("Quay lại" - Dark Slate/Grey style)
                Expanded(
                  child: SizedBox(
                    height: 42,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pop(false);
                        if (onCancel != null) onCancel!();
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: const BorderSide(
                          color: Color(0xFFCBD5E1),
                          width: 1.2,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        cancelText,
                        style: const TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF475569),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // Confirm Button (Red Accent Solid Elevated)
                Expanded(
                  child: SizedBox(
                    height: 42,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                        if (onConfirm != null) onConfirm!();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: themeColor,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        confirmText,
                        style: const TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

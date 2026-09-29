import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:hiweb_app_management/core/theme/app_colors.dart';

class ShareQrDialog extends StatelessWidget {
  final bool isVideoMode;
  final String title;
  final double price;
  final String Function(double) formatCurrency;

  const ShareQrDialog({
    super.key,
    required this.isVideoMode,
    required this.title,
    required this.price,
    required this.formatCurrency,
  });

  static Future<void> show(
    BuildContext context, {
    required bool isVideoMode,
    required String title,
    required double price,
    required String Function(double) formatCurrency,
  }) {
    return showDialog(
      context: context,
      builder:
          (context) => ShareQrDialog(
            isVideoMode: isVideoMode,
            title: title,
            price: price,
            formatCurrency: formatCurrency,
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isVideoMode ? 'Mã QR Video' : 'Mã QR Sản Phẩm',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
                IconButton(
                  icon: const Icon(LucideIcons.x, size: 20),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: const Center(
                child: Icon(
                  LucideIcons.qrCode,
                  size: 130,
                  color: Color(0xFF0F5A6E),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF334155),
              ),
            ),
            if (!isVideoMode) ...[
              const SizedBox(height: 8),
              Text(
                formatCurrency(price),
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFE53935),
                ),
              ),
            ],
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        isVideoMode
                            ? 'Đã tải mã QR video về thiết bị'
                            : 'Đã tải mã QR về thiết bị',
                      ),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
                icon: const Icon(LucideIcons.download, size: 16),
                label: const Text('Lưu mã QR'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
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

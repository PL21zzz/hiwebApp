import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:hiweb_app_management/features/chat/screens/messages_screen.dart';
import 'share_item_button.dart';
import 'share_qr_dialog.dart';

class ShareActionsGrid extends StatelessWidget {
  final bool isVideoMode;
  final String title;
  final double price;
  final String Function(double) formatCurrency;

  const ShareActionsGrid({
    super.key,
    required this.isVideoMode,
    required this.title,
    required this.price,
    required this.formatCurrency,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShareItemButton(
            iconWidget: ShareItemButton.buildCircleButton(
              bgColor: const Color(0xFF0F5A6E),
              icon: LucideIcons.qrCode,
            ),
            label: 'Mã QR',
            onTap: () {
              Navigator.pop(context);
              ShareQrDialog.show(
                context,
                isVideoMode: isVideoMode,
                title: title,
                price: price,
                formatCurrency: formatCurrency,
              );
            },
          ),
          ShareItemButton(
            iconWidget: ShareItemButton.buildCircleButton(
              bgColor: const Color(0xFF0284C7),
              icon: LucideIcons.send,
            ),
            label: 'VietMade Chat',
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MessagesScreen()),
              );
            },
          ),
          if (isVideoMode) ...[
            ShareItemButton(
              iconWidget: ShareItemButton.buildCircleButton(
                bgColor: const Color(0xFF64748B),
                icon: LucideIcons.eyeOff,
              ),
              label: 'Không thích',
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Đã ẩn các video tương tự'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
            ),
            ShareItemButton(
              iconWidget: ShareItemButton.buildCircleButton(
                bgColor: const Color(0xFFEF4444),
                icon: LucideIcons.flag,
              ),
              label: 'Báo cáo',
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Đã gửi báo cáo nội dung video'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
            ),
          ] else ...[
            ShareItemButton(
              iconWidget: ShareItemButton.buildCircleButton(
                bgColor: const Color(0xFFF59E0B),
                icon: LucideIcons.gift,
              ),
              label: 'Thưởng 20K',
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Link tiếp thị thưởng 20k đã tạo!'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}

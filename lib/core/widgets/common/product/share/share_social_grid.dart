import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'share_item_button.dart';

class ShareSocialGrid extends StatelessWidget {
  final bool isVideoMode;
  final String videoId;

  const ShareSocialGrid({
    super.key,
    required this.isVideoMode,
    this.videoId = '',
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
            iconWidget: ShareItemButton.buildTextCircleButton(
              bgColor: const Color(0xFF0068FF),
              text: 'Zalo',
            ),
            label: 'Zalo',
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    isVideoMode
                        ? 'Mở Zalo chia sẻ video...'
                        : 'Mở ứng dụng Zalo...',
                  ),
                ),
              );
            },
          ),
          ShareItemButton(
            iconWidget: ShareItemButton.buildCircleButton(
              bgColor: const Color(0xFF1877F2),
              icon: LucideIcons.facebook,
            ),
            label: 'Facebook',
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    isVideoMode
                        ? 'Đăng video lên Facebook...'
                        : 'Mở ứng dụng Facebook...',
                  ),
                ),
              );
            },
          ),
          ShareItemButton(
            iconWidget: ShareItemButton.buildCircleButton(
              bgColor: const Color(0xFF0084FF),
              icon: LucideIcons.messageCircle,
            ),
            label: 'Messenger',
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Mở Messenger...')),
              );
            },
          ),
          ShareItemButton(
            iconWidget: ShareItemButton.buildCircleButton(
              bgColor: const Color(0xFFF1F5F9),
              icon: LucideIcons.copy,
              iconColor: const Color(0xFF0F5A6E),
            ),
            label: 'Sao chép',
            onTap: () {
              Clipboard.setData(
                ClipboardData(
                  text:
                      isVideoMode
                          ? 'https://vietmade.vn/video/$videoId'
                          : 'https://vietmade.vn/product/share',
                ),
              );
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    isVideoMode
                        ? 'Đã sao chép liên kết video'
                        : 'Đã sao chép liên kết sản phẩm',
                  ),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
          ),
          ShareItemButton(
            iconWidget: ShareItemButton.buildCircleButton(
              bgColor: const Color(0xFFF1F5F9),
              icon: LucideIcons.download,
              iconColor: const Color(0xFF0F5A6E),
            ),
            label: isVideoMode ? 'Tải video' : 'Lưu ảnh',
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    isVideoMode
                        ? 'Đang tải video MP4 về thiết bị...'
                        : 'Đã tải ảnh sản phẩm về thư viện',
                  ),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
          ),
          ShareItemButton(
            iconWidget: ShareItemButton.buildCircleButton(
              bgColor: const Color(0xFF10B981),
              icon: LucideIcons.mail,
            ),
            label: 'Tin nhắn/SMS',
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Gửi qua SMS...')),
              );
            },
          ),
        ],
      ),
    );
  }
}

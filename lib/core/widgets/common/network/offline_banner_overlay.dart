import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:hiweb_app_management/core/services/network_service.dart';
import 'package:hiweb_app_management/core/widgets/common/dialogs/top_notification.dart';

class OfflineBannerOverlay extends StatelessWidget {
  final Widget child;

  const OfflineBannerOverlay({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: NetworkService.instance,
      builder: (context, _) {
        final isOffline = NetworkService.instance.isOffline;
        final isChecking = NetworkService.instance.isChecking;

        return Stack(
          children: [
            child,
            if (isOffline)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Material(
                  color: Colors.transparent,
                  child: SafeArea(
                    bottom: false,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E293B),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.25),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Icon(LucideIcons.wifiOff, color: Color(0xFFF87171), size: 20),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'Không có kết nối Internet. Vui lòng kiểm tra lại 4G/Wi-Fi.',
                              style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
                            ),
                          ),
                          const SizedBox(width: 8),
                          InkWell(
                            onTap: isChecking
                                ? null
                                : () async {
                                    final reconnected = await NetworkService.instance.checkConnection();
                                    if (context.mounted && reconnected) {
                                      TopNotification.show(
                                        context,
                                        message: 'Đã khôi phục kết nối Internet',
                                        isError: false,
                                      );
                                    }
                                  },
                            borderRadius: BorderRadius.circular(6),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEF4444),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: isChecking
                                  ? const SizedBox(
                                      width: 12,
                                      height: 12,
                                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                    )
                                  : const Text(
                                      'Thử lại',
                                      style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

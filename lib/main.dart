import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:device_preview/device_preview.dart';
import 'package:hiweb_app_management/core/theme/app_theme.dart';
import 'package:hiweb_app_management/features/navigation/screens/main_navigation_screen.dart';
import 'package:hiweb_app_management/core/widgets/common/network/offline_banner_overlay.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Custom status bar: transparent background & white icons
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ),
  );

  // Optimize image cache memory to prevent OOM when streaming videos
  PaintingBinding.instance.imageCache.maximumSizeBytes = 40 << 20; // 40MB limit
  PaintingBinding.instance.imageCache.maximumSize = 100;

  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => const VietMadeApp(),
    ),
  );
}

class VietMadeApp extends StatelessWidget {
  const VietMadeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: DevicePreview.locale(context),
      builder: (context, child) {
        final previewChild = DevicePreview.appBuilder(context, child);
        return OfflineBannerOverlay(child: previewChild);
      },
      title: 'VIETMADE.vn',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const MainNavigationScreen(),
    );
  }
}

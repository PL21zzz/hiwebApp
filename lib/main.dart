import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:device_preview/device_preview.dart';
import 'package:hiweb_app_management/core/theme/app_theme.dart';
import 'package:hiweb_app_management/core/services/app_lifecycle_service.dart';
import 'package:hiweb_app_management/core/widgets/common/network/offline_banner_overlay.dart';
import 'package:hiweb_app_management/features/navigation/screens/main_navigation_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppLifecycleService.instance;

  // Lock device orientation to Portrait mode
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

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
      enabled: !kIsWeb && !kReleaseMode,
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
        return Builder(
          builder: (innerContext) {
            final mediaQuery = MediaQuery.of(innerContext);
            final screenWidth = mediaQuery.size.width;
            final widthScaleFactor = (screenWidth / 375.0).clamp(1.0, 1.25);
            final responsiveScaler = TextScaler.linear(widthScaleFactor).clamp(
              minScaleFactor: 1.0,
              maxScaleFactor: 1.35,
            );
            return MediaQuery(
              data: mediaQuery.copyWith(textScaler: responsiveScaler),
              child: OfflineBannerOverlay(child: previewChild),
            );
          },
        );
      },
      title: 'VIETMADE.vn',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const MainNavigationScreen(),
    );
  }
}

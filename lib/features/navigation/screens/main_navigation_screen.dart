import 'package:flutter/material.dart';
import 'package:hiweb_app_management/features/auth/services/auth_service.dart';
import 'package:hiweb_app_management/core/widgets/common/layout/vietmade_bottom_nav_bar.dart';
import 'package:hiweb_app_management/features/auth/screens/account_screen.dart';
import 'package:hiweb_app_management/features/auth/screens/login_screen.dart';
import 'package:hiweb_app_management/features/category/screens/categories_screen.dart';
import 'package:hiweb_app_management/features/home/screens/home_screen.dart';
import 'package:hiweb_app_management/features/video/screens/video_feed_screen.dart';
import 'package:hiweb_app_management/features/notification/screens/notifications_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  final int initialIndex;

  const MainNavigationScreen({
    super.key,
    this.initialIndex = 0,
  });

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    if (widget.initialIndex == 4 && !AuthService.instance.isLoggedIn) {
      _currentIndex = 0;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const LoginScreen(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
          (route) => false,
        );
      });
    } else {
      _currentIndex = widget.initialIndex;
    }
  }

  final List<Widget> _screens = const [
    HomeScreen(),
    CategoriesScreen(),
    VideoFeedScreen(),
    NotificationsScreen(),
    AccountScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: VietmadeBottomNavBar(
        selectedIndex: _currentIndex,
        onTap: (index) {
          if (index == 3) {
            setState(() => _currentIndex = index);
          } else if (index == 4) {
            if (!AuthService.instance.isLoggedIn) {
              Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      const LoginScreen(),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
                (route) => false,
              );
            } else {
              setState(() {
                _currentIndex = index;
              });
            }
          } else {
            setState(() {
              _currentIndex = index;
            });
          }
        },
      ),
    );
  }
}

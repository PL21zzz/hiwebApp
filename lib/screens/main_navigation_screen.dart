import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../widgets/common/vietmade_bottom_nav_bar.dart';
import 'auth/account_screen.dart';
import 'auth/login_screen.dart';
import 'category/categories_screen.dart';
import 'home_screen.dart';
import 'video/video_feed_screen.dart';
import 'notification/notifications_screen.dart';

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
        Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const LoginScreen(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
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
              Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      const LoginScreen(),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
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

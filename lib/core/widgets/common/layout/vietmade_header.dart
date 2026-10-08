import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons/lucide_icons.dart';

import 'package:hiweb_app_management/core/core.dart';
import 'package:hiweb_app_management/features/auth/auth.dart';
import 'package:hiweb_app_management/features/cart_checkout/cart_checkout.dart';
import 'package:hiweb_app_management/features/chat/chat.dart';
import 'package:hiweb_app_management/features/navigation/navigation.dart';
import 'package:hiweb_app_management/features/search/search.dart';

class VietmadeHeader extends StatelessWidget implements PreferredSizeWidget {
  final bool showMenu;

  const VietmadeHeader({
    super.key,
    this.showMenu = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(52);

  Widget _buildIconButton({
    required IconData icon,
    required VoidCallback onTap,
    int badgeCount = 0,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Icon(
              icon,
              size: 21,
              color: Colors.white,
            ),
            if (badgeCount > 0)
              Positioned(
                top: -3,
                right: -4,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  constraints: const BoxConstraints(
                    minWidth: 14,
                    minHeight: 14,
                  ),
                  decoration: const BoxDecoration(
                    color: Color(0xFFEF4444),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '$badgeCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 8.5,
                        fontWeight: FontWeight.bold,
                        height: 1.0,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Container(
        color: AppColors.header,
        child: SafeArea(
          bottom: false,
          child: Container(
            height: 52,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                // Hamburger Menu Button
                if (showMenu)
                  GestureDetector(
                    onTap: () {
                      Scaffold.of(context).openDrawer();
                    },
                    behavior: HitTestBehavior.opaque,
                    child: const Padding(
                      padding: EdgeInsets.only(right: 10, top: 4, bottom: 4),
                      child: Icon(
                        LucideIcons.menu,
                        size: 23,
                        color: Colors.white,
                      ),
                    ),
                  ),

                // Brand Logo "VietMade.vn"
                GestureDetector(
                  onTap: () {
                    Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            const MainNavigationScreen(initialIndex: 0),
                        transitionDuration: Duration.zero,
                        reverseTransitionDuration: Duration.zero,
                      ),
                      (route) => false,
                    );
                  },
                  child: RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: 'VietMade',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.5,
                            fontWeight: FontWeight.w900,
                            fontStyle: FontStyle.italic,
                            letterSpacing: -0.5,
                          ),
                        ),
                        TextSpan(
                          text: '.vn',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.5,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const Spacer(),

                // Action Icons (Search, Messages, Cart, Profile)
                Row(
                  children: [
                    _buildIconButton(
                      icon: LucideIcons.search,
                      onTap: () {
                        Navigator.of(context).push(
                          PageRouteBuilder(
                            pageBuilder: (context, animation, secondaryAnimation) =>
                                const SearchScreen(),
                            transitionDuration: Duration.zero,
                            reverseTransitionDuration: Duration.zero,
                          ),
                        );
                      },
                    ),
                    _buildIconButton(
                      icon: LucideIcons.messageSquare,
                      onTap: () {
                        Navigator.of(context).push(
                          PageRouteBuilder(
                            pageBuilder: (context, animation, secondaryAnimation) =>
                                const MessagesScreen(),
                            transitionDuration: Duration.zero,
                            reverseTransitionDuration: Duration.zero,
                          ),
                        );
                      },
                    ),
                    ListenableBuilder(
                      listenable: Listenable.merge([CartService.instance, AuthService.instance]),
                      builder: (context, _) {
                        final count = AuthService.instance.isLoggedIn
                            ? CartService.instance.totalItemCount
                            : 0;

                        return _buildIconButton(
                          icon: LucideIcons.shoppingCart,
                          badgeCount: count,
                          onTap: () {
                            if (!AuthService.instance.isLoggedIn) {
                              TopNotification.show(
                                context,
                                message: 'Bạn chưa đăng nhập!',
                                isError: true,
                              );
                              return;
                            }
                            Navigator.of(context).push(
                              PageRouteBuilder(
                                pageBuilder: (context, animation, secondaryAnimation) =>
                                    const CartScreen(),
                                transitionDuration: Duration.zero,
                                reverseTransitionDuration: Duration.zero,
                              ),
                            );
                          },
                        );
                      },
                    ),
                    _buildIconButton(
                      icon: LucideIcons.user,
                      onTap: () {
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
                          Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                            PageRouteBuilder(
                              pageBuilder: (context, animation, secondaryAnimation) =>
                                  const MainNavigationScreen(initialIndex: 4),
                              transitionDuration: Duration.zero,
                              reverseTransitionDuration: Duration.zero,
                            ),
                            (route) => false,
                          );
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

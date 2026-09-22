import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../screens/auth/account_screen.dart';
import '../../screens/auth/login_screen.dart';
import '../../screens/cart/cart_screen.dart';
import '../../screens/chat/messages_screen.dart';
import '../../screens/search/search_screen.dart';
import '../../services/auth_service.dart';
import '../../theme/app_colors.dart';

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
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
        child: Icon(
          icon,
          size: 21,
          color: Colors.white,
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
        color: AppColors.primary,
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
                    Navigator.of(context).popUntil((route) => route.isFirst);
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
                    _buildIconButton(
                      icon: LucideIcons.shoppingCart,
                      onTap: () {
                        Navigator.of(context).push(
                          PageRouteBuilder(
                            pageBuilder: (context, animation, secondaryAnimation) =>
                                const CartScreen(),
                            transitionDuration: Duration.zero,
                            reverseTransitionDuration: Duration.zero,
                          ),
                        );
                      },
                    ),
                    _buildIconButton(
                      icon: LucideIcons.user,
                      onTap: () {
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
                          Navigator.of(context).push(
                            PageRouteBuilder(
                              pageBuilder: (context, animation, secondaryAnimation) =>
                                  const AccountScreen(),
                              transitionDuration: Duration.zero,
                              reverseTransitionDuration: Duration.zero,
                            ),
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

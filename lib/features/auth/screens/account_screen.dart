import 'package:flutter/material.dart';
import 'package:hiweb_app_management/features/auth/services/auth_service.dart';
import 'package:hiweb_app_management/features/auth/screens/login_screen.dart';
import 'package:hiweb_app_management/features/user/profile/screens/user_profile_screen.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AuthService.instance,
      builder: (context, _) {
        if (AuthService.instance.isLoggedIn) {
          return UserProfileScreen(user: AuthService.instance.currentUser!);
        }
        return const LoginScreen();
      },
    );
  }
}

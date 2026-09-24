import 'package:flutter/material.dart';
import 'package:hiweb_app_management/features/auth/models/user_model.dart';
import 'package:hiweb_app_management/features/user/orders/screens/orders_screen.dart';
import 'package:hiweb_app_management/features/user/profile/widgets/profile_user_header_banner.dart';
import 'package:hiweb_app_management/features/user/profile/widgets/profile_user_logout_button.dart';
import 'package:hiweb_app_management/features/user/profile/widgets/profile_user_orders_card.dart';
import 'package:hiweb_app_management/features/user/profile/widgets/profile_user_quick_actions_card.dart';
import 'package:hiweb_app_management/features/user/profile/widgets/profile_user_recommendations_section.dart';
import 'package:hiweb_app_management/features/user/profile/widgets/profile_user_rewards_card.dart';
import 'package:hiweb_app_management/features/user/profile/widgets/profile_user_tools_grid.dart';
import 'package:hiweb_app_management/core/widgets/common/layout/vietmade_footer.dart';
import 'package:hiweb_app_management/core/widgets/common/layout/vietmade_header.dart';

class UserProfileScreen extends StatelessWidget {
  final UserModel user;

  const UserProfileScreen({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: const VietmadeHeader(showMenu: false),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top User Profile Banner
            ProfileUserHeaderBanner(user: user),
            const SizedBox(height: 8),

            // Rewards Card ("Trung tâm phần thưởng")
            ProfileUserRewardsCard(user: user),

            // Orders Card ("Đơn hàng của tôi")
            ProfileUserOrdersCard(
              onStatusTap: (tabIndex) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => OrdersScreen(initialTabIndex: tabIndex),
                  ),
                );
              },
            ),

            // Quick Product Actions Card
            const ProfileUserQuickActionsCard(),

            // Tools & Services Grid ("Công cụ & Dịch vụ")
            const ProfileUserToolsGrid(),

            // Logout Button
            const ProfileUserLogoutButton(),

            // Recommendations Section ("Gợi ý dành cho bạn")
            const ProfileUserRecommendationsSection(),

            const SizedBox(height: 120),
            const VietmadeFooter(),
          ],
        ),
      ),
    );
  }
}

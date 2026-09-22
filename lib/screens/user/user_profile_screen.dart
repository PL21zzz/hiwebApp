import 'package:flutter/material.dart';
import '../../models/user/user_model.dart';
import 'orders/orders_screen.dart';
import '../../widgets/user/profile/profile_user_header_banner.dart';
import '../../widgets/user/profile/profile_user_logout_button.dart';
import '../../widgets/user/profile/profile_user_orders_card.dart';
import '../../widgets/user/profile/profile_user_quick_actions_card.dart';
import '../../widgets/user/profile/profile_user_recommendations_section.dart';
import '../../widgets/user/profile/profile_user_rewards_card.dart';
import '../../widgets/user/profile/profile_user_tools_grid.dart';
import '../../widgets/common/vietmade_footer.dart';
import '../../widgets/common/vietmade_header.dart';

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

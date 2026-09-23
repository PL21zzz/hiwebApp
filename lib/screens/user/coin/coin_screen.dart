import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../services/auth_service.dart';
import '../../../theme/app_colors.dart';
import '../../../widgets/common/dialogs/top_notification.dart';
import '../../../widgets/common/layout/vietmade_footer.dart';
import '../../../widgets/user/coin/coin_daily_checkin_card.dart';
import '../../../widgets/user/coin/coin_game_banner_card.dart';

class CoinScreen extends StatefulWidget {
  const CoinScreen({super.key});

  @override
  State<CoinScreen> createState() => _CoinScreenState();
}

class _CoinScreenState extends State<CoinScreen> {
  int _claimedDays = 1;
  bool _hasClaimedToday = false;

  void _claimDailyCoins() {
    if (_hasClaimedToday) {
      TopNotification.show(
        context,
        message: 'Bạn đã nhận xu hôm nay rồi. Hãy quay lại vào ngày mai!',
        isError: false,
      );
      return;
    }

    setState(() {
      _hasClaimedToday = true;
      _claimedDays = (_claimedDays % 5) + 1;
    });

    TopNotification.show(
      context,
      message: 'Chúc mừng! Bạn đã nhận thành công +100 VietMade xu!',
      isError: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthService.instance.currentUser;
    final coins = user?.coins ?? 50;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF1F5F9),
        body: Column(
          children: [
            // Top Header Section
            Container(
              color: AppColors.header,
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 20),
                  child: Column(
                    children: [
                      // Back Button & Screen Title
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.of(context).pop(),
                            child: const Padding(
                              padding: EdgeInsets.all(4),
                              child: Icon(
                                LucideIcons.chevronLeft,
                                color: Colors.white,
                                size: 22,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Text(
                            'Ưu đãi VietMade xu',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Coin Balance Info Card
                      Row(
                        children: [
                          Container(
                            width: 38,
                            height: 38,
                            decoration: const BoxDecoration(
                              color: Color(0xFFFFB000),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: const Color(0xFFFFD765),
                                    width: 2,
                                  ),
                                ),
                                child: const Center(
                                  child: Text(
                                    'v',
                                    style: TextStyle(
                                      color: Color(0xFFFFF3A7),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '$coins',
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const Spacer(),

                          // History Button
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.25),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Row(
                              children: [
                                Text(
                                  'Lịch sử',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(width: 2),
                                Icon(
                                  LucideIcons.chevronRight,
                                  size: 14,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        children: [
                          // 1. Daily Check-in Card (Extracted Component)
                          CoinDailyCheckinCard(
                            claimedDays: _claimedDays,
                            hasClaimedToday: _hasClaimedToday,
                            onClaimTap: _claimDailyCoins,
                          ),
                          const SizedBox(height: 14),

                          // 2. Game Banner Card (Extracted Component)
                          const CoinGameBannerCard(),
                        ],
                      ),
                    ),

                    const SizedBox(height: 60),

                    // 3. VietMade Footer (Full Width, edge to edge)
                    const VietmadeFooter(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

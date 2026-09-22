import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../services/auth_service.dart';
import '../../../widgets/common/top_notification.dart';

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

  Widget _buildCheckInSlot(int dayIndex, String label, bool isToday, bool isClaimed) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 3),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        decoration: BoxDecoration(
          color: isToday ? const Color(0xFFF0F9FF) : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isToday ? const Color(0xFF0097B2) : const Color(0xFFE2E8F0),
            width: isToday ? 1.5 : 1,
          ),
        ),
        child: Column(
          children: [
            Text(
              '+100',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: isToday ? const Color(0xFF0097B2) : const Color(0xFF475569),
              ),
            ),
            const SizedBox(height: 6),
            Container(
              width: 28,
              height: 28,
              decoration: const BoxDecoration(
                color: Color(0xFFFFB000),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFFFFD765), width: 1.5),
                  ),
                  child: const Center(
                    child: Text(
                      'v',
                      style: TextStyle(
                        color: Color(0xFFFFF3A7),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: isToday ? FontWeight.bold : FontWeight.w500,
                color: isToday ? const Color(0xFF0097B2) : const Color(0xFF94A3B8),
              ),
            ),
          ],
        ),
      ),
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
            // Top Cyan Header Section matching media_1789982981383.png
            Container(
              color: const Color(0xFF0097B2),
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

                      // Balance Row: Coin Icon + 50 + History Pill
                      Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: const BoxDecoration(
                              color: Color(0xFFFFB000),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: const Color(0xFFFFD765),
                                    width: 1.8,
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
                                  Icons.chevron_right,
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // --- Card 1: Điểm Danh Nhận Xu ---
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.03),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                const Text(
                                  'Điểm Danh Nhận Xu',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic,
                                    color: Color(0xFF0097B2),
                                  ),
                                ),
                                const SizedBox(height: 14),

                                // 5 Slots Row
                                Row(
                                  children: [
                                    _buildCheckInSlot(1, 'Hôm nay', true, _hasClaimedToday),
                                    _buildCheckInSlot(2, 'Ngày 2', false, false),
                                    _buildCheckInSlot(3, 'Ngày 3', false, false),
                                    _buildCheckInSlot(4, 'Ngày 4', false, false),
                                    _buildCheckInSlot(5, 'Ngày 5', false, false),
                                  ],
                                ),
                                const SizedBox(height: 16),

                                // Action Button
                                SizedBox(
                                  width: double.infinity,
                                  height: 44,
                                  child: ElevatedButton(
                                    onPressed: _claimDailyCoins,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF0097B2),
                                      foregroundColor: Colors.white,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(22),
                                      ),
                                    ),
                                    child: Text(
                                      _hasClaimedToday
                                          ? 'Đã nhận xu hôm nay'
                                          : 'Nhận thêm 100 xu hôm nay!',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),

                          // --- Section 2: 1CLICK - NHẬN XU ---
                          const Text(
                            '1CLICK - NHẬN XU',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0097B2),
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Game Banner Container matching media_1789982981383.png
                          Container(
                      height: 280,
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xFF0284C7),
                            Color(0xFF0369A1),
                            Color(0xFF1E3A8A),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Stack(
                        children: [
                          // Top Right Floating Cart Icon
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Container(
                              width: 38,
                              height: 38,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                LucideIcons.shoppingCart,
                                color: Color(0xFF0284C7),
                                size: 18,
                              ),
                            ),
                          ),

                          // Center Game Graphic & Button
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  '100% TRÚNG XU',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w900,
                                    fontStyle: FontStyle.italic,
                                    color: Colors.white,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                const SizedBox(height: 16),

                                // Gift Box Icon with Glow Ring
                                Container(
                                  width: 90,
                                  height: 90,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white.withValues(alpha: 0.3),
                                      width: 1.5,
                                    ),
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      LucideIcons.gift,
                                      size: 42,
                                      color: Color(0xFFFFD700),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),

                                // Touch Button
                                ElevatedButton(
                                  onPressed: _claimDailyCoins,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFF59E0B),
                                    foregroundColor: Colors.white,
                                    elevation: 2,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 28,
                                      vertical: 10,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  child: const Text(
                                    'Chạm để nhận xu',
                                    style: TextStyle(
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                          ),
                        ],
                      ),
                    ),

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

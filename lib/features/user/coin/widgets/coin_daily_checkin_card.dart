import 'package:flutter/material.dart';

class CoinDailyCheckinCard extends StatelessWidget {
  final int claimedDays;
  final bool hasClaimedToday;
  final VoidCallback onClaimTap;

  const CoinDailyCheckinCard({
    super.key,
    required this.claimedDays,
    required this.hasClaimedToday,
    required this.onClaimTap,
  });

  Widget _buildCheckInSlot(
    int dayIndex,
    String label,
    bool isToday,
    bool isClaimed,
  ) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 3),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
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
                color:
                    isToday
                        ? const Color(0xFF0097B2)
                        : const Color(0xFF475569),
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
                    border: Border.all(
                      color: const Color(0xFFFFD765),
                      width: 1.5,
                    ),
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
                color:
                    isToday
                        ? const Color(0xFF0097B2)
                        : const Color(0xFF94A3B8),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Title: "Điểm Danh Nhận Xu" (Italic & Bold Teal)
          const Text(
            'Điểm Danh Nhận Xu',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w900,
              fontStyle: FontStyle.italic,
              color: Color(0xFF0097B2),
            ),
          ),
          const SizedBox(height: 16),

          // 5 Check-in Slots (Hôm nay, Ngày 2 -> Ngày 5)
          Row(
            children: [
              _buildCheckInSlot(
                1,
                'Hôm nay',
                claimedDays == 1,
                claimedDays >= 1,
              ),
              _buildCheckInSlot(
                2,
                'Ngày 2',
                claimedDays == 2,
                claimedDays >= 2,
              ),
              _buildCheckInSlot(
                3,
                'Ngày 3',
                claimedDays == 3,
                claimedDays >= 3,
              ),
              _buildCheckInSlot(
                4,
                'Ngày 4',
                claimedDays == 4,
                claimedDays >= 4,
              ),
              _buildCheckInSlot(
                5,
                'Ngày 5',
                claimedDays == 5,
                claimedDays >= 5,
              ),
            ],
          ),
          const SizedBox(height: 18),

          // Action Button: "Nhận thêm 100 xu hôm nay!" (Full width Cyan Button)
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton(
              onPressed: onClaimTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0097B2),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22),
                ),
              ),
              child: Text(
                hasClaimedToday
                    ? 'Đã nhận hôm nay'
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
    );
  }
}

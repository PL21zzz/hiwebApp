import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class SupportStep1TypeSelector extends StatelessWidget {
  final Function(String type, String label) onSelectType;

  const SupportStep1TypeSelector({
    super.key,
    required this.onSelectType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Option 1: Về Đơn hàng
        GestureDetector(
          onTap: () => onSelectType('order', 'Về Đơn hàng'),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF59E0B),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Icon(
                      LucideIcons.package,
                      size: 22,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Về Đơn hàng',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        'Giao thiếu, hỏng, sai sản phẩm, đổi/trả... -> Người bán xử lý',
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF64748B),
                          height: 1.25,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  LucideIcons.chevronRight,
                  size: 18,
                  color: Color(0xFFCBD5E1),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Option 2: Báo Lỗi
        GestureDetector(
          onTap: () => onSelectType('bug', 'Báo Lỗi'),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFF8B5CF6),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Icon(
                      LucideIcons.cog,
                      size: 22,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Báo Lỗi',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        'App/web lỗi, đăng nhập, thanh toán, tài khoản... -> VietMade xử lý',
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF64748B),
                          height: 1.25,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  LucideIcons.chevronRight,
                  size: 18,
                  color: Color(0xFFCBD5E1),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

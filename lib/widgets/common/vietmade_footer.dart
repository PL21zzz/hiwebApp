import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class VietmadeFooter extends StatelessWidget {
  const VietmadeFooter({super.key});

  Widget _buildSupportRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF94A3B8),
            fontSize: 13,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13.5,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildBadge(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.grey.shade300,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildSocialIcon(IconData icon) {
    return Container(
      width: 34,
      height: 34,
      decoration: const BoxDecoration(
        color: Color(0xFF1E293B),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.white, size: 16),
    );
  }

  Widget _buildSocialIconText(String text) {
    return Container(
      width: 34,
      height: 34,
      decoration: const BoxDecoration(
        color: Color(0xFF1E293B),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildAccordionTile(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13.5,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: Color(0xFF94A3B8),
            size: 18,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFF111827),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Hotline / CSKH Info
          _buildSupportRow('CSKH', '0932.888.300'),
          const SizedBox(height: 8),
          _buildSupportRow('Tổng đài', '1900 2054'),
          const SizedBox(height: 8),
          _buildSupportRow('Khiếu nại', '0911.888.300'),
          const SizedBox(height: 14),
          InkWell(
            onTap: () {},
            child: const Text(
              'Đăng ký gian hàng →',
              style: TextStyle(
                color: Color(0xFF38BDF8),
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Divider(color: Colors.white10),
          const SizedBox(height: 16),

          // 2. Email Newsletter
          const Text(
            'Nhận thông tin khuyến mãi',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.5,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Cập nhật sản phẩm và chương trình ưu đãi mới nhất.',
            style: TextStyle(
              color: Color(0xFF94A3B8),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F172A),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.white12),
                  ),
                  alignment: Alignment.centerLeft,
                  child: const TextField(
                    style: TextStyle(color: Colors.white, fontSize: 13),
                    decoration: InputDecoration(
                      hintText: 'Email của bạn',
                      hintStyle: TextStyle(color: Color(0xFF64748B), fontSize: 13),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE53935),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(80, 40),
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: const Text(
                  'ĐĂNG KÝ',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // 3. Payment Badges
          const Text(
            'Thanh toán',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.5,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              _buildBadge('VISA'),
              _buildBadge('MasterCard'),
              _buildBadge('JCB'),
              _buildBadge('Tiền mặt'),
              _buildBadge('Internet Banking'),
            ],
          ),
          const SizedBox(height: 20),

          // 4. Social Links
          const Text(
            'Kết nối với VietMade',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.5,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _buildSocialIcon(LucideIcons.facebook),
              const SizedBox(width: 10),
              _buildSocialIconText('X'),
              const SizedBox(width: 10),
              _buildSocialIcon(LucideIcons.youtube),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(color: Colors.white10),

          // 5. Expandable Links
          _buildAccordionTile('Hỗ trợ khách hàng'),
          const Divider(color: Colors.white10, height: 1),
          _buildAccordionTile('Danh mục sản phẩm'),
          const SizedBox(height: 24),

          // 6. Copyright Notice
          const Center(
            child: Text(
              '© 2026 VietMade.vn. All rights reserved.',
              style: TextStyle(
                color: Color(0xFF64748B),
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

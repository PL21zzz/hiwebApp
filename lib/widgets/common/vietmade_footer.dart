import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';

class VietmadeFooter extends StatelessWidget {
  const VietmadeFooter({super.key});

  Future<void> _launchSocialUrl(BuildContext context, String urlString) async {
    final uri = Uri.parse(urlString);
    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Mở liên kết: $urlString')),
        );
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Mở liên kết: $urlString')),
        );
      }
    }
  }

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

  Widget _buildSocialIcon(IconData icon, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 34,
        height: 34,
        decoration: const BoxDecoration(
          color: Color(0xFF1E293B),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 16),
      ),
    );
  }

  Widget _buildSocialIconText(String text, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
              _buildSocialIcon(
                LucideIcons.facebook,
                onTap: () => _launchSocialUrl(context, 'https://www.facebook.com'),
              ),
              const SizedBox(width: 10),
              _buildSocialIconText(
                'X',
                onTap: () => _launchSocialUrl(context, 'https://x.com'),
              ),
              const SizedBox(width: 10),
              _buildSocialIcon(
                LucideIcons.youtube,
                onTap: () => _launchSocialUrl(context, 'https://www.youtube.com'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(color: Colors.white10),

          // 5. Expandable Links
          const _ExpandableFooterSection(
            title: 'Hỗ trợ khách hàng',
            items: _customerSupportItems,
          ),
          const Divider(color: Colors.white10, height: 1),
          const _ExpandableFooterSection(
            title: 'Danh mục sản phẩm',
            items: _productCategoryItems,
          ),
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

const List<String> _customerSupportItems = [
  'Giới thiệu',
  'Chính sách đổi trả',
  'Hướng dẫn đặt hàng',
  'Vận chuyển & Giao nhận',
  'Đăng ký bán hàng trên VietMade',
  'Cam kết bảo mật thông tin',
  'Liên hệ',
  'Quy chế hoạt động',
  'Sơ đồ Website',
];

const List<String> _productCategoryItems = [
  'Thực phẩm chức năng',
  'Mẹ và bé',
  'Đồng hồ',
  'Thiết bị chăm sóc sức khỏe',
  'Điện máy điện lạnh',
  'Văn phòng phẩm',
  'Thời trang hàng hiệu',
  'Chăm sóc cơ thể',
  'Chăm sóc tóc',
  'Thương hiệu',
  'Son môi',
  'Collagen chính hãng',
];

class _ExpandableFooterSection extends StatefulWidget {
  final String title;
  final List<String> items;

  const _ExpandableFooterSection({
    required this.title,
    required this.items,
  });

  @override
  State<_ExpandableFooterSection> createState() =>
      _ExpandableFooterSectionState();
}

class _ExpandableFooterSectionState extends State<_ExpandableFooterSection> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(
                  _isExpanded
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  color: const Color(0xFF94A3B8),
                  size: 20,
                ),
              ],
            ),
          ),
        ),
        if (_isExpanded)
          Padding(
            padding: const EdgeInsets.only(bottom: 12, top: 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.items.map((item) {
                return InkWell(
                  onTap: () {},
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Text(
                      item,
                      style: const TextStyle(
                        color: Color(0xFF94A3B8),
                        fontSize: 13,
                        height: 1.3,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }
}

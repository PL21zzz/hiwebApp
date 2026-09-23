import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class ProductCustomizationSection extends StatefulWidget {
  const ProductCustomizationSection({super.key});

  @override
  State<ProductCustomizationSection> createState() =>
      _ProductCustomizationSectionState();
}

class _ProductCustomizationSectionState
    extends State<ProductCustomizationSection> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tùy chỉnh sản phẩm',
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 8),
          const Text.rich(
            TextSpan(
              text: 'Nhập chữ tùy chỉnh',
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: Color(0xFF334155),
              ),
              children: [
                TextSpan(
                  text: ' *',
                  style: TextStyle(color: Color(0xFFEF4444)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Nhập nội dung chữ muốn in lên sản phẩm',
            style: TextStyle(fontSize: 9, color: Color(0xFF94A3B8)),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: _controller,
            maxLength: 100,
            maxLines: 4,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              hintText: 'VD: Hello, Tên của bạn...',
              hintStyle: const TextStyle(
                fontSize: 10,
                color: Color(0xFF94A3B8),
              ),
              counterText: '${_controller.text.length}/100',
              counterStyle: const TextStyle(
                fontSize: 8,
                color: Color(0xFF94A3B8),
              ),
              contentPadding: const EdgeInsets.fromLTRB(10, 8, 10, 5),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(color: AppColors.primary),
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Text.rich(
            TextSpan(
              text: 'Tải ảnh của bạn lên',
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: Color(0xFF334155),
              ),
              children: [
                TextSpan(
                  text: ' *',
                  style: TextStyle(color: Color(0xFFEF4444)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Container(
            height: 84,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(
                color: const Color(0xFFCBD5E1),
                style: BorderStyle.solid,
              ),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.image_outlined, size: 21, color: Color(0xFF94A3B8)),
                SizedBox(height: 4),
                Text(
                  'Tải lên ảnh',
                  style: TextStyle(fontSize: 10, color: Color(0xFF334155)),
                ),
                Text(
                  'Chọn tối đa 1 ảnh',
                  style: TextStyle(fontSize: 8, color: Color(0xFF94A3B8)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hiweb_app_management/core/theme/app_colors.dart';

class ProductCustomizationSection extends StatefulWidget {
  final String initialText;
  final String? initialImagePath;
  final ValueChanged<String>? onTextChanged;
  final ValueChanged<String?>? onImageChanged;
  final double horizontalPadding;

  const ProductCustomizationSection({
    super.key,
    this.initialText = '',
    this.initialImagePath,
    this.onTextChanged,
    this.onImageChanged,
    this.horizontalPadding = 14,
  });

  @override
  State<ProductCustomizationSection> createState() =>
      _ProductCustomizationSectionState();
}

class _ProductCustomizationSectionState
    extends State<ProductCustomizationSection> {
  late final TextEditingController _controller;
  String? _imagePath;

  bool get hasText => _controller.text.trim().isNotEmpty;
  bool get hasImage => _imagePath != null && _imagePath!.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialText);
    _imagePath = widget.initialImagePath;
  }

  @override
  void didUpdateWidget(covariant ProductCustomizationSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialText != widget.initialText &&
        widget.initialText != _controller.text) {
      _controller.text = widget.initialText;
    }
    if (oldWidget.initialImagePath != widget.initialImagePath) {
      _imagePath = widget.initialImagePath;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked == null || !mounted) return;
    setState(() => _imagePath = picked.path);
    widget.onImageChanged?.call(picked.path);
  }

  void _removeImage() {
    setState(() => _imagePath = null);
    widget.onImageChanged?.call(null);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(
        widget.horizontalPadding,
        12,
        widget.horizontalPadding,
        14,
      ),
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
            onChanged: (value) {
              setState(() {});
              widget.onTextChanged?.call(value);
            },
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
          GestureDetector(
            onTap: _pickImage,
            child: Container(
              height: 84,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFCBD5E1)),
                borderRadius: BorderRadius.circular(6),
              ),
              clipBehavior: Clip.antiAlias,
              child:
                  hasImage
                      ? Stack(
                        fit: StackFit.expand,
                        children: [
                          Container(
                            color: const Color(0xFFF8FAFC),
                            padding: const EdgeInsets.all(6),
                            child: Image.file(
                              File(_imagePath!),
                              fit: BoxFit.contain,
                            ),
                          ),
                          Positioned(
                            top: 5,
                            right: 5,
                            child: GestureDetector(
                              onTap: _removeImage,
                              child: Container(
                                width: 22,
                                height: 22,
                                decoration: const BoxDecoration(
                                  color: Colors.black54,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.close,
                                  size: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                      : const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.image_outlined,
                            size: 21,
                            color: Color(0xFF94A3B8),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Tải lên ảnh',
                            style: TextStyle(
                              fontSize: 10,
                              color: Color(0xFF334155),
                            ),
                          ),
                          Text(
                            'Chọn tối đa 1 ảnh',
                            style: TextStyle(
                              fontSize: 8,
                              color: Color(0xFF94A3B8),
                            ),
                          ),
                        ],
                      ),
            ),
          ),
        ],
      ),
    );
  }
}

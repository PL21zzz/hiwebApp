import 'package:flutter/material.dart';
import 'package:hiweb_app_management/core/theme/app_colors.dart';

InputDecoration buildAuthInputDecoration({
  required String hintText,
  IconData? prefixIcon,
  Widget? suffixIcon,
  String? errorText,
  double verticalPadding = 9.0,
}) {
  return InputDecoration(
    hintText: hintText,
    hintStyle: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
    errorText: errorText,
    errorStyle: const TextStyle(fontSize: 10.5, color: Colors.red, height: 1.1),
    prefixIcon: prefixIcon != null
        ? Icon(prefixIcon, size: 16, color: const Color(0xFF94A3B8))
        : null,
    suffixIcon: suffixIcon != null
        ? Padding(
            padding: const EdgeInsets.only(right: 8),
            child: suffixIcon,
          )
        : null,
    suffixIconConstraints: const BoxConstraints(
      minWidth: 28,
      minHeight: 28,
    ),
    isDense: true,
    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: verticalPadding),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(7),
      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(7),
      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(7),
      borderSide: const BorderSide(color: AppColors.primary),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(7),
      borderSide: const BorderSide(color: Colors.red),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(7),
      borderSide: const BorderSide(color: Colors.red, width: 1.5),
    ),
  );
}

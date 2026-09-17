import 'package:flutter/material.dart';

class AppColors {
  // Brand Primary & Accent
  static const Color primary = Color(0xFF00A8E8);
  static const Color primaryDark = Color(0xFF0077B6);
  static const Color textWhite = Colors.white;
  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color background = Color(0xFFF5F7FA);
  static const Color cardBg = Colors.white;
  static const Color flashSaleRed = Color(0xFFFF3B30);
  static const Color productBoxBg = Color(0xFFBCEDF4); // Màu nền xanh nhạt chuẩn mã Hex #BCEDF4

  // Top Section Scrollable Background Gradient
  static const LinearGradient topSectionGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF00A8E8), // Cyan dưới Header
      Color(0xFF80D8FF), // Xanh nhạt qua Slider
      Color(0xFFE0F7FA), // Xanh phớt qua Category & Flash Sale
      Color(0xFFF5F7FA), // Chuyển hẳn sang nền trang
    ],
  );

  // Header Bar Gradient
  static const LinearGradient headerGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF0077B6),
      Color(0xFF00A8E8),
    ],
  );
}

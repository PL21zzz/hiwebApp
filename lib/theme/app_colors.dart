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

  // Seamless Top-to-Bottom Background Gradient (Xanh đậm -> Xanh nhạt -> Trắng/Xám)
  static const LinearGradient topBackgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF0088CC), // Đỉnh Header: Xanh đậm
      Color(0xFF00A8E8), // Header đến Banner: Cyan rực rỡ
      Color(0xFF80D8FF), // Dưới Banner: Xanh nhạt
      Color(0xFFE0F7FA), // Dưới Category: Xanh phớt nhẹ
      Color(0xFFF5F7FA), // Khối Flash Sale: Xám nhạt/trắng
    ],
    stops: [0.0, 0.20, 0.40, 0.55, 0.75],
  );

  // Header Gradient
  static const LinearGradient headerGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF0077B6),
      Color(0xFF00A8E8),
    ],
  );
}

import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF116B81);
  static const Color primaryDark = Color(0xFF0D5466);
  static const Color textWhite = Colors.white;
  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color background = Color(0xFFF5F7FA);
  static const Color cardBg = Colors.white;
  static const Color flashSaleRed = Color(0xFFFF3B30);
  static const Color productBoxBg = Color(0xFFBCEDF4);

  static const LinearGradient topSectionGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF116B81),
      Color(0xFF5BB2C6),
      Color(0xFFC7E8F0),
      Color(0xFFF5F7FA),
    ],
    stops: [0.0, 0.45, 0.85, 1.0],
  );

  static const LinearGradient headerGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF0D5466),
      Color(0xFF116B81),
    ],
  );
}

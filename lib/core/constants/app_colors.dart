import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF2196F3);
  static const Color primaryLight = Color(0xFF64B5F6);
  static const Color primaryDark = Color(0xFF1976D2);
  static const Color accent = Color(0xFF00BCD4);
  static const Color accentLight = Color(0xFF4DD0E1);

  static const Color backgroundStart = Color(0xFFE3F2FD);
  static const Color backgroundMiddle = Color(0xFF90CAF9);
  static const Color backgroundEnd = Color(0xFF42A5F5);

  static const Color textPrimary = Color(0xFF1565C0);
  static const Color textSecondary = Color(0xFF0D47A1);
  static const Color textLight = Colors.white;

  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color cardShadow = Color(0x1A000000);

  static const Color ripple = Color(0x4000BCD4);
  static const Color rippleLight = Color(0x2000BCD4);

  static const Color error = Color(0xFFE53935);
  static const Color success = Color(0xFF43A047);

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [backgroundStart, backgroundMiddle, backgroundEnd],
  );

  static const LinearGradient waterGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF64B5F6),
      Color(0xFF2196F3),
      Color(0xFF1976D2),
    ],
  );
}

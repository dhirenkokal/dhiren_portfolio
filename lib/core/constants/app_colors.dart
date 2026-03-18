import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Backgrounds
  static const Color background = Color(0xFF050A14);
  static const Color backgroundSecondary = Color(0xFF0A1628);
  static const Color cardBackground = Color(0xFF0D1929);
  static const Color cardBorder = Color(0xFF1A2840);
  static const Color terminalBackground = Color(0xFF020810);

  // Electric Blue Accent
  static const Color accent = Color(0xFF00B4FF);
  static const Color accentBright = Color(0xFF40CFFF);
  static const Color accentGlow = Color(0xFF0066FF);
  static const Color accentDim = Color(0xFF003366);

  // Text
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB0B8C8);
  static const Color textMuted = Color(0xFF5A6478);
  static const Color textTerminal = Color(0xFF00FF88);

  // Gradients
  static const List<Color> heroGradient = [
    Color(0xFF00B4FF),
    Color(0xFF0066FF),
  ];

  static const List<Color> meshGradient = [
    Color(0xFF050A14),
    Color(0xFF071220),
    Color(0xFF0A1628),
    Color(0xFF050A14),
  ];
}

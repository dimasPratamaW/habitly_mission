import 'package:flutter/material.dart';

class AppColors {
  final Color background;
  final Color textColor;
  final Color success;
  final Color border;
  final Color error;

  const AppColors({
    required this.background,
    required this.textColor,
    required this.success,
    required this.border,
    required this.error,
  });

  static AppColors of(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? dark : light;
  }

  static const light = AppColors(
    background: Color(0xFFE3FFDB),
    textColor: Color(0xFF1A1A1A),
    success: Color(0xFF16A34A),
    border: Colors.black,
    error: Color(0xFFDC2626),
  );

  static const dark = AppColors(
    background: Color(0xFFA7A7A7),
    textColor: Color(0xFFE6E6E6),
    success: Color(0xFF22C55E),
    border: Colors.black,
    error: Color(0xFFF87171),
  );
}

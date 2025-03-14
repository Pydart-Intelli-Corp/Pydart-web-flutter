import 'package:flutter/material.dart';

extension ColorParsing on Color {
  String toRGBACode() {
    return 'rgba($red,$green,$blue,$opacity)';
  }
}
// colors.dart

class AppColors {
  static const Color primary = Color(0xFF2A63FE); // Your brand primary
  static const Color secondary = Color(0xFF8B4DFF); // Your brand secondary
  static const Color accent = Color(0xFF00C9A7);
   static const Color deepBlue = Color(0xFF00172D);
  static const Color darkNavy = Color(0xFF000B18);
  static const Color accentBlue = Color(0xFF00A3FF);
  static const Color lightTeal = Color(0xFF00E5C2); // Add other colors as needed

  static const TextStyle buttonTextStyle = TextStyle(color: Colors.white);
    static const Color background = Color(0xFF0A192F);
  static const Color cardBackground = Color(0xFF172A45);
  
}
import 'package:flutter/material.dart';

extension ColorParsing on Color {
  String toRGBACode() {
    return 'rgba($red,$green,$blue,$opacity)';
  }
}
// colors.dart

class AppColors {
  static const Color primary = Color(0xFF2A63FE);
    static const Color pydart = Color.fromARGB(255, 0, 179, 171); // Your brand primary
  static const Color secondary = Color(0xFF8B4DFF); // Your brand secondary
  static const Color accent = Color(0xFF00C9A7);
   static const Color deepBlue = Color(0xFF00172D);
  static const Color darkNavy = Color(0xFF000B18);
  static const Color accentBlue = Color(0xFF00A3FF);
  static const Color lightTeal = Color(0xFF00E5C2); // Add other colors as needed
  static const Color primaryDark = Color(0xFF0A0F1F);
  static const Color glassBorder = Color(0xFF2A3447);
  static const Color primaryText = Color(0xFFE0E4EC);
 static const Color primarySurface = Color(0xFFF8FAFF);
 static const Color whitegrey = Colors.white70;
  static const Color accentTeal = Color(0xFF00C6C2);
  static const Color accentPurple = Color(0xFF7B61FF);
  static const Color scroll = Color.fromARGB(23, 32, 95, 122);

  static const TextStyle buttonTextStyle = TextStyle(color: Colors.white);
    static const Color background = Color(0xFF0A192F);
  static const Color cardBackground = Color(0xFF172A45);

  static const Gradient accentGradient = LinearGradient(
    colors: [Color(0xFF00E0FF), Color(0xFF00FF87)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient backgroundGradient = LinearGradient(
    colors: [darkNavy, background],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  static const Color deepSpace = Color(0xFF000814);
  static const Color cosmicPurple = Color(0xFF2A0944);
  static const Color neonPurple = Color(0xFFBC00FF);
  static const Color deepPurple = Color(0xFF3D087B);
  static const Color electricBlue = Color(0xFF00F5FF);
  static const Color oceanBlue = Color(0xFF3D7BFF);
  static const Color cyberGreen = Color(0xFF00FF9D);
  static const Color teal = Color(0xFF0EAB9C);
  static const Color neonPink = Color(0xFFFF006B);
  static const Color neonWhite = Color(0xFFF4F5FD);

  static const Gradient cyberGradient = LinearGradient(
    colors: [electricBlue, cyberGreen, neonPurple],
    stops: [0.1, 0.5, 0.9],
  );

  static const Gradient neonPinkGradient = LinearGradient(
    colors: [neonPink, Color(0xFFFF0099)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const Color secondaryDark = Color(0xFF000814);
  static const Color darkBlue = Color(0xFF2A0944);

}
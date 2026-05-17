import 'package:flutter/material.dart';

class AppStyles {
  // Colors
  static const Color primaryColor = Color(0xFF1565C0);
  static const Color accentColor = Color(0xFF03A9F4);
  static const Color adminColor = Color(0xFFE53935);
  static const Color clientColor = Color(0xFF43A047);
  static const Color backgroundDark = Color(0xFF0D47A1);
  static const Color backgroundAdmin = Color(0xFF1A237E);

  // Text Styles
  static const TextStyle titleStyle = TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    letterSpacing: 2,
  );

  static const TextStyle subtitleStyle = TextStyle(
    fontSize: 16,
    color: Colors.white70,
    letterSpacing: 4,
  );

  static const TextStyle headingStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static const TextStyle bodyStyle = TextStyle(
    fontSize: 14,
    color: Colors.white70,
  );

  static const TextStyle cardTitleStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static const TextStyle temperatureStyle = TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    shadows: [
      Shadow(
        color: Colors.black26,
        blurRadius: 10,
        offset: Offset(2, 2),
      ),
    ],
  );

  // Decorations
  static BoxDecoration get glassCardDecoration => BoxDecoration(
    color: Colors.white.withOpacity(0.1),
    borderRadius: BorderRadius.circular(20),
    border: Border.all(
      color: Colors.white.withOpacity(0.2),
      width: 1,
    ),
  );

  static BoxDecoration get searchDecoration => BoxDecoration(
    color: Colors.white.withOpacity(0.15),
    borderRadius: BorderRadius.circular(20),
    border: Border.all(
      color: Colors.white.withOpacity(0.3),
      width: 1,
    ),
  );

  // Input Decoration
  static InputDecoration searchInputDecoration({String? hint, Widget? suffixIcon}) => InputDecoration(
    hintText: hint,
    hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
    prefixIcon: Icon(Icons.search, color: Colors.white.withOpacity(0.7)),
    suffixIcon: suffixIcon,
    border: InputBorder.none,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
  );

  // Button Style
  static ButtonStyle get primaryButtonStyle => ElevatedButton.styleFrom(
    backgroundColor: primaryColor,
    foregroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    elevation: 4,
  );

  // SnackBar
  static SnackBar successSnack(String message) => SnackBar(
    content: Text(message),
    backgroundColor: Colors.green,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  );

  static SnackBar errorSnack(String message) => SnackBar(
    content: Text(message),
    backgroundColor: Colors.red,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  );
}

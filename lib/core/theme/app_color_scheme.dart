import 'package:flutter/material.dart';

class AppColorScheme {
  static ColorScheme _buildColorScheme(Brightness brightness) {
    if (brightness == Brightness.light) {
      return ColorScheme.fromSeed(
        seedColor: const Color(0xFFFF8C00),
        primary: const Color(0xFFFF8C00),
        secondary: const Color(0xFFFFA500),
        onPrimary: Colors.white,
        surface: const Color(0xFFFAFAFA),
        onSurface: Colors.black87,
        error: Colors.red,
        brightness: Brightness.light,
      );
    } else {
      return ColorScheme.fromSeed(
        seedColor: const Color(0xFFFF8C00),
        primary: const Color(0xFFFF8C00),
        secondary: const Color(0xFFFFA500),
        brightness: Brightness.dark,
      );
    }
  }

  static final ColorScheme lightColorScheme = _buildColorScheme(
    Brightness.light,
  );
  static final ColorScheme darkColorScheme = _buildColorScheme(Brightness.dark);
}

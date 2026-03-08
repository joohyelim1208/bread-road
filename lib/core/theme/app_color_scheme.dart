import 'package:flutter/material.dart';

class AppColorScheme {
  static ColorScheme _buildColorScheme(Brightness brightness) {
    return ColorScheme.fromSeed(
      // 브랜드 컬러
      seedColor: const Color.fromARGB(255, 255, 161, 9),
      brightness: brightness,
      // 특정 색상 지정이 필요하면 덮어쓰기 primary,
    );
  }

  static final ColorScheme lightColorScheme = _buildColorScheme(
    Brightness.light,
  );
  static final ColorScheme darkColorScheme = _buildColorScheme(Brightness.dark);
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:han_ppyeom/core/theme/app_color_scheme.dart';
import 'package:han_ppyeom/core/theme/app_text_theme.dart';

// 기본값 라이트 / 다크모드 상태 관리 프로바이더(상태 캡슐화)
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.light);

// colorScheme 프로바이더
final colorSchemeProvider = StateProvider<ColorScheme>((ref) {
  final mode = ref.watch(themeModeProvider);
  return mode == ThemeMode.dark
      ? AppColorScheme.darkColorScheme
      : AppColorScheme.lightColorScheme;
});

// textTheme 프로바이더
final TextThemeProvider = StateProvider((ref) {
  final mode = ref.watch(themeModeProvider);
  return mode == ThemeMode.dark
      ? AppTextTheme.darkTextTheme
      : AppTextTheme.lightTextTheme;
});

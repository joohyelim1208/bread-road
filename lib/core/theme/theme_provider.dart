import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:han_ppyeom/core/theme/app_color_scheme.dart';
import 'package:han_ppyeom/core/theme/app_text_theme.dart';
import 'package:han_ppyeom/core/theme/app_theme.dart';

// 기본값 라이트 / 다크모드 상태 관리 프로바이더(상태 캡슐화)-> 변경가능한 상태
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);

// themeData 자체를 반환하는 프로바이더 -> 단순 읽기전용. 분기처리
final themeProvider = Provider<ThemeData>((ref) {
  final mode = ref.watch(themeModeProvider);
  if (mode == ThemeMode.dark) {
    return AppTheme.darkTheme;
  }
  return AppTheme.lightTheme;
});

// colorScheme 프로바이더 -> 단순 읽기전용
final colorSchemeProvider = Provider<ColorScheme>((ref) {
  final mode = ref.watch(themeModeProvider);
  return mode == ThemeMode.dark
      ? AppColorScheme.darkColorScheme
      : AppColorScheme.lightColorScheme;
});

// textTheme 프로바이더 -> 단순 읽기 전용
final textThemeProvider = Provider((ref) {
  final mode = ref.watch(themeModeProvider);
  return mode == ThemeMode.dark
      ? AppTextTheme.darkTextTheme
      : AppTextTheme.lightTextTheme;
});

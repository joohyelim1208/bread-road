import 'package:flutter/material.dart';
import 'package:bread_road/core/theme/app_text_theme.dart';
import 'app_color_scheme.dart';

// 라이트/다크 모드의 모든 설정(색상, 텍스트, 버튼 스타일, 입력창 디자인 등)을 하나로 합쳐주는 최종 조립소 역할
class AppTheme {
  static ThemeData get lightTheme => ThemeData(
    fontFamily: 'Pretendard',
    useMaterial3: true,
    colorScheme: AppColorScheme.lightColorScheme,
    textTheme: AppTextTheme.lightTextTheme,
    inputDecorationTheme: _buildInputTheme(
      AppColorScheme.lightColorScheme,
      AppTextTheme.lightTextTheme,
    ),
    elevatedButtonTheme: _elevatedButtonTheme(
      AppColorScheme.lightColorScheme,
      AppTextTheme.lightTextTheme,
    ),
  );

  // 다크테마
  static ThemeData get darkTheme => ThemeData(
    fontFamily: 'Pretendard',
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: AppColorScheme.darkColorScheme,
    textTheme: AppTextTheme.darkTextTheme,
    inputDecorationTheme: _buildInputTheme(
      AppColorScheme.darkColorScheme,
      AppTextTheme.darkTextTheme,
    ),
    elevatedButtonTheme: _elevatedButtonTheme(
      AppColorScheme.darkColorScheme,
      AppTextTheme.darkTextTheme,
    ),
  );

  static ElevatedButtonThemeData _elevatedButtonTheme(
    ColorScheme colors,
    TextTheme texts,
  ) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        // 앞면에 표시되는 텍스트나 아이콘 색상
        // onPrimary 라이트 / 다크 모드 글자색 자동 선택되서 편리하다.
        foregroundColor: colors.onPrimary,
        backgroundColor: colors.primary,
        minimumSize: const Size.fromHeight(56),
        textStyle: texts.labelLarge,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      ),
    );
  }

  /// ==========================================================
  /// 텍스트 필드 디자인 (Minimal Input)
  /// ==========================================================
  static InputDecorationTheme _buildInputTheme(
    ColorScheme colors,
    TextTheme texts,
  ) {
    return InputDecorationTheme(
      filled: true,
      fillColor: colors.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      labelStyle: texts.bodyMedium,
      hintStyle: texts.bodyMedium?.copyWith(color: Colors.grey[400]),
      helperStyle: texts.labelSmall,
      errorStyle: texts.labelSmall?.copyWith(color: colors.error),
      border: WidgetStateInputBorder.resolveWith((states) {
        // 1. 에러가 포함될 때. 가장 먼저 체크
        if (states.contains(WidgetState.error)) {
          return OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(color: colors.error, width: 1.5),
          );
        }
        // 2. 포커스 받았을 때
        if (states.contains(WidgetState.focused)) {
          return OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(color: colors.primary, width: 1.5),
          );
        }
        // 3. 기본 디폴트 값
        return OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: colors.outlineVariant, width: 1),
        );
      }),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:han_ppyeom/core/theme/app_text_theme.dart';
import 'app_color_scheme.dart';

// 라이트/다크 모드의 모든 설정(색상, 텍스트, 버튼 스타일, 입력창 디자인 등)을 하나로 합쳐주는 최종 조립소 역할
class AppTheme {
  static ThemeData get lightTheme => ThemeData(
    fontFamily: 'Pretendard',
    useMaterial3: true,
    colorScheme: AppColorScheme.lightColorScheme,
    textTheme: AppTextTheme.lightTextTheme,
    inputDecorationTheme: _inputDecoraationTheme(Brightness.light),
    elevatedButtonTheme: _elevatedButtonTheme,
  );

  // 다크테마
  static ThemeData get darkTheme => ThemeData(
    fontFamily: 'Pretendard',
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: AppColorScheme.darkColorScheme,
    textTheme: AppTextTheme.darkTextTheme,
    inputDecorationTheme: _inputDecoraationTheme(Brightness.dark),
    elevatedButtonTheme: _elevatedButtonTheme,
  );

  static final _elevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: AppColorScheme.lightColorScheme.primary,
      minimumSize: const Size.fromHeight(56),
      textStyle: AppTextTheme.lightTextTheme.labelLarge,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
  );

  // 입력창 테마도 모드에 따라 대응 가능하게
  static InputDecorationTheme _inputDecoraationTheme(Brightness brightness) {
    final darkMode = brightness == Brightness.dark;
    // null safety 체크해줘야 오류안남
    final Color focusBorderColor = darkMode
        ? Colors.grey[400]!
        : Colors.grey[600]!;
    final Color defaultBorderColor = darkMode
        ? Colors.grey[400]!
        : Colors.grey[600]!;

    return InputDecorationTheme(
      hintStyle: TextStyle(
        fontSize: 16,
        // 다크모드면 힌트색상 더 밝게하기
        color: darkMode ? Colors.grey[400] : Colors.grey[600],
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      // 텍스트 테마 적용
      helperStyle: const TextStyle(),
      errorStyle: const TextStyle(height: 1),
      border: WidgetStateInputBorder.resolveWith((states) {
        print(states);
        // 1. 에러가 포함될 때. 가장 먼저 체크
        if (states.contains(WidgetState.error)) {
          return OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.red[200]!, width: 2),
          );
        }
        // 2. 포커스 받았을 때
        if (states.contains(WidgetState.focused)) {
          return OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: focusBorderColor, width: 2),
          );
        }
        // 3. 기본 디폴트 값
        return OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: defaultBorderColor, width: 1),
        );
      }),
    );
  }
}

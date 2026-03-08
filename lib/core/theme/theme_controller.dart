import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app_text_theme.dart';
import 'app_color_scheme.dart';

class ThemeController extends GetxController {
  // 현재 테마 모드를 확인한다
  bool get isDarkMode => Get.isDarkMode;
  // 텍스트 시스템 테마 상태에 따라 다크 / 라이트 테마를 반환
  TextTheme get textTheme =>
      isDarkMode ? AppTextTheme.darkTextTheme : AppTextTheme.lightTextTheme;
  // 색상 테마. getter의 반환 타입은 ColorScheme
  ColorScheme get colorScheme => isDarkMode
      ? AppColorScheme.darkColorScheme
      : AppColorScheme.lightColorScheme;
  // 테마 변경 기능. 필요 시 호출한다.
  void toggleTheme() {
    Get.changeThemeMode(isDarkMode ? ThemeMode.light : ThemeMode.dark);
    update(); // UI 업데이트 알림
  }
}

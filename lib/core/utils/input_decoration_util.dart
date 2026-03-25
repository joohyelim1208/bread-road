import 'package:flutter/material.dart';

class InputDecorationUtil {
  static InputDecoration commonDecoration({
    required BuildContext context,
    required String hintText,
    String? counterText,
    Widget? prefixIcon, // 텍스트 필드 내에서 고정될 텍스트
  }) {
    // final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return InputDecoration(
      hintText: hintText,
      counterText: counterText,
      prefixIcon: prefixIcon,
      filled: true,
      fillColor: Colors.white,
      // 기본상태
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
      ),
      // 포커스 상태
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: BorderSide(color: colorScheme.primary, width: 2),
      ),
      // 에러발생 시
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: BorderSide(color: colorScheme.error, width: 2),
      ),
      // 에러상황에서 선택했을 때
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: BorderSide(color: colorScheme.error, width: 2),
      ),

      // 힌트텍스트 스타일
      hintStyle: TextStyle(color: Colors.grey[500]),
    );
  }
}

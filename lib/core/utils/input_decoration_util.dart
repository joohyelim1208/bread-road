import 'package:flutter/material.dart';

class InputDecorationUtil {
  static InputDecoration commonDecoration({
    required BuildContext context,
    required String hintText,
    String? counterText,
  }) {
    // final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return InputDecoration(
      hintText: hintText,
      counterText: counterText,
      filled: true,
      fillColor: Colors.white,
      // 기본상태
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: BorderSide(color: Colors.grey[100]!, width: 5),
      ),
      // 포커스 상태
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: BorderSide(color: colorScheme.primary, width: 5),
      ),
      // 에러발생 시
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: BorderSide(color: colorScheme.error, width: 5),
      ),
      // 에러상황에서 선택했을 때
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: BorderSide(color: colorScheme.error, width: 5),
      ),

      // 힌트텍스트 스타일
      hintStyle: TextStyle(color: Colors.grey[400]),
    );
  }
}

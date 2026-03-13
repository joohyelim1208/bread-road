import 'package:flutter/material.dart';

class AppTextTheme {
  // 공통 스타일 적용(size, weight)
  static TextTheme _buildTextTheme(Color baseTextColor, Color secondTextColor) {
    return TextTheme(
      displayLarge: TextStyle(
        // headline 1: 큰 제목
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: baseTextColor,
      ),
      // headline 2: 각 섹션 타이틀, 카드제목
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: baseTextColor,
      ),
      // body 1: 게시글 본문, 리스트 항목
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: baseTextColor,
      ),
      // body 2: 보조 설명, 입력창 가이드문구
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        // 특정 위젯에서 색이 달라야 할 땐 .copywith를 사용해서 기존 값은 유지하면서 특정속성(color)만 바꾸기!
        color: secondTextColor,
      ),
      // Caption: 날짜, 좋아요 수 등 작은 태그 정보
      labelSmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: secondTextColor,
      ),
      // Botton: 메인 버튼
      labelLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: baseTextColor,
      ),
    );
  }

  // 라이트 모드용 테마
  static TextTheme lightTextTheme = _buildTextTheme(
    Colors.black87,
    Colors.grey[600]!,
  );

  // 다크 모드용 테마
  static TextTheme darkTextTheme = _buildTextTheme(
    Colors.white,
    Colors.grey[400]!,
  );
}

import 'package:intl/intl.dart';

class DateUtil {
  /// ISO 포맷의 날짜 문자열을 전달받아 한국어 "yyyy년 MM월 dd일 (E)" 포맷으로 변환합니다.
  /// 날짜 파싱에 실패하면 원본 문자열을 그대로 반환합니다.
  static String formatKoreanDate(String dateStr) {
    if (dateStr.isEmpty) return "";
    try {
      DateTime dt = DateTime.parse(dateStr);
      return DateFormat('yyyy년 MM월 dd일 (E)', 'ko_KR').format(dt);
    } catch (e) {
      return dateStr;
    }
  }
}

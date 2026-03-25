// writePage, recordWritePage 공통 사용
class AppTodo {
  final String id;
  final String title;
  final DateTime scheduleAt; // 날짜+시간. intl패키지 예쁘게 나옴
  final bool isFavorite;
  final bool isDone; // 라이트페이지: 방문완료, 레시피페이지: 제작완료

  const AppTodo({
    required this.id,
    required this.title,
    required this.scheduleAt,
    this.isFavorite = false,
    this.isDone = false,
  });

  AppTodo copyWith({
    String? id,
    String? title,
    DateTime? scheduleAt,
    bool? isFavorite,
    bool? isDone,
  }) {
    return AppTodo(
      // 변경할 값 없으면 기존값 사용. null이 들어올 수 없게됨 기존 유효한 값을 가짐
      id: id ?? this.id,
      title: title ?? this.title,
      scheduleAt: scheduleAt ?? this.scheduleAt,
      isFavorite: isFavorite ?? this.isFavorite,
      isDone: isDone ?? this.isDone,
    );
  }
}

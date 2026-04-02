import 'package:flutter/material.dart';

/// 빵지순례 등급 카드 위젯
/// records.length에 따라 트로피 동그라미가 채워지며, 5개 단위로 등급이 올라갑니다.
class BreadGradeCard extends StatelessWidget {
  final int totalRecords;

  const BreadGradeCard({super.key, required this.totalRecords});

  static const List<Map<String, String>> _grades = [
    {'title': '빵 입문자', 'emoji': '🌱'},
    {'title': '빵 탐험가', 'emoji': '🗺️'},
    {'title': '빵 마니아', 'emoji': '🍞'},
    {'title': '빵 박사', 'emoji': '🎓'},
    {'title': '빵지순례 마스터', 'emoji': '🏆'},
  ];

  // 채워질수록 점점 진해지는 오렌지 팔레트
  static const List<Color> _filledColors = [
    Color(0xFFFFE0B2),
    Color(0xFFFFCC80),
    Color(0xFFFFA726),
    Color(0xFFFF8C00),
    Color(0xFFE65100),
  ];

  int get _gradeIndex => (totalRecords ~/ 5).clamp(0, _grades.length - 1);
  int get _filledInCycle => totalRecords % 5;
  int get _remaining => 5 - _filledInCycle;

  String get _nextGradeTitle {
    final nextIndex = (_gradeIndex + 1).clamp(0, _grades.length - 1);
    return _grades[nextIndex]['title']!;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    final currentGrade = _grades[_gradeIndex];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      decoration: BoxDecoration(
        // 카드 배경: 가장 연한 오렌지 (#FFE0B2 — 첫 번째 원 색상과 동일)
        color: const Color(0xFFFFE0B2),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // 헤더와 동그라미를 같은 폭으로 묶어 가운데 정렬
          Center(
            child: IntrinsicWidth(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 상단 헤더: 제목 가운데 / 등급 뱃지 우측
                  Stack(
                    alignment: Alignment.center,
                    clipBehavior: Clip.none,
                    children: [
                      Text(
                        '빵지순례 등급',
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Positioned(
                        right: -12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            currentGrade['title']!,
                            style: textTheme.labelMedium?.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // 트로피 동그라미 5개 — 고정 8px 간격으로 자연스럽게 붙임
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(5, (index) {
                      final isFilled = index < _filledInCycle;
                      final fillColor = isFilled
                          ? _filledColors[index]
                          : Colors.grey[100]!;
                      final iconColor = isFilled
                          ? Colors.white
                          : Colors.grey[300]!;

                      return Padding(
                        padding: EdgeInsets.only(left: index == 0 ? 0 : 8),
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: fillColor,
                            border: Border.all(
                              color: isFilled
                                  ? _filledColors[index]
                                  : Colors.grey[300]!,
                              width: 1.5,
                            ),
                            boxShadow: isFilled
                                ? [
                                    BoxShadow(
                                      color: _filledColors[index].withValues(
                                        alpha: 0.4,
                                      ),
                                      blurRadius: 6,
                                      offset: const Offset(0, 3),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Icon(
                            Icons.emoji_events,
                            color: iconColor,
                            size: 22,
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),

          // 다음 등급까지 안내 텍스트
          Text(
            _gradeIndex >= _grades.length - 1
                ? '최고 등급 달성! 빵지순례 마스터입니다!'
                : "다음 등급 '$_nextGradeTitle'까지 방문 $_remaining곳 남았어요!",
            style: textTheme.bodySmall?.copyWith(
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

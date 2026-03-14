import 'package:flutter/material.dart';

// 상단 현황 카드섹션
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // 상태에 대한 데이터
  int _counter = 0;
  int _counterSecond = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: colorScheme.primaryContainer,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // 첫번째 누적달성
                  _achieveCount('누적달성', 0, textTheme),
                  // 두번째 진행중
                  _achieveCount('진행중', 0, textTheme),
                  // 세번째 버튼아이콘
                  IconButton(
                    onPressed: () {
                      // 출석체크 팝업 페이지 확인
                    },
                    icon: Icon(Icons.circle_outlined, size: 30),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 위젯으로 분리. 목표달성, 진행중 리스트 목록에 따라 카운트가 변함
Widget _achieveCount(String title, int count, TextTheme textTheme) {
  return Column(
    mainAxisSize: MainAxisSize.min, // 세로공간을 최소화하기
    children: [
      Text(title, style: textTheme.bodyMedium),
      Text(
        "$count",
        style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
      ),
    ],
  );
}

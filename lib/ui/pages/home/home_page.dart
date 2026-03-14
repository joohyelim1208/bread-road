import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> todos = [];

  @override
  Widget build(BuildContext context) {
    // 테마정보 가져오기. 기본제공 테마
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: colorScheme.surface,
      appBar: AppBar(),
      body: SafeArea(
        bottom: false,
        child: todos.isEmpty
            ? _buildEmptyView(textTheme)
            : _buildListView(textTheme),
      ),
    );
  }
}

// 리스트가 없을 때
Widget _buildEmptyView(TextTheme textTheme) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // 박스 안에 아이콘 텍스트 들어가있고, 리스트 추가하는 칸이 오른쪽으로 밀면 나옴
        const Icon(Icons.abc),
        Text("오늘의 한 뼘을 적어보세요.", style: textTheme.bodyMedium),
      ],
    ),
  );
}

// 리스트가 있을 때
Widget _buildListView(TextTheme textTheme) {
  return ListView(
    // 화면에 리스트는 최신등록한 리스트 3개가 컬럼배치 되어있고, 리스트를 추가하는 칸이 오른쪽으로 밀면 나옴
  );
}

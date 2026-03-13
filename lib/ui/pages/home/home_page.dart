import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:han_ppyeom/core/theme/theme_provider.dart';
import 'package:han_ppyeom/ui/pages/home/home_view_model.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todos = ref.watch(homeViewModelProvider);
    final theme = ref.watch(themeProvider);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: colorScheme.surface,
      appBar: AppBar(),
      body: SafeArea(
        bottom: false,
        // 빈리스트, 리스트가 있을 때 삼항연산자
        child: todos.isEmpty
            ? Container(
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(20),
                      margin: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        color: colorScheme.primary,
                      ),
                      // 내부 아이콘, 텍스트
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // 첫번째. 누적달성
                          Column(
                            children: [
                              Text('누적달성', style: textTheme.bodyMedium),
                              Text('0'),
                            ],
                          ),
                          Column(
                            children: [
                              Text('진행중', style: textTheme.bodyMedium),
                              Text('0'),
                            ],
                          ),
                          Column(
                            children: [
                              Icon(Icons.circle_outlined),
                              //
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            : Container(),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:bread_road/core/theme/app_theme.dart';
import 'package:bread_road/ui/pages/home/home_page.dart';
import 'package:bread_road/ui/pages/login/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      // 초기화면 설정(로그인이 안된거면 로그인페이지)
      initialRoute: '/login',
      // 고라우터 삭제. 라우트 경로
      routes: {
        '/': (context) => const HomePage(),
        '/login': (context) => const LoginPage(),
      },
    );
  }
}

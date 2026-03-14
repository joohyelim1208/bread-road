import 'package:flutter/material.dart';
import 'package:han_ppyeom/core/theme/app_theme.dart';
import 'package:han_ppyeom/ui/pages/home/home_page.dart';

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
      // 고라우터 대신 홈 속성
      home: HomePage(),
    );
  }
}

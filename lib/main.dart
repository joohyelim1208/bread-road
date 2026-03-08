import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:han_ppyeom/core/theme/app_theme.dart';
import 'package:han_ppyeom/ui/pages/login/login_page.dart';
import 'package:get/get.dart';

void main() {
  // 리버팟 패키지
  runApp(ProviderScope(child: MyApp()));
  // Get X 컨트롤러
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: LoginPage(),
    );
  }
}

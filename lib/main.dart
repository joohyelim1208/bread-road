import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:han_ppyeom/ui/pages/login/login_page.dart';

void main() {
  // 리버팟 패키지
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Pretendard',
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 255, 161, 9),
        ),
        highlightColor: Colors.amber,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            foregroundColor: WidgetStatePropertyAll(Colors.white),
            backgroundColor: WidgetStatePropertyAll(Colors.orange),
            minimumSize: WidgetStatePropertyAll(Size.fromHeight(56)),
            textStyle: WidgetStatePropertyAll(TextStyle(fontSize: 18)),
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
          ),
        ),
        //
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: TextStyle(
            // 추후 테마 적용
            fontSize: 16,
            color: Colors.grey,
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          border: WidgetStateInputBorder.resolveWith((states) {
            print(states);
            // 1. 포커스 받았을 때
            if (states.contains(WidgetState.focused)) {
              return OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.grey, width: 2),
              );
            }
            WidgetState;

            // 2. 에러가 포함될 때
            if (states.contains(WidgetState.error)) {
              return OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.red[200]!, width: 2),
              );
            }
            // 3. 기본 디폴트 값
            return OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
            );
          }),
        ),
      ),
      home: LoginPage(),
    );
  }
}

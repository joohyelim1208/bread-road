import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    // 2초 후 로그인 페이지로 이동
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA), // 사용자 요청 배경색
      body: SizedBox.expand(
        child: Image.asset(
          'assets/images/bread.webp',
          fit: BoxFit.cover, // 화면에 꽉 차게 설정
          // 이미지 로딩 중 에러 대비
          errorBuilder: (context, error, stackTrace) {
            return const Center(
              child: Icon(Icons.bakery_dining, size: 80, color: Colors.grey),
            );
          },
        ),
      ),
    );
  }
}

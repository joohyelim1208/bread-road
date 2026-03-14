import 'package:flutter/material.dart';
import 'package:han_ppyeom/ui/pages/join/join_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      // 컬럼이 전체 사용할 수 있도록 패딩으로 감싸줌
      body: SafeArea(
        child: SizedBox.expand(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Spacer(flex: 2),
                // 로고 등 이미지
                // Image.asset('assets/logo.png', width: 100'),
                const SizedBox(height: 20),
                Text(
                  '어제보다 딱 한 뼘,\n나를 토닥이는 작은 기록',
                  textAlign: TextAlign.center,
                  style: textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                const Spacer(flex: 3),
                // 로그인 기능은 구현 전
                _buildLoginButton(
                  label: '카카오톡으로 시작하기',
                  onPressed: () {},
                  backgroundColor: Color(0xFFFEE500),
                  foregroundColor: Colors.black,
                ),
                const SizedBox(height: 10),
                _buildLoginButton(
                  label: '구글로 시작하기',
                  onPressed: () {},
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                ),
                const SizedBox(height: 10),
                _buildLoginButton(
                  label: '다른 방법으로 시작하기',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const JoinPage()),
                    );
                  },
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      // 일단 조인페이지로
                      MaterialPageRoute(builder: (context) => const JoinPage()),
                    );
                  },
                  child: Text(
                    "이미 계정이 있나요? 로그인하기",
                    style: textTheme.bodyMedium?.copyWith(
                      decoration: TextDecoration.underline,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// 버튼을 만드는 함수 코드 중복방지(추상화)
Widget _buildLoginButton({
  required String label,
  required VoidCallback onPressed,
  required Color backgroundColor,
  required Color foregroundColor,
  bool isBorder = false,
}) {
  return SizedBox(
    width: double.infinity,
    height: 54,
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(24),
          side: isBorder ? BorderSide(color: Colors.grey) : BorderSide.none,
        ),
      ),
      child: Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
    ),
  );
}

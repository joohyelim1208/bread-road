import 'package:flutter/material.dart';
import 'package:bread_road/ui/pages/join/join_page.dart';
import 'package:bread_road/ui/widgets/social_login_button.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(flex: 3),
              // 로고 영역 (아이콘으로 임시 대체)
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: colorScheme.primary.withAlpha(10),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.bakery_dining,
                  size: 48,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Bread Road',
                textAlign: TextAlign.center,
                style: textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  height: 1.4,
                  color: colorScheme.onSurface,
                ),
              ),
              Text(
                '빵으로 잇는 일상의 지도',
                textAlign: TextAlign.center,
                style: textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  height: 1.4,
                  color: colorScheme.onSurface,
                ),
              ),
              const Spacer(flex: 4),
              // 소셜 로그인 섹션
              // 1. 카카오 로그인
              SocialLoginButton.kakao(
                onPressed: () {
                  print("카카오 로그인 시도");
                },
              ),
              const SizedBox(height: 12),
              // 2. 구글 로그인
              SocialLoginButton.google(
                onPressed: () {
                  print("구글 로그인 시도");
                },
              ),
              const SizedBox(height: 12),
              // 3. 다른 방법으로 로그인(일반생성자로 직접 커스텀하기)
              SocialLoginButton(
                text: "다른 방법으로 시작하기",
                backgroundColor: colorScheme.primary,
                textColor: colorScheme.onPrimary,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const JoinPage()),
                  );
                },
              ),
              const SizedBox(height: 24),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const JoinPage()),
                  );
                },
                style: TextButton.styleFrom(minimumSize: const Size(100, 44)),
                child: RichText(
                  text: TextSpan(
                    style: textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                    children: [
                      const TextSpan(text: "이미 계정이 있나요? "),
                      TextSpan(
                        text: "로그인하기",
                        style: TextStyle(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

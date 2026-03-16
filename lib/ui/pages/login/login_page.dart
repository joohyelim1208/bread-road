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
                '한 뼘',
                textAlign: TextAlign.center,
                style: textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  height: 1.4,
                  color: colorScheme.onSurface,
                ),
              ),
              Text(
                '한 걸음씩 찾아가는 나만의 빵 취향',
                textAlign: TextAlign.center,
                style: textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  height: 1.4,
                  color: colorScheme.onSurface,
                ),
              ),
              const Spacer(flex: 4),
              // 소셜 로그인 섹션
              _buildLoginButton(
                label: '카카오톡으로 시작하기',
                onPressed: () {},
                backgroundColor: const Color(0xFFFEE500),
                foregroundColor: Colors.black87,
                icon: Icons.chat_bubble,
              ),
              const SizedBox(height: 12),
              _buildLoginButton(
                label: '구글로 시작하기',
                onPressed: () {},
                backgroundColor: Colors.white,
                foregroundColor: Colors.black87,
                isBorder: true,
                icon: Icons.g_mobiledata,
              ),
              const SizedBox(height: 12),
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
                icon: Icons.mail_outline,
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

// 공통적용
Widget _buildLoginButton({
  required String label,
  required VoidCallback onPressed,
  required Color backgroundColor,
  required Color foregroundColor,
  bool isBorder = false,
  IconData? icon,
}) {
  return SizedBox(
    width: double.infinity,
    height: 56,
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: isBorder
              ? BorderSide(color: Colors.grey[300]!)
              : BorderSide.none,
        ),
      ),
      child: Stack(
        children: [
          if (icon != null)
            Align(alignment: Alignment.centerLeft, child: Icon(icon, size: 24)),
          Center(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.5,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

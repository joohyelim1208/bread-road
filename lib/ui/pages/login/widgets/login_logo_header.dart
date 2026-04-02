import 'dart:ui';
import 'package:flutter/material.dart';

class LoginLogoImage extends StatelessWidget {
  const LoginLogoImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // 그림자 레이어
        Transform.translate(
          offset: const Offset(0, 6),
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
            child: Image.asset(
              'assets/images/breadroadtextlogo.webp',
              width: 280,
              height: 280,
              fit: BoxFit.contain,
              color: Colors.black.withValues(alpha: 0.4),
            ),
          ),
        ),
        // 원본 이미지 레이어
        Image.asset(
          'assets/images/breadroadtextlogo.webp',
          width: 280,
          height: 280,
          fit: BoxFit.contain,
        ),
      ],
    );
  }
}

class LoginWelcomeText extends StatelessWidget {
  const LoginWelcomeText({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Bread Road',
          style: textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '빵으로 잇는 일상의 지도',
          style: textTheme.bodyLarge?.copyWith(
            color: Colors.black87.withValues(alpha: 0.7),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

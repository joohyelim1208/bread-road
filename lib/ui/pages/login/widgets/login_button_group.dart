import 'package:flutter/material.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:bread_road/ui/widgets/social_login_button.dart';

class LoginButtonGroup extends StatelessWidget {
  final VoidCallback onGoogleTap;
  final VoidCallback onKakaoTap;
  final VoidCallback onAppleTap;
  final VoidCallback onCheckExistingTap;
  
  final bool isGoogleLoading;
  final bool isKakaoLoading;

  const LoginButtonGroup({
    super.key,
    required this.onGoogleTap,
    required this.onKakaoTap,
    required this.onAppleTap,
    required this.onCheckExistingTap,
    this.isGoogleLoading = false,
    this.isKakaoLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SocialLoginButton.google(
          onPressed: onGoogleTap,
          isLoading: isGoogleLoading,
        ),
        const SizedBox(height: 12),
        SocialLoginButton.kakao(
          onPressed: onKakaoTap,
          isLoading: isKakaoLoading,
        ),
        const SizedBox(height: 16),
        SignInWithAppleButton(
          text: 'Apple로 로그인',
          style: SignInWithAppleButtonStyle.black,
          borderRadius: const BorderRadius.all(Radius.circular(26)),
          height: 52,
          onPressed: () async => onAppleTap(),
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '이미 계정이 있으신가요? ',
                style: TextStyle(color: Colors.grey[600], fontSize: 13),
              ),
              GestureDetector(
                onTap: onCheckExistingTap,
                child: const Text(
                  '로그인하기',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

/// ==========================================================
/// 소셜 로그인 버튼 위젯 (과제 1: 기본 로그인 UI)
/// ==========================================================
/// 구글, 카카오 로그인 버튼을 재사용 가능한 위젯으로 만들었습니다.

class SocialLoginButton extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final IconData? icon;
  final String? iconAsset;
  final VoidCallback onPressed;
  final bool isLoading;

  const SocialLoginButton({
    super.key,
    required this.text,
    required this.backgroundColor,
    required this.textColor,
    this.icon,
    this.iconAsset,
    required this.onPressed,
    this.isLoading = false,
  });

  /// 구글 로그인 버튼
  factory SocialLoginButton.google({
    required VoidCallback onPressed,
    bool isLoading = false,
  }) {
    return SocialLoginButton(
      text: 'Google로 로그인',
      backgroundColor: Colors.white,
      textColor: Colors.black87,
      icon: Icons.g_mobiledata,
      onPressed: onPressed,
      isLoading: isLoading,
    );
  }

  /// 카카오 로그인 버튼
  factory SocialLoginButton.kakao({
    required VoidCallback onPressed,
    bool isLoading = false,
  }) {
    return SocialLoginButton(
      text: '카카오로 로그인',
      backgroundColor: const Color(0xFFFEE500),
      textColor: Colors.black87,
      icon: Icons.chat_bubble,
      onPressed: onPressed,
      isLoading: isLoading,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: backgroundColor == Colors.white
                ? const BorderSide(color: Colors.grey)
                : BorderSide.none,
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: textColor,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) Icon(icon, size: 24),
                  if (icon != null) const SizedBox(width: 12),
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

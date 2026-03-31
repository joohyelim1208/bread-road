import 'package:flutter/material.dart';

/// 하단 공통 버튼 위젯 (Save, Register, etc.)
class ButtonUtil extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final Color? backgroundColor;
  final Color? textColor;

  const ButtonUtil({
    super.key,
    required this.label,
    required this.onTap,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      // 1. 버튼 뒤 배경색과 그림자 제거 (완전 투명 유지)
      color: Colors.transparent,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
          child: Container(
            // 2. 버튼 형태에 맞춘 국소화된 그림자 (현대적인 입체감)
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: onTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: backgroundColor ?? colorScheme.primary,
                  foregroundColor: textColor ?? colorScheme.onPrimary,
                  elevation: 0, // 컨테이너 그림자를 사용하므로 버튼 자체 고유 고도 값은 0
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28), // 반원형
                  ),
                ),
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

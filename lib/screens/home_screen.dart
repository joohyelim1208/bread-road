import 'package:flutter/material.dart';

/// ==========================================================
/// 홈 화면 (로그인 성공 후)
/// ==========================================================
/// 로그인에 성공한 사용자 정보를 표시합니다.

class HomeScreen extends StatelessWidget {
  final String userName;
  final String userEmail;
  final String? userPhoto;
  final String userUid;
  final VoidCallback onLogout;

  const HomeScreen({
    super.key,
    required this.userName,
    required this.userEmail,
    this.userPhoto,
    required this.userUid,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // 프로필 사진
            CircleAvatar(
              radius: 50,
              backgroundImage: userPhoto != null
                  ? NetworkImage(userPhoto!)
                  : null,
              child: userPhoto == null
                  ? const Icon(Icons.person, size: 50)
                  : null,
            ),
            const SizedBox(height: 24),

            // 로그인 성공 메시지
            Text(
              '로그인 성공!',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 32),

            // 사용자 정보 카드
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _InfoRow(label: '이름', value: userName),
                    const Divider(),
                    _InfoRow(label: '이메일', value: userEmail),
                    const Divider(),
                    _InfoRow(label: 'Firebase UID', value: userUid),
                    const Divider(),
                    const _InfoRow(label: '로그인 방식', value: 'Firebase'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // OAuth 흐름 설명
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.purple[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.school, color: Colors.purple[700], size: 20),
                      const SizedBox(width: 8),
                      Text(
                        '여기까지 오는 과정 (OAuth 7단계)',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.purple[700],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const _StepItem(step: '1~4', text: 'SDK로 소셜 로그인 UI 표시'),
                  const _StepItem(step: '5', text: '소셜 토큰(idToken) 수신'),
                  const _StepItem(step: '6', text: 'Firebase에 소셜 토큰 전달'),
                  const _StepItem(step: '7', text: 'Firebase가 검증 후 JWT 발급'),
                ],
              ),
            ),

            const Spacer(),

            // 로그아웃 버튼
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton.icon(
                onPressed: onLogout,
                icon: const Icon(Icons.logout),
                label: const Text('로그아웃'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

class _StepItem extends StatelessWidget {
  final String step;
  final String text;

  const _StepItem({required this.step, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 20,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.purple[200],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              step,
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 13))),
        ],
      ),
    );
  }
}

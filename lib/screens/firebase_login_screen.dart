import 'package:bread_road/ui/widgets/social_login_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/firebase/firebase_google_auth_service.dart';
import '../services/firebase/kakao_oidc_auth_service.dart';
import 'home_screen.dart';

/// ==========================================================
/// Firebase 로그인 화면 (4장)
/// ==========================================================
/// Firebase Auth를 사용한 구글/카카오 로그인 화면입니다.
///
/// [구글 로그인]: FirebaseGoogleAuthService (4-2)
/// [카카오 로그인]: KakaoOidcAuthService (4-3-1, OIDC 방식 - 서버 불필요)

class FirebaseLoginScreen extends StatefulWidget {
  const FirebaseLoginScreen({super.key});

  @override
  State<FirebaseLoginScreen> createState() => _FirebaseLoginScreenState();
}

class _FirebaseLoginScreenState extends State<FirebaseLoginScreen> {
  // ── 서비스 인스턴스 ──
  final _googleAuth = FirebaseGoogleAuthService();
  final _kakaoOidcAuth = KakaoOidcAuthService();

  // ── 로딩 상태 ──
  bool _isGoogleLoading = false;
  bool _isKakaoLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        // Firebase 인증 상태를 실시간으로 감지
        stream: _googleAuth.authStateChanges,
        builder: (context, snapshot) {
          // 이미 로그인된 상태라면 → 홈 화면 표시
          if (snapshot.hasData) {
            final user = snapshot.data!;
            return HomeScreen(
              userName: user.displayName ?? '사용자',
              userEmail: user.email ?? '이메일 없음',
              userPhoto: user.photoURL,
              userUid: user.uid,
              onLogout: _handleLogout,
            );
          }

          // 로그인이 안 된 상태 → 로그인 버튼 표시
          return _buildLoginUI();
        },
      ),
    );
  }

  Widget _buildLoginUI() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),

            // 제목
            Text(
              '소셜 로그인 실습',
              style: Theme.of(
                context,
              ).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Firebase Auth가 6~7단계를 자동 처리합니다',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 48),

            // ── 구글 로그인 버튼 (4-2) ──
            SocialLoginButton.google(
              onPressed: _handleGoogleLogin,
              isLoading: _isGoogleLoading,
            ),
            const SizedBox(height: 16),

            // ── 카카오 로그인 버튼 (4-3-1, OIDC) ──
            SocialLoginButton.kakao(
              onPressed: _handleKakaoLogin,
              isLoading: _isKakaoLoading,
            ),

            const Spacer(),

            // 안내
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.local_fire_department,
                    color: Colors.orange,
                    size: 20,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Firebase가 토큰 검증, 사용자 관리,\nJWT 발급을 모두 자동으로 처리합니다.',
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ──────────────────────────────────────────────
  // 구글 로그인 처리 (4-2)
  // ──────────────────────────────────────────────
  Future<void> _handleGoogleLogin() async {
    setState(() => _isGoogleLoading = true);

    try {
      final result = await _googleAuth.signInWithGoogle();
      if (result != null) {
        // ignore: avoid_print
        print('구글 로그인 성공: ${result.user?.email}');
        // StreamBuilder가 자동으로 홈 화면을 표시합니다
      }
    } catch (e) {
      print('GoogleSignInException: ${e.toString()}');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('구글 로그인 실패: $e')));
      }
    } finally {
      if (mounted) setState(() => _isGoogleLoading = false);
    }
  }

  // ──────────────────────────────────────────────
  // 카카오 로그인 처리 (4-3-1, OIDC)
  // ──────────────────────────────────────────────
  Future<void> _handleKakaoLogin() async {
    setState(() => _isKakaoLoading = true);

    try {
      await _kakaoOidcAuth.signInWithKakao();
      // StreamBuilder가 자동으로 홈 화면을 표시합니다
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('카카오 로그인 실패: $e')));
      }
    } finally {
      if (mounted) setState(() => _isKakaoLoading = false);
    }
  }

  // ──────────────────────────────────────────────
  // 로그아웃 (8장)
  // ──────────────────────────────────────────────
  Future<void> _handleLogout() async {
    await _googleAuth.signOut();
    // StreamBuilder가 자동으로 로그인 화면을 표시합니다
  }
}

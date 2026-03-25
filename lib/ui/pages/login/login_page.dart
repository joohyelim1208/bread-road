import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bread_road/services/firebase/firebase_google_auth_service.dart';
import 'package:bread_road/services/firebase/kakao_oidc_auth_service.dart';
import 'package:bread_road/ui/widgets/social_login_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _googleAuth = FirebaseGoogleAuthService();
  final _kakaoOidcAuth = KakaoOidcAuthService();

  bool _isGoogleLoading = false;
  bool _isKakaoLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white, body: _buildLoginUI());
  }

  Widget _buildLoginUI() {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            const Spacer(flex: 2),

            // 상단 로고 및 타이틀
            Center(
              child: Column(
                children: [
                  // 임시 빵 아이콘 로고
                  Icon(
                    Icons.bakery_dining,
                    size: 80,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Bread Road',
                    style: textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '빵으로 잇는 일상의 지도',
                    style: textTheme.bodyLarge?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(flex: 3),

            // 소셜 로그인 버튼
            SocialLoginButton.google(
              onPressed: _handleGoogleLogin,
              isLoading: _isGoogleLoading,
            ),
            const SizedBox(height: 12),
            SocialLoginButton.kakao(
              onPressed: _handleKakaoLogin,
              isLoading: _isKakaoLoading,
            ),
            const SizedBox(height: 16),

            //다른 방법으로 로그인
            SocialLoginButton(
              text: '다른 방법으로 로그인하기',
              backgroundColor: Colors.grey.shade100,
              textColor: Colors.black54,
              icon: Icons.mail_outline,
              onPressed: () => Navigator.pushNamed(context, '/join'),
            ),

            const SizedBox(height: 16),

            //이미 계정이 있으신가요?
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '이미 계정이 있으신가요? ',
                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                ),
                GestureDetector(
                  onTap: _handleCheckExistingLogin,
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
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // ── 인증 로직 ──

  /// 소셜 로그인 성공 시 실행되는 공통 내비게이션 로직
  void _onSuccessLogin() {
    // 닉네임 등록을 위해 JoinPage로 이동
    if (mounted) {
      Navigator.pushNamed(context, '/join');
    }
  }

  /// '로그인하기' 버튼 클릭 시: 이미 로그인이 되어있는지 확인 후 홈으로 이동
  void _handleCheckExistingLogin() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // 이미 로그인 상태라면 홈 화면으로 이동
      Navigator.pushReplacementNamed(context, '/');
    } else {
      // 로그인이 안 되어 있다면 안내 메시지
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('소셜 로그인을 먼저 진행해주세요.')));
    }
  }

  Future<void> _handleGoogleLogin() async {
    setState(() => _isGoogleLoading = true);
    try {
      final result = await _googleAuth.signInWithGoogle();
      if (result != null) {
        _onSuccessLogin();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('구글 로그인 실패: $e')));
      }
    } finally {
      if (mounted) setState(() => _isGoogleLoading = false);
    }
  }

  Future<void> _handleKakaoLogin() async {
    setState(() => _isKakaoLoading = true);
    try {
      final result = await _kakaoOidcAuth.signInWithKakao();
      if (result != null) {
        _onSuccessLogin();
      }
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
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bread_road/services/firebase/firebase_google_auth_service.dart';
import 'package:bread_road/services/firebase/kakao_oidc_auth_service.dart';
import 'widgets/scrolling_background.dart';
import 'widgets/login_logo_header.dart';
import 'widgets/login_button_group.dart';

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
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          const ScrollingBackground(),
          Positioned.fill(
            child: Container(color: Colors.white.withValues(alpha: 0.7)),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  const Spacer(flex: 3),
                  const LoginLogoHeader(),
                  const Spacer(flex: 3),
                  LoginButtonGroup(
                    onGoogleTap: _handleGoogleLogin,
                    onKakaoTap: _handleKakaoLogin,
                    onAppleTap: () async {
                      // TODO: AppleAuth 구현 시 연결
                    },
                    onCheckExistingTap: _handleCheckExistingLogin,
                    isGoogleLoading: _isGoogleLoading,
                    isKakaoLoading: _isKakaoLoading,
                  ),
                ],
              ),
            ),
          ),
        ],
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

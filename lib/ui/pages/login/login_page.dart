import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
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

  // 배경 애니메이션을 위한 컨트롤러
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    // 프레임 렌더링 후 애니메이션 시작
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startBackgroundAnimation();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // 무한 흐르는 애니메이션 로직
  void _startBackgroundAnimation() {
    if (!_scrollController.hasClients) return;

    // 현재 위치에서 끝까지 이동
    final maxScroll = _scrollController.position.maxScrollExtent;
    const duration = Duration(seconds: 460); //매우 천천히 이동

    _scrollController
        .animateTo(maxScroll, duration: duration, curve: Curves.linear)
        .then((_) {
          if (mounted) {
            // 끝에 도달하면 즉시 처음으로 점프 후 다시 시작
            _scrollController.jumpTo(0);
            _startBackgroundAnimation();
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white, body: _buildLoginUI());
  }

  Widget _buildLoginUI() {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Stack(
      children: [
        // 1. 무한히 흐르는 배경 이미지 (SingleChildScrollView 사용)
        Positioned.fill(
          child: IgnorePointer(
            child: SingleChildScrollView(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(
                  3,
                  (index) => Image.asset(
                    'assets/images/bread.webp',
                    height: MediaQuery.of(context).size.height,
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
            ),
          ),
        ),
        // 2. 전체적인 분위기를 위한 옅은 오버레이
        Positioned.fill(
          child: Container(color: Colors.white.withValues(alpha: 0.7)),
        ),
        // 3. 실제 로그인 UI 콘텐츠
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                const Spacer(flex: 3),

                // 중앙 메인 텍스트 영역 (가독성을 위한 흰색 박스 추가)
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 32,
                    horizontal: 40,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: Column(
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
                      const SizedBox(height: 12),
                      Text(
                        '빵으로 잇는 일상의 지도',
                        style: textTheme.bodyLarge?.copyWith(
                          color: Colors.black87.withValues(alpha: 0.7),
                          fontWeight: FontWeight.w500,
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

                // Apple 로그인
                SignInWithAppleButton(
                  text: 'Apple로 로그인',
                  style: SignInWithAppleButtonStyle.black,
                  borderRadius: const BorderRadius.all(Radius.circular(26)),
                  height: 52,
                  onPressed: () async {
                    // 로그인 로직 실행
                    // TODO: AppleAuth 구현 시 연결
                  },
                ),

                const SizedBox(height: 24),

                //이미 계정이 있으신가요? (가독성을 위한 흰색 박스 추가)
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 16,
                  ),
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
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ],
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

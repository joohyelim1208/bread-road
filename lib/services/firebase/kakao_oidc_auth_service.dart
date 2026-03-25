import 'package:firebase_auth/firebase_auth.dart';

/// ==========================================================
/// 카카오 OIDC + Firebase (4장 - 4-3-1, 방법 A)
/// ==========================================================
/// Firebase의 OIDC 커스텀 제공업체를 사용하여
/// 서버 없이 카카오 로그인을 Firebase와 연동합니다.
///
/// [사전 설정 필요]
///   1. Firebase 콘솔 → Authentication → Identity Platform 업그레이드
///   2. Sign-in method → 새 공급업체 추가 → OpenID Connect
///   3. 카카오 개발자 콘솔에서 OIDC 활성화 + Redirect URI 설정
///   자세한 설정은 README.md를 참고하세요.
///
/// [장점]
///   - 서버 구축 불필요
///   - 코드가 매우 간단
///   - Firebase가 토큰 관리 자동 처리
///
/// [주의]
///   - Firebase Identity Platform 업그레이드 필요 (과금 가능)
///   - 카카오 SDK 고유 기능(카카오톡 공유 등) 직접 사용 불가

class KakaoOidcAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ──────────────────────────────────────────────
  // 카카오 OIDC 로그인 (서버 불필요!)
  // ──────────────────────────────────────────────
  Future<UserCredential?> signInWithKakao() async {
    try {
      // 1. OIDC Provider 생성 (Firebase 콘솔에서 설정한 Provider ID)
      final provider = OAuthProvider('oidc.kakao');

      // 2. 추가 파라미터 설정 (선택)
      provider.setCustomParameters({
        'prompt': 'login', // 항상 로그인 화면 표시
      });

      // 3. Firebase가 카카오 로그인 플로우 전체를 처리
      //    - 웹뷰로 카카오 로그인 화면 표시
      //    - 인증 완료 시 Firebase 자동 연동
      //    - Firebase JWT 발급까지 한번에 완료
      return await _auth.signInWithProvider(provider);
    } on FirebaseAuthException catch (e) {
      // ignore: avoid_print
      print('카카오 OIDC 로그인 실패: ${e.code} - ${e.message}');
      rethrow;
    }
  }

  // ──────────────────────────────────────────────
  // 기존 계정에 카카오 연결 (계정 통합)
  // ──────────────────────────────────────────────
  // 구글로 로그인한 사용자가 카카오도 연결하고 싶을 때 사용
  Future<UserCredential?> linkKakaoAccount() async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return null;

    final provider = OAuthProvider('oidc.kakao');
    return await currentUser.linkWithProvider(provider);
  }

  // ──────────────────────────────────────────────
  // 로그아웃
  // ──────────────────────────────────────────────
  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// 현재 로그인된 사용자
  User? get currentUser => _auth.currentUser;

  /// 인증 상태 변경 스트림
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// ==========================================================
/// 구글 로그인 + Firebase (4장 - 4-2)
/// ==========================================================
/// Firebase Auth를 사용한 구글 로그인 구현입니다.
///
/// [흐름]
///   1~4단계: GoogleSignIn.instance.authenticate() → 구글 로그인 UI 표시
///   5단계:   googleUser.authentication → 소셜 토큰(idToken) 수신
///   6단계:   GoogleAuthProvider.credential() → 토큰을 Firebase 형태로 포장
///   7단계:   signInWithCredential() → Firebase 서버에서 검증 후 Firebase JWT 발급
///
/// [참고] google_sign_in v7.x API를 사용합니다.
///        v6.x의 signIn() → v7.x의 authenticate()
///        v6.x의 GoogleSignIn() → v7.x의 GoogleSignIn.instance

class FirebaseGoogleAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ──────────────────────────────────────────────
  // 구글 로그인 (Native: Android / iOS)
  // ──────────────────────────────────────────────
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // ──────────────────────────────────────────
      // [1~4단계] Google 로그인 UI 표시 → 사용자 인증
      // ──────────────────────────────────────────
      // v7.x: GoogleSignIn.instance.authenticate() 사용
      //   1단계: 사용자가 로그인 버튼 클릭 (이 함수 호출 시점)
      //   2단계: Google SDK가 Google 인증 서버에 로그인 요청
      //   3단계: Google 로그인 화면(웹뷰/시스템 UI) 표시
      //   4단계: 사용자가 Google 계정 선택 및 비밀번호 입력
      final GoogleSignInAccount googleUser =
          await GoogleSignIn.instance.authenticate();

      // ──────────────────────────────────────────
      // [5단계] Google이 소셜 토큰 발급
      // ──────────────────────────────────────────
      // v7.x에서 authentication은 동기 getter입니다.
      // googleAuth.idToken: 사용자 신원 증명 JWT (sub, email 등 포함)
      //
      // ⚠️ v7.x에서는 accessToken이 authentication이 아닌
      //     authorizationClient에서 별도로 요청해야 합니다.
      final GoogleSignInAuthentication googleAuth =
          googleUser.authentication;

      // ──────────────────────────────────────────
      // [6단계 준비] Firebase가 이해하는 형태로 토큰 포장
      // ──────────────────────────────────────────
      // credential()은 네트워크 요청 없이 OAuthCredential 객체만 생성합니다.
      // v7.x에서는 idToken만 사용합니다.
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      // ──────────────────────────────────────────
      // [6~7단계] Firebase 서버에 토큰 전달 → 검증 → Firebase JWT 발급
      // ──────────────────────────────────────────
      // Firebase 서버가 내부적으로 하는 일:
      //   6단계: credential에서 idToken을 꺼내 Google JWKS로 서명 검증
      //          → iss(발급자), aud(대상), exp(만료) 클레임 확인
      //   7단계: 검증 통과 시 Firebase 사용자 조회/생성 후
      //          Firebase 자체 JWT를 UserCredential로 반환
      //
      // 이 시점부터 "우리 서비스(Firebase)에 로그인 완료" 상태!
      return await _auth.signInWithCredential(credential);
    } on GoogleSignInException catch (e) {
      print('GoogleSignInException: ${e.code} - ${e.description}');
      // 사용자가 로그인을 취소한 경우
      if (e.code == GoogleSignInExceptionCode.canceled) {
        return null;
      }
      rethrow;
    } on FirebaseAuthException catch (e) {
      // ignore: avoid_print
      print('Firebase Auth Error: ${e.code} - ${e.message}');
      rethrow;
    }
  }

  // ──────────────────────────────────────────────
  // 구글 로그인 (Web 플랫폼)
  // ──────────────────────────────────────────────
  Future<UserCredential?> signInWithGoogleWeb() async {
    try {
      final GoogleAuthProvider googleProvider = GoogleAuthProvider();

      // 추가 scope 요청 (선택)
      googleProvider.addScope('email');
      googleProvider.addScope('profile');

      // 팝업으로 로그인
      return await _auth.signInWithPopup(googleProvider);
    } on FirebaseAuthException catch (e) {
      // ignore: avoid_print
      print('Firebase Auth Error: ${e.code} - ${e.message}');
      rethrow;
    }
  }

  // ──────────────────────────────────────────────
  // 로그아웃
  // ──────────────────────────────────────────────
  Future<void> signOut() async {
    await GoogleSignIn.instance.signOut();
    await _auth.signOut();
  }

  /// 현재 로그인된 사용자
  User? get currentUser => _auth.currentUser;

  /// 인증 상태 변경 스트림 (로그인/로그아웃 감지)
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}

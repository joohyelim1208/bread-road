import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as kakao;

// 1. 상태 클래스 (필요 시 확장 가능)
class LoginState {
  final bool isLoading;
  final String? errorMessage;

  LoginState({this.isLoading = false, this.errorMessage});
}

// 2. 뷰모델: 로그인 관련 비즈니스 로직을 담당합니다.
class LoginViewModel {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// 구글 로그인 실행
  /// 1. 구글 계정 선택 팝업 표시 (main.dart에서 초기화된 instance 사용)
  /// 2. 선택된 계정의 인증 정보(ID 토큰) 획득
  /// 3. 파이어베이스 자격 증명(OAuthCredential) 생성 후 로그인 실행
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // 구글 로그인 시작 (instance.authenticate() 사용)
      final GoogleSignInAccount? googleUser = await GoogleSignIn.instance
          .authenticate();
      if (googleUser == null) return null; // 사용자가 취소한 경우

      // 구글 인증 정보 획득 (가장 최신 버전에서는 await가 필요 없을 수 있음)
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      // 파이어베이스 Credential 생성
      // v7.x 최신 버전에서는 idToken만 제공될 수 있으므로, accessToken은 제외하거나 null 처리 합니다.
      final OAuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      // 파이어베이스 로그인 실행 및 결과 반환
      return await _auth.signInWithCredential(credential);
    } catch (e) {
      // 실제 서비스 시에는 로깅 프레임워크 사용 권장
      rethrow;
    }
  }

  /// 카카오 로그인 실행
  /// 1. 카카오톡 앱 설치 여부에 따라 '앱으로 로그인' 또는 '계정으로 로그인' 실행
  /// 2. 로그인 성공 시 사용자 정보 가져오기
  Future<kakao.User?> signInWithKakao() async {
    try {
      // 카카오톡 설치 여부 확인 후 로그인 방식 결정
      if (await kakao.isKakaoTalkInstalled()) {
        try {
          await kakao.UserApi.instance.loginWithKakaoTalk();
        } catch (error) {
          // 사용자가 카카오톡 설치 후 로그인을 취소한 경우 (예: 뒤로 가기)
          if (error is PlatformException && error.code == 'CANCELED') {
            return null;
          }
          // 기타 에러 시 계정 로그인 시도
          await kakao.UserApi.instance.loginWithKakaoAccount();
        }
      } else {
        // 카카오톡 미설치 시 브라우저를 통한 계정 로그인
        await kakao.UserApi.instance.loginWithKakaoAccount();
      }

      // 로그인 성공 시 카카오 사용자 정보 반환
      return await kakao.UserApi.instance.me();
    } catch (e) {
      // 실제 서비스 시에는 로깅 프레임워크 사용 권장
      rethrow;
    }
  }

  /// 로그아웃
  Future<void> signOut() async {
    await _auth.signOut();
    await GoogleSignIn.instance.signOut();
  }
}

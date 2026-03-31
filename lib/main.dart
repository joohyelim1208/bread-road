import 'package:bread_road/config/app_config.dart';
import 'package:bread_road/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:bread_road/core/theme/app_theme.dart';
import 'package:bread_road/ui/pages/home/home_page.dart';
import 'package:bread_road/ui/pages/login/login_page.dart';
import 'package:bread_road/ui/pages/join/join_page.dart';
import 'package:bread_road/ui/pages/splash/splash_page.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/date_symbol_data_local.dart'; // 캘린더 intl 패키지한국어 데이터 추가
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart'
    as kakao; // 한국어 로캘 설정 추가하면 앱 전체 기본 위젯이 한국어로 바뀜!

void main() async {
  // 비동기작업을 위한 바인딩 초기화 필수
  WidgetsFlutterBinding.ensureInitialized();
  // intl 캘린더 패키지 한국어데이터
  await initializeDateFormatting('ko_KR', null);
  // 파이어베이스 초기화
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // 3. Google Sign-In 초기화 (v7.x 필수!)
  //    clientId는 iOS에서 필요. Android는 google-services.json에서 자동 설정
  await GoogleSignIn.instance.initialize(
    clientId: AppConfig.googleClientIdIOS,
    serverClientId: AppConfig.googleClientIdWeb,
  );

  // 4. 카카오 SDK 초기화
  kakao.KakaoSdk.init(nativeAppKey: AppConfig.kakaoNativeAppKey);

  // 임시로 로그아웃 하는 코드임. 파이어베이스 로그아웃
  await FirebaseAuth.instance.signOut();
  // 2. 카카오 로그아웃
  try {
    await kakao.UserApi.instance.logout();
    print('카카오 로그아웃 성공');
  } catch (error) {
    print('카카오 로그아웃 실패 (이미 로그아웃 상태일 수 있음)');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      // 초기화면 설정(스플래시 화면)
      initialRoute: '/splash',
      // 고라우터 삭제. 라우트 경로
      routes: {
        '/': (context) => const HomePage(),
        '/splash': (context) => const SplashPage(),
        '/login': (context) => const LoginPage(),
        '/join': (context) => const JoinPage(),
      },
      // 한국어 로캘 설정
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate, // 안드로이드용 위젯 한국어화
        GlobalWidgetsLocalizations.delegate, // 기본 위젯 글자 방향 등 설정
        GlobalCupertinoLocalizations.delegate, // ios용 위젯 한국어화
      ],
      // 사용자가 폰에 설정해둔 언어에 따라 실행이 바뀜
      supportedLocales: const [
        Locale('ko', 'KR'), // 앱이 지원하는 언어 목록
        Locale('en', 'US'), // 영어, 미국
      ],
    );
  }
}

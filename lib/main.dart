import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:han_ppyeom/core/theme/app_theme.dart';
import 'package:han_ppyeom/ui/pages/home/home_page.dart';
import 'package:han_ppyeom/ui/pages/join/join_page.dart';

// 고라우터도 프로바이더로 관리
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/Join', // 테스트를 위해 우선 조인페이지 설정. '/'으로 변경하기.
    routes: [
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => HomePage(),
      ),
      GoRoute(
        path: '/join',
        name: 'join',
        builder: (context, state) => JoinPage(),
      ),

      // 파라미터가 필요한 경로가 있으면 추가. 페이지 이동 시 특정 데이터(ID, 이름, 카테고리 등) 함께 넘겨줘야 될 때
    ],
  );
});
void main() {
  // 리버팟 패키지
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    // 앱에 고라우터 적용
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
    );
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:go_router/go_router.dart';
import 'package:han_ppyeom/ui/pages/home/home_page.dart';
import 'package:han_ppyeom/ui/pages/join/join_page.dart';

// 고라우터도 프로바이더로 관리. 나중에 실제로 로그인 상태를 관리할 프로바이더가 생기면 여기서 연결해야됨
// 임시로 로그인 안됨 false를 넣음
final loginProvider = StateProvider<bool>((ref) => false);

final routerProvider = Provider<GoRouter>((ref) {
  // 로그인프로바이더의 상태를 확인함
  final isLoginId = ref.watch(loginProvider);

  return GoRouter(
    initialLocation: "/", // 테스트를 위한 페이지 설정. 나중에 '/'으로 변경하기.
    // 로그인 여부에 따라. 리다이렉트 로그인 안됐는데 홈으로 가려고 하면 조인페이지로 이동
    redirect: (context, state) {
      final loninApp = state.matchedLocation == "/join";
      // 로그인이 안됐는데 홈으로 가려고 하면 조인페이지로, 로그인이 되었는데 조인페이지에 있으려고 하면 홈으로
      if (!loninApp && !isLoginId) {
        return "/join";
      }
      if (loninApp && isLoginId) {
        return "/home";
      }
      return null; // 그 외엔 원래 가려는 곳으로 감!
    },
    routes: [
      GoRoute(
        path: "/home",
        name: "home",
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: "/join",
        name: "join",
        builder: (context, state) => const JoinPage(),
      ),

      // 파라미터가 필요한 경로가 있으면 추가. 페이지 이동 시 특정 데이터(ID, 이름, 카테고리 등) 함께 넘겨줘야 될 때
    ],
  );
});

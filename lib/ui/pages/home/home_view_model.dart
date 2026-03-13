// 상태관리 노티파이어 정의
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:han_ppyeom/data/model/app_todo.dart';

class HomeViewModel extends Notifier<List<AppTodo>> {
  @override
  List<AppTodo> build() {
    return []; // 초기값은 빈 값
  }

  // 메서드. 할 일을 추가하기
  void addTodo(String title) {
    final newTodo = AppTodo(
      id: DateTime.now().toString(), // 임시 ID
      title: title,
      scheduleAt: DateTime.now(),
    );
    // state.add(newTodo); 내부 리스트 값은 변하는데 주소값은 그대로라서 리버팟이 상태변화를 인식하지 못함
    state = [...state, newTodo]; // 스프레드 연산자. 기존요소 + 새로운 리스트 객체
  }

  // 즐겨찾기 상태
  void stateFavorite(String id) {
    state = [
      for (final todo in state)
        if (todo.id == id)
          todo.copyWith(isFavorite: !todo.isFavorite)
        else
          todo,
    ];
  }

  // 완료 상태
  void stateDone(String id) {
    state = [
      for (final todo in state)
        if (todo.id == id) todo.copyWith(isDone: !todo.isDone) else todo,
    ];
  }
}

// 노티파이어프로바이더 정의. 외부에서 사용
final homeViewModelProvider = NotifierProvider<HomeViewModel, List<AppTodo>>(
  HomeViewModel.new,
);

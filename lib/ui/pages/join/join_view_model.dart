import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class JoinState {
  final String nickname;
  final File? profileImage;
  final bool isLoading;

  JoinState({this.nickname = "", this.profileImage, this.isLoading = false});

  // 상태를 변경할 때 사용하는 메서드. 기존 객체를 복사하여 새로운 상태 객체를 생성(불변성 유지)
  JoinState copyWith({String? nickname, File? profileImage, bool? isLoading}) {
    return JoinState(
      // 새로운 값이 들어오면 그 값을 사용하고, 전해지지 않으면 기존 값을 그대로 유지.
      nickname: nickname ?? this.nickname,
      profileImage: profileImage ?? this.profileImage,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class JoinViewModel extends Notifier<JoinState> {
  @override
  JoinState build() {
    return JoinState();
  }

  // 갤러리에서 이미지를 선택하는 비동기 메서드
  Future<void> pickImage() async {
    final picker = ImagePicker();

    // 갤러리에서 이미지를 선택하도록 호출
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    // 사용자가 이미지 선택 시 실행
    if (pickedFile != null) {
      // 선택된 파일의 경로를 File 객체로 변환하여 상태를 업데이트
      state = state.copyWith(profileImage: File(pickedFile.path));
    }
  }

  // 사용자가 입력한 닉네임을 상태에 반영하는 메서드
  void updateNickname(String nickname) {
    // copyWith를 호출하여 닉네임만 변경된 새로운 상태로 업데이트
    state = state.copyWith(nickname: nickname);
  }

  // 회원 등록 로직
  Future<void> submit() async {
    // 등록이 시작되었으므로 로딩 상태를 true로 변경
    state = state.copyWith(isLoading: true);
    await Future.delayed(const Duration(seconds: 2));
    // 등록 작업 완료 로딩 상태를 false로 변경
    state = state.copyWith(isLoading: false);

    // 실제 가입 성공 후 페이지 이동 로직 등이 들어갈 수 있다.-> 홈으로 이동
    print("회원 등록 완료: ${state.nickname}");
  }
}

// 외부에서 뷰모델에 접근할 수 있도록 도와주는 프로바이더. 전역관리
// autoDispose를 사용하여 페이지를 벗어나면 상태가 메모리에서 사라지도록 설정
final joinViewModelProvider =
    NotifierProvider.autoDispose<JoinViewModel, JoinState>(() {
      return JoinViewModel();
    });

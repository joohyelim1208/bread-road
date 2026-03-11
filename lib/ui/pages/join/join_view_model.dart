import 'dart:io'; // 파일 처리를 위한 dart:io 임포트
import 'package:flutter_riverpod/flutter_riverpod.dart'; // 리버팟 상태 관리를 위한 패키지 임포트
import 'package:image_picker/image_picker.dart'; // 이미지 선택 기능을 위한 패키지 임포트

// 회원가입 화면의 상태를 정의하는 클래스입니다.
class JoinState {
  final String nickname; // 사용자가 입력한 닉네임을 저장하는 필드입니다.
  final File? profileImage; // 사용자가 선택한 프로필 이미지 파일을 저장하는 필드입니다. (선택 사항)
  final bool isLoading; // 서버와의 통신 등 작업 중인지 여부를 나타내는 플래그입니다.

  // 클래스의 생성자입니다. 초기값을 설정할 수 있습니다.
  JoinState({
    this.nickname = "", // 닉네임의 초기값은 빈 문자열입니다.
    this.profileImage, // 프로필 이미지는 초기값이 null입니다.
    this.isLoading = false, // 로딩 상태의 초기값은 false입니다.
  });

  // 상태를 변경할 때 사용하는 메서드입니다. 기존 객체를 복사하여 새로운 상태 객체를 생성합니다. (불변성 유지)
  JoinState copyWith({
    String? nickname, // 변경할 닉네임 값이 있다면 이 인자로 전달됩니다.
    File? profileImage, // 변경할 프로필 이미지 파일이 있다면 이 인자로 전달됩니다.
    bool? isLoading, // 변경할 로딩 상태 값이 있다면 이 인자로 전달됩니다.
  }) {
    return JoinState(
      // 새로운 값이 들어오면 그 값을 사용하고, 전해지지 않으면 기존 값을 그대로 유지합니다.
      nickname: nickname ?? this.nickname,
      profileImage: profileImage ?? this.profileImage,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

// 회원가입 화면의 비즈니스 로직을 담당하는 뷰모델 클래스입니다.
// Notifier를 상속받아 JoinState 상태를 관리합니다.
class JoinViewModel extends Notifier<JoinState> {
  // 뷰모델의 초기 상태를 설정하는 build 메서드입니다.
  @override
  JoinState build() {
    return JoinState(); // 초기 상태인 JoinState 객체를 반환합니다.
  }

  // 갤러리에서 이미지를 선택하는 비동기 메서드입니다.
  Future<void> pickImage() async {
    final picker = ImagePicker(); // ImagePicker 인스턴스를 생성합니다.

    // 갤러리에서 이미지를 선택하도록 호출합니다.
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery, // 소스를 갤러리로 지정합니다.
    );

    // 사용자가 이미지를 선택했다면 실행됩니다.
    if (pickedFile != null) {
      // 선택된 파일의 경로를 File 객체로 변환하여 상태를 업데이트합니다.
      state = state.copyWith(profileImage: File(pickedFile.path));
    }
  }

  // 사용자가 입력한 닉네임을 상태에 반영하는 메서드입니다.
  void updateNickname(String nickname) {
    // copyWith를 호출하여 닉네임만 변경된 새로운 상태로 업데이트합니다.
    state = state.copyWith(nickname: nickname);
  }

  // 회원 등록 로직을 수행하는 메서드입니다.
  Future<void> submit() async {
    // 등록이 시작되었으므로 로딩 상태를 true로 변경합니다.
    state = state.copyWith(isLoading: true);

    // 실제 서버 통신을 대신하여 2초간의 지연 시간을 둡니다.
    await Future.delayed(const Duration(seconds: 2));

    // 등록 작업이 완료되었으므로 로딩 상태를 false로 변경합니다.
    state = state.copyWith(isLoading: false);

    // 여기에 실제 가입 성공 후 페이지 이동 로직 등이 들어갈 수 있습니다.
    print("회원 등록 완료: ${state.nickname}");
  }
}

// 외부에서 뷰모델에 접근할 수 있도록 도와주는 프로바이더(Provider) 정의입니다.
// autoDispose를 사용하여 페이지를 벗어나면 상태가 메모리에서 사라지도록 설정합니다.
final joinViewModelProvider =
    NotifierProvider.autoDispose<JoinViewModel, JoinState>(() {
      return JoinViewModel(); // JoinViewModel의 인스턴스를 반환하여 전역적으로 관리합니다.
    });

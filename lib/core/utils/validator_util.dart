class ValidatorUtil {
  static String? validatorNickNameError(String? text) {
    // 비어있는지 확인하기
    if (text == null || text.trim().isEmpty) {
      return "닉네임을 입력해주세요.";
    }
    // 글자수 제한 12자 초과 시 에러
    if (text.length > 12) {
      return "닉네임은 12글자 이하만 가능합니다.";
    }
    // 중복체크 가짜 함수 (서버통신 흉내냄)
    if (text == "관리자" || text == "admin") {
      // 실제로는 서버에 GET요청을 보내야 함
      return "이미 사용중인 닉네임입니다.";
    }
    return null;
  }

  // 글자 수 표시 형식
  static String textLengthCount(int current, int max) {
    return "$current / $max";
  }

  // 제품명 유효성 검사 (30자 제한)
  static String? validatorBreadNameError(String? text) {
    if (text == null || text.trim().isEmpty) {
      return "제품명을 입력해주세요.";
    }
    if (text.length > 30) {
      return "제품명은 30글자 이하만 가능합니다.";
    }
    return null;
  }

  // 비밀번호도 필요 시 validatorPassword
}

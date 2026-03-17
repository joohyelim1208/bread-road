import 'package:flutter/material.dart';
import 'package:bread_road/core/utils/validator_util.dart';

// 비밀번호도 똑같은 구조 obscureText: true, 비밀번호 가리는 속성
class NickNameTextFormField extends StatelessWidget {
  // 부모에게서 필요한 정보를 받아옴
  final String nickname;
  final ValueChanged<String> onChaged;
  final TextEditingController controller;

  const NickNameTextFormField({
    super.key,
    required this.nickname, // 현재 입력 된 닉네임 값
    required this.onChaged,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final currentLength = nickname.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        TextFormField(
          controller: controller, // 컨트롤러 연결!
          onChanged: onChaged,
          // 텍스트폼필드 속성. 유저가 입력할 때 마다 즉시 검증을 수행하도록 한다.
          autovalidateMode: AutovalidateMode.onUserInteraction,
          style: textTheme.bodyLarge,
          decoration: InputDecoration(
            hintText: '닉네임을 입력해주세요.',

            // 내장 속성 카운터 사용해서 UI 밀림 최소화하기
            helperText: " ",
            helperStyle: textTheme.bodySmall,
            counterText: "$currentLength / 12", // 뷰모델의 상태값을 사용함
            counterStyle: TextStyle(
              color: currentLength > 12
                  ? colorScheme.error
                  : colorScheme.onSurface,
              height: 2,
            ),
          ),
          // 기본 유효성 검사
          validator: (value) => ValidatorUtil.validatorNickNameError(value),
        ),
      ],
    );
  }
}

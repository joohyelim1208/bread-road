import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:han_ppyeom/core/utils/validator_util.dart';
import 'package:han_ppyeom/ui/pages/join/join_view_model.dart';

// 비밀번호도 똑같은 구조 obscureText: true, 비밀번호 가리는 속성
class NickNameTextFormField extends ConsumerWidget {
  // 컨트롤러 삭제 후 온체인지드 콜백을 받음
  final ValueChanged<String> onChanged;

  const NickNameTextFormField({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 뷰모델에서 현재 닉네임의 상태를 가지고 오기!
    final nickname = ref.watch(joinViewModelProvider).nickname;
    final currentLength = nickname.length;
    // 테마데이터 가져오기. joinPage에서 ref.watch로 최신으로 반영되는 테마가 전달됨
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        TextFormField(
          onChanged: onChanged,
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
          validator: (value) => ValidatorUtil.validatorNickNameError(value),
        ),
      ],
    );
  }
}

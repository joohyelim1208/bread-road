import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:han_ppyeom/core/utils/validator_util.dart';

// 비밀번호도 똑같은 구조 obscureText: true, 비밀번호 가리는 속성
class NickNameTextFormField extends ConsumerStatefulWidget {
  const NickNameTextFormField({
    super.key,
    required this.controller,
    required void Function(value) onChanged,
  });

  final TextEditingController controller;

  @override
  ConsumerState<NickNameTextFormField> createState() =>
      _NickNameTextFormFieldState();
}

class _NickNameTextFormFieldState extends ConsumerState<NickNameTextFormField> {
  int _currentLength = 0;

  @override
  void initState() {
    super.initState();
    // 위젯 내부에서 리스너를 달아줌. 글자 수 실시간 업데이트
    widget.controller.addListener(_updateLength);
  }

  void _updateLength() {
    if (mounted) {
      setState(() {
        _currentLength = widget.controller.text.length;
      });
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_updateLength);
    super.dispose(); // 순서에 주의하자!
  }

  @override
  Widget build(BuildContext context) {
    // 테마데이터 가져오기. joinPage에서 ref.watch로 최신으로 반영되는 테마가 전달됨
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        TextFormField(
          controller: widget.controller,
          // 텍스트폼필드 속성. 유저가 입력할 때 마다 즉시 검증을 수행하도록 한다.
          autovalidateMode: AutovalidateMode.onUserInteraction,
          style: textTheme.bodyLarge,
          decoration: InputDecoration(
            hintText: '닉네임을 입력해주세요.',

            // 내장 속성 카운터 사용해서 UI 밀림 최소화하기
            helperText: " ",
            helperStyle: textTheme.bodySmall,
            counterText: "$_currentLength / 12",
            counterStyle: TextStyle(
              color: _currentLength > 12
                  ? colorScheme.error
                  : colorScheme.onSurface,
              height: 2,
            ),
          ),
          validator: ValidatorUtil.validatorNickNameError,
        ),
      ],
    );
  }
}

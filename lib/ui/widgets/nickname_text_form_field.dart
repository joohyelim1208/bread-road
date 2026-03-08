import 'package:flutter/material.dart';
import 'package:han_ppyeom/core/utils/validator_util.dart';

// 비밀번호도 똑같은 구조 obscureText: true, 비밀번호 가리는 속성
class NickNameTextFormField extends StatefulWidget {
  const NickNameTextFormField({super.key, required this.controller});

  final TextEditingController controller;

  @override
  State<NickNameTextFormField> createState() => _NickNameTextFormFieldState();
}

class _NickNameTextFormFieldState extends State<NickNameTextFormField> {
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
    super.dispose();
    widget.controller.removeListener(_updateLength);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        TextFormField(
          controller: widget.controller,
          // 텍스트폼필드 속성. 유저가 입력할 때 마다 즉시 검증을 수행하도록 한다.
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: InputDecoration(
            hintText: '닉네임을 입력해주세요.',
            // 내장 속성 카운터 사용해서 UI밀림 최소화하기
            helperText: " ",
            helperStyle: const TextStyle(fontSize: 12),
            // 에러스타일 고정시키기 UI 밀림 방지
            errorStyle: const TextStyle(fontSize: 12, height: 1),
            counterText: "$_currentLength / 12",
            counterStyle: TextStyle(
              color: _currentLength > 12 ? Colors.red : Colors.grey,
            ),
          ),
          validator: ValidatorUtil.validatorNickNameError,
        ),
      ],
    );
  }
}

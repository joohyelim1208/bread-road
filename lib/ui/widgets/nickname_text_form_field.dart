import 'package:flutter/material.dart';
import 'package:han_ppyeom/core/validator_util.dart';

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
    widget.controller.addListener(() {
      if (mounted) {
        setState(() {
          _currentLength = widget.controller.text.length;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        TextFormField(
          controller: widget.controller,
          decoration: InputDecoration(
            hintText: '닉네임을 입력해주세요.',
            counterText: "", // 하단 기본 카운터 숨기기
          ),
          validator: ValidatorUtil.validatorNickNameError,
        ),
        Text(
          "$_currentLength / 12",
          style: TextStyle(
            fontSize: 12,
            color: _currentLength > 12 ? Colors.red : Colors.grey,
          ),
        ),
      ],
    );
  }
}

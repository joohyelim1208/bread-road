import 'dart:io';
import 'package:flutter/material.dart';
import 'package:han_ppyeom/ui/widgets/nickname_text_form_field.dart';

class JoinPage extends StatefulWidget {
  const JoinPage({super.key});

  @override
  State<JoinPage> createState() => _JoinPageState();
}

class _JoinPageState extends State<JoinPage> {
  // 상태 데이터 직접 선언
  String _nickname = "";
  File? _profileImage;
  bool _isLoading = false;

  // 닉네임 컨트롤러
  final TextEditingController _nicknameController = TextEditingController();

  // 프로필 이미지(이미지 피커 삭제했으므로 로직 흐름두고, 다시 사용한다면 여기서 수정)
  Future<void> _pickImage() async {
    print("이미지 선택 호출");
  }

  // 등록완료. 메시지도 출력
  Future<void> _submitNickname() async {
    if (_nickname.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("닉네임을 입력해주세요.")));
      return;
    }
    // 등록
    setState(() => _isLoading = true);
    // 실제 등록 로직(서버통신 할 때 로직 구현)
    await Future.delayed(const Duration(seconds: 2));
    // 비동기 API요청 수행 시 요청 완료되기 전 사용자가 화면을 떠나면 (Dispose) context를 더이상 사용할 수 없어서 에러가 발생
    // 이를 방지하기 위해 if (!mounted) return; 체크를 반드시 해야됨
    if (mounted) {
      setState(() => _isLoading = false);
      // 등록 완료 후 홈화면 스택비우고 이동하기
      Navigator.pushAndRemoveUntil(context, '/', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Scaffold(
      // 화면 키보드 나타날 때 화면크기 줄여서 키보드 위로 올림. 로그인 화면에서는 true
      resizeToAvoidBottomInset: true,
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text('프로필 등록하기', style: textTheme.titleLarge),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          const SizedBox(height: 20),

          // 프로필이미지 위젯
          const SizedBox(height: 40),

          // 닉네임 입력 위젯
          const SizedBox(height: 40),

          // 하단 등록하기 버튼 위젯
          const SizedBox(height: 16),
          Text(
            "소셜 로그인 시 더 다양한 기능을 활용하실 수 있습니다.",
            textAlign: TextAlign.center,
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant, // 배경색 바뀌면 잘 보이게끔
            ),
          ),
        ],
      ),
    );
  }

  // 이미지 등록 위젯
  Widget _buildProfileImage(ColorScheme colorScheme) {
    return Center(
      child: GestureDetector(
        onTap: _pickImage,
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                shape: BoxShape.circle,
                image: _profileImage != null
                    ? DecorationImage(
                        image: FileImage(_profileImage!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              // 프로필이미지 없을 때
              child: _profileImage == null
                  ? Icon(
                      Icons.person,
                      size: 80,
                      color: colorScheme.onSurfaceVariant,
                    )
                  : null,
            ),
            // 카메라 아이콘
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: colorScheme.primary,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1),
              ),
              child: const Icon(
                Icons.camera_alt,
                size: 20,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

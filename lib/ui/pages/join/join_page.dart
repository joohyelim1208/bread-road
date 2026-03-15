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

  // 닉네임 컨트롤러. 초기화. 자식위젯 닉네임텍스트폼필드 연결
  final TextEditingController _nicknameController = TextEditingController();

  // 컨트롤러 삭제
  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }

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
    try {
      // 실제 등록 로직(서버통신 할 때 로직 구현)
      await Future.delayed(const Duration(seconds: 2));
      // 비동기 API요청 수행 시 요청 완료되기 전 사용자가 화면을 떠나면 (Dispose) context를 더이상 사용할 수 없어서 에러가 발생
      // 이를 방지하기 위해 if (!mounted) return; 체크를 반드시 해야됨
      if (!mounted) return;
      // 성공 시 홈화면으로 이동. 라우트 사용시 Name이 붙어야 스트링타입 쓸 수 있음!
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        // 에러발생 시 사용자에게 알림만 주고 조인페이지에 머물러야 함. 등록에러메시지 추가하기기능 검색
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("닉네임 등록 실패: $e")));
      }
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
      body: GestureDetector(
        // 화면 밖 터치 시 키보드 숨김
        onTap: () => FocusScope.of(context).unfocus(),
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: [
            const SizedBox(height: 20),
            // 프로필이미지 위젯
            _buildProfileImage(colorScheme),
            const SizedBox(height: 40),
            // 닉네임 입력 위젯. 자식에게서 컨트롤러 전달받음
            NickNameTextFormField(
              nickname: _nickname,
              controller: _nicknameController,
              onChaged: (value) {
                setState(() {
                  _nickname = value; // 입력할 때 마다 상태를 업데이트 글자수 즉시 변경
                });
              },
            ),
            const SizedBox(height: 40),
            // 하단 등록하기 버튼 위젯
            _buildInputButton(colorScheme, textTheme),
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

  // 버튼 등록 위젯
  Widget _buildInputButton(ColorScheme colorScheme, TextTheme textTheme) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _submitNickname,
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        child: _isLoading
            ? SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Text("등록완료", style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}

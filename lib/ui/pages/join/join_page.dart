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
      resizeToAvoidBottomInset: true,
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(
          '프로필 등록하기',
          style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 40),
              // 프로필이미지 위젯
              _buildProfileImage(colorScheme),
              const SizedBox(height: 48),
              // 닉네임 입력 위젯
              NickNameTextFormField(
                nickname: _nickname,
                controller: _nicknameController,
                onChaged: (value) {
                  setState(() {
                    _nickname = value;
                  });
                },
              ),
              const SizedBox(height: 10),
              // 하단 등록하기 버튼 위젯
              _buildInputButton(colorScheme, textTheme),
              const SizedBox(height: 20),
              Text(
                "로그인 정보를 잊으셨나요?\n소셜 로그인 시 더 다양한 기능을 활용하실 수 있습니다.",
                textAlign: TextAlign.center,
                style: textTheme.bodySmall?.copyWith(
                  color: Colors.grey[500],
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // 프로필이미지 위젯
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
                color: Colors.grey[100],
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey[200]!, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(10),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
                image: _profileImage != null
                    ? DecorationImage(
                        image: FileImage(_profileImage!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: _profileImage == null
                  ? Icon(
                      Icons.person_outline,
                      size: 70,
                      color: Colors.grey[400],
                    )
                  : null,
            ),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: colorScheme.primary,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(10),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.camera_alt,
                size: 18,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputButton(ColorScheme colorScheme, TextTheme textTheme) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _submitNickname,
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: _isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Text(
                "등록완료",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
      ),
    );
  }
}

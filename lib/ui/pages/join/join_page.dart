import 'dart:io';
import 'package:flutter/material.dart';
import 'package:bread_road/ui/widgets/nickname_text_form_field.dart';
import 'widgets/profile_image_picker.dart';
import 'widgets/join_submit_button.dart';

class JoinPage extends StatefulWidget {
  const JoinPage({super.key});

  @override
  State<JoinPage> createState() => _JoinPageState();
}

class _JoinPageState extends State<JoinPage> {
  String _nickname = "";
  File? _profileImage;
  bool _isLoading = false;

  final TextEditingController _nicknameController = TextEditingController();

  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }

  Future<void> _submitNickname() async {
    if (_nickname.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("닉네임을 입력해주세요.")));
      return;
    }
    setState(() => _isLoading = true);
    try {
      await Future.delayed(const Duration(seconds: 2));
      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
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
              ProfileImagePicker(
                initialImage: _profileImage,
                onImageSelected: (image) {
                  setState(() {
                    _profileImage = image;
                  });
                },
              ),
              const SizedBox(height: 48),
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
              JoinSubmitButton(
                text: "등록완료",
                isLoading: _isLoading,
                onPressed: _submitNickname,
              ),
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
}

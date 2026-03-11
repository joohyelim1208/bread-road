import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:han_ppyeom/core/theme/theme_provider.dart';
import 'package:han_ppyeom/ui/pages/join/join_view_model.dart';
import 'package:han_ppyeom/ui/widgets/nickname_text_form_field.dart';

class JoinPage extends ConsumerWidget {
  const JoinPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 상태를 관찰함
    final joinState = ref.watch(joinViewModelProvider);
    // 뷰모델을 참조함
    final joinViewModel = ref.read(joinViewModelProvider.notifier);
    final theme = ref.watch(themeProvider);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Scaffold(
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
          Center(
            child: GestureDetector(
              // 이미지 가져오기
              onTap: () => joinViewModel.pickImage(),
              child: Stack(
                alignment: Alignment.bottomLeft,
                children: [
                  Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest,
                      shape: BoxShape.circle,
                      image: joinState.profileImage != null
                          ? DecorationImage(
                              image: FileImage(
                                joinState.profileImage!,
                              ), // 선택된 이미지가 있으면 표시
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    // 만약 이미지가 없다면 기본 아이콘 화면
                    child: joinState.profileImage == null
                        ? Icon(
                            Icons.person,
                            size: 80,
                            color: colorScheme.onSurfaceVariant,
                          )
                        : null,
                  ),
                  // 프로필 등록 카메라 아이콘
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1),
                    ),
                    child: Icon(
                      Icons.camera_alt,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 40),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
            children: [
              Text("닉네임", style: textTheme.titleMedium),
              const SizedBox(height: 10),
              NickNameTextFormField(
                // 텍스트가 입력이 될 때 마다 뷰모델에게 알려줌. 온체인지드 사용해서 뷰모델에 저장!!
                onChanged: (value) => joinViewModel.updateNickname(value),
              ),
            ],
          ),
          const SizedBox(height: 40),
          // 하단 등록하기 버튼
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              // 로딩 중이 아닐 때만 버튼이 동작하게 한다.
              onPressed: joinState.isLoading
                  ? null
                  : () => joinViewModel.submit(),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary, // 배경색과 대비되는 색상
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                elevation: 0,
              ),
              // 로딩 중일 때는 로딩바를, 아닐 때는 등록 완료
              child: joinState.isLoading
                  ? SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: colorScheme.onPrimary, // 선택이 되지 않았을 땐 대비색
                      ),
                    )
                  : Text("등록 완료", style: textTheme.labelSmall),
            ),
          ),
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
}

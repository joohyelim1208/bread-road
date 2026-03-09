import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:han_ppyeom/core/theme/theme_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:han_ppyeom/ui/widgets/nickname_text_form_field.dart';

class JoinPage extends ConsumerStatefulWidget {
  const JoinPage({super.key});

  @override
  ConsumerState<JoinPage> createState() => _JoinPageState();
}

class _JoinPageState extends ConsumerState<JoinPage> {
  // 선택한 파일을 저장할 변수
  //File? _image;

  // 이미지피커 패키지 추가

  final _nickNameControllor = TextEditingController();
  final formkey = GlobalKey<FormState>();

  // 기존 데이터 수정. 서버에서 불러온 닉네임을 미리 채워넣어야 할 때, 값이 변할 때 마다 실시간 로직을 처리해야 할 때(리스너 등록)
  @override
  void initState() {
    super.initState();
    _nickNameControllor.text = "";
  }

  @override
  void dispose() {
    _nickNameControllor.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 리버팟 테마 적용. themeData 통째로 가져옴
    final theme = ref.watch(themeProvider);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: () {
        // 빈 화면 눌렀을 때 키보드 해제
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        appBar: AppBar(title: Text('프로필 등록하기', style: textTheme.titleLarge)),
        body: Form(
          key: formkey,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 20),
            children: [
              GestureDetector(
                onTap: () {
                  // 메서드 만들어서 넘겨주기. 이미지 피커 로직 호출함
                },
                child: Center(
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      // 프로필 영역
                      Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHighest,
                          shape: BoxShape.circle,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.person,
                              size: 60,
                              color: colorScheme.onSurfaceVariant,
                            ),
                            Text("프로필 사진", style: TextStyle()),
                          ],
                        ),
                      ),
                      // 스택구조 카메라 아이콘 배치
                      Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: colorScheme.primary,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: colorScheme.surface,
                            width: 2,
                          ),
                        ),
                        child: Icon(
                          Icons.camera_alt,
                          size: 24,
                          color: colorScheme.onPrimary, // 배경색에 대비되는 색
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("닉네임", style: textTheme.titleMedium),
                  SizedBox(height: 10),
                  // 에러메시지와 카운터는 이 위젯이 알아서 그려줌
                  NickNameTextFormField(controller: _nickNameControllor),
                ],
              ),

              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  formkey.currentState?.validate();
                  print("등록 로직 실행");
                },
                child: Text("등록 완료"),
              ),
              Container(
                height: 40,
                color: Colors.transparent,
                alignment: Alignment.center,
                child: Text(
                  "소셜 로그인 시 더 다양한 기능을 활용하실 수 있습니다.",
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

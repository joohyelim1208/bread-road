import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:han_ppyeom/ui/widgets/nickname_text_form_field.dart';

class JoinPage extends StatefulWidget {
  const JoinPage({super.key});

  @override
  State<JoinPage> createState() => _JoinPageState();
}

class _JoinPageState extends State<JoinPage> {
  // 선택한 파일을 저장할 변수
  //File? _image;

  // 이미지피커 패키지 추가

  final _nickNameControllor = TextEditingController();
  final formkey = GlobalKey<FormState>();

  // 기존 데이터 수정. 서버에서 불러온 닉네임을 미리 채워넣어야 할 때, 값이 변할 때 마다 실시간 로직을 처리해야 할 때(리스너 등록)
  @override
  void initState() {
    super.initState();
    _nickNameControllor.text = "기본값";
  }

  @override
  void dispose() {
    _nickNameControllor.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // 빈 화면 눌렀을 때 키보드 해제
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(title: Text('프로필 등록하기')),
        body: Form(
          key: formkey,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 20),
            children: [
              GestureDetector(
                onTap: () {
                  // 메서드 만들어서 넘겨주기. 이미지 선택 로직 호출함
                },
                child: Center(
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      // 프로필 영역
                      Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          shape: BoxShape.circle,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.person, size: 60, color: Colors.grey),
                            Text("프로필 사진", style: TextStyle()),
                          ],
                        ),
                      ),
                      // 스택구조 카메라 아이콘 배치
                      Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: Icon(
                          Icons.camera_alt,
                          size: 24,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("닉네임", style: TextStyle()),
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
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

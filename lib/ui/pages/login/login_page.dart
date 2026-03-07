import 'package:flutter/material.dart';
import 'package:han_ppyeom/ui/pages/join/join_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 컬럼이 전체 사용할 수 있도록 패딩으로 감싸줌
      body: SafeArea(
        child: SizedBox.expand(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Spacer(),
                // 로고 등 이미지
                // Image.asset('assets/'),
                SizedBox(height: 20),
                Text(
                  '어제보다 딱 한 뼘,\n나를 토닥이는 작은 기록',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    //
                  ),
                ),
                Spacer(),
                ElevatedButton(onPressed: () {}, child: Text('카카오톡으로 로그인하기')),
                SizedBox(height: 10),
                ElevatedButton(onPressed: () {}, child: Text('구글로 로그인하기')),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return JoinPage();
                        },
                      ),
                    );
                  },
                  child: Text('다른 방법으로 시작하기'),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          // 로그인 구현 전. 바로 프로필 등록으로 넘어감
                          return JoinPage();
                        },
                      ),
                    );
                  },
                  child: Container(
                    height: 40,
                    color: Colors.transparent,
                    alignment: Alignment.center,
                    child: Text('이미 계정이 있나요? 로그인하기', style: TextStyle()),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

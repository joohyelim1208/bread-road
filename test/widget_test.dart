import 'package:flutter/material.dart';

// 이미지 피커 테스트
void main() => runApp(MaterialApp(home: Test()));

class Test extends StatelessWidget {
  const Test({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.network(
          'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
          loadingBuilder: (context, child, loadingProgress) {
            return loadingProgress == null
                ? child
                : CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}

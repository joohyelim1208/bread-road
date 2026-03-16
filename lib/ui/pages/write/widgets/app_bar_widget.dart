import 'package:flutter/material.dart';

// 커스터마이징 앱 바를 사용해서 페이지 별 적용해서 사용하기!
class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color? backgroundColor;
  final List<Widget>? actions;
  final bool showBack;
  // 즐겨찾기 누르고 정보를 가지고 다시 돌아가려면
  final VoidCallback? onBackPressed;

  const AppBarWidget({
    super.key,
    required this.title,
    this.backgroundColor = Colors.transparent,
    this.actions,
    this.showBack = true,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      // 그림자 제거
      elevation: 0,
      centerTitle: true,
      leading: showBack
          ? IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              // 현재 열려있는 페이지를 닫고 원래 있던 곳으로 되돌아가기
              // 즐겨찾기 저장된 채 돌아가는 기능. 밖에서 준 기능이 있으면 그걸 쓰고 없으면 그냥 꺼짐
              onPressed: onBackPressed ?? () => Navigator.pop(context),
            )
          : null,
      title: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(56);
}

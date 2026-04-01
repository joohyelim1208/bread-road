import 'package:flutter/material.dart';

class ScrollingBackground extends StatefulWidget {
  final String imagePath;

  const ScrollingBackground({
    super.key,
    this.imagePath = 'assets/images/bread.webp',
  });

  @override
  State<ScrollingBackground> createState() => _ScrollingBackgroundState();
}

class _ScrollingBackgroundState extends State<ScrollingBackground> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startBackgroundAnimation();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _startBackgroundAnimation() {
    if (!_scrollController.hasClients || !mounted) return;

    final maxScroll = _scrollController.position.maxScrollExtent;
    const duration = Duration(seconds: 460); // 매우 천천히 이동

    _scrollController
        .animateTo(maxScroll, duration: duration, curve: Curves.linear)
        .then((_) {
      if (mounted) {
        _scrollController.jumpTo(0);
        _startBackgroundAnimation();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(
            3,
            (index) => Image.asset(
              widget.imagePath,
              height: MediaQuery.of(context).size.height,
              fit: BoxFit.fitHeight,
            ),
          ),
        ),
      ),
    );
  }
}

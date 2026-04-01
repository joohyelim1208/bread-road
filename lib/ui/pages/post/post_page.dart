import 'package:bread_road/core/utils/button_util.dart';
import 'package:bread_road/ui/pages/write/write_page.dart';
import 'package:bread_road/ui/widgets/app_bar_widget.dart';
import 'package:flutter/material.dart';

import 'widgets/post_image_gallery.dart';
import 'widgets/post_detail_header.dart';
import 'widgets/post_sensory_section.dart';

class PostPage extends StatefulWidget {
  final Map<String, dynamic> record;

  const PostPage({super.key, required this.record});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  bool _isFavorite = false;
  late Map<String, dynamic> _currentRecord;

  @override
  void initState() {
    super.initState();
    _currentRecord = widget.record;
    _isFavorite = _currentRecord['isFavorite'] ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final record = _currentRecord;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarWidget(
        title: '내 기록',
        onBackPressed: () =>
            Navigator.pop(context, {"data": _currentRecord, "goToRecord": true}),
        actions: [
          IconButton(
            icon: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
              color: _isFavorite ? Colors.red : Colors.grey,
            ),
            onPressed: () {
              setState(() {
                _isFavorite = !_isFavorite;
                _currentRecord['isFavorite'] = _isFavorite;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.grey),
            onPressed: () {
              _showDeleteDialog(context);
            },
          ),
        ],
      ),
      extendBody: true,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PostImageGallery(
              images: (record['images'] as List?)?.map((e) => e.toString()).toList() ?? [],
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PostDetailHeader(record: record),
                  PostSensorySection(record: record),
                  const Divider(),
                  const SizedBox(height: 24),
                  Text(
                    "설명",
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    record['content'] ?? '상세 설명이 없습니다.',
                    style: textTheme.bodyMedium?.copyWith(
                      fontSize: 14,
                      color: Colors.black87,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 40),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: ButtonUtil(
        label: "수정하기",
        onTap: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WritePage(initialData: _currentRecord),
            ),
          );
          if (result != null && mounted) {
            setState(() {
              _currentRecord = result as Map<String, dynamic>;
            });
          }
        },
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("삭제하시겠습니까?"),
        content: const Text("삭제된 데이터는 복구할 수 없습니다."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("취소"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // 팝업 닫기
              Navigator.pop(context, {"isDeleted": true}); // 이전 페이지로 삭제 정보 전달
            },
            child: const Text("삭제", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

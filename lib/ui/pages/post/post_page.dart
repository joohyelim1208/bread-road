import 'dart:io';
import 'package:bread_road/core/utils/button_util.dart';
import 'package:bread_road/ui/pages/write/write_page.dart';
import 'package:bread_road/ui/widgets/app_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PostPage extends StatefulWidget {
  final Map<String, dynamic> record;

  const PostPage({super.key, required this.record});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  bool _isFavorite = false;
  // 1. 현재 페이지에서 보여줄 데이터 상태를 별도로 관리
  late Map<String, dynamic> _currentRecord;
  int _currentPage = 0;

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
      // 5. extendBody를 true로 설정하여 바디 콘텐츠가 바텀바 영역까지 흐르도록 함 (투명 효과를 위해)
      extendBody: true,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 이미지 영역
            Container(
              width: double.infinity,
              height: 300,
              color: Colors.grey[100],
              child: Stack(
                children: [
                  if ((record['images'] as List?)?.isNotEmpty ?? false)
                    PageView.builder(
                      itemCount: (record['images'] as List).length,
                      onPageChanged: (index) {
                        setState(() {
                          _currentPage = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        final String imagePath = record['images'][index].toString();
                        final bool isNetwork = imagePath.startsWith('http');
                        return Image(
                          image: isNetwork
                              ? NetworkImage(imagePath)
                              : FileImage(File(imagePath)) as ImageProvider,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        );
                      },
                    )
                  else
                    const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.bakery_dining, size: 80, color: Colors.grey),
                          SizedBox(height: 12),
                          Text(
                            "등록된 사진이 없습니다.",
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  if ((record['images'] as List?)?.isNotEmpty ?? false)
                    Positioned(
                      bottom: 16,
                      right: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "${_currentPage + 1} / ${(record['images'] as List).length}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${record['mainType'] ?? '분류없음'} / ${record['subCategory'] ?? '소분류없음'}",
                    style: textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    record['name'] ?? '제품명 없음',
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: List.generate(5, (index) {
                          double rating =
                              double.tryParse(
                                record['rating']?.toString() ?? '0',
                              ) ??
                              0;
                          IconData iconData = Icons.star_border;
                          Color iconColor = Colors.grey[300]!;

                          if (rating >= index + 1) {
                            iconData = Icons.star;
                            iconColor = Colors.amber;
                          } else if (rating > index) {
                            iconData = Icons.star_half;
                            iconColor = Colors.amber;
                          }

                          return Icon(iconData, color: iconColor, size: 24);
                        }),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        "총점 ${double.tryParse(record['rating']?.toString() ?? '0')?.toStringAsFixed(1) ?? '0.0'}",
                        style: textTheme.bodyMedium?.copyWith(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      const Icon(
                        Icons.storefront,
                        size: 20,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          record['bakery'] ?? '가게명 없음',
                          style: textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      // 임시로 넣어둔 것. 추후 위치데이터 연동 가능 시 반영하기
                      Text(
                        "평점 0.0  리뷰 000+",
                        style: textTheme.labelSmall?.copyWith(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 20,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "서울시 강남구 역삼동",
                        style: textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_outlined,
                        size: 20,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        "방문날짜",
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        _formatDate(record['visitDate'] ?? ''),
                        style: textTheme.bodyLarge,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(
                        Icons.check_circle_outline,
                        size: 20,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        "시식여부",
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        (record['isScheduled'] == false) ? "시식완료" : "시식예정",
                        style: textTheme.bodyLarge,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 24),
                  _buildSensoryEvaluation(record, textTheme),
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
                  // 6. 바텀바가 투명이므로 마지막 요소가 가려지지 않게 여백 추가
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
      // 7. 수정하기 버튼을 ButtonUtil로 디자인 통일 및 그림자 효과가 포함된 하단 바 적용
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

  Widget _buildSensoryEvaluation(
    Map<String, dynamic> record,
    TextTheme textTheme,
  ) {
    return Column(
      children: [
        _buildSensoryRow(
          "맛",
          (record['tastes'] as List?)?.map((e) => e.toString()).toList() ?? [],
          textTheme,
        ),
        const SizedBox(height: 16),
        _buildSensoryRow(
          "풍미",
          record['flavor'] != null ? [record['flavor'].toString()] : [],
          textTheme,
        ),
        const SizedBox(height: 16),
        _buildSensoryRow(
          "향",
          (record['scents'] as List?)?.map((e) => e.toString()).toList() ?? [],
          textTheme,
        ),
        const SizedBox(height: 16),
        _buildSensoryRow(
          "식감",
          (record['textures'] as List?)?.map((e) => e.toString()).toList() ?? [],
          textTheme,
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildSensoryRow(
    String title,
    List<String> values,
    TextTheme textTheme,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 60,
          child: Text(
            title,
            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: values.map((value) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Text(
                  value,
                  style: textTheme.bodySmall?.copyWith(color: Colors.grey[800]),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  String _formatDate(String dateStr) {
    try {
      DateTime dt = DateTime.parse(dateStr);
      return DateFormat('yyyy년 MM월 dd일 (E)', 'ko_KR').format(dt);
    } catch (e) {
      return dateStr;
    }
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

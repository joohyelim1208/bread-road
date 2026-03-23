import 'package:bread_road/ui/pages/write/write_page.dart';
import 'package:bread_road/ui/widgets/app_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PostPage extends StatefulWidget {
  final Map<String, dynamic> data;

  const PostPage({super.key, required this.data});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  bool _isFavorite = false;
  // 1. 현재 페이지에서 보여줄 데이터 상태를 별도로 관리
  late Map<String, dynamic> _currentData;

  @override
  void initState() {
    super.initState();
    _currentData = widget.data;
    _isFavorite = _currentData['isFavorite'] ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final data = _currentData;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarWidget(
        title: '내 기록',
        onBackPressed: () => Navigator.pop(context, {
          "data": _currentData,
          "goToRecord": true,
        }),
        actions: [
          IconButton(
            icon: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
              color: _isFavorite ? Colors.red : Colors.grey,
            ),
            onPressed: () {
              setState(() {
                _isFavorite = !_isFavorite;
                _currentData['isFavorite'] = _isFavorite;
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
              height: 250,
              color: Colors.grey[200],
              child: Stack(
                children: [
                  const Center(
                    child: Icon(Icons.image, size: 70, color: Colors.grey),
                  ),
                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      child: const Text(
                        "1 / 10",
                        style: TextStyle(color: Colors.white, fontSize: 12),
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
                    "${data['mainType'] ?? '분류없음'} / ${data['subCategory'] ?? '소분류없음'}",
                    style: textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    data['name'] ?? '제품명 없음',
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
                          double rating = double.tryParse(
                                data['rating']?.toString() ?? '0',
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

                          return Icon(
                            iconData,
                            color: iconColor,
                            size: 24,
                          );
                        }),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        "총점 ${double.tryParse(data['rating']?.toString() ?? '0')?.toStringAsFixed(1) ?? '0.0'}",
                        style: textTheme.bodyMedium?.copyWith(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      const Icon(Icons.storefront, size: 20, color: Colors.grey),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          data['bakery'] ?? '가게명 없음',
                          style: textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        "평점 0.0  리뷰 000+",
                        style: textTheme.labelSmall?.copyWith(color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 20, color: Colors.grey),
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
                      const Icon(Icons.calendar_today_outlined,
                          size: 20, color: Colors.grey),
                      const SizedBox(width: 12),
                      Text(
                        "방문날짜",
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        _formatDate(data['visitDate'] ?? ''),
                        style: textTheme.bodyLarge,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.check_circle_outline,
                          size: 20, color: Colors.grey),
                      const SizedBox(width: 12),
                      Text(
                        "시식여부",
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        (data['isScheduled'] == false) ? "시식완료" : "시식예정",
                        style: textTheme.bodyLarge,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 24),
                  _buildSensoryEvaluation(data, textTheme),
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
                    data['content'] ?? '상세 설명이 없습니다.',
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
      // 7. 수정하기 버튼을 바텀바에 고정 (배경 투명 처리)
      bottomNavigationBar: Container(
        color: Colors.transparent,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WritePage(initialData: _currentData),
                    ),
                  );
                  if (result != null && mounted) {
                    setState(() {
                      _currentData = result as Map<String, dynamic>;
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: const Text(
                  "수정하기",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSensoryEvaluation(
    Map<String, dynamic> data,
    TextTheme textTheme,
  ) {
    return Column(
      children: [
        _buildSensoryRow(
          "맛",
          (data['tastes'] as List?)?.map((e) => e.toString()).toList() ?? [],
          textTheme,
        ),
        const SizedBox(height: 16),
        _buildSensoryRow(
          "풍미",
          data['flavor'] != null ? [data['flavor'].toString()] : [],
          textTheme,
        ),
        const SizedBox(height: 16),
        _buildSensoryRow(
          "향",
          (data['scents'] as List?)?.map((e) => e.toString()).toList() ?? [],
          textTheme,
        ),
        const SizedBox(height: 16),
        _buildSensoryRow(
          "식감",
          (data['textures'] as List?)?.map((e) => e.toString()).toList() ?? [],
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
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
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

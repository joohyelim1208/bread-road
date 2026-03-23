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
  // 1. 현재 페이지에서 보여줄 데이터 상태를 별도로 관리 (상위에서 받은 widget.data를 초기값으로 사용)
  late Map<String, dynamic> _currentData;

  @override
  void initState() {
    super.initState();
    // 전달받은 데이터를 상태 변수에 저장하여, 수정 시 화면을 즉시 갱신
    _currentData = widget.data;
    _isFavorite = _currentData['isFavorite'] ?? false;
  }

  @override
  Widget build(BuildContext context) {
    // widget.data 대신 상태 값인 _currentData를 사용
    final data = _currentData;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarWidget(
        title: '내 기록',
        // 2. 뒤로가기 버튼 클릭 시, 수정된 최신 데이터를 가지고 이전 화면(HomePage)으로 돌아간다.
        onBackPressed: () => Navigator.pop(context, _currentData),
        actions: [
          IconButton(
            icon: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
              color: _isFavorite ? Colors.red : Colors.grey,
            ),
            onPressed: () {
              setState(() {
                _isFavorite = !_isFavorite;
                // 즐겨찾기 상태 변경 시 데이터에도 반영됨
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
                      // 이미지 연동 가능하면 사진 등록장수 반영되게 수정하기
                      child: const Text(
                        "1 / 10",
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // 분류 이미지영역 아래로 빼기
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
                  // 제품명
                  Text(
                    data['name'] ?? '제품명 없음',
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // 별점
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: List.generate(5, (index) {
                          double rating =
                              double.tryParse(
                                data['rating']?.toString() ?? '0',
                              ) ??
                              0;
                          return Icon(
                            index < rating ? Icons.star : Icons.star_border,
                            color: index < rating
                                ? Colors.amber
                                : Colors.grey[300],
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

                  // 상호명. 추후 위치데이터 연동하고 정보가져오기 가능하면 위치, 평점, 리뷰 반영되게 변경하기!
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
                          data['bakery'] ?? '가게명 없음',
                          style: textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        "평점 0.0  리뷰 000+",
                        style: textTheme.labelSmall?.copyWith(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // 가게 위치 (가상 데이터)
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 20,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "서울시 강남구 역삼동", // 임시 데이터
                        style: textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  const Divider(),
                  const SizedBox(height: 16),

                  // 방문날짜
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
                        _formatDate(data['visitDate'] ?? ''),
                        style: textTheme.bodyLarge,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // 시식여부
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
                        (data['isScheduled'] == false) ? "시식완료" : "시식예정",
                        style: textTheme.bodyLarge,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  const Divider(),
                  const SizedBox(height: 24),

                  // 감각 평가 (맛, 풍미, 향, 식감)
                  _buildSensoryEvaluation(data, textTheme),

                  const Divider(),
                  const SizedBox(height: 24),

                  // 상세 설명
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

                  // 수정하기 버튼
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () async {
                        // 3. 수정하기 로직: WritePage로 이동하여 편집 후 돌아올 때 수정된 데이터가 저장된 채 돌아와야 함
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                WritePage(initialData: _currentData),
                          ),
                        );

                        // 4. 수정을 마치고 돌아왔을 때, 결과값이 있으면 현재 페이지의 상태(_currentData)를 갱신함
                        // PostPage 바로 업데이트, HomePage로 돌아갈 때도 최신 데이터를 전달함
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
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
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
          // 데이터가 null일 수 있음 그럼 그대로 반환하고 멈춤, null이 아닐 때 .map을 실행한다. 각 요소 (e)를 하나씩 꺼내고 문자열로 강제변환하기.
          // .toList Iterable 추상적 형태를 반환하는걸 실제 List<String>형태로 최종 반환함
          (data['tastes'] as List?)?.map((e) => e.toString()).toList() ??
              [], // 모든 결과가 null일 경우 널세이프티=에러 대신에 빈리스트[]를 넣어라. 앱이 멈추지 않음
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
        Expanded(
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: values
                .map(
                  (v) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Text(
                      v,
                      style: textTheme.bodyMedium?.copyWith(
                        fontSize: 12,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }

  String _formatDate(String dateStr) {
    if (dateStr.isEmpty) return '';
    try {
      DateTime dt = DateTime.parse(dateStr);
      return DateFormat('yyyy.MM.dd.(E)', 'ko_KR').format(dt);
    } catch (e) {
      return dateStr;
    }
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("알림"),
        content: const Text("삭제 하시겠습니까?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("취소"),
          ),
          TextButton(
            onPressed: () {
              // 5. 삭제 시에는 isDeleted 표시를 담아 pop 함으로써 HomePage에서 목록에서 제거
              Navigator.pop(context); // 다이얼로그 닫기
              Navigator.pop(context, {
                "isDeleted": true,
              }); // PostPage 닫으며 삭제 정보 전달
            },
            child: const Text("삭제", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

import 'package:bread_road/ui/pages/post/post_page.dart';
import 'package:bread_road/ui/widgets/app_bar_widget.dart';
import 'package:flutter/material.dart';

// postPage에서 뒤로가기를 누르면 레코드페이지로 넘어오기
class RecordPage extends StatefulWidget {
  // 1. 전체 기록 리스트를 생성자로 전달받는다.
  final List<Map<String, dynamic>> records;
  // 2. 리스트가 변경되었을 때 상위 페이지(home_page)의 상태를 업데이트하기 위한 콜백 함수
  final Function(int index, dynamic result) onRecordUpdated;

  const RecordPage({
    super.key,
    required this.records,
    required this.onRecordUpdated,
  });

  @override
  State<RecordPage> createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const AppBarWidget(
        title: '내 기록',
        showBack: false, // 탭 내부 페이지이므로 뒤로가기 버튼 비활성화
      ),
      // 3. 기록이 있으면 리스트를 보여주고, 없으면 빈 화면
      body: widget.records.isEmpty
          ? _buildEmptyView(textTheme)
          : ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: widget.records.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final record = widget.records[index];
                return _buildRecordItem(record, index, textTheme);
              },
            ),
    );
  }

  // 데이터가 없을 때 표시할 화면 (오늘의 빵이 비어있을 때)
  Widget _buildEmptyView(TextTheme textTheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.auto_stories_outlined, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            "아직 작성된 기록이 없습니다.",
            style: textTheme.bodyLarge?.copyWith(color: Colors.grey),
          ),
          const SizedBox(height: 8),
          Text(
            "오늘 먹은 빵을 기록해보세요!",
            style: textTheme.bodyMedium?.copyWith(color: Colors.grey[400]),
          ),
        ],
      ),
    );
  }

  // 4. 홈 페이지의 리스트 스타일을 그대로 갖고옴
  Widget _buildRecordItem(
    Map<String, dynamic> record,
    int index,
    TextTheme textTheme,
  ) {
    return GestureDetector(
      onTap: () async {
        // 상세 페이지로 이동하고, 거기서 수정한 정보를 결과값으로 받아온다.
        final result = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PostPage(data: record)),
        );
        // 결과가 있다면 (수정되거나 삭제되었다면) 상위 HomePage로 정보를 전달합니다.
        widget.onRecordUpdated(index, result);
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[50], // 부드러운 배경색
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[100]!),
        ),
        child: Row(
          children: [
            // 빵 이미지 영역 (현재는 임시 아이콘)
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.bakery_dining_outlined,
                color: Colors.grey,
              ),
            ),
            const SizedBox(width: 16),
            // 텍스트 정보 영역 (제품명, 가게명, 별점)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    record["name"] ?? "제품명 없음",
                    style: textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        record["bakery"] ?? "가게 정보 없음",
                        style: textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(width: 8),
                      // 별점 (0.5 단위 반쪽 별 지원)
                      ...List.generate(5, (index) {
                        final double r =
                            double.tryParse(record["rating"].toString()) ?? 0.0;
                        IconData iconData = Icons.star_border;
                        Color iconColor = Colors.grey[300]!;

                        if (r >= index + 1) {
                          iconData = Icons.star;
                          iconColor = Colors.amber;
                        } else if (r > index) {
                          iconData = Icons.star_half;
                          iconColor = Colors.amber;
                        }

                        return Icon(iconData, size: 12, color: iconColor);
                      }),
                      const SizedBox(width: 4),
                      Text(
                        "${record["rating"] ?? '0.0'}",
                        style: textTheme.bodySmall?.copyWith(
                          color: Colors.amber[700],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
          ],
        ),
      ),
    );
  }
}

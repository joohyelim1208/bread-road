import 'package:flutter/material.dart';
import 'package:bread_road/core/utils/date_util.dart';

class PostDetailHeader extends StatelessWidget {
  final Map<String, dynamic> record;

  const PostDetailHeader({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Column(
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
                double rating = double.tryParse(
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
              DateUtil.formatKoreanDate(record['visitDate']?.toString() ?? ''),
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
      ],
    );
  }
}

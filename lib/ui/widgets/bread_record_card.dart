import 'dart:io';
import 'package:flutter/material.dart';

class BreadRecordCard extends StatelessWidget {
  final Map<String, dynamic> record;
  final VoidCallback onTap;
  final VoidCallback onFavoriteToggle;

  const BreadRecordCard({
    super.key,
    required this.record,
    required this.onTap,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    final dateStr = record["visitDate"] ?? record["date"] ?? "2024-01-01";
    final day = dateStr.split("-").last;
    final time = record["time"] ?? "12:00";
    final bool isFavorite = record["isFavorite"] ?? false;
    final double rating = double.tryParse(record["rating"].toString()) ?? 0.0;

    String name = record["name"] ?? "제품명 없음";
    if (name.length > 12) {
      name = "${name.substring(0, 12)}...";
    }

    final List<dynamic> images = record["images"] ?? [];

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  day,
                  style: textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
                Text(
                  time,
                  style: textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                ),
                const SizedBox(height: 2),
                IconButton(
                  constraints: const BoxConstraints(),
                  padding: EdgeInsets.zero,
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : Colors.grey[300],
                    size: 30,
                  ),
                  onPressed: onFavoriteToggle,
                ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              record["bakery"] ?? "상호명 없음",
                              style: textTheme.bodySmall?.copyWith(
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  size: 14,
                                  color: Colors.grey[400],
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  record["location"] ?? "위치 정보 없음",
                                  style: textTheme.bodySmall?.copyWith(
                                    color: Colors.grey[400],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Row(
                                  children: List.generate(5, (index) {
                                    return Icon(
                                      index < rating.floor()
                                          ? Icons.star
                                          : index < rating
                                          ? Icons.star_half
                                          : Icons.star_border,
                                      size: 16,
                                      color: Colors.amber,
                                    );
                                  }),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  "총점 ${rating.toStringAsFixed(1)}",
                                  style: textTheme.bodySmall?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.chevron_right, color: Colors.grey[400]),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: List.generate(3, (index) {
                      final hasImage = images.length > index;
                      return Expanded(
                        child: Container(
                          height: 80,
                          margin: EdgeInsets.only(right: index == 2 ? 0 : 8),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                            image: hasImage
                                ? DecorationImage(
                                    image: images[index].toString().startsWith('http')
                                        ? NetworkImage(images[index].toString())
                                        : FileImage(File(images[index].toString()))
                                            as ImageProvider,
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          child: !hasImage
                              ? Center(
                                  child: Icon(
                                    Icons.bakery_dining,
                                    color: Colors.grey[300],
                                    size: 32,
                                  ),
                                )
                              : null,
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

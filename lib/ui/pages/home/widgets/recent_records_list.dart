import 'package:flutter/material.dart';
import 'package:bread_road/ui/widgets/bread_record_card.dart';

class RecentRecordsList extends StatelessWidget {
  final List<Map<String, dynamic>> records;
  final void Function(Map<String, dynamic>) onRecordTap;
  final void Function(Map<String, dynamic>) onFavoriteToggle;

  const RecentRecordsList({
    super.key,
    required this.records,
    required this.onRecordTap,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    if (records.isEmpty) {
      return Center(
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(vertical: 20),
          padding: const EdgeInsets.all(40),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.history_toggle_off, size: 60, color: Colors.grey[300]),
              const SizedBox(height: 16),
              Text(
                "오늘 먹은 빵을 기록해 주세요.",
                style: textTheme.bodyLarge?.copyWith(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: records.take(3).map((record) {
        return BreadRecordCard(
          record: record,
          onTap: () => onRecordTap(record),
          onFavoriteToggle: () => onFavoriteToggle(record),
        );
      }).toList(),
    );
  }
}

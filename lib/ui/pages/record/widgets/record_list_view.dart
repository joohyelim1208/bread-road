import 'package:flutter/material.dart';
import 'package:bread_road/ui/widgets/bread_record_card.dart';
import 'package:bread_road/ui/pages/post/post_page.dart';

class RecordListView extends StatelessWidget {
  final List<Map<String, dynamic>> originalRecords;
  final List<Map<String, dynamic>> filteredRecords;
  final Function(int, dynamic) onRecordUpdated;

  const RecordListView({
    super.key,
    required this.originalRecords,
    required this.filteredRecords,
    required this.onRecordUpdated,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10,
      ),
      itemCount: filteredRecords.length,
      itemBuilder: (context, index) {
        final record = filteredRecords[index];
        final originalIndex = originalRecords.indexOf(record);
        
        return BreadRecordCard(
          record: record,
          onTap: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PostPage(record: record),
              ),
            );
            onRecordUpdated(originalIndex, result);
          },
          onFavoriteToggle: () {
            // Immutable 상태 업데이트 (값 복사 후 변경사항을 적용하여 부모 콜백)
            final updatedRecord = Map<String, dynamic>.from(record);
            updatedRecord["isFavorite"] = !(record["isFavorite"] ?? false);
            onRecordUpdated(originalIndex, updatedRecord);
          },
        );
      },
    );
  }
}

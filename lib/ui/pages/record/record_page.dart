import 'package:bread_road/ui/pages/post/post_page.dart';
import 'package:bread_road/ui/widgets/bread_record_card.dart';
import 'package:flutter/material.dart';

class RecordPage extends StatefulWidget {
  final List<Map<String, dynamic>> records;
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
  int _selectedMonth = 0; // 0: 전체, 1~12: 각 월

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    // 최신기록이 위로 오도록 리버싱 기반 필터링
    final reversedRecords = widget.records.reversed.toList();

    final filteredRecords = _selectedMonth == 0
        ? reversedRecords
        : reversedRecords.where((record) {
            final dateStr = record["visitDate"] ?? record["date"] ?? "";
            if (dateStr.isEmpty) return false;
            try {
              final month = int.parse(dateStr.split("-")[1]);
              return month == _selectedMonth;
            } catch (_) {
              return false;
            }
          }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F5F5),
        elevation: 0,
        centerTitle: true,
        title: Text(
          '내 기록',
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: Column(
        children: [
          _buildMonthFilter(colorScheme, textTheme),
          Expanded(
            child: filteredRecords.isEmpty
                ? _buildEmptyView(textTheme)
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    itemCount: filteredRecords.length,
                    itemBuilder: (context, index) {
                      final record = filteredRecords[index];
                      final originalIndex = widget.records.indexOf(record);
                      return BreadRecordCard(
                        record: record,
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PostPage(record: record),
                            ),
                          );
                          widget.onRecordUpdated(originalIndex, result);
                        },
                        onFavoriteToggle: () {
                          setState(() {
                            record["isFavorite"] =
                                !(record["isFavorite"] ?? false);
                          });
                          // 원본 데이터 동기화를 위해 부모 위젯에 알림
                          widget.onRecordUpdated(
                            originalIndex,
                            Map<String, dynamic>.from(record),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthFilter(ColorScheme colorScheme, TextTheme textTheme) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: 13,
        itemBuilder: (context, index) {
          final isSelected = _selectedMonth == index;
          final String label = index == 0 ? "전체" : "$index월";

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(label),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  setState(() => _selectedMonth = index);
                }
              },
              selectedColor: colorScheme.primary,
              backgroundColor: Colors.white,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.grey[700],
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 13,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isSelected ? colorScheme.primary : Colors.grey[300]!,
                ),
              ),
              showCheckmark: false,
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyView(TextTheme textTheme) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(20),
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

}

import 'package:flutter/material.dart';
import 'widgets/month_filter_bar.dart';
import 'widgets/record_list_view.dart';
import 'widgets/record_empty_view.dart';

class RecordPage extends StatefulWidget {
  final List<Map<String, dynamic>> records;
  final Function(int index, dynamic result) onRecordUpdated;
  final VoidCallback onAddRecord;

  const RecordPage({
    super.key,
    required this.records,
    required this.onRecordUpdated,
    required this.onAddRecord,
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

    // 최신기록이 위로 오도록 필터링 (HomePage에서 이미 최신순으로 추가되므로 원본 순서 사용)
    final recordsList = widget.records;

    final filteredRecords = _selectedMonth == 0
        ? recordsList
        : recordsList.where((record) {
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
          MonthFilterBar(
            selectedMonth: _selectedMonth,
            onMonthSelected: (month) {
              setState(() => _selectedMonth = month);
            },
          ),
          Expanded(
            child: filteredRecords.isEmpty
                ? RecordEmptyView(onAddRecord: widget.onAddRecord)
                : RecordListView(
                    originalRecords: widget.records,
                    filteredRecords: filteredRecords,
                    onRecordUpdated: widget.onRecordUpdated,
                  ),
          ),
        ],
      ),
    );
  }
}

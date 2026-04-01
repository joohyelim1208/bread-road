import 'package:flutter/material.dart';

class RecordEmptyView extends StatelessWidget {
  final VoidCallback onAddRecord;

  const RecordEmptyView({
    super.key,
    required this.onAddRecord,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Center(
      child: GestureDetector(
        onTap: onAddRecord,
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
                "오늘 먹은 빵 기록이 없어요",
                style: textTheme.bodyLarge?.copyWith(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.grey[400],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

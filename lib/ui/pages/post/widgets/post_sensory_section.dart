import 'package:flutter/material.dart';

class PostSensorySection extends StatelessWidget {
  final Map<String, dynamic> record;

  const PostSensorySection({
    super.key,
    required this.record,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Column(
      children: [
        _buildSensoryRow(
          "맛",
          (record['tastes'] as List?)?.map((e) => e.toString()).toList() ?? [],
          textTheme,
        ),
        const SizedBox(height: 16),
        _buildSensoryRow(
          "풍미",
          record['flavor'] != null ? [record['flavor'].toString()] : [],
          textTheme,
        ),
        const SizedBox(height: 16),
        _buildSensoryRow(
          "향",
          (record['scents'] as List?)?.map((e) => e.toString()).toList() ?? [],
          textTheme,
        ),
        const SizedBox(height: 16),
        _buildSensoryRow(
          "식감",
          (record['textures'] as List?)?.map((e) => e.toString()).toList() ?? [],
          textTheme,
        ),
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
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
}

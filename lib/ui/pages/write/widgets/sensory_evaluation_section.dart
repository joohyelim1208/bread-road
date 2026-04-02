import 'package:flutter/material.dart';

class SensoryEvaluationSection extends StatelessWidget {
  final Set<String> selectedTastes;
  final String? selectedFlavor;
  final Set<String> selectedScents;
  final Set<String> selectedTextures;

  final Function(String) onTastesChanged;
  final Function(String) onFlavorChanged;
  final Function(String) onScentsChanged;
  final Function(String) onTexturesChanged;

  const SensoryEvaluationSection({
    super.key,
    required this.selectedTastes,
    this.selectedFlavor,
    required this.selectedScents,
    required this.selectedTextures,
    required this.onTastesChanged,
    required this.onFlavorChanged,
    required this.onScentsChanged,
    required this.onTexturesChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Column(
      children: [
        const Divider(height: 1, thickness: 1),
        const SizedBox(height: 24),
        _buildSensorySection(
          title: "맛",
          hasMultipleChoice: true,
          options: const ["고소함", "느끼함", "단맛", "짠맛", "신맛"],
          selectedOptions: selectedTastes,
          onTap: onTastesChanged,
          colorScheme: colorScheme,
          textTheme: textTheme,
        ),
        const SizedBox(height: 24),
        _buildSensorySection(
          title: "풍미",
          hasMultipleChoice: false,
          options: const ["강하다", "약하다"],
          selectedSingle: selectedFlavor,
          onTap: onFlavorChanged,
          colorScheme: colorScheme,
          textTheme: textTheme,
        ),
        const SizedBox(height: 24),
        _buildSensorySection(
          title: "향",
          hasMultipleChoice: true,
          options: const ["버터", "곡물", "치즈", "발효", "과일"],
          selectedOptions: selectedScents,
          onTap: onScentsChanged,
          colorScheme: colorScheme,
          textTheme: textTheme,
        ),
        const SizedBox(height: 24),
        _buildSensorySection(
          title: "식감",
          hasMultipleChoice: true,
          options: const ["바삭", "촉촉", "쫄깃", "부드러움"],
          selectedOptions: selectedTextures,
          onTap: onTexturesChanged,
          colorScheme: colorScheme,
          textTheme: textTheme,
        ),
        const SizedBox(height: 24),
        const Divider(height: 1, thickness: 1),
      ],
    );
  }

  Widget _buildSensorySection({
    required String title,
    required bool hasMultipleChoice,
    required List<String> options,
    Set<String>? selectedOptions,
    String? selectedSingle,
    required Function(String) onTap,
    required ColorScheme colorScheme,
    required TextTheme textTheme,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            if (hasMultipleChoice) ...[
              const Spacer(),
              Text(
                "중복선택 가능",
                style: textTheme.labelSmall?.copyWith(color: Colors.grey),
              ),
            ],
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((option) {
            final isSelected = hasMultipleChoice
                ? selectedOptions!.contains(option)
                : selectedSingle == option;
            return GestureDetector(
              onTap: () => onTap(option),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? colorScheme.secondary : Colors.grey[100],
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? colorScheme.secondary : Colors.grey[300]!,
                  ),
                ),
                child: Text(
                  option,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey[700],
                    fontSize: 14,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

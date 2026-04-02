import 'package:flutter/material.dart';

class BreadRatingBar extends StatelessWidget {
  final double rating;
  final Function(double) onRatingChanged;

  const BreadRatingBar({
    super.key,
    required this.rating,
    required this.onRatingChanged,
  });

  void _updateRating(Offset localPosition, double maxWidth) {
    final double starAreaWidth = 36.0 * 5;
    double percent = localPosition.dx / starAreaWidth;
    double newRating = (percent * 5).clamp(0.0, 5.0);

    newRating = (newRating * 2).round() / 2.0;

    if (newRating != rating) {
      onRatingChanged(newRating);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "종합평가",
          style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        LayoutBuilder(
          builder: (context, constraints) {
            return GestureDetector(
              onHorizontalDragUpdate: (details) =>
                  _updateRating(details.localPosition, constraints.maxWidth),
              onTapDown: (details) =>
                  _updateRating(details.localPosition, constraints.maxWidth),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(5, (index) {
                      IconData iconData = Icons.star_border;
                      Color iconColor = Colors.grey[300]!;

                      if (rating >= index + 1) {
                        iconData = Icons.star;
                        iconColor = Colors.amber;
                      } else if (rating > index) {
                        iconData = Icons.star_half;
                        iconColor = Colors.amber;
                      }

                      return Icon(
                        iconData,
                        color: iconColor,
                        size: 36,
                      );
                    }),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    "총점 ${rating.toStringAsFixed(1)}",
                    style: textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

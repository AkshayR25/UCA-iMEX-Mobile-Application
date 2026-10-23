import 'package:flutter/material.dart';

class FilterSegmentedButton<T> extends StatelessWidget {
  const FilterSegmentedButton({
    required this.segments,
    required this.selected,
    required this.onSelectionChanged,
    super.key,
  });

  final List<FilterSegments> segments;
  final T selected;
  final void Function(T) onSelectionChanged;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final selectedTextStyle = TextStyle(
      color: scheme.onPrimary,
      fontWeight: FontWeight.w500,
    );
    final unselectedTextStyle = TextStyle(
      color: scheme.onSurface.withValues(alpha: 0.38),
      fontWeight: FontWeight.w400,
    );
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: scheme.onSurface.withValues(alpha: 0.06),
      ),
      height: 32,
      padding: const EdgeInsets.all(2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(
          segments.length,
          (index) => Expanded(
            child: InkWell(
              onTap: () => onSelectionChanged(segments[index].value as T),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color:
                      segments[index].value == selected
                          ? Theme.of(context).primaryColor
                          : null,
                ),
                child: Center(
                  child: Text(
                    segments[index].label,
                    style:
                        segments[index].value == selected
                            ? selectedTextStyle
                            : unselectedTextStyle,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

final class FilterSegments<T> {
  const FilterSegments({required this.label, required this.value});

  final String label;
  final T value;
}

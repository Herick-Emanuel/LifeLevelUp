import 'package:flutter/material.dart';

class ReminderDaysSelector extends StatelessWidget {
  final List<int> selectedDays;
  final Function(List<int>) onDaysChanged;

  const ReminderDaysSelector({
    super.key,
    required this.selectedDays,
    required this.onDaysChanged,
  });

  @override
  Widget build(BuildContext context) {
    final days = ['Dom', 'Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb'];

    return Wrap(
      spacing: 8,
      children: List.generate(7, (index) {
        final isSelected = selectedDays.contains(index);
        return FilterChip(
          label: Text(days[index]),
          selected: isSelected,
          onSelected: (selected) {
            final newDays = List<int>.from(selectedDays);
            if (selected) {
              newDays.add(index);
            } else {
              newDays.remove(index);
            }
            onDaysChanged(newDays);
          },
        );
      }),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReminderTimePicker extends StatelessWidget {
  final TimeOfDay? selectedTime;
  final Function(TimeOfDay) onTimeSelected;

  const ReminderTimePicker({
    super.key,
    this.selectedTime,
    required this.onTimeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final TimeOfDay? picked = await showTimePicker(
          context: context,
          initialTime: selectedTime ?? TimeOfDay.now(),
        );
        if (picked != null) {
          onTimeSelected(picked);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).dividerColor),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              selectedTime != null
                  ? DateFormat.Hm().format(
                    DateTime(
                      2024,
                      1,
                      1,
                      selectedTime!.hour,
                      selectedTime!.minute,
                    ),
                  )
                  : 'Selecione o horário',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const Icon(Icons.access_time),
          ],
        ),
      ),
    );
  }
}

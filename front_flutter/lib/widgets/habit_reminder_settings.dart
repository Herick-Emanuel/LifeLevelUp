import 'package:flutter/material.dart';
import '../services/notification_service.dart';

class HabitReminderSettings extends StatefulWidget {
  final bool initialReminderEnabled;
  final TimeOfDay? initialReminderTime;
  final List<int> initialReminderDays;
  final Function(bool, TimeOfDay?, List<int>) onReminderSettingsChanged;

  const HabitReminderSettings({
    super.key,
    required this.initialReminderEnabled,
    this.initialReminderTime,
    required this.initialReminderDays,
    required this.onReminderSettingsChanged,
  });

  @override
  State<HabitReminderSettings> createState() => _HabitReminderSettingsState();
}

class _HabitReminderSettingsState extends State<HabitReminderSettings> {
  late bool _reminderEnabled;
  TimeOfDay? _reminderTime;
  late List<int> _selectedDays;

  @override
  void initState() {
    super.initState();
    _reminderEnabled = widget.initialReminderEnabled;
    _reminderTime = widget.initialReminderTime;
    _selectedDays = List.from(widget.initialReminderDays);
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _reminderTime ?? TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        _reminderTime = picked;
        widget.onReminderSettingsChanged(
          _reminderEnabled,
          _reminderTime,
          _selectedDays,
        );
      });
    }
  }

  void _toggleDay(int day) {
    setState(() {
      if (_selectedDays.contains(day)) {
        _selectedDays.remove(day);
      } else {
        _selectedDays.add(day);
      }
      widget.onReminderSettingsChanged(
        _reminderEnabled,
        _reminderTime,
        _selectedDays,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SwitchListTile(
          title: const Text('Ativar Lembretes'),
          value: _reminderEnabled,
          onChanged: (bool value) {
            setState(() {
              _reminderEnabled = value;
              widget.onReminderSettingsChanged(
                _reminderEnabled,
                _reminderTime,
                _selectedDays,
              );
            });
          },
        ),
        if (_reminderEnabled) ...[
          ListTile(
            title: const Text('Horário do Lembrete'),
            trailing: Text(
              _reminderTime?.format(context) ?? 'Selecionar horário',
            ),
            onTap: () => _selectTime(context),
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Dias da Semana'),
          ),
          Wrap(
            spacing: 8.0,
            children: [
              for (int i = 1; i <= 7; i++)
                FilterChip(
                  label: Text(_getDayName(i)),
                  selected: _selectedDays.contains(i),
                  onSelected: (_) => _toggleDay(i),
                ),
            ],
          ),
        ],
      ],
    );
  }

  String _getDayName(int day) {
    const days = ['Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb', 'Dom'];
    return days[day - 1];
  }
}

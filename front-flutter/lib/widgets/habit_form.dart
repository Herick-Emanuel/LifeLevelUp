import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/habit.dart';
import '../services/notification_service.dart';
import 'package:provider/provider.dart';

class HabitForm extends StatefulWidget {
  final Function(Habit habit) onSave;
  final Habit? habit;

  const HabitForm({required this.onSave, this.habit, super.key});

  @override
  _HabitFormState createState() => _HabitFormState();
}

class _HabitFormState extends State<HabitForm> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late String _frequency;
  late int _goal;
  bool _reminder = false;
  TimeOfDay _reminderTime = TimeOfDay.now();

  @override
  void initState() {
    super.initState();
    _name = widget.habit?.name ?? '';
    _frequency = widget.habit?.frequency ?? 'Diário';
    _goal = widget.habit?.goal ?? 1;
    _reminder = widget.habit?.reminder ?? false;
    if (widget.habit != null && _reminder) {
      _reminderTime = TimeOfDay(hour: 8, minute: 0);
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final habit = Habit(
        id: widget.habit?.id ?? 0,
        name: _name,
        frequency: _frequency,
        goal: _goal,
        progress: widget.habit?.progress ?? 0,
        reminder: _reminder,
      );

      widget.onSave(habit);

      _scheduleReminder();

      Navigator.of(context).pop(true);
    }
  }

  void _scheduleReminder() {
    if (_reminder) {
      final notificationService =
          Provider.of<NotificationService>(context, listen: false);

      final now = DateTime.now();
      DateTime scheduledDate = DateTime(
        now.year,
        now.month,
        now.day,
        _reminderTime.hour,
        _reminderTime.minute,
      );

      if (scheduledDate.isBefore(now)) {
        scheduledDate = scheduledDate.add(Duration(days: 1));
      }

      notificationService.scheduleNotification(
        id: widget.habit?.id ?? DateTime.now().millisecondsSinceEpoch,
        title: 'Lembrete de Hábito',
        body: 'É hora de completar seu hábito: $_name!',
        scheduledDate: scheduledDate,
      );
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _reminderTime,
    );

    if (pickedTime != null && pickedTime != _reminderTime) {
      setState(() {
        _reminderTime = pickedTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.habit == null ? 'Novo Hábito' : 'Editar Hábito'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _name,
                decoration: InputDecoration(
                  labelText: 'Nome do Hábito',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o nome do hábito';
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value!;
                },
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _frequency,
                decoration: InputDecoration(
                  labelText: 'Frequência',
                  border: OutlineInputBorder(),
                ),
                items: ['Diário', 'Semanal', 'Mensal']
                    .map((frequency) => DropdownMenuItem(
                          value: frequency,
                          child: Text(frequency),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _frequency = value!;
                  });
                },
                onSaved: (value) {
                  _frequency = value!;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                initialValue: _goal.toString(),
                decoration: InputDecoration(
                  labelText: 'Meta (vezes)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      int.tryParse(value) == null ||
                      int.parse(value) <= 0) {
                    return 'Por favor, insira um número válido';
                  }
                  return null;
                },
                onSaved: (value) {
                  _goal = int.parse(value!);
                },
              ),
              SizedBox(height: 16),
              SwitchListTile(
                title: Text("Ativar Lembrete"),
                value: _reminder,
                onChanged: (value) {
                  setState(() {
                    _reminder = value;
                    if (_reminder) {
                      _selectTime(context);
                    }
                  });
                },
              ),
              SizedBox(height: 8),
              if (_reminder)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text("Definir Horário de Lembrete"),
                  subtitle: Text(
                      "${_reminderTime.hour.toString().padLeft(2, '0')}:${_reminderTime.minute.toString().padLeft(2, '0')}"),
                  trailing: IconButton(
                    icon: Icon(Icons.alarm),
                    onPressed: () => _selectTime(context),
                  ),
                ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  textStyle: TextStyle(fontSize: 16),
                ),
                child: Text('Salvar Hábito'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

extension on NotificationService {
  void scheduleNotification(
      {required int id,
      required String title,
      required String body,
      required DateTime scheduledDate}) {}
}

import 'package:flutter/material.dart';
import '../models/habit.dart';
import '../services/api_service.dart';
import '../services/notification_service.dart';
import '../widgets/reminder_time_picker.dart';
import '../widgets/reminder_days_selector.dart';

class HabitFormScreen extends StatefulWidget {
  final Habit? habit;
  final int userId;

  const HabitFormScreen({super.key, this.habit, required this.userId});

  @override
  _HabitFormScreenState createState() => _HabitFormScreenState();
}

class _HabitFormScreenState extends State<HabitFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _goalController = TextEditingController();
  final _quantidadeConclusoesController = TextEditingController();
  final _tempoDuracaoController = TextEditingController();
  String _frequency = 'Diário';
  bool _reminder = false;
  TimeOfDay? _reminderTime;
  List<int> _reminderDays = [];

  @override
  void initState() {
    super.initState();
    if (widget.habit != null) {
      _nameController.text = widget.habit!.name;
      _goalController.text = widget.habit!.goal.toString();
      _frequency = widget.habit!.frequency;
      _reminder = widget.habit!.reminder;
      if (widget.habit!.reminderTime != null) {
        final timeParts = widget.habit!.reminderTime!.split(':');
        _reminderTime = TimeOfDay(
          hour: int.parse(timeParts[0]),
          minute: int.parse(timeParts[1]),
        );
      }
      _reminderDays = widget.habit!.reminderDays;
      if (widget.habit!.quantidadeDeConclusoes != null) {
        _quantidadeConclusoesController.text =
            widget.habit!.quantidadeDeConclusoes.toString();
      }
      if (widget.habit!.tempoDeDuracaoDoHabito != null) {
        _tempoDuracaoController.text =
            widget.habit!.tempoDeDuracaoDoHabito.toString();
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _goalController.dispose();
    _quantidadeConclusoesController.dispose();
    _tempoDuracaoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.habit == null ? 'Novo Hábito' : 'Editar Hábito'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nome do Hábito'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira um nome';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _frequency,
                decoration: const InputDecoration(labelText: 'Frequência'),
                items:
                    ['Diário', 'Semanal', 'Mensal'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _frequency = newValue!;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _goalController,
                decoration: const InputDecoration(labelText: 'Meta'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira uma meta';
                  }
                  if (int.tryParse(value) == null || int.parse(value) <= 0) {
                    return 'A meta deve ser um número positivo';
                  }
                  return null;
                },
              ),
              if (_frequency == 'Diário') ...[
                const SizedBox(height: 16),
                TextFormField(
                  controller: _quantidadeConclusoesController,
                  decoration: const InputDecoration(
                    labelText: 'Quantidade de Conclusões por Dia',
                    helperText:
                        'Quantas vezes este hábito deve ser concluído por dia',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira a quantidade de conclusões';
                    }
                    if (int.tryParse(value) == null || int.parse(value) <= 0) {
                      return 'A quantidade deve ser um número positivo';
                    }
                    return null;
                  },
                ),
              ],
              const SizedBox(height: 16),
              TextFormField(
                controller: _tempoDuracaoController,
                decoration: const InputDecoration(
                  labelText: 'Tempo de Duração (em minutos)',
                  helperText:
                      'Tempo estimado para completar o hábito (opcional)',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    if (int.tryParse(value) == null || int.parse(value) < 0) {
                      return 'O tempo deve ser um número não negativo';
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Ativar Lembrete'),
                value: _reminder,
                onChanged: (bool value) {
                  setState(() {
                    _reminder = value;
                  });
                },
              ),
              if (_reminder) ...[
                const SizedBox(height: 16),
                ReminderTimePicker(
                  selectedTime: _reminderTime,
                  onTimeSelected: (TimeOfDay time) {
                    setState(() {
                      _reminderTime = time;
                    });
                  },
                ),
                const SizedBox(height: 16),
                ReminderDaysSelector(
                  selectedDays: _reminderDays,
                  onDaysChanged: (List<int> days) {
                    setState(() {
                      _reminderDays = days;
                    });
                  },
                ),
              ],
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveHabit,
                child: Text(
                  widget.habit == null ? 'Criar Hábito' : 'Salvar Alterações',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveHabit() async {
    if (_formKey.currentState!.validate()) {
      final habit = Habit(
        id: widget.habit?.id,
        name: _nameController.text,
        frequency: _frequency,
        goal: int.parse(_goalController.text),
        reminder: _reminder,
        reminderTime:
            _reminderTime != null
                ? '${_reminderTime!.hour.toString().padLeft(2, '0')}:${_reminderTime!.minute.toString().padLeft(2, '0')}'
                : null,
        reminderDays: _reminderDays,
        userId: widget.userId,
        quantidadeDeConclusoes:
            _frequency == 'Diário' &&
                    _quantidadeConclusoesController.text.isNotEmpty
                ? int.parse(_quantidadeConclusoesController.text)
                : null,
        tempoDeDuracaoDoHabito:
            _tempoDuracaoController.text.isNotEmpty
                ? int.parse(_tempoDuracaoController.text)
                : null,
      );

      try {
        if (widget.habit == null) {
          await ApiService.addHabit(habit);
        } else {
          await ApiService.updateHabit(habit);
        }
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erro ao salvar hábito: $e')));
      }
    }
  }
}

import 'package:flutter/material.dart';
import '../models/habit.dart';
import '../models/habit_completion.dart';
import '../services/api_service.dart';
import '../screens/habit_stats_screen.dart';
import 'package:go_router/go_router.dart';

class HabitCard extends StatelessWidget {
  final Habit habit;
  final Function(Habit) onUpdate;
  final Function(int) onDelete;
  final VoidCallback onEdit;

  const HabitCard({
    super.key,
    required this.habit,
    required this.onUpdate,
    required this.onDelete,
    required this.onEdit,
  });

  Future<void> _handleDelete() async {
    if (habit.id != null) {
      bool success = await ApiService.deleteHabit(habit.id!);
      if (success) {
        onDelete(habit.id!);
      }
    }
  }

  Future<void> _handleProgressUpdate(BuildContext context) async {
    if (habit.id != null) {
      int? tempoGasto;
      if (habit.tempoDeDuracaoDoHabito != null) {
        tempoGasto = await _showTempoGastoDialog(context);
        if (tempoGasto == null) return; // Usuário cancelou
      }

      try {
        await ApiService.createHabitCompletion(habit.id!, tempoGasto);

        Habit updatedHabit = Habit(
          id: habit.id,
          name: habit.name,
          frequency: habit.frequency,
          goal: habit.goal,
          progress: habit.progress + 1,
          reminder: habit.reminder,
          reminderTime: habit.reminderTime,
          reminderDays: habit.reminderDays,
          userId: habit.userId,
          quantidadeDeConclusoes: habit.quantidadeDeConclusoes,
          tempoDeDuracaoDoHabito: habit.tempoDeDuracaoDoHabito,
        );

        bool success = await ApiService.updateHabit(updatedHabit);
        if (success) {
          onUpdate(updatedHabit);
        }
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erro ao completar hábito: $e')));
      }
    }
  }

  Future<int?> _showTempoGastoDialog(BuildContext context) async {
    final controller = TextEditingController();
    return showDialog<int>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Tempo Gasto'),
            content: TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'Tempo em minutos',
                helperText:
                    'Digite quanto tempo você gastou realizando este hábito',
              ),
              keyboardType: TextInputType.number,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  final tempo = int.tryParse(controller.text);
                  if (tempo != null && tempo >= 0) {
                    Navigator.pop(context, tempo);
                  }
                },
                child: const Text('Confirmar'),
              ),
            ],
          ),
    );
  }

  String _formatDuration(int? minutes) {
    if (minutes == null) return 'Não definido';
    if (minutes < 60) return '$minutes minutos';
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;
    if (remainingMinutes == 0) return '$hours horas';
    return '$hours horas e $remainingMinutes minutos';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    habit.name,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => onEdit(),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: _handleDelete,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('Frequência: ${habit.frequency}'),
            Text('Meta: ${habit.goal}'),
            Text('Progresso: ${habit.progress}'),
            if (habit.quantidadeDeConclusoes != null)
              Text('Conclusões por dia: ${habit.quantidadeDeConclusoes}'),
            if (habit.tempoDeDuracaoDoHabito != null)
              Text('Tempo estimado: ${habit.tempoDeDuracaoDoHabito} minutos'),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () => _handleProgressUpdate(context),
                  child: const Text('Completar'),
                ),
                TextButton(
                  onPressed: () {
                    context.push(
                      '/habits/stats/${habit.id}',
                      extra: {'habit': habit},
                    );
                  },
                  child: const Text('Ver Estatísticas'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

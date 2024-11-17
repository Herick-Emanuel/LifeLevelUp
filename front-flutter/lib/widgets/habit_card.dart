import 'package:flutter/material.dart';
import '../models/habit.dart';
import '../services/api_service.dart';

class HabitCard extends StatelessWidget {
  final Habit habit;
  final VoidCallback onUpdate;
  final Function(Habit habit) onEdit;

  const HabitCard({
    super.key,
    required this.habit,
    required this.onUpdate,
    required this.onEdit,
  });

  void _deleteHabit(BuildContext context) async {
    bool confirmed = await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Confirmar'),
        content: Text('Deseja realmente excluir este hábito?'),
        actions: <Widget>[
          TextButton(
            child: Text('Cancelar'),
            onPressed: () => Navigator.of(ctx).pop(false),
          ),
          TextButton(
            child: Text('Excluir'),
            onPressed: () => Navigator.of(ctx).pop(true),
          ),
        ],
      ),
    );

    if (confirmed) {
      try {
        bool success = await ApiService.deleteHabit(habit.id);
        if (success) {
          onUpdate();
        } else {
          throw Exception('Falha ao excluir hábito.');
        }
      } catch (e) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Erro'),
            content: Text('Falha ao excluir hábito: $e'),
            actions: <Widget>[
              TextButton(
                child: Text('Fechar'),
                onPressed: () => Navigator.of(ctx).pop(),
              ),
            ],
          ),
        );
      }
    }
  }

  void _incrementProgress(BuildContext context) async {
    try {
      Habit updatedHabit = Habit(
        id: habit.id,
        name: habit.name,
        frequency: habit.frequency,
        goal: habit.goal,
        progress: habit.progress + 1,
        reminder: habit.reminder,
      );
      bool success = await ApiService.updateHabit(updatedHabit);
      if (success) {
        onUpdate();
      } else {
        throw Exception('Falha ao atualizar progresso.');
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Erro'),
          content: Text('Falha ao atualizar progresso: $e'),
          actions: <Widget>[
            TextButton(
              child: Text('Fechar'),
              onPressed: () => Navigator.of(ctx).pop(),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double progressPercent =
        habit.goal > 0 ? (habit.progress / habit.goal) : 0.0;
    if (progressPercent > 1.0) progressPercent = 1.0;

    return Card(
      child: ListTile(
        title: Text(habit.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Frequência: ${habit.frequency}'),
            SizedBox(height: 5),
            LinearProgressIndicator(value: progressPercent),
            SizedBox(height: 5),
            Text('${habit.progress} / ${habit.goal}'),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'editar') {
              onEdit(habit);
            } else if (value == 'excluir') {
              _deleteHabit(context);
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'editar',
              child: Text('Editar'),
            ),
            PopupMenuItem(
              value: 'excluir',
              child: Text('Excluir'),
            ),
          ],
        ),
        onTap: () => _incrementProgress(context),
      ),
    );
  }
}

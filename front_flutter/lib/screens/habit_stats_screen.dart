import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/habit.dart';
import '../models/habit_completion.dart';
import '../services/api_service.dart';

class HabitStatsScreen extends StatefulWidget {
  final Habit habit;

  const HabitStatsScreen({super.key, required this.habit});

  @override
  _HabitStatsScreenState createState() => _HabitStatsScreenState();
}

class _HabitStatsScreenState extends State<HabitStatsScreen> {
  List<HabitCompletion> _completions = [];
  HabitCompletionStats? _stats;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final completions = await ApiService.getHabitCompletions(
        widget.habit.id!,
      );
      final stats = await ApiService.getHabitCompletionStats(widget.habit.id!);
      setState(() {
        _completions = completions;
        _stats = stats;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao carregar dados: $e')));
    }
  }

  String _formatDuration(dynamic minutes) {
    if (minutes == null) return 'Não registrado';

    // Converter para double primeiro e depois para int
    int minutesInt;
    if (minutes is String) {
      minutesInt = double.parse(minutes).round();
    } else if (minutes is double) {
      minutesInt = minutes.round();
    } else if (minutes is int) {
      minutesInt = minutes;
    } else {
      return 'Valor inválido';
    }

    if (minutesInt < 60) return '$minutesInt minutos';
    final hours = minutesInt ~/ 60;
    final remainingMinutes = minutesInt % 60;
    if (remainingMinutes == 0) return '$hours horas';
    return '$hours horas e $remainingMinutes minutos';
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(title: Text('Estatísticas de ${widget.habit.name}')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Resumo',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    if (_stats != null) ...[
                      Text('Total de conclusões: ${_stats!.totalConclusoes}'),
                      Text(
                        'Tempo médio: ${_formatDuration(_stats!.mediaTempo)}',
                      ),
                      Text(
                        'Tempo mínimo: ${_formatDuration(_stats!.minTempo)}',
                      ),
                      Text(
                        'Tempo máximo: ${_formatDuration(_stats!.maxTempo)}',
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Histórico de Conclusões',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    if (_completions.isEmpty)
                      const Center(child: Text('Nenhuma conclusão registrada'))
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _completions.length,
                        itemBuilder: (context, index) {
                          final completion = _completions[index];
                          return ListTile(
                            title: Text(completion.completionDate.toString()),
                            subtitle: Text(
                              'Tempo gasto: ${_formatDuration(completion.tempoGasto)}',
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

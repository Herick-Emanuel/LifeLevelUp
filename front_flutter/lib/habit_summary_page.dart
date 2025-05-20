import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'models/habit.dart';
import 'services/api_service.dart';

class HabitSummaryPage extends StatefulWidget {
  const HabitSummaryPage({super.key});

  @override
  _HabitSummaryPageState createState() => _HabitSummaryPageState();
}

class _HabitSummaryPageState extends State<HabitSummaryPage> {
  List<Habit> _habits = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHabits();
  }

  Future<void> _loadHabits() async {
    try {
      List<Habit> habits = await ApiService.fetchHabits();
      setState(() {
        _habits = habits;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorDialog('Erro ao carregar hábitos');
    }
  }

  void _showErrorDialog(String mensagem) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Erro'),
            content: Text(mensagem),
            actions: <Widget>[
              TextButton(
                child: const Text('Fechar'),
                onPressed: () => Navigator.of(ctx).pop(),
              ),
            ],
          ),
    );
  }

  List<Habit> _getMostCompletedHabits() {
    return _habits
      ..sort((a, b) => b.completionRate.compareTo(a.completionRate));
  }

  List<Habit> _getPendingHabits() {
    return _habits.where((habit) => habit.status == 'pending').toList();
  }

  List<Habit> _getFailedHabits() {
    return _habits.where((habit) => habit.status == 'failed').toList();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Resumo dos Hábitos')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              'Hábitos Mais Cumpridos',
              _getMostCompletedHabits(),
              Colors.green,
            ),
            const SizedBox(height: 20),
            _buildSection(
              'Hábitos Pendentes',
              _getPendingHabits(),
              Colors.orange,
            ),
            const SizedBox(height: 20),
            _buildSection('Hábitos Falhados', _getFailedHabits(), Colors.red),
            const SizedBox(height: 20),
            _buildCompletionChart(),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Habit> habits, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Card(
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: habits.length,
            itemBuilder: (context, index) {
              final habit = habits[index];
              return ListTile(
                title: Text(habit.name),
                subtitle: Text(
                  'Taxa de conclusão: ${habit.completionRate.toStringAsFixed(2)}%',
                ),
                trailing: CircularProgressIndicator(
                  value: habit.completionRate / 100,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCompletionChart() {
    final completedHabits =
        _habits.where((h) => h.status == 'completed').length;
    final pendingHabits = _habits.where((h) => h.status == 'pending').length;
    final failedHabits = _habits.where((h) => h.status == 'failed').length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Distribuição de Status',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 200,
          child: PieChart(
            PieChartData(
              sections: [
                PieChartSectionData(
                  value: completedHabits.toDouble(),
                  title: 'Completos',
                  color: Colors.green,
                  radius: 50,
                ),
                PieChartSectionData(
                  value: pendingHabits.toDouble(),
                  title: 'Pendentes',
                  color: Colors.orange,
                  radius: 50,
                ),
                PieChartSectionData(
                  value: failedHabits.toDouble(),
                  title: 'Falhados',
                  color: Colors.red,
                  radius: 50,
                ),
              ],
              sectionsSpace: 2,
              centerSpaceRadius: 40,
            ),
          ),
        ),
      ],
    );
  }
}

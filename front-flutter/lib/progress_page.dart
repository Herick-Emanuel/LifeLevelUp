import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'models/habit.dart';
import 'services/api_service.dart';

class ProgressPage extends StatefulWidget {
  const ProgressPage({super.key});

  @override
  _ProgressPageState createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
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
      builder: (ctx) => AlertDialog(
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

  List<ChartSeries<HabitProgress, String>> _createChartData() {
    final data = _habits.map((habit) {
      double completionRate =
          habit.goal > 0 ? (habit.progress / habit.goal) * 100 : 0;
      if (completionRate > 100) completionRate = 100;
      return HabitProgress(habit.name, completionRate);
    }).toList();

    return [
      ColumnSeries<HabitProgress, String>(
        dataSource: data,
        xValueMapper: (HabitProgress progress, _) => progress.habitName,
        yValueMapper: (HabitProgress progress, _) => progress.completionRate,
        dataLabelSettings: const DataLabelSettings(isVisible: true),
        color: Colors.teal,
      )
    ];
  }

  Widget _buildChart() {
    return SfCartesianChart(
      primaryXAxis: CategoryAxis(),
      title: ChartTitle(text: 'Progresso dos Hábitos'),
      tooltipBehavior: TooltipBehavior(enable: true),
      series: _createChartData(),
    );
  }

  Widget _buildSummary() {
    int completedHabits =
        _habits.where((habit) => habit.progress >= habit.goal).length;
    int pendingHabits = _habits
        .where((habit) => habit.progress < habit.goal && habit.progress > 0)
        .length;
    int failedHabits = _habits.where((habit) => habit.progress == 0).length;

    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.check_circle, color: Colors.green),
          title: const Text('Hábitos Cumpridos'),
          trailing: Text('$completedHabits'),
        ),
        ListTile(
          leading: const Icon(Icons.access_time, color: Colors.orange),
          title: const Text('Hábitos Pendentes'),
          trailing: Text('$pendingHabits'),
        ),
        ListTile(
          leading: const Icon(Icons.cancel, color: Colors.red),
          title: const Text('Hábitos Falhados'),
          trailing: Text('$failedHabits'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Progresso dos Hábitos'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadHabits,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 300,
                      child: _buildChart(),
                    ),
                    const SizedBox(height: 20),
                    _buildSummary(),
                  ],
                ),
              ),
            ),
    );
  }
}

class HabitProgress {
  final String habitName;
  final double completionRate;

  HabitProgress(this.habitName, this.completionRate);
}

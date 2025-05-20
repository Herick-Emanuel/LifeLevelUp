import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'models/habit.dart';
import 'services/api_service.dart';
import 'widgets/habit_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Habit> _habits = [];
  bool _isLoading = true;
  String? _errorMessage;
  int? _userId;

  @override
  void initState() {
    super.initState();
    _loadUserAndHabits();
  }

  Future<void> _loadUserAndHabits() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Primeiro carrega o usuário
      final user = await ApiService.getCurrentUser();
      if (user == null) {
        throw Exception('Usuário não encontrado. Faça login novamente.');
      }

      setState(() {
        _userId = user.id;
      });

      // Depois carrega os hábitos
      final habits = await ApiService.getHabits();
      setState(() {
        _habits = habits;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
      _showError(_errorMessage ?? 'Erro ao carregar dados');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _addHabit() async {
    if (_userId == null) {
      _showError('Usuário não encontrado. Faça login novamente.');
      return;
    }

    final result = await context.push<Habit>('/habits/new', extra: _userId);

    if (result != null) {
      setState(() {
        final index = _habits.indexWhere((h) => h.id == result.id);
        if (index >= 0) {
          _habits[index] = result;
        } else {
          _habits.add(result);
        }
      });
    }
  }

  void _editHabit(Habit habit) async {
    if (_userId == null) {
      _showError('Usuário não encontrado. Faça login novamente.');
      return;
    }

    final result = await context.push<Habit>(
      '/habits/edit/${habit.id}',
      extra: {'habit': habit, 'userId': _userId},
    );

    if (result != null) {
      setState(() {
        final index = _habits.indexWhere((h) => h.id == result.id);
        if (index >= 0) {
          _habits[index] = result;
        }
      });
    }
  }

  void _deleteHabit(int id) async {
    try {
      bool success = await ApiService.deleteHabit(id);
      if (success) {
        setState(() {
          _habits.removeWhere((habit) => habit.id == id);
        });
      } else {
        throw Exception('Erro ao excluir hábito');
      }
    } catch (e) {
      _showError('Erro ao excluir hábito: $e');
    }
  }

  void _updateHabit(Habit habit) async {
    try {
      await ApiService.updateHabit(habit);
      await _loadUserAndHabits();
    } catch (e) {
      _showError('Erro ao atualizar hábito: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciador de Hábitos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            tooltip: 'Progresso',
            onPressed: () => context.push('/progress'),
          ),
          IconButton(
            icon: const Icon(Icons.book),
            tooltip: 'Missões',
            onPressed: () => context.push('/missions'),
          ),
          IconButton(
            icon: const Icon(Icons.format_quote),
            tooltip: 'Motivações',
            onPressed: () => context.push('/motivation'),
          ),
          IconButton(
            icon: const Icon(Icons.person),
            tooltip: 'Perfil',
            onPressed: () => context.push('/profile'),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Configurações',
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _errorMessage != null
              ? Center(child: Text(_errorMessage!))
              : RefreshIndicator(
                onRefresh: _loadUserAndHabits,
                child:
                    _habits.isEmpty
                        ? ListView(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.4,
                              child: const Center(
                                child: Text('Nenhum hábito encontrado.'),
                              ),
                            ),
                          ],
                        )
                        : ListView.builder(
                          itemCount: _habits.length,
                          itemBuilder: (context, index) {
                            final habit = _habits[index];
                            return HabitCard(
                              habit: habit,
                              onEdit: () => _editHabit(habit),
                              onDelete: _deleteHabit,
                              onUpdate: _updateHabit,
                            );
                          },
                        ),
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addHabit,
        child: const Icon(Icons.add),
      ),
    );
  }
}

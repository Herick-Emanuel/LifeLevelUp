import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/habit.dart';
import 'models/user.dart';
import 'progress_page.dart';
import 'services/api_service.dart';
import 'settings_page.dart';
import 'widgets/habit_card.dart';
import 'widgets/habit_form.dart';
import 'screens/missions_screen.dart';
import 'screens/motivation_screen.dart';
import 'screens/profile_screen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Habit> _habits = [];
  bool _isLoading = true;
  String? _errorMessage;

  final FlutterSecureStorage storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _fetchHabits();
  }

  Future<void> _fetchHabits() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      List<Habit> habits = await ApiService.getHabits();
      setState(() {
        _habits = habits;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Erro ao carregar hábitos: $e';
        _isLoading = false;
      });
      print(_errorMessage);
    }
  }

  void _addHabit() async {
    bool? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HabitForm(
          onSave: (Habit habit) async {
            try {
              if (habit.id == 0) {
                await ApiService.addHabit(habit);
              } else {
                await ApiService.updateHabit(habit);
              }
              await _fetchHabits();
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Erro ao salvar hábito: $e')),
              );
            }
          },
          habit: null,
        ),
      ),
    );

    if (result == true) {
      await _fetchHabits();
    }
  }

  void _editHabit(Habit habit) async {
    bool? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HabitForm(
          onSave: (Habit updatedHabit) async {
            try {
              await ApiService.updateHabit(updatedHabit);
              await _fetchHabits();
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Erro ao atualizar hábito: $e')),
              );
            }
          },
          habit: habit,
        ),
      ),
    );

    if (result == true) {
      await _fetchHabits();
    }
  }

  void _incrementProgress(Habit habit) async {
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
        User? currentUser = await ApiService.getCurrentUser();
        if (currentUser != null) {
          // Calcula pontos com base no progresso
          int earnedPoints = (habit.progress + 1 >= habit.goal) ? 20 : 5;
          currentUser.addPoints(earnedPoints);

          // Atualiza o usuário no backend
          await ApiService.updateUser(currentUser);
        }
        await _fetchHabits();
      } else {
        throw Exception('Erro ao atualizar progresso.');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao incrementar progresso: $e')),
      );
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
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProgressPage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.book),
            tooltip: 'Missões',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MissionsScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.format_quote),
            tooltip: 'Motivações',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const MotivationScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            tooltip: 'Perfil',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Configurações',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Text(_errorMessage!))
              : RefreshIndicator(
                  onRefresh: _fetchHabits,
                  child: _habits.isEmpty
                      ? ListView(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.4,
                              child: const Center(
                                  child: Text('Nenhum hábito encontrado.')),
                            ),
                          ],
                        )
                      : ListView.builder(
                          itemCount: _habits.length,
                          itemBuilder: (context, index) {
                            return HabitCard(
                              habit: _habits[index],
                              onUpdate: _fetchHabits,
                              onEdit: _editHabit,
                            );
                          },
                        ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addHabit,
        tooltip: 'Adicionar Hábito',
        child: const Icon(Icons.add),
      ),
    );
  }
}

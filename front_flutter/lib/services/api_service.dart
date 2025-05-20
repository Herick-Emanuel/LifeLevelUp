import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/customization_item.dart';
import '../models/habit.dart';
import '../models/journal_entry.dart';
import '../models/mission.dart';
import '../models/motivation_message.dart';
import '../models/user.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';
import '../services/notification_service.dart';
import '../models/habit_completion.dart';

class ApiService {
  static String get baseUrl {
    // Para Android em emulador, use 10.0.2.2
    // Para dispositivo físico, use seu IP local
    return 'http://10.0.2.2:3001/api';
  }

  static const storage = FlutterSecureStorage();

  static Future<void> _saveToken(String token) async {
    try {
      await storage.write(key: 'token', value: token);
    } catch (e) {
      print('Erro ao salvar token: $e');
      throw Exception('Erro ao salvar token: $e');
    }
  }

  static Future<String?> _getToken() async {
    try {
      return await storage.read(key: 'token');
    } catch (e) {
      print('Erro ao ler token: $e');
      return null;
    }
  }

  static Future<void> _deleteToken() async {
    try {
      await storage.delete(key: 'token');
    } catch (e) {
      print('Erro ao deletar token: $e');
    }
  }

  static Future<String> login(String email, String password) async {
    try {
      print('Tentando fazer login com: $email');
      print('URL da requisição: ${Uri.parse('$baseUrl/auth/login')}');

      final response = await http
          .post(
            Uri.parse('$baseUrl/auth/login'),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({'email': email, 'password': password}),
          )
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              throw Exception('Timeout na requisição');
            },
          );

      print('Resposta do servidor: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await _saveToken(data['token']);
        return data['token'];
      } else {
        throw Exception('Erro ao fazer login: ${response.body}');
      }
    } catch (e) {
      print('Erro durante o login: $e');
      throw Exception('Erro ao fazer login: $e');
    }
  }

  static Future<bool> register(
    String name,
    String email,
    String password,
  ) async {
    try {
      print('Tentando registrar usuário: $email');
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({'name': name, 'email': email, 'password': password}),
      );

      print('Resposta do servidor: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 201) {
        return true;
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Erro ao registrar usuário');
      }
    } catch (e) {
      print('Erro ao registrar usuário: $e');
      throw Exception('Erro ao registrar usuário: $e');
    }
  }

  static Future<void> logout() async {
    await _deleteToken();
  }

  static Future<User?> getCurrentUser() async {
    final token = await _getToken();
    if (token == null) return null;

    print('Token recuperado: $token');
    final url = Uri.parse('$baseUrl/users/profile');
    print('Fazendo requisição para: $url');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    print('Resposta getCurrentUser: ${response.statusCode} - ${response.body}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return User.fromJson(data);
    } else {
      return null;
    }
  }

  static Future<List<Habit>> fetchHabits() async {
    try {
      final token = await _getToken();
      print('Token recuperado: $token');

      final response = await http.get(
        Uri.parse('$baseUrl/habits'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('URL da requisição: $baseUrl/habits');
      print('Status code: ${response.statusCode}');
      print('Resposta: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> habitsJson = jsonDecode(response.body);
        print('Hábitos decodificados: $habitsJson');

        final habits =
            habitsJson.map((json) {
              print('Convertendo hábito: $json');
              return Habit.fromJson(json);
            }).toList();

        print('Hábitos convertidos: $habits');
        return habits;
      } else if (response.statusCode == 404) {
        print('Nenhum hábito encontrado');
        return [];
      } else {
        throw Exception('Falha ao carregar hábitos: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao buscar hábitos: $e');
      return [];
    }
  }

  static Future<Habit> addHabit(Habit habit) async {
    try {
      final token = await _getToken();
      if (token == null) {
        throw Exception('Token ausente. Faça login novamente.');
      }

      // Garante que temos o usuário atual
      final currentUser = await getCurrentUser();
      if (currentUser == null) {
        throw Exception('Usuário não encontrado. Faça login novamente.');
      }

      print('Preparando para enviar hábito:');
      print('Nome: ${habit.name}');
      print('Frequência: ${habit.frequency}');
      print('Meta: ${habit.goal}');
      print('Lembrete ativo: ${habit.reminder}');
      print('Horário do lembrete: ${habit.reminderTime}');
      print('Dias do lembrete: ${habit.reminderDays}');
      print('ID do usuário: ${currentUser.id}');

      final habitJson = {
        ...habit.toJson(),
        'reminder_time': habit.reminderTime,
        'reminder_days': habit.reminderDays,
        'user_id': currentUser.id,
      };

      print('JSON do hábito a ser enviado: $habitJson');

      final url = Uri.parse('$baseUrl/habits');
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(habitJson),
      );

      print('Status code da resposta: ${response.statusCode}');
      print('Corpo da resposta: ${response.body}');

      if (response.statusCode == 201) {
        final responseData = json.decode(response.body);
        print('Dados recebidos do servidor: $responseData');

        try {
          final createdHabit = Habit.fromJson(responseData);
          print('Hábito criado com sucesso:');
          print('ID: ${createdHabit.id}');
          print('Nome: ${createdHabit.name}');
          print('Frequência: ${createdHabit.frequency}');
          print('Meta: ${createdHabit.goal}');
          print('Progresso: ${createdHabit.progress}');

          if (habit.reminder && habit.reminderTime != null) {
            final notificationService = NotificationService();
            final timeParts = habit.reminderTime!.split(':');
            final scheduledTime = DateTime(
              DateTime.now().year,
              DateTime.now().month,
              DateTime.now().day,
              int.parse(timeParts[0]),
              int.parse(timeParts[1]),
            );

            await notificationService.scheduleHabitReminder(
              id: createdHabit.id!,
              title: 'Lembrete de Hábito',
              body: 'É hora de completar seu hábito: ${habit.name}!',
              scheduledTime: scheduledTime,
              weekDays: habit.reminderDays,
            );
          }
          return createdHabit;
        } catch (e) {
          print('Erro ao converter resposta para Habit: $e');
          print('Stack trace: ${StackTrace.current}');
          rethrow;
        }
      } else {
        throw Exception(
          'Falha ao salvar hábito: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('Erro ao adicionar hábito: $e');
      print('Stack trace: ${StackTrace.current}');
      rethrow;
    }
  }

  static Future<bool> updateHabit(Habit habit) async {
    final token = await _getToken();
    if (token == null) throw Exception('Token ausente. Faça login novamente.');

    final url = Uri.parse('$baseUrl/habits/${habit.id}');
    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        ...habit.toJson(),
        'reminder_time': habit.reminderTime,
        'reminder_days': habit.reminderDays,
      }),
    );

    if (response.statusCode == 200) {
      final notificationService = NotificationService();
      if (habit.reminder && habit.reminderTime != null) {
        final timeParts = habit.reminderTime!.split(':');
        final scheduledTime = DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          int.parse(timeParts[0]),
          int.parse(timeParts[1]),
        );

        await notificationService.scheduleHabitReminder(
          id: habit.id!,
          title: 'Lembrete de Hábito',
          body: 'É hora de completar seu hábito: ${habit.name}!',
          scheduledTime: scheduledTime,
        );
      } else {
        await notificationService.cancelHabitReminder(habit.id!);
      }
      return true;
    } else {
      throw Exception(
        'Falha ao atualizar hábito: ${response.statusCode} - ${response.body}',
      );
    }
  }

  static Future<bool> deleteHabit(int id) async {
    final token = await _getToken();
    if (token == null) throw Exception('Token ausente. Faça login novamente.');

    final url = Uri.parse('$baseUrl/habits/$id');
    final response = await http.delete(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    return response.statusCode == 200;
  }

  static Future<List<Habit>> getHabits() async {
    final token = await _getToken();
    if (token == null) throw Exception('Token ausente. Faça login novamente.');

    final url = Uri.parse('$baseUrl/habits');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((habitData) => Habit.fromJson(habitData)).toList();
    } else {
      throw Exception(
        'Erro ao carregar hábitos: ${response.statusCode} - ${response.body}',
      );
    }
  }

  static Future<User?> getUserProfile() async {
    final token = await _getToken();
    if (token == null) return null;

    final url = Uri.parse('$baseUrl/users/profile');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return User.fromJson(data);
    } else {
      return null;
    }
  }

  static Future<List<JournalEntry>> getJournalEntries() async {
    final token = await _getToken();
    final url = Uri.parse('$baseUrl/journal');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((entry) => JournalEntry.fromJson(entry)).toList();
    } else {
      throw Exception('Erro ao carregar entradas do diário.');
    }
  }

  static Future<bool> addJournalEntry(String content) async {
    final token = await _getToken();
    final url = Uri.parse('$baseUrl/journal');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({'content': content}),
    );

    return response.statusCode == 201;
  }

  static Future<List<MotivationMessage>> getMotivationMessages() async {
    final token = await _getToken();
    final url = Uri.parse('$baseUrl/motivation');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((msg) => MotivationMessage.fromJson(msg)).toList();
    } else {
      throw Exception('Erro ao carregar mensagens de motivação.');
    }
  }

  static Future<bool> addMotivationMessage(String message) async {
    try {
      final token = await _getToken();
      if (token == null) {
        throw Exception('Token ausente. Faça login novamente.');
      }

      final response = await http.post(
        Uri.parse('$baseUrl/motivation'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({'message': message}),
      );

      return response.statusCode == 201;
    } catch (e) {
      print('Erro ao adicionar mensagem de motivação: $e');
      throw Exception('Erro ao adicionar mensagem de motivação: $e');
    }
  }

  static Future<bool> deleteMotivationMessage(int id) async {
    try {
      final token = await _getToken();
      if (token == null) {
        throw Exception('Token ausente. Faça login novamente.');
      }

      final response = await http.delete(
        Uri.parse('$baseUrl/motivation/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Erro ao excluir mensagem de motivação: $e');
      throw Exception('Erro ao excluir mensagem de motivação: $e');
    }
  }

  static Future<List<Mission>> getMissions() async {
    final token = await _getToken();
    final url = Uri.parse('$baseUrl/missions');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((mission) => Mission.fromJson(mission)).toList();
    } else {
      throw Exception('Erro ao carregar missões.');
    }
  }

  static Future<bool> completeMission(int missionId) async {
    final token = await _getToken();
    final url = Uri.parse('$baseUrl/missions/$missionId/complete');
    final response = await http.post(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    return response.statusCode == 200;
  }

  static Future<List<CustomizationItem>>
  getAvailableCustomizationItems() async {
    final token = await _getToken();
    final url = Uri.parse('$baseUrl/customization/items');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => CustomizationItem.fromJson(item)).toList();
    } else {
      throw Exception('Erro ao carregar itens de customização.');
    }
  }

  static Future<bool> purchaseCustomizationItem(int itemId) async {
    final token = await _getToken();
    final url = Uri.parse('$baseUrl/customization/items/$itemId/purchase');
    final response = await http.post(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    return response.statusCode == 200;
  }

  static Future<List<User>> getGlobalRanking() async {
    final token = await _getToken();
    final url = Uri.parse('$baseUrl/ranking/global');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((user) => User.fromJson(user)).toList();
    } else {
      throw Exception('Erro ao carregar ranking global.');
    }
  }

  static Future<bool> updateUser(User user) async {
    final token = await _getToken();
    if (token == null) throw Exception('Token ausente. Faça login novamente.');

    final url = Uri.parse('$baseUrl/user/${user.id}');

    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'name': user.name,
        'email': user.email,
        'level': user.level,
        'points': user.points,
      }),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception(
        'Erro ao atualizar usuário: ${response.statusCode} - ${response.body}',
      );
    }
  }

  static Future<bool> addMission({
    required String title,
    required String description,
    required String type,
  }) async {
    final token = await _getToken();
    final url = Uri.parse('$baseUrl/missions');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'title': title,
        'description': description,
        'type': type,
      }),
    );

    return response.statusCode == 201;
  }

  static Future<HabitCompletion> createHabitCompletion(
    int habitId,
    int? tempoGasto,
  ) async {
    final token = await _getToken();
    if (token == null) throw Exception('Token ausente. Faça login novamente.');

    final url = Uri.parse('$baseUrl/habit-completions');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({'habit_id': habitId, 'tempo_gasto': tempoGasto}),
    );

    if (response.statusCode == 201) {
      return HabitCompletion.fromJson(json.decode(response.body));
    } else {
      throw Exception(
        'Falha ao criar conclusão: ${response.statusCode} - ${response.body}',
      );
    }
  }

  static Future<List<HabitCompletion>> getHabitCompletions(int habitId) async {
    final token = await _getToken();
    if (token == null) throw Exception('Token ausente. Faça login novamente.');

    final url = Uri.parse('$baseUrl/habit-completions/habit/$habitId');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => HabitCompletion.fromJson(json)).toList();
    } else {
      throw Exception(
        'Falha ao buscar conclusões: ${response.statusCode} - ${response.body}',
      );
    }
  }

  static Future<HabitCompletionStats> getHabitCompletionStats(
    int habitId,
  ) async {
    final token = await _getToken();
    if (token == null) throw Exception('Token ausente. Faça login novamente.');

    final url = Uri.parse('$baseUrl/habit-completions/stats/$habitId');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return HabitCompletionStats.fromJson(json.decode(response.body));
    } else {
      throw Exception(
        'Falha ao buscar estatísticas: ${response.statusCode} - ${response.body}',
      );
    }
  }
}

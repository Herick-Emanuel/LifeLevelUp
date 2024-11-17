import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/customization_item.dart';
import '../models/habit.dart';
import '../models/journal_entry.dart';
import '../models/mission.dart';
import '../models/motivation_message.dart';
import '../models/user.dart';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:3000';
  static const storage = FlutterSecureStorage();

  static Future<String> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await storage.write(key: 'token', value: data['token']);
      return data['token'];
    } else {
      print('Erro ao fazer login: ${response.body}');
      throw Exception('Erro ao fazer login: ${response.body}');
    }
  }

  static Future<bool> register(
      String name, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      print('Erro ao registrar usuário: ${response.body}');
      throw Exception('Erro ao registrar usuário');
    }
  }

  static Future<void> logout() async {
    await storage.delete(key: 'token');
  }

  static Future<User?> getCurrentUser() async {
    final token = await storage.read(key: 'token');
    if (token == null) return null;

    final url = Uri.parse('$baseUrl/user');
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

  static Future<List<Habit>> fetchHabits() async {
    final token = await storage.read(key: 'token');
    if (token == null) throw Exception('Token ausente. Faça login novamente.');

    final url = Uri.parse('$baseUrl/habits');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      if (data.isNotEmpty) {
        return data.map((habitData) {
          if (habitData is Map<String, dynamic>) {
            return Habit.fromJson(habitData);
          } else {
            throw Exception('Dados de hábito inválidos');
          }
        }).toList();
      } else {
        throw Exception('Resposta inesperada ao buscar hábitos');
      }
    } else {
      throw Exception('Erro ao carregar hábitos: ${response.statusCode}');
    }
  }

  static Future<bool> addHabit(Habit habit) async {
    final token = await storage.read(key: 'token');
    if (token == null) throw Exception('Token ausente. Faça login novamente.');

    final url = Uri.parse('$baseUrl/habits');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(habit.toJson()),
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      throw Exception(
          'Falha ao salvar hábito: ${response.statusCode} - ${response.body}');
    }
  }

  static Future<bool> updateHabit(Habit habit) async {
    final token = await storage.read(key: 'token');
    if (token == null) throw Exception('Token ausente. Faça login novamente.');

    final url = Uri.parse('$baseUrl/habits/${habit.id}');
    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(habit.toJson()),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception(
          'Falha ao atualizar hábito: ${response.statusCode} - ${response.body}');
    }
  }

  static Future<bool> deleteHabit(int id) async {
    final token = await storage.read(key: 'token');
    if (token == null) throw Exception('Token ausente. Faça login novamente.');

    final url = Uri.parse('$baseUrl/habits/$id');
    final response = await http.delete(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    return response.statusCode == 200;
  }

  static Future<List<Habit>> getHabits() async {
    final token = await storage.read(key: 'token');
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
          'Erro ao carregar hábitos: ${response.statusCode} - ${response.body}');
    }
  }

  static Future<User?> getUserProfile() async {
    final token = await storage.read(key: 'token');
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
    final token = await storage.read(key: 'token');
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
    final token = await storage.read(key: 'token');
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
    final token = await storage.read(key: 'token');
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
    final token = await storage.read(key: 'token');
    final url = Uri.parse('$baseUrl/motivation');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({'message': message}),
    );

    return response.statusCode == 201;
  }

  static Future<List<Mission>> getMissions() async {
    final token = await storage.read(key: 'token');
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
    final token = await storage.read(key: 'token');
    final url = Uri.parse('$baseUrl/missions/$missionId/complete');
    final response = await http.post(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    return response.statusCode == 200;
  }

  static Future<List<CustomizationItem>>
      getAvailableCustomizationItems() async {
    final token = await storage.read(key: 'token');
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
    final token = await storage.read(key: 'token');
    final url = Uri.parse('$baseUrl/customization/items/$itemId/purchase');
    final response = await http.post(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    return response.statusCode == 200;
  }

  static Future<List<User>> getGlobalRanking() async {
    final token = await storage.read(key: 'token');
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
    final token =
        await storage.read(key: 'token'); // Recupera o token de autenticação
    if (token == null) throw Exception('Token ausente. Faça login novamente.');

    final url = Uri.parse(
        '$baseUrl/user/${user.id}'); // Endpoint para atualização do usuário

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
          'Erro ao atualizar usuário: ${response.statusCode} - ${response.body}');
    }
  }
}

import 'package:json_annotation/json_annotation.dart';

part 'habit.g.dart';

@JsonSerializable()
class Habit {
  final int? id;
  final String name;
  final String frequency;
  final int goal;
  final int progress;
  final bool reminder;
  @JsonKey(name: 'reminder_time')
  final String? reminderTime;
  @JsonKey(name: 'reminder_days')
  final List<int> reminderDays;
  @JsonKey(name: 'user_id')
  final int? userId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  @JsonKey(name: 'completion_rate')
  final double completionRate;
  final String status;
  final int? quantidadeDeConclusoes;
  final int? tempoDeDuracaoDoHabito;

  static DateTime? _dateFromJson(dynamic date) =>
      date == null ? null : DateTime.parse(date.toString());

  static String? _dateToJson(DateTime? date) => date?.toIso8601String();

  Habit({
    this.id,
    required this.name,
    required this.frequency,
    required this.goal,
    this.progress = 0,
    this.reminder = false,
    this.reminderTime,
    this.reminderDays = const [],
    this.userId,
    this.createdAt,
    this.updatedAt,
    this.completionRate = 0.0,
    this.status = 'pending',
    this.quantidadeDeConclusoes,
    this.tempoDeDuracaoDoHabito,
  });

  factory Habit.fromJson(Map<String, dynamic> json) {
    return Habit(
      id: json['id'],
      name: json['name'],
      frequency: json['frequency'],
      goal: json['goal'],
      progress: json['progress'] ?? 0,
      reminder: json['reminder'] ?? false,
      reminderTime: json['reminder_time'],
      reminderDays: List<int>.from(json['reminder_days'] ?? []),
      userId: json['user_id'],
      createdAt:
          json['created_at'] != null
              ? DateTime.parse(json['created_at'])
              : null,
      updatedAt:
          json['updated_at'] != null
              ? DateTime.parse(json['updated_at'])
              : null,
      completionRate: (json['completion_rate'] ?? 0.0).toDouble(),
      status: json['status'] ?? 'pending',
      quantidadeDeConclusoes: json['quantidade_de_conclusoes'],
      tempoDeDuracaoDoHabito: json['tempo_de_duracao_do_habito'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'frequency': frequency,
      'goal': goal,
      'progress': progress,
      'reminder': reminder,
      'reminder_time': reminderTime,
      'reminder_days': reminderDays,
      'user_id': userId,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'completion_rate': completionRate,
      'status': status,
      'quantidade_de_conclusoes': quantidadeDeConclusoes,
      'tempo_de_duracao_do_habito': tempoDeDuracaoDoHabito,
    };
  }

  Habit copyWith({
    int? id,
    String? name,
    String? frequency,
    int? goal,
    int? progress,
    bool? reminder,
    String? reminderTime,
    List<int>? reminderDays,
    int? userId,
    DateTime? createdAt,
    DateTime? updatedAt,
    double? completionRate,
    String? status,
    int? quantidadeDeConclusoes,
    int? tempoDeDuracaoDoHabito,
  }) {
    return Habit(
      id: id ?? this.id,
      name: name ?? this.name,
      frequency: frequency ?? this.frequency,
      goal: goal ?? this.goal,
      progress: progress ?? this.progress,
      reminder: reminder ?? this.reminder,
      reminderTime: reminderTime ?? this.reminderTime,
      reminderDays: reminderDays ?? List.from(this.reminderDays),
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      completionRate: completionRate ?? this.completionRate,
      status: status ?? this.status,
      quantidadeDeConclusoes:
          quantidadeDeConclusoes ?? this.quantidadeDeConclusoes,
      tempoDeDuracaoDoHabito:
          tempoDeDuracaoDoHabito ?? this.tempoDeDuracaoDoHabito,
    );
  }

  bool get isValid {
    if (name.isEmpty) return false;
    if (!['Diário', 'Semanal', 'Mensal'].contains(frequency)) return false;
    if (goal <= 0) return false;
    if (reminder && reminderTime == null) return false;
    if (reminderDays.any((day) => day < 0 || day > 6)) return false;
    if (frequency == 'Diário' &&
        quantidadeDeConclusoes != null &&
        quantidadeDeConclusoes! < 1) {
      return false;
    }
    if (tempoDeDuracaoDoHabito != null && tempoDeDuracaoDoHabito! < 0) {
      return false;
    }
    return true;
  }
}

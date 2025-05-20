// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Habit _$HabitFromJson(Map<String, dynamic> json) => Habit(
  id: (json['id'] as num?)?.toInt(),
  name: json['name'] as String,
  frequency: json['frequency'] as String,
  goal: (json['goal'] as num).toInt(),
  progress: (json['progress'] as num?)?.toInt() ?? 0,
  reminder: json['reminder'] as bool? ?? false,
  reminderTime: json['reminder_time'] as String?,
  reminderDays:
      (json['reminder_days'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList() ??
      [],
  userId: (json['user_id'] as num?)?.toInt(),
  createdAt:
      json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
  updatedAt:
      json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
  completionRate: (json['completion_rate'] as num?)?.toDouble() ?? 0.0,
  status: json['status'] as String? ?? 'pending',
  quantidadeDeConclusoes: (json['quantidade_de_conclusoes'] as num?)?.toInt(),
  tempoDeDuracaoDoHabito: (json['tempo_de_duracao_do_habito'] as num?)?.toInt(),
);

Map<String, dynamic> _$HabitToJson(Habit instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'frequency': instance.frequency,
  'goal': instance.goal,
  'progress': instance.progress,
  'reminder': instance.reminder,
  'reminder_time': instance.reminderTime,
  'reminder_days': instance.reminderDays,
  'user_id': instance.userId,
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
  'completion_rate': instance.completionRate,
  'status': instance.status,
  'quantidade_de_conclusoes': instance.quantidadeDeConclusoes,
  'tempo_de_duracao_do_habito': instance.tempoDeDuracaoDoHabito,
};

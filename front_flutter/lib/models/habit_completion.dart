class HabitCompletion {
  final int? id;
  final int habitId;
  final DateTime completionDate;
  final int? tempoGasto;

  HabitCompletion({
    this.id,
    required this.habitId,
    required this.completionDate,
    this.tempoGasto,
  });

  factory HabitCompletion.fromJson(Map<String, dynamic> json) {
    return HabitCompletion(
      id: json['id'],
      habitId: json['habit_id'],
      completionDate: DateTime.parse(json['completion_date']),
      tempoGasto: json['tempo_gasto'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'habit_id': habitId,
      'completion_date': completionDate.toIso8601String(),
      'tempo_gasto': tempoGasto,
    };
  }
}

class HabitCompletionStats {
  final double mediaTempo;
  final int minTempo;
  final int maxTempo;
  final int totalConclusoes;

  HabitCompletionStats({
    required this.mediaTempo,
    required this.minTempo,
    required this.maxTempo,
    required this.totalConclusoes,
  });

  factory HabitCompletionStats.fromJson(Map<String, dynamic> json) {
    return HabitCompletionStats(
      mediaTempo: (json['media_tempo'] ?? 0.0).toDouble(),
      minTempo: json['min_tempo'] ?? 0,
      maxTempo: json['max_tempo'] ?? 0,
      totalConclusoes: json['total_conclusoes'] ?? 0,
    );
  }
}

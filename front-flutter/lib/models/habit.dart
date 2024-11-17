class Habit {
  final int id;
  final String name;
  final String frequency;
  final int goal;
  final int progress;
  final bool reminder;

  Habit({
    required this.id,
    required this.name,
    required this.frequency,
    required this.goal,
    required this.progress,
    required this.reminder,
  });

  factory Habit.fromJson(Map<String, dynamic> json) {
    return Habit(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      frequency: json['frequency'] ?? '',
      goal: json['goal'] ?? 0,
      progress: json['progress'] ?? 0,
      reminder: json['reminder'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'frequency': frequency,
        'goal': goal,
        'progress': progress,
        'reminder': reminder,
      };
}

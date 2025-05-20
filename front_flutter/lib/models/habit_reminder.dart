class HabitReminder {
  final int id;
  final int habitId;
  final String title;
  final String body;
  final DateTime scheduledTime;
  final String frequency;

  HabitReminder({
    required this.id,
    required this.habitId,
    required this.title,
    required this.body,
    required this.scheduledTime,
    required this.frequency,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'habitId': habitId,
      'title': title,
      'body': body,
      'scheduledTime': scheduledTime.toIso8601String(),
      'frequency': frequency,
    };
  }

  factory HabitReminder.fromJson(Map<String, dynamic> json) {
    return HabitReminder(
      id: json['id'],
      habitId: json['habitId'],
      title: json['title'],
      body: json['body'],
      scheduledTime: DateTime.parse(json['scheduledTime']),
      frequency: json['frequency'],
    );
  }
}

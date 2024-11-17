class Mission {
  final int id;
  final String title;
  final String description;
  final String type;
  final bool isCompleted;

  Mission({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.isCompleted,
  });

  factory Mission.fromJson(Map<String, dynamic> json) {
    return Mission(
      id: json['id'],
      title: json['title'],
      description: json['description'] ?? '',
      type: json['type'],
      isCompleted: json['is_completed'],
    );
  }
}

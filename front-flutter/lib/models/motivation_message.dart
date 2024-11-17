class MotivationMessage {
  final int id;
  final String message;
  final DateTime createdAt;

  MotivationMessage({
    required this.id,
    required this.message,
    required this.createdAt,
  });

  factory MotivationMessage.fromJson(Map<String, dynamic> json) {
    return MotivationMessage(
      id: json['id'],
      message: json['message'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}

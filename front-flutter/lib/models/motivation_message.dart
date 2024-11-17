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
    if (json['message'] == null) {
      throw Exception("O campo 'message' está nulo.");
    }
    return MotivationMessage(
      id: json['id'] as int,
      message: json['message'] as String,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

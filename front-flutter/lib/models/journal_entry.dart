class JournalEntry {
  final int id;
  final String content;
  final DateTime createdAt;

  JournalEntry({
    required this.id,
    required this.content,
    required this.createdAt,
  });

  factory JournalEntry.fromJson(Map<String, dynamic> json) {
    if (json['content'] == null) {
      throw Exception("O campo 'content' está nulo.");
    }
    return JournalEntry(
      id: json['id'] as int,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

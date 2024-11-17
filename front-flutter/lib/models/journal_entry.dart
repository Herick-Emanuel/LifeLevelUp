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
    return JournalEntry(
      id: json['id'],
      content: json['content'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}

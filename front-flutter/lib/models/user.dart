class User {
  final int id;
  final String name;
  final String email;
  final int level;
  final int points;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.level,
    required this.points,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      level: json['level'] ?? 1,
      points: json['points'] ?? 0,
    );
  }
}

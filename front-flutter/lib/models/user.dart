class User {
  final int id;
  final String name;
  final String email;
  int level;
  int points;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.level = 1,
    this.points = 0,
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

  void addPoints(int earnedPoints) {
    points += earnedPoints;

    if (points >= level * 100) {
      level++;
      points = points - (level - 1) * 100;
    }
  }
}

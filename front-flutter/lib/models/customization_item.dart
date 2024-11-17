class CustomizationItem {
  final int id;
  final String name;
  final String type;
  final int levelRequired;
  final int pointsCost;

  CustomizationItem({
    required this.id,
    required this.name,
    required this.type,
    required this.levelRequired,
    required this.pointsCost,
  });

  factory CustomizationItem.fromJson(Map<String, dynamic> json) {
    return CustomizationItem(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      levelRequired: json['level_required'],
      pointsCost: json['points_cost'],
    );
  }
}

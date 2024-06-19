// lib/models/category.dart

class Category {
  final int id;
  final String name;
  final String color;
  final int workspace;

  Category({
    required this.id,
    required this.name,
    required this.color,
    required this.workspace,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      color: json['color'],
      workspace: json['workspace'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'color': color,
      'workspace': workspace,
    };
  }
}

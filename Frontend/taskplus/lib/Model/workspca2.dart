class Workspace2 {
  final String name;
  final String sector;

  Workspace2({required this.name, required this.sector});

  factory Workspace2.fromJson(Map<String, dynamic> json) {
    return Workspace2(
      name: json['name'],
      sector: json['sector'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'sector': sector,
    };
  }
}

// workspace_model.dart

class Workspace {
  final int id;
  final String name;
  final String sector;
  final String inviteCode;

  Workspace({
    required this.id,
    required this.name,
    required this.sector,
    required this.inviteCode,
  });

  factory Workspace.fromJson(Map<String, dynamic> json) {
    return Workspace(
      id: json['id'],
      name: json['name'],
      sector: json['sector'],
      inviteCode: json['invite_code'],
    );
  }
}

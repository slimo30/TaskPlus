class Member {
  final int id;
  final String password;
  final String? deviceToken;
  final String username;
  final bool superuser;
  final int? workspace;
  final String name;

  Member({
    required this.id,
    required this.password,
    this.deviceToken,
    required this.username,
    required this.superuser,
    this.workspace,
    required this.name,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'password': password,
      'device_token': deviceToken,
      'username': username,
      'superuser': superuser,
      'workspace': workspace,
      'name': name,
    };
  }

  static Member fromJson(Map<String, dynamic> data) {
    return Member(
      id: data['id'],
      password: data['password'],
      deviceToken: data['device_token'],
      username: data['username'],
      superuser: data['superuser'],
      workspace: data['workspace'],
      name: data['name'],
    );
  }
}

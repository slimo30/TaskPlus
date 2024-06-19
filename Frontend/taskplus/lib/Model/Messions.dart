class Mission {
  final int id;
  final String title;
  final String priority;
  final bool ordered;
  final DateTime timeCreated;
  final int category;
  final int workspace;

  Mission({
    required this.id,
    required this.title,
    required this.priority,
    required this.ordered,
    required this.timeCreated,
    required this.category,
    required this.workspace,
  });

  factory Mission.fromJson(Map<String, dynamic> json) {
    return Mission(
      id: json['id'],
      title: json['title'],
      priority: json['priority'],
      ordered: json['ordered'],
      timeCreated: DateTime.parse(json['time_created']),
      category: json['category'],
      workspace: json['workspace'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'priority': priority,
      'ordered': ordered,
      'time_created': timeCreated.toIso8601String(),
      'category': category,
      'workspace': workspace,
    };
  }
}

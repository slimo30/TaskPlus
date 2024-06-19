class Comment {
  final int id;
  final String text;
  final DateTime timePosted;
  final int employee;
  final int task;
  final int workspace;

  Comment({
    required this.id,
    required this.text,
    required this.timePosted,
    required this.employee,
    required this.task,
    required this.workspace,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      text: json['text'],
      timePosted: DateTime.parse(json['time_posted']),
      employee: json['employee'],
      task: json['task'],
      workspace: json['workspace'],
    );
  }
}

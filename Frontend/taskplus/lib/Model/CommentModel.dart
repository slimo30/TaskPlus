class Comment {
  final int id;
  final String text;
  final DateTime timePosted;
  final int employee;
  final int task;

  Comment({
    required this.id,
    required this.text,
    required this.timePosted,
    required this.employee,
    required this.task,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      text: json['text'],
      timePosted: DateTime.parse(json['time_posted']),
      employee: json['employee'],
      task: json['task'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'time_posted': timePosted.toIso8601String(),
      'employee': employee,
      'task': task,
    };
  }
}

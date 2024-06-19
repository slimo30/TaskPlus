class Task {
  final int taskId;
  final String title;
  final String description;
  final String priority;
  final String state;
  final DateTime deadline;
  final String? fileAttachment;
  final DateTime timeCreated;
  final int orderPosition;
  final String timeToAlert;
  final bool notificationSent;
  final bool notificationSentAlert;
  final int taskOwner;
  final int mission;

  Task({
    required this.taskId,
    required this.title,
    required this.description,
    required this.priority,
    required this.state,
    required this.deadline,
    this.fileAttachment,
    required this.timeCreated,
    required this.orderPosition,
    required this.timeToAlert,
    required this.notificationSent,
    required this.notificationSentAlert,
    required this.taskOwner,
    required this.mission,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      taskId: json['task_id'],
      title: json['title'],
      description: json['description'],
      priority: json['priority'],
      state: json['state'],
      deadline: DateTime.parse(json['deadline']),
      fileAttachment: json['file_attachment'],
      timeCreated: DateTime.parse(json['time_created']),
      orderPosition: json['order_position'],
      timeToAlert: json['time_to_alert'],
      notificationSent: json['notification_sent'],
      notificationSentAlert: json['notification_sent_alert'],
      taskOwner: json['task_owner'],
      mission: json['mission'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'task_id': taskId,
      'title': title,
      'description': description,
      'priority': priority,
      'state': state,
      'deadline': deadline.toIso8601String(),
      'file_attachment': fileAttachment,
      'time_created': timeCreated.toIso8601String(),
      'time_to_alert': timeToAlert,
      'notification_sent': notificationSent,
      'notification_sent_alert': notificationSentAlert,
      'task_owner': taskOwner,
      'mission': mission,
    };
  }
}

part of 'task_bloc.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object> get props => [];
}

class LoadTasks extends TaskEvent {}

class LoadTaskDetail extends TaskEvent {
  final int taskId;

  const LoadTaskDetail(this.taskId);

  @override
  List<Object> get props => [taskId];
}

class CreateTask extends TaskEvent {
  final Task task;
  final int? missionId;
  final int? memberId;

  const CreateTask(this.task, {this.missionId, this.memberId});

  @override
  List<Object> get props => [task, missionId ?? 0, memberId ?? 0];
}

class UpdateTask extends TaskEvent {
  final Task task;
  final int? missionId;
  final int? memberId;
  final int? memberIdHistory;

  const UpdateTask(this.task,
      {this.missionId, this.memberId, this.memberIdHistory});

  @override
  List<Object> get props => [task, missionId ?? 0, memberId ?? 0];
}

class DeleteTask extends TaskEvent {
  final int taskId;
  final int? missionId;
  final int? memberId;

  const DeleteTask(this.taskId, {this.missionId, this.memberId});

  @override
  List<Object> get props => [taskId, missionId ?? 0, memberId ?? 0];
}

class LoadTasksByMission extends TaskEvent {
  final int missionId;

  const LoadTasksByMission(this.missionId);

  @override
  List<Object> get props => [missionId];
}

class LoadTasksByMember extends TaskEvent {
  final int memberId;

  const LoadTasksByMember(this.memberId);

  @override
  List<Object> get props => [memberId];
}

class LoadTasksByHistory extends TaskEvent {
  final int memberId;

  const LoadTasksByHistory(this.memberId);

  @override
  List<Object> get props => [memberId];
}

class ClearTaskState extends TaskEvent {
  @override
  String toString() => 'ClearTaskState';
}

part of 'task_bloc.dart';

abstract class TaskState extends Equatable {
  const TaskState();

  @override
  List<Object> get props => [];
}

class TaskInitial extends TaskState {}

class TaskLoading extends TaskState {}

class TaskLoadSuccess extends TaskState {
  final List<Task> tasks;

  const TaskLoadSuccess(this.tasks);

  @override
  List<Object> get props => [tasks];
}

class TaskDetailLoadSuccess extends TaskState {
  final Task task;

  const TaskDetailLoadSuccess(this.task);

  @override
  List<Object> get props => [task];
}

class TaskCreateSuccess extends TaskState {
  final Task task;

  const TaskCreateSuccess(this.task);

  @override
  List<Object> get props => [task];
}

class TaskUpdateSuccess extends TaskState {
  final Task task;

  const TaskUpdateSuccess(this.task);

  @override
  List<Object> get props => [task];
}

class TaskDeleteSuccess extends TaskState {}

class TaskLoadFailure extends TaskState {
  final String error;

  const TaskLoadFailure(this.error);

  @override
  List<Object> get props => [error];
}

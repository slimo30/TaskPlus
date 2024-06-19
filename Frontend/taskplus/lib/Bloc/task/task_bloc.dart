import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:taskplus/Controller/task_repo.dart';
import 'package:taskplus/Model/TaskModel.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskRepository taskRepository;

  TaskBloc({required this.taskRepository}) : super(TaskInitial()) {
    on<LoadTasks>(_onLoadTasks);
    on<LoadTaskDetail>(_onLoadTaskDetail);
    on<CreateTask>(_onCreateTask);
    on<UpdateTask>(_onUpdateTask);
    on<DeleteTask>(_onDeleteTask);
    on<LoadTasksByMission>(_onLoadTasksByMission);
    on<LoadTasksByMember>(_onLoadTasksByMember);
    on<LoadTasksByHistory>(_onLoadTasksByHistory);
  }

  void _onLoadTasks(LoadTasks event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    try {
      final tasks = await taskRepository.getTasks();
      emit(TaskLoadSuccess(tasks));
    } catch (e) {
      emit(TaskLoadFailure(e.toString()));
    }
  }

  void _onLoadTaskDetail(LoadTaskDetail event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    try {
      final task = await taskRepository.getTaskDetail(event.taskId);
      emit(TaskDetailLoadSuccess(task));
    } catch (e) {
      emit(TaskLoadFailure(e.toString()));
    }
  }

  void _onCreateTask(CreateTask event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    try {
      await taskRepository.createTask(event.task);
      if (event.missionId != null) {
        add(LoadTasksByMission(event.missionId!));
      } else if (event.memberId != null) {
        add(LoadTasksByMember(event.memberId!));
      } else {
        add(LoadTasks());
      }
    } catch (e) {
      emit(TaskLoadFailure(e.toString()));
    }
  }

  void _onUpdateTask(UpdateTask event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    try {
      await taskRepository.updateTask(event.task);
      if (event.missionId != null) {
        add(LoadTasksByMission(event.missionId!));
      } else if (event.memberId != null) {
        add(LoadTasksByMember(event.memberId!));
      } else if (event.memberIdHistory != null) {
        add(LoadTasksByHistory(event.memberIdHistory!));
      } else {
        add(LoadTasks());
      }
    } catch (e) {
      emit(TaskLoadFailure(e.toString()));
    }
  }

  void _onDeleteTask(DeleteTask event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    try {
      await taskRepository.deleteTask(event.taskId);
      if (event.missionId != null) {
        add(LoadTasksByMission(event.missionId!));
      } else if (event.memberId != null) {
        add(LoadTasksByMember(event.memberId!));
      } else {
        add(LoadTasks());
      }
    } catch (e) {
      emit(TaskLoadFailure(e.toString()));
    }
  }

  void _onLoadTasksByMission(
      LoadTasksByMission event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    try {
      final tasks = await taskRepository.getTasksByMission(event.missionId);
      emit(TaskLoadSuccess(tasks));
    } catch (e) {
      emit(TaskLoadFailure(e.toString()));
    }
  }

  void _onLoadTasksByMember(
      LoadTasksByMember event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    try {
      final tasks = await taskRepository.getTasksByMember(event.memberId);
      emit(TaskLoadSuccess(tasks));
    } catch (e) {
      emit(TaskLoadFailure(e.toString()));
    }
  }

  void _onLoadTasksByHistory(
      LoadTasksByHistory event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    try {
      final tasks =
          await taskRepository.getTasksByHistorymember(event.memberId);
      emit(TaskLoadSuccess(tasks));
    } catch (e) {
      emit(TaskLoadFailure(e.toString()));
    }
  }
}

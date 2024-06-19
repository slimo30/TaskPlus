// lib/bloc/mission_event.dart
import 'package:equatable/equatable.dart';
import 'package:taskplus/Model/Messions.dart';

abstract class MissionEvent extends Equatable {
  const MissionEvent();

  @override
  List<Object> get props => [];
}

class LoadMissions extends MissionEvent {}

class AddMission extends MissionEvent {
  final Mission mission;

  const AddMission(this.mission);

  @override
  List<Object> get props => [mission];
}

class UpdateMission extends MissionEvent {
  final Mission mission;

  const UpdateMission(this.mission);

  @override
  List<Object> get props => [mission];
}

class DeleteMission extends MissionEvent {
  final int id;

  const DeleteMission(this.id);

  @override
  List<Object> get props => [id];
}

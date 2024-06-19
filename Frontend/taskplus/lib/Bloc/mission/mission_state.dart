// lib/bloc/mission_state.dart
import 'package:equatable/equatable.dart';
import 'package:taskplus/Model/Messions.dart';


abstract class MissionState extends Equatable {
  const MissionState();

  @override
  List<Object> get props => [];
}

class MissionInitial extends MissionState {}

class MissionLoadInProgress extends MissionState {}


class MissionLoadSuccess extends MissionState {
  final List<Mission> missions;

  const MissionLoadSuccess(this.missions);

  @override
  List<Object> get props => [missions];
}


class MissionOperationFailure extends MissionState {
  final String error;

  const MissionOperationFailure(this.error);

  @override
  List<Object> get props => [error];
}

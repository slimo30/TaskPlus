import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskplus/Controller/mission_repo.dart';
import 'mission_event.dart';
import 'mission_state.dart';

class MissionBloc extends Bloc<MissionEvent, MissionState> {
  final MissionRepository missionRepository;

  MissionBloc({required this.missionRepository}) : super(MissionInitial()) {
    on<LoadMissions>(_onLoadMissions);
    on<AddMission>(_onAddMission);
    on<UpdateMission>(_onUpdateMission);
    on<DeleteMission>(_onDeleteMission);
  }

  Future<void> _onLoadMissions(
      LoadMissions event, Emitter<MissionState> emit) async {
    emit(MissionLoadInProgress());
    try {
      final missions = await missionRepository.fetchMissions();
      emit(MissionLoadSuccess(missions));
    } catch (e) {
      emit(MissionOperationFailure(e.toString()));
    }
  }

  Future<void> _onAddMission(
      AddMission event, Emitter<MissionState> emit) async {
    try {
      await missionRepository.addMission(event.mission);
      final missions = await missionRepository.fetchMissions();
      emit(MissionLoadSuccess(missions));
    } catch (e) {
      emit(MissionOperationFailure(e.toString()));
    }
  }

  Future<void> _onUpdateMission(
      UpdateMission event, Emitter<MissionState> emit) async {
    try {
      await missionRepository.updateMission(event.mission);
      final missions = await missionRepository.fetchMissions();
      emit(MissionLoadSuccess(missions));
    } catch (e) {
      emit(MissionOperationFailure(e.toString()));
    }
  }

  Future<void> _onDeleteMission(
      DeleteMission event, Emitter<MissionState> emit) async {
    try {
      await missionRepository.deleteMission(event.id);
      final missions = await missionRepository.fetchMissions();
      emit(MissionLoadSuccess(missions));
    } catch (e) {
      emit(MissionOperationFailure(e.toString()));
    }
  }
}

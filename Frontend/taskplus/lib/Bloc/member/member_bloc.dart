import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskplus/Bloc/member/member_event.dart';
import 'package:taskplus/Bloc/member/member_state.dart';
import 'package:taskplus/Controller/member_repo.dart';
import 'package:taskplus/Model/Member.dart';

class MemberBloc extends Bloc<MemberEvent, MemberState> {
  final MemberRepository memberRepository;

  MemberBloc({required this.memberRepository}) : super(MemberInitial()) {
    on<FetchMembers>(_onFetchMembers);
    on<UpdateMember>(_onUpdateMember);
  }

  Future<void> _onFetchMembers(
      FetchMembers event, Emitter<MemberState> emit) async {
    emit(MemberLoading());
    try {
      final members = await memberRepository.fetchMembers();
      emit(MemberLoaded(members));
    } catch (e) {
      emit(MemberError('Failed to fetch members'));
    }
  }

  Future<void> _onUpdateMember(
      UpdateMember event, Emitter<MemberState> emit) async {
    emit(MemberLoading());
    try {
      await memberRepository.updateMember(event.member);
      final members = await memberRepository.fetchMembers();
      emit(MemberLoaded(members));
    } catch (e) {
      emit(MemberError('Failed to update member'));
    }
  }
}

import 'package:equatable/equatable.dart';
import 'package:taskplus/Model/Member.dart';

abstract class MemberEvent extends Equatable {
  const MemberEvent();

  @override
  List<Object> get props => [];
}

class FetchMembers extends MemberEvent {}

class UpdateMember extends MemberEvent {
  final Member member;

  const UpdateMember(this.member);

  @override
  List<Object> get props => [member];
}

import 'package:equatable/equatable.dart';
import 'package:taskplus/Model/CommentModel.dart';

abstract class CommentEvent extends Equatable {
  const CommentEvent();

  @override
  List<Object> get props => [];
}

class FetchComments extends CommentEvent {
  final int taskId;

  const FetchComments(this.taskId);

  @override
  List<Object> get props => [taskId];
}

class UpdateComment extends CommentEvent {
  final Comment comment;

  const UpdateComment(this.comment);

  @override
  List<Object> get props => [comment];
}

class CreateComment extends CommentEvent {
  final Comment comment;

  const CreateComment(this.comment);

  @override
  List<Object> get props => [comment];
}

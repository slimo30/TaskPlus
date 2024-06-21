import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskplus/Bloc/comment/comment_event.dart';
import 'package:taskplus/Bloc/comment/comment_state.dart';
import 'package:taskplus/Controller/commrnt_repo.dart';
import 'package:taskplus/Model/CommentModel.dart';



class CommentBloc extends Bloc<CommentEvent, CommentState> {
  final CommentRepository repository;

  CommentBloc({required this.repository}) : super(CommentInitial()) {
    on<FetchComments>(_onFetchComments);
    on<UpdateComment>(_onUpdateComment);
    on<CreateComment>(_onCreateComment);
  }

  void _onFetchComments(FetchComments event, Emitter<CommentState> emit) async {
    emit(CommentLoading());
    try {
      List<Comment> comments = await repository.fetchComments(event.taskId);
      emit(CommentLoaded(comments));
    } catch (e) {
      emit(CommentError('Failed to fetch comments'));
    }
  }

  void _onUpdateComment(UpdateComment event, Emitter<CommentState> emit) async {
    emit(CommentLoading());
    try {
      await repository.updateComment(event.comment);
      List<Comment> comments =
          await repository.fetchComments(event.comment.task);
      emit(CommentLoaded(comments));
    } catch (e) {
      emit(CommentError('Failed to update comment'));
    }
  }

  void _onCreateComment(CreateComment event, Emitter<CommentState> emit) async {
    emit(CommentLoading());
    try {
      await repository.createComment(event.comment);
      List<Comment> comments =
          await repository.fetchComments(event.comment.task);
      emit(CommentLoaded(comments));
    } catch (e) {
      emit(CommentError('Failed to create comment'));
    }
  }
}

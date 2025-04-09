import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tez_med_client/core/error/failure.dart';
import 'package:tez_med_client/data/comments/model/comment_model.dart';
import 'package:tez_med_client/domain/comments/usecase/post_comment_usecase.dart';

part 'comment_event.dart';
part 'comment_state.dart';

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  final PostCommentUsecase postCommentUsecase;
  CommentBloc(this.postCommentUsecase) : super(CommentInitial()) {
    on<PostCommit>(_onPostCommit);
  }

  Future<void> _onPostCommit(
      PostCommit event, Emitter<CommentState> emit) async {
    emit(CommentLoading());
    final result = await postCommentUsecase.postComment(event.commentModel);
    result.fold(
      (error) => emit(CommentError(error)),
      (data) => emit(CommentLoaded()),
    );
  }
}

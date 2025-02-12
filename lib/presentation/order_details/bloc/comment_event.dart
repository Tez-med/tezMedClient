part of 'comment_bloc.dart';

sealed class CommentEvent extends Equatable {
  const CommentEvent();

  @override
  List<Object> get props => [];
}

class PostCommit extends CommentEvent {
  final CommentModel commentModel;
  const PostCommit(this.commentModel);

  @override
  List<Object> get props => [commentModel];
}

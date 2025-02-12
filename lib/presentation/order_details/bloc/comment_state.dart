part of 'comment_bloc.dart';

sealed class CommentState extends Equatable {
  const CommentState();

  @override
  List<Object> get props => [];
}

final class CommentInitial extends CommentState {}

final class CommentLoading extends CommentState {}

final class CommentLoaded extends CommentState {}

final class CommentError extends CommentState {
  final Failure error;
  const CommentError(this.error);
  @override
  List<Object> get props => [error];
}

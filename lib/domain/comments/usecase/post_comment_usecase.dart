import 'package:tez_med_client/core/error/either.dart';
import 'package:tez_med_client/core/error/failure.dart';
import 'package:tez_med_client/data/comments/model/comment_model.dart';
import 'package:tez_med_client/domain/comments/repositories/comment_repositories.dart';

class PostCommentUsecase {
  final CommentRepositories commentRepositories;

  PostCommentUsecase(this.commentRepositories);

  Future<Either<Failure, void>> postComment(CommentModel commentModel) async {
    return await commentRepositories.postComment(commentModel);
  }
}

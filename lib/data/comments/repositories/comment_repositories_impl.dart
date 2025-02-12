import 'package:tez_med_client/core/error/either.dart';
import 'package:tez_med_client/core/error/failure.dart';
import 'package:tez_med_client/data/comments/model/comment_model.dart';
import 'package:tez_med_client/data/comments/source/comment_source.dart';
import 'package:tez_med_client/domain/comments/repositories/comment_repositories.dart';

class CommentRepositoriesImpl implements CommentRepositories {
  final CommentSource commentSource;

  CommentRepositoriesImpl(this.commentSource);
  @override
  Future<Either<Failure, void>> postComment(CommentModel commentModel) async {
    return await commentSource.postComment(commentModel);
  }
}

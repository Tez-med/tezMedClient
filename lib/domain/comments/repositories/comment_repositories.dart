import 'package:tez_med_client/core/error/either.dart';
import 'package:tez_med_client/core/error/failure.dart';
import 'package:tez_med_client/data/comments/model/comment_model.dart';

abstract class CommentRepositories {
  Future<Either<Failure, void>> postComment(CommentModel commentModel);
}

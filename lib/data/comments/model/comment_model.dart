import 'dart:convert';

CommentModel commentModelFromJson(String str) =>
    CommentModel.fromJson(json.decode(str));

String commentModelToJson(CommentModel data) => json.encode(data.toJson());

class CommentModel {
  final String comment;
  final int like;
  final String requestId;

  CommentModel({
    required this.comment,
    required this.like,
    required this.requestId,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) => CommentModel(
        comment: json["comment"],
        like: json["like"],
        requestId: json["request_id"],
      );

  Map<String, dynamic> toJson() => {
        "comment": comment,
        "like": like,
        "request_id": requestId,
      };
}

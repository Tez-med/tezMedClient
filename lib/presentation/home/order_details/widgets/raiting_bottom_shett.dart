import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tez_med_client/core/utils/app_color.dart';
import 'package:tez_med_client/core/utils/app_textstyle.dart';
import 'package:tez_med_client/core/widgets/custom_snackbar.dart';
import 'package:tez_med_client/data/comments/model/comment_model.dart';
import 'package:tez_med_client/gen/assets.gen.dart';
import 'package:tez_med_client/generated/l10n.dart';
import 'package:tez_med_client/presentation/home/order_details/bloc/comment_bloc.dart';

class RatingBottomSheet extends StatefulWidget {
  final String requestId;
  final CommentBloc commentBloc;

  const RatingBottomSheet({
    super.key,
    required this.requestId,
    required this.commentBloc,
  });

  @override
  State<RatingBottomSheet> createState() => _RatingBottomSheetState();
}

class _RatingBottomSheetState extends State<RatingBottomSheet> {
  final TextEditingController _commentController = TextEditingController();
  int _rating = 0;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _submitRating() {
    final commentModel = CommentModel(
      requestId: widget.requestId,
      comment: _commentController.text,
      like: _rating,
    );

    widget.commentBloc.add(PostCommit(commentModel));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CommentBloc, CommentState>(
      bloc: widget.commentBloc,
      listener: (context, state) {
        if (state is CommentLoaded) {
          Navigator.pop(context);
          AnimatedCustomSnackbar.show(
            context: context,
            message: S.of(context).raiting_succes,
            type: SnackbarType.success,
          );
        } else if (state is CommentError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error.code.toString())),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              S.of(context).leave_comment,
              style: AppTextstyle.nunitoBold.copyWith(fontSize: 24),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  onPressed: () => setState(() => _rating = index + 1),
                  icon: Assets.icons.star.svg(
                    colorFilter: ColorFilter.mode(
                      index < _rating ? Color(0xffFF9910) : Color(0xffE0E8F1),
                      BlendMode.srcIn,
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _commentController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: S.of(context).enter_text,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitRating,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  backgroundColor: AppColor.primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: BlocBuilder<CommentBloc, CommentState>(
                  bloc: widget.commentBloc,
                  builder: (context, state) {
                    if (state is CommentLoading) {
                      return const CircularProgressIndicator(
                          color: Colors.white);
                    }
                    return Text(
                      S.of(context).choose,
                      style: AppTextstyle.nunitoBold.copyWith(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:tez_med_client/core/utils/app_color.dart';
import 'package:tez_med_client/core/utils/app_textstyle.dart';
import 'package:tez_med_client/core/widgets/custom_cached_image.dart';
import 'package:tez_med_client/core/widgets/raiting_stars.dart';
import 'package:tez_med_client/data/requests_get/model/get_by_id_request_model.dart';
import 'package:tez_med_client/generated/l10n.dart';

class NurseDetails extends StatelessWidget {
  final GetByIdRequestModel requestss;
  final String nursePhoto;
  const NurseDetails(
      {super.key, required this.requestss, required this.nursePhoto});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
            child: Text(
              S.of(context).nurse_info,
              style: AppTextstyle.nunitoBold.copyWith(fontSize: 20),
            ),
          ),
          const Divider(
            color: AppColor.buttonBackColor,
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 25,
                  child: CustomCachedImage(
                    isProfile: true,
                    image: nursePhoto,
                    fit: BoxFit.cover,
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        requestss.nurseName,
                        style: AppTextstyle.nunitoBold.copyWith(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const PreciseRatingStars(rating: 5),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tez_med_client/core/routes/app_routes.gr.dart';
import 'package:tez_med_client/core/utils/app_color.dart';
import 'package:tez_med_client/core/utils/app_textstyle.dart';
import 'package:tez_med_client/core/widgets/custom_cached_image.dart';
import 'package:tez_med_client/core/widgets/raiting_stars.dart';
import 'package:tez_med_client/generated/l10n.dart';
import 'package:tez_med_client/presentation/history/widgets/video_call_button.dart';
import '../../../data/schedule/model/schedule_model.dart';

class DoctorCardWidget extends StatelessWidget {
  final Schedule data;

  DoctorCardWidget({super.key, required this.data});

  final format = NumberFormat("#,###");

  final _dateFormatter = DateFormat('dd MMMM');

  String _formatDate(String dateString) {
    try {
      DateTime date = DateFormat("yyyy/MM/dd").parse(dateString);
      return _dateFormatter.format(date);
    } catch (e) {
      return "Invalid date";
    }
  }

  Widget _buildInfoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextstyle.nunitoMedium.copyWith(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: AppColor.greyTextColor,
          ),
        ),
        Text(
          value,
          style: AppTextstyle.nunitoBold.copyWith(fontSize: 15),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 35,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: AppColor.greyTextColor,
      ),
    );
  }

  Widget _buildDoctorInfo() {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            radius: 25,
            child: CustomCachedImage(
              isProfile: true,
              image: data.doctorPhoto,
              fit: BoxFit.cover,
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppColor.greyTextColor),
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
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.doctorName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextstyle.nunitoBold.copyWith(fontSize: 18),
                ),
                PreciseRatingStars(
                  rating: double.parse(data.doctorRating.toString()),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.router.push(DoctorOrderDetailsRoute(id: data.id)),
      child: Card(
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildDoctorInfo(),
                  data.nurseTypeName == 'Uyga chaqirish'
                      ? Container(
                          padding: EdgeInsets.all(8),
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0x99FFFFFF),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(Icons.home,
                              color: AppColor.primaryColor, size: 22),
                        )
                      : VideoCallButton(
                          scheduleId: data.id,
                        )
                  // _buildStatusBadge(context),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildInfoItem(
                    S.of(context).day,
                    _formatDate(data.date),
                  ),
                  const SizedBox(width: 10),
                  _buildDivider(),
                  const SizedBox(width: 10),
                  _buildInfoItem(
                    S.of(context).time,
                    data.time,
                  ),
                  const SizedBox(width: 10),
                  _buildDivider(),
                  const SizedBox(width: 10),
                  _buildInfoItem(
                    S.of(context).price,
                    "${format.format(data.price)} ${S.of(context).sum}",
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

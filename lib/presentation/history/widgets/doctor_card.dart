import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tez_med_client/core/utils/app_color.dart';
import 'package:tez_med_client/core/utils/app_textstyle.dart';
import 'package:tez_med_client/core/widgets/custom_cached_image.dart';
import 'package:tez_med_client/core/widgets/raiting_stars.dart';
import 'package:tez_med_client/generated/l10n.dart';
import '../../../core/constant/parse_date_time.dart';
import '../../../data/schedule/model/schedule_model.dart';

class DoctorCardWidget extends StatelessWidget {
  final Schedule data;

  DoctorCardWidget({super.key, required this.data});

  final format = NumberFormat("#,###");
  final _dateFormatter = DateFormat('dd MMMM');

  String _formatDate(String dateString) {
    try {
      DateTime date = parseToDateTime(dateString);
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
          style: AppTextstyle.nunitoRegular.copyWith(
            fontSize: 15,
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

  // Widget _buildStatusBadge(BuildContext context) {
  //   Color statusColor;
  //   switch (data.status.toLowerCase()) {
  //     case 'booked':
  //       statusColor = Colors.blue;
  //       break;
  //     case 'completed':
  //       statusColor = Colors.green;
  //       break;
  //     case 'cancelled':
  //       statusColor = Colors.red;
  //       break;
  //     default:
  //       statusColor = Colors.grey;
  //   }

  //   return Container(
  //     padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
  //     decoration: BoxDecoration(
  //       color: statusColor.withValues(alpha: 0.1),
  //       borderRadius: BorderRadius.circular(12),
  //     ),
  //     child: Text(
  //       data.status,
  //       style: AppTextstyle.nunitoRegular.copyWith(
  //         color: statusColor,
  //         fontWeight: FontWeight.w600,
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Card(
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
    );
  }
}

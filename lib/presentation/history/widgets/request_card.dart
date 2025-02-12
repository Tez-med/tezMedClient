import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tez_med_client/core/constant/status.dart';
import 'package:tez_med_client/core/routes/app_routes.gr.dart';
import 'package:tez_med_client/core/utils/app_color.dart';
import 'package:tez_med_client/core/widgets/custom_cached_image.dart';
import 'package:tez_med_client/core/widgets/raiting_stars.dart';
import 'package:tez_med_client/data/requests_get/model/active_request_model.dart';
import 'package:tez_med_client/generated/l10n.dart';
import '../../../core/constant/parse_date_time.dart';
import '../../../core/utils/app_textstyle.dart';

class RequestCard extends StatelessWidget {
  final Requestss data;

  RequestCard({super.key, required this.data});

  final format = NumberFormat("#,###");
  final _dateFormatter = DateFormat('dd MMMM');
  final _timeFormatter = DateFormat('HH:mm');

  String _formatDate(String dateString) {
    try {
      DateTime date = parseToDateTime(dateString);
      return _dateFormatter.format(date);
    } catch (e) {
      return "Invalid date";
    }
  }

  String _formatTime(String dateString) {
    try {
      DateTime date = parseToDateTime(dateString);
      return _timeFormatter.format(date);
    } catch (e) {
      return "Invalid time";
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

  Widget _buildNurseInfo() {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            radius: 25,
            child: CustomCachedImage(
              isProfile: true,
              image: data.nursePhoto,
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
                  data.nurseName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextstyle.nunitoBold.copyWith(fontSize: 18),
                ),
                PreciseRatingStars(
                    rating: double.parse(data.nurseRating.toString())),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context) {
    final statusColor = StatusHelper.getBackgroundColor(data.status);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: .1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        StatusHelper.getName(data.status, context),
        style: AppTextstyle.nunitoRegular.copyWith(
          color: statusColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.router.push(
        OrderDetailsRoute(
          id: data.id,
          number: data.number.toString(),
          nursePhoto: data.nursePhoto,
        ),
      ),
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (data.nurseName.isEmpty)
                    Text(
                      "${S.of(context).order} №${data.number}",
                      style: AppTextstyle.nunitoBold.copyWith(
                        fontSize: 18,
                        color: Colors.black87,
                      ),
                    )
                  else
                    _buildNurseInfo(),
                  _buildStatusBadge(context),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildInfoItem(
                      S.of(context).day,
                      _formatDate(data
                          .requestAffairs.first.hour)), // Safe check for null
                  const SizedBox(width: 10),
                  _buildDivider(),
                  const SizedBox(width: 10),
                  _buildInfoItem(
                      S.of(context).time,
                      _formatTime(data
                          .requestAffairs.first.hour)), // Safe check for null
                  const SizedBox(width: 10),
                  _buildDivider(),
                  const SizedBox(width: 10),
                  _buildInfoItem(
                      S.of(context).price, "${format.format(data.price)} sum"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

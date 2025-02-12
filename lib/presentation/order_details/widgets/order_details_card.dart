import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tez_med_client/core/constant/parse_date_time.dart';
import 'package:tez_med_client/core/utils/app_color.dart';
import 'package:tez_med_client/core/utils/app_textstyle.dart';
import 'package:tez_med_client/data/requests_get/model/get_by_id_request_model.dart';
import 'package:tez_med_client/generated/l10n.dart';

class OrderDetailsCard extends StatelessWidget {
  const OrderDetailsCard({
    super.key,
    required this.requestss,
  });

  final GetByIdRequestModel requestss;

  @override
  Widget build(BuildContext context) {
    DateTime parsedDate = parseToDateTime(requestss.requestAffairs.first.hour);
    String formattedDate = DateFormat('HH:mm').format(parsedDate);

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
            padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
            child: Text(
              S.of(context).order_information,
              style: AppTextstyle.nunitoBold.copyWith(fontSize: 20),
            ),
          ),
          const Divider(
            color: AppColor.buttonBackColor,
            thickness: 1,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
            child: Column(
              children: [
                _orderDetailRow(
                    title: S.of(context).address, value: requestss.address),
                if (requestss.house.isNotEmpty) ...[
                  const Divider(
                    color: AppColor.buttonBackColor,
                    thickness: 0.5,
                  ),
                  _orderDetailRow(
                    title: S.of(context).house,
                    value: requestss.house,
                  ),
                ],
                if (requestss.floor.isNotEmpty) ...[
                  const Divider(
                    color: AppColor.buttonBackColor,
                    thickness: 0.5,
                  ),
                  _orderDetailRow(
                    title: S.of(context).floor,
                    value: requestss.floor,
                  ),
                ],
                if (requestss.apartment.isNotEmpty) ...[
                  const Divider(
                    color: AppColor.buttonBackColor,
                    thickness: 0.5,
                  ),
                  _orderDetailRow(
                    title: S.of(context).apartment,
                    value: requestss.apartment,
                  ),
                ],
                if (requestss.entrance.isNotEmpty) ...[
                  const Divider(
                    color: AppColor.buttonBackColor,
                    thickness: 0.5,
                  ),
                  _orderDetailRow(
                    title: S.of(context).entrance,
                    value: requestss.entrance,
                  ),
                ],
                if (requestss.comment.isNotEmpty) ...[
                  const Divider(
                    color: AppColor.buttonBackColor,
                    thickness: 0.5,
                  ),
                  _orderDetailRow(
                    title: S.of(context).comment,
                    value: requestss.comment,
                  ),
                ],
                if (requestss.accessCode.isNotEmpty) ...[
                  const Divider(
                    color: AppColor.buttonBackColor,
                    thickness: 0.5,
                  ),
                  _orderDetailRow(
                    title: S.of(context).access_code,
                    value: requestss.accessCode,
                  ),
                ],
                const Divider(
                  color: AppColor.buttonBackColor,
                  thickness: 0.5,
                ),
                _orderDetailRow(
                    title: S.of(context).start_time, value: formattedDate),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _orderDetailRow({
    required String title,
    required String value,
  }) {
    return Row(
      children: [
        Expanded(
          child: RichText(
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            text: TextSpan(
              children: [
                TextSpan(
                  text: "$title\n",
                  style: AppTextstyle.nunitoSemiBold
                      .copyWith(fontSize: 14, color: AppColor.greyColor500),
                ),
                TextSpan(
                  text: value,
                  style: AppTextstyle.nunitoRegular.copyWith(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:tez_med_client/core/constant/parse_date_time.dart';
import 'package:tez_med_client/core/constant/status.dart';
import 'package:tez_med_client/core/utils/app_color.dart';
import 'package:tez_med_client/core/utils/app_textstyle.dart';
import 'package:tez_med_client/data/requests_get/model/get_by_id_request_model.dart';
import 'package:tez_med_client/generated/l10n.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../gen/assets.gen.dart';

class StatusCard extends StatelessWidget {
  const StatusCard({
    super.key,
    required this.requestss,
    required this.isFinished,
  });

  final GetByIdRequestModel requestss;
  final bool isFinished;

  bool _isActiveStatus(String currentStatus, String checkStatus) {
    final statusOrder = [
      "new",
      "connecting",
      "approved",
      "not_online",
      "attached",
      "ontheway",
      "came",
      "in_process",
      "finished"
    ];
    if (isFinished) return true;

    if (requestss.status == "nurse_canceled" ||
        requestss.status == "not_pickup" ||
        requestss.status == 'new' ||
        requestss.status == "not_online") {
      return checkStatus == "connecting";
    }

    final currentIndex = statusOrder.indexOf(requestss.status);
    final checkIndex = statusOrder.indexOf(checkStatus);

    if (currentIndex == -1 || checkIndex == -1) return false;

    return checkIndex <= currentIndex;
  }

  @override
  Widget build(BuildContext context) {
    DateTime parsedDate = parseToDateTime(requestss.requestAffairs.first.hour);
    String formattedDate = DateFormat('dd.MM.yyyy | HH:mm').format(parsedDate);

    return Card(
      elevation: 0,
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  S.of(context).order,
                  style: AppTextstyle.nunitoBold.copyWith(
                    fontSize: 20,
                  ),
                ),
                Text(
                  formattedDate,
                  style: AppTextstyle.nunitoRegular
                      .copyWith(color: AppColor.greyColor500),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                Expanded(
                    child: _statusAvatar(Assets.icons.connecting.path,
                        _isActiveStatus("attached", "connecting"))),
                _statusConnector(_isActiveStatus("attached", "attached")),
                Expanded(
                    child: _statusAvatar(Assets.icons.attached.path,
                        _isActiveStatus("attached", "attached"))),
                _statusConnector(_isActiveStatus("ontheway", "ontheway")),
                Expanded(
                    child: _statusAvatar(Assets.icons.ontheway.path,
                        _isActiveStatus("ontheway", "ontheway"))),
                _statusConnector(_isActiveStatus("came", "came")),
                Expanded(
                    child: _statusAvatar(Assets.icons.came.path,
                        _isActiveStatus("came", "came"))),
                _statusConnector(_isActiveStatus("finished", "finished")),
                Expanded(
                    child: _statusAvatar(Assets.icons.finished.path,
                        _isActiveStatus("finished", "finished"))),
              ],
            ),
          ),
          Text(
            StatusHelper.getName(requestss.status, context),
            style: AppTextstyle.nunitoRegular.copyWith(
              fontSize: 18,
              color: AppColor.greyColor500,
              fontWeight: FontWeight.bold,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Divider(
              color: AppColor.buttonBackColor,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () async {
                await launchUrl(Uri(scheme: 'tel', path: '+998555140003'));
              },
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: AppColor.buttonBackColor,
                fixedSize: const Size(double.maxFinite, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Assets.icons.call.svg(),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      S.of(context).call_help_center,
                      textAlign: TextAlign.center,
                      style: AppTextstyle.nunitoBold
                          .copyWith(color: Colors.black, fontSize: 15),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _statusAvatar(String image, bool isActive) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: CircleAvatar(
        radius: 33,
        backgroundColor:
            isActive ? AppColor.primaryColor : AppColor.buttonBackColor,
        child: SvgPicture.asset(
          image,
          colorFilter: ColorFilter.mode(
            isActive ? Colors.white : Colors.black,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }

  Widget _statusConnector(bool isActive) {
    return Container(
      width: 15,
      height: 5,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: isActive ? AppColor.primaryColor : Color(0xffD9D9D9),
      ),
    );
  }
}

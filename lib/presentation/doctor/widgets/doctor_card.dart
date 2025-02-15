import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tez_med_client/core/utils/app_color.dart';
import 'package:tez_med_client/core/widgets/custom_cached_image.dart';
import 'package:tez_med_client/data/doctor/model/doctor_model.dart';
import 'package:tez_med_client/generated/l10n.dart';

import 'doctor_details_shett.dart';

class DoctorCard extends StatelessWidget {
  final String type;
  final String typeDoctor;
  final bool online;
  final Doctor doc;

  const DoctorCard(
      {super.key,
      required this.doc,
      required this.type,
      required this.online,
      required this.typeDoctor});

  @override
  Widget build(BuildContext context) {
    final format = NumberFormat("#,###");
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Card(
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: CustomCachedImage(
                      image: doc.photo,
                      isProfile: false,
                      imageBuilder: (context, imageProvider) {
                        return Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                      width: 50,
                      height: 50,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          doc.fullName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1D2D50),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${S.of(context).experience}: ${doc.experience} ${S.of(context).year}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColor.greyTextColor,
                          ),
                        ),
                        Text(
                          "${S.of(context).price}: ${format.format(doc.consultationPrice)} ${S.of(context).sum}",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColor.greyTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  showCupertinoModalPopup(
                    context: context,
                    barrierColor: Colors.black87,
                    builder: (context) => Container(
                      decoration: BoxDecoration(
                        color: CupertinoColors.systemBackground
                            .resolveFrom(context),
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(25)),
                      ),
                      child: DraggableScrollableSheet(
                        initialChildSize: 0.9,
                        minChildSize: 0.6,
                        maxChildSize: 1,
                        expand: false,
                        builder: (context, scrollController) {
                          return DoctorDetailSheet(
                            price: doc.consultationPrice.toString(),
                            online: online,
                            type: typeDoctor,
                            id: doc.id,
                            controller: scrollController,
                          );
                        },
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primaryColor,
                  foregroundColor: Colors.white,
                  fixedSize: Size(double.maxFinite, 45),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                child: Text(
                  S.of(context).consultation,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

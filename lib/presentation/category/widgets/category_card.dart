import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:tez_med_client/core/extension/localization_extension.dart';
import 'package:tez_med_client/core/routes/app_routes.gr.dart';
import 'package:tez_med_client/core/widgets/custom_cached_image.dart';
import 'package:tez_med_client/data/species/model/species_model.dart';
import 'package:tez_med_client/generated/l10n.dart';

import '../../../core/utils/app_textstyle.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    super.key,
    required this.speciess,
  });

  final Speciess speciess;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (speciess.isActive) {
          if (speciess.type == 'nurse') {
            context.router.push(LocationDetails(
              title: context.toLocalized(
                uz: speciess.nameUz,
                ru: speciess.nameRu,
                en: speciess.nameEn,
              ),
              id: speciess.id,
            ));
          } else if (speciess.type == 'doctor') {
            context.router.push(CategoryRouteDoctor(
              title: context.toLocalized(
                uz: speciess.nameUz,
                ru: speciess.nameRu,
                en: speciess.nameEn,
              ),
              id: speciess.id,
            ));
          }
        }
      },
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: Colors.white,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: CustomCachedImage(
                      image: speciess.photo,
                      width: 100,
                      height: 91,
                      fit: BoxFit.cover,
                    ),
                  ),
                  if (!speciess.isActive)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Text(
                            S.of(context).added_soon,
                            style: AppTextstyle.nunitoBold.copyWith(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      context.toLocalized(
                          uz: speciess.nameUz,
                          ru: speciess.nameRu,
                          en: speciess.nameEn),
                      style: AppTextstyle.nunitoBold.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 20.0,
                        color: Color(0xff1D2D50),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      context.toLocalized(
                          uz: speciess.descriptionUz,
                          ru: speciess.descriptionRu,
                          en: speciess.descriptionEn),
                      style: AppTextstyle.nunitoMedium.copyWith(
                        fontWeight: FontWeight.w400,
                        fontSize: 14.0,
                        color: Color(0xff737F91),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

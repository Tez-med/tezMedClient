import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tez_med_client/core/bloc/language/language_bloc.dart';
import 'package:tez_med_client/core/routes/app_routes.gr.dart';
import 'package:tez_med_client/core/widgets/custom_cached_image.dart';
import 'package:tez_med_client/data/species/model/species_model.dart';
import 'package:tez_med_client/generated/l10n.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    super.key,
    required this.speciess,
  });

  final Speciess speciess;

  @override
  Widget build(BuildContext context) {
    final lang = context.read<LanguageBloc>().state.locale.languageCode;

    String getLocalizedName() {
      switch (lang) {
        case "uz":
          return speciess.nameUz;
        case "en":
          return speciess.nameEn;
        default:
          return speciess.nameRu;
      }
    }

    String getLocalizedDescription() {
      switch (lang) {
        case "uz":
          return speciess.descriptionUz;
        case "en":
          return speciess.descriptionEn;
        default:
          return speciess.descriptionRu;
      }
    }

    return GestureDetector(
      onTap: speciess.isActive
          ? () {
              context.router.push(CategoryRoute(
                title: getLocalizedName(),
                id: speciess.id,
              ));
            }
          : null,
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
                            style: TextStyle(
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
                      getLocalizedName(),
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20.0,
                        height: 24.2 / 20.0,
                        color: Color(0xff1D2D50),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      getLocalizedDescription(),
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14.0,
                        height: 16.94 / 14.0,
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

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tez_med_client/core/extension/localization_extension.dart';
import 'package:tez_med_client/core/routes/app_routes.gr.dart';
import 'package:tez_med_client/core/utils/app_color.dart';
import 'package:tez_med_client/core/widgets/custom_cached_image.dart';
import 'package:tez_med_client/data/clinic/model/clinics_model.dart';
import 'package:tez_med_client/presentation/clinic/bloc/clinic_bloc.dart';

class ClinicsLoadedView extends StatelessWidget {
  final ClinicsModel clinicsModel;

  const ClinicsLoadedView({
    Key? key,
    required this.clinicsModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context
            .read<ClinicBloc>()
            .add(const GetClinicsEvent(forceRefresh: true));
        // Yangilash tugaguncha kutish
        return Future.delayed(const Duration(milliseconds: 1000));
      },
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 16),
        itemCount: clinicsModel.clinics.length,
        itemBuilder: (context, index) {
          final clinic = clinicsModel.clinics[index];
          return _ClinicCard(clinic: clinic);
        },
      ),
    );
  }
}

class _ClinicCard extends StatelessWidget {
  final Clinic clinic;

  const _ClinicCard({
    Key? key,
    required this.clinic,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: () {
          context.router.push(ClinicDetailsRoute(clinicId: clinic.id));
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.only(left: 8, top: 8, bottom: 8, right: 4),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    width: 75,
                    height: 75,
                    child: _buildClinicImage(clinic.photo),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.toLocalized(
                            uz: clinic.nameUz,
                            ru: clinic.nameRu,
                            en: clinic.nameEn),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColor.primaryDark,
                        ),
                      ),
                      Text(
                        clinic.address,
                        maxLines: 2,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColor.greyTextColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildClinicImage(List<String> photos) {
    if (photos.isNotEmpty && photos[0].isNotEmpty) {
      return CustomCachedImage(
        image: photos[0],
      );
    } else {
      return Container(
        color: Colors.grey[200],
        child: const Icon(Icons.local_hospital, color: Colors.grey),
      );
    }
  }
}
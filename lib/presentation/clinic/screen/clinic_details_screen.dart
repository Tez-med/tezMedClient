import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tez_med_client/core/widgets/error_display_widget.dart';
import 'package:tez_med_client/data/clinic/model/clinics_model.dart';
import 'package:tez_med_client/presentation/clinic/bloc/clinic_bloc.dart';
import 'package:tez_med_client/presentation/clinic/widgets/clinic_detail_view.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

@RoutePage()
class ClinicDetailsScreen extends StatefulWidget {
  final String clinicId;

  const ClinicDetailsScreen({
    super.key,
    required this.clinicId,
  });

  @override
  State<ClinicDetailsScreen> createState() => _ClinicDetailsScreenState();
}

class _ClinicDetailsScreenState extends State<ClinicDetailsScreen> {
  bool isDescriptionExpanded = false;
  YandexMapController? mapController;
  @override
  void initState() {
    super.initState();
    // InitState da ma'lumotlarni so'rash
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ClinicBloc>().add(GetFullClinicsEvent(widget.clinicId));
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClinicBloc, ClinicState>(
      buildWhen: (previous, current) {
        return current is ClinicFullLoading ||
            current is ClinicFullLoaded ||
            current is ClinicFullError;
      },
      builder: (context, state) {
        if (state is ClinicFullLoading) {
          return Skeletonizer(
              child: ClinicDetailView(
                  clinic: Clinic(
                      id: "",
                      districtId: "",
                      regionId: "",
                      countryId: "",
                      nameUz: "",
                      nameRu: "",
                      nameEn: "",
                      longitude: "69.255",
                      latitude: "41.255",
                      description: "",
                      phoneNumber: [],
                      address: "",
                      photo: [],
                      instagramLink: "",
                      tgLink: "",
                      rating: 0,
                      hours: [],
                      amenities: []),
                  mapController: mapController,
                  onMapCreated: _onMapCreated));
        } else if (state is ClinicFullLoaded) {
          return ClinicDetailView(
            clinic: state.clinic,
            mapController: mapController,
            onMapCreated: _onMapCreated,
          );
        } else if (state is ClinicFullError) {
          return ErrorDisplayWidget(
            errorCode: state.message.code,
            onRetry: () => context
                .read<ClinicBloc>()
                .add(GetFullClinicsEvent(widget.clinicId)),
          );
        }

        return const SizedBox();
      },
    );
  }

 

  void _onMapCreated(YandexMapController controller) {
    mapController = controller;
    
  }
}



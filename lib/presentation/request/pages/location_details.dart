import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:tez_med_client/core/routes/app_routes.gr.dart';
import 'package:tez_med_client/data/request_post/model/request_model.dart';
import 'package:tez_med_client/domain/dio_client/repository/dio_client_repository.dart';
import 'package:tez_med_client/generated/l10n.dart';
import 'package:tez_med_client/injection.dart';
import 'package:tez_med_client/presentation/auth/widgets/button_widget.dart';
import 'package:tez_med_client/presentation/request/widgets/location_widget.dart';

@RoutePage()
class LocationDetails extends StatefulWidget {
  final String title;
  final String id;

  const LocationDetails({
    super.key,
    required this.title,
    required this.id,
  });

  @override
  State<LocationDetails> createState() => _LocationDetailsState();
}

class _LocationDetailsState extends State<LocationDetails> {
  final TextEditingController addressController = TextEditingController();
  final TextEditingController entranceController = TextEditingController();
  final TextEditingController floorController = TextEditingController();
  final TextEditingController apartmentController = TextEditingController();
  final TextEditingController houseController = TextEditingController();
  final TextEditingController landmarkController = TextEditingController();
  final TextEditingController latController = TextEditingController();
  final TextEditingController longController = TextEditingController();
  final TextEditingController accessCodeController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  String? currentTime;
  bool timeEmpty = false;
  final formKey = GlobalKey<FormState>();
  int? discountAmount;
  String? promocodeKey;
  bool isPercentage = false;

  @override
  void dispose() {
    addressController.dispose();
    entranceController.dispose();
    floorController.dispose();
    apartmentController.dispose();
    houseController.dispose();
    landmarkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.router.maybePop(),
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
          ),
        ),
        title: Text(
          S.of(context).address,
        ),
      ),
      body: Stack(
        children: [
          Form(
            key: formKey,
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: Colors.white,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: LocationWidget(
                          addressController: addressController,
                          entranceController: entranceController,
                          floorController: floorController,
                          apartmentController: apartmentController,
                          houseController: houseController,
                          landmarkController: landmarkController,
                          latController: latController,
                          longController: longController,
                          accessCodeController: accessCodeController,
                          formKey: formKey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: ButtonWidget(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                final data = RequestModel(
                  price: 0,
                  singleRequest: true,
                  promocodeKey: "",
                  nurseTypeId: "",
                  accessCode: accessCodeController.text,
                  address: addressController.text,
                  apartment: apartmentController.text,
                  clientId: "",
                  comment: landmarkController.text,
                  createdAt: DateTime.now().toString(),
                  entrance: entranceController.text,
                  floor: floorController.text,
                  clientBody: ClientBody(extraPhone: ""),
                  house: houseController.text,
                  latitude: latController.text,
                  longitude: longController.text,
                  photos: [],
                  requestAffairs: [],
                );
                getIt<DioClientRepository>()
                    .getData(
                        "/region/nearest?lat=${latController.text}&long=${longController.text}")
                    .then((value) {
                  context.router.push(
                    CategoryRouteNurse(
                        district: value.data['district_id'],
                        id: widget.id,
                        title: widget.title,
                        requestModel: data),
                  );
                });
              }
            },
            consent: true,
            isLoading: false),
      ),
    );
  }
}

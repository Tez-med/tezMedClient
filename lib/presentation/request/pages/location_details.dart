import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tez_med_client/core/constant/storage_keys.dart';
import 'package:tez_med_client/core/error/error_handler.dart';
import 'package:tez_med_client/core/routes/app_routes.gr.dart';
import 'package:tez_med_client/core/utils/app_color.dart';
import 'package:tez_med_client/core/utils/app_textstyle.dart';
import 'package:tez_med_client/core/widgets/custom_snackbar.dart';
import 'package:tez_med_client/data/local_storage/local_storage_service.dart';
import 'package:tez_med_client/data/request_post/model/request_model.dart';
import 'package:tez_med_client/data/requests_get/model/active_request_model.dart';
import 'package:tez_med_client/generated/l10n.dart';
import 'package:tez_med_client/presentation/request/pages/promocode.dart';
import 'package:tez_med_client/presentation/request/bloc/request/request_bloc.dart';
import 'package:tez_med_client/presentation/request/widgets/check_widget.dart';
import 'package:tez_med_client/presentation/request/widgets/custom_loading_succes.dart';
import 'package:tez_med_client/presentation/request/widgets/time_widget.dart';
import 'package:tez_med_client/presentation/request/widgets/location_widget.dart';
import 'package:tez_med_client/presentation/request/widgets/payment_widget.dart';

@RoutePage()
class LocationDetails extends StatefulWidget {
  final List<RequestAffairGet> requestAffair;
  final List<String> photo;
  final int price;
  final String extraPhone;

  const LocationDetails({
    super.key,
    required this.requestAffair,
    required this.photo,
    required this.extraPhone,
    required this.price,
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

  void _handlePromocode(int amount, bool isPercent) {
    setState(() {
      discountAmount = amount;
      isPercentage = isPercent;
    });
  }

  void _scrollToFirstInvalidField() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0.0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _scrollToCenter() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        final maxScroll = _scrollController.position.maxScrollExtent;
        final centerPosition = maxScroll / 2.5;

        _scrollController.animateTo(
          centerPosition,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

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
      backgroundColor: AppColor.buttonBackColor,
      appBar: AppBar(
        elevation: 1,
        shadowColor: AppColor.buttonBackColor,
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => context.router.maybePop(),
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
          ),
        ),
        centerTitle: true,
        title: Text(
          S.of(context).address,
          style: AppTextstyle.nunitoBold.copyWith(
            color: Colors.black,
            fontSize: 22,
          ),
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
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: timeEmpty ? Colors.red : Colors.white,
                        ),
                      ),
                      child: DeliveryTimeWidget(
                        onTimeSelected: (DateTime selectedTime) {
                          setState(() {
                            timeEmpty = false;
                            currentTime = selectedTime.toString();
                          });
                        },
                      ),
                    ),
                    Promocode(
                      onPromocodeApplied: (amount, isPercent, promocodeKeys) {
                        setState(() {
                          promocodeKey = promocodeKeys;
                        });
                        _handlePromocode(amount, isPercent);
                      },
                    ),
                    const SizedBox(height: 10),
                    const PaymentWidget(),
                    const SizedBox(height: 10),
                    CheckWidget(
                      servicePrice: widget.price,
                      requestAffairs: widget.requestAffair,
                      discountAmount: discountAmount != null
                          ? double.parse(discountAmount.toString())
                          : 0.0,
                      isPercentage: isPercentage,
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: BlocListener<RequestBloc, RequestState>(
              listener: (context, state) {
                if (state is RequestLoaded || state is RequestLoading) {
                  if (state is RequestLoaded) {
                    context.router.maybePop();
                  }
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => UnifiedLoadingAnimation(
                      isSuccess: state is RequestLoaded,
                      theme: const LoadingDialogTheme(
                        primaryColor: Colors.blue,
                        backgroundColor: Colors.white,
                      ),
                      text: LoadingDialogText(
                        loadingTitle: S.of(context).loading,
                        loadingSubtitle: S.of(context).please_wait,
                        successTitle: S.of(context).successful,
                        successSubtitle:
                            S.of(context).order_successfully_created,
                      ),
                      onComplete: () {
                        context.router.replaceAll([HomeRoute()]);
                      },
                    ),
                  );
                } else if (state is RequestError) {
                  ErrorHandler.showError(context, state.error.code);
                  context.maybePop();
                }
              },
              child: BottomAppBar(
                color: Colors.transparent,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primaryColor,
                    elevation: 0,
                    fixedSize: const Size(double.maxFinite, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    if (!formKey.currentState!.validate()) {
                      _scrollToFirstInvalidField();
                      return;
                    }

                    // Address validation
                    if (addressController.text.isEmpty) {
                      return AnimatedCustomSnackbar.show(
                        context: context,
                        message: S.of(context).please_select_address,
                        type: SnackbarType.warning,
                      );
                    }

                    // Time validation
                    if (currentTime == null) {
                      setState(() {
                        timeEmpty = true;
                      });
                      _scrollToCenter();
                      return;
                    }

                    final clientId =
                        LocalStorageService().getString(StorageKeys.userId);

                    // Transform request affairs
                    final updatedRequestAffairs =
                        widget.requestAffair.map((affair) {
                      return affair.copyWith(startDate: currentTime!);
                    }).toList();

                    final updatedRequestAffairsPost =
                        updatedRequestAffairs.map((affairGet) {
                      return RequestAffairPost(
                        affairId: affairGet.affairId,
                        count: affairGet.count,
                        day: 1,
                        startDate: affairGet.startDate,
                      );
                    }).toList();

                    // Create request model
                    final data = RequestModel(
                      price: 0,
                      singleRequest: true,
                      promocodeKey: promocodeKey?.trim() ?? "",
                      nurseTypeId: widget.requestAffair.first.typeModel.id,
                      accessCode: accessCodeController.text,
                      address: addressController.text,
                      apartment: apartmentController.text,
                      clientId: clientId,
                      comment: landmarkController.text,
                      createdAt: DateTime.now().toString(),
                      entrance: entranceController.text,
                      floor: floorController.text,
                      clientBody: ClientBody(
                        extraPhone: widget.extraPhone == '+998'
                            ? ''
                            : widget.extraPhone,
                      ),
                      house: houseController.text,
                      latitude: latController.text,
                      longitude: longController.text,
                      photos: widget.photo,
                      requestAffairs: updatedRequestAffairsPost,
                    );

                    // Submit request
                    context.read<RequestBloc>().add(PostRequest(data));
                  },
                  child: Text(
                    S.of(context).confirm,
                    style: AppTextstyle.nunitoBold.copyWith(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

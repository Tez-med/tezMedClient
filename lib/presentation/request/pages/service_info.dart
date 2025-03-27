import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tez_med_client/core/constant/storage_keys.dart';
import 'package:tez_med_client/core/error/error_handler.dart';
import 'package:tez_med_client/core/routes/app_routes.gr.dart';
import 'package:tez_med_client/core/utils/app_color.dart';
import 'package:tez_med_client/core/utils/app_textstyle.dart';
import 'package:tez_med_client/data/category/model/category_model.dart';
import 'package:tez_med_client/data/local_storage/local_storage_service.dart';
import 'package:tez_med_client/data/request_post/model/request_model.dart';
import 'package:tez_med_client/data/requests_get/model/active_request_model.dart';
import 'package:tez_med_client/generated/l10n.dart';
import 'package:tez_med_client/presentation/request/pages/promocode.dart';
import 'package:tez_med_client/presentation/request/bloc/request/request_bloc.dart';
import 'package:tez_med_client/presentation/request/widgets/check_widget.dart';
import 'package:tez_med_client/presentation/request/widgets/custom_loading_succes.dart';
import 'package:tez_med_client/presentation/request/widgets/time_widget.dart';
import 'package:tez_med_client/presentation/request/widgets/payment_widget.dart';

@RoutePage()
class ServiceInfo extends StatefulWidget {
  final RequestModel requestModel;
  final int price;

  const ServiceInfo({
    super.key,
    required this.requestModel,
    required this.price,
  });

  @override
  State<ServiceInfo> createState() => _ServiceInfoState();
}

class _ServiceInfoState extends State<ServiceInfo> {
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
          S.of(context).order_details,
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
                      requestAffairs:
                          widget.requestModel.requestAffairs.map((affairGet) {
                        return RequestAffairGet(
                          nameUz: affairGet.nameUz,
                          nameEn: affairGet.nameEn,
                          nameRu: affairGet.nameRu,
                          createdAt: "",
                          hour: "",
                          price: affairGet.price,
                          typeModel: TypeModel(
                              id: "",
                              nameUz: "",
                              nameEn: "",
                              nameRu: "",
                              price: 0),
                          affairId: affairGet.affairId,
                          count: affairGet.count,
                          startDate: affairGet.startDate,
                        );
                      }).toList(),
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

                    // Time validation
                    if (currentTime == null) {
                      setState(() {
                        timeEmpty = true;
                      });
                      return;
                    }

                    final clientId =
                        LocalStorageService().getString(StorageKeys.userId);

                    final result = widget.requestModel.copyWith(
                      createdAt: DateTime.now().toString(),
                      promocodeKey: promocodeKey?.trim() ?? "",
                      clientId: clientId,
                      requestAffairs: widget.requestModel.requestAffairs
                          .map((affair) =>
                              affair.copyWith(startDate: currentTime))
                          .toList(),
                      clientBody: ClientBody(
                        extraPhone:
                            widget.requestModel.clientBody.extraPhone == '+998'
                                ? ''
                                : widget.requestModel.clientBody.extraPhone,
                      ),
                    );

                    // Submit request
                    context.read<RequestBloc>().add(PostRequest(result));
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

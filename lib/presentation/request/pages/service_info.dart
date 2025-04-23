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

class _ServiceInfoState extends State<ServiceInfo>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final _formKey = GlobalKey<FormState>();

  String? _currentTime;
  String? _promocodeKey;
  int? _discountAmount;
  bool _isPercentage = false;
  bool _timeEmpty = false;
  bool _isSubmitting = false;

  // Animation controller for the submit button
  late final AnimationController _buttonController;
  late final Animation<double> _buttonScaleAnimation;

  @override
  void initState() {
    super.initState();

    // Setup animations
    _buttonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _buttonScaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _buttonController.dispose();
    super.dispose();
  }

  void _handlePromocode(int amount, bool isPercent, String? code) {
    setState(() {
      _discountAmount = amount;
      _isPercentage = isPercent;
      _promocodeKey = code;
    });
  }

  void _scrollToTop() {
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

  void _submitRequest() {
    if (!_formKey.currentState!.validate()) {
      _scrollToTop();
      return;
    }

    // Time validation
    if (_currentTime == null) {
      setState(() {
        _timeEmpty = true;
      });
      _scrollToTop();
      return;
    }

    // Prevent multiple submissions
    if (_isSubmitting) return;

    setState(() {
      _isSubmitting = true;
    });

    // Prepare request data
    final clientId = LocalStorageService().getString(StorageKeys.userId);

    final result = widget.requestModel.copyWith(
      createdAt: DateTime.now().toString(),
      promocodeKey: _promocodeKey?.trim() ?? "",
      clientId: clientId,
      requestAffairs: widget.requestModel.requestAffairs
          .map((affair) => affair.copyWith(startDate: _currentTime))
          .toList(),
      clientBody: ClientBody(
        extraPhone: widget.requestModel.clientBody.extraPhone == '+998'
            ? ''
            : widget.requestModel.clientBody.extraPhone,
      ),
    );

    // Submit request
    context.read<RequestBloc>().add(PostRequest(result));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.router.maybePop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        centerTitle: true,
        title: Text(S.of(context).order_details),
        elevation: 0,
      ),
      body: BlocListener<RequestBloc, RequestState>(
        listener: (context, state) {
          if (state is RequestLoading) {
            _showLoadingDialog();
          } else if (state is RequestLoaded) {
            Navigator.of(context).pop(); // Close loading dialog if open
            _showSuccessDialog();
          } else if (state is RequestError) {
            Navigator.of(context).pop(); // Close loading dialog if open
            ErrorHandler.showError(context, state.error.code);
            setState(() {
              _isSubmitting = false;
            });
          }
        },
        child: Stack(
          children: [
            _buildForm(),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTimeSelection(),
              const SizedBox(height: 15),

              Promocode(
                onPromocodeApplied: (amount, isPercent, promocodeKeys) {
                  _handlePromocode(amount, isPercent, promocodeKeys);
                },
              ),
              const SizedBox(height: 15),

              const PaymentWidget(),
              const SizedBox(height: 15),

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
                        id: "", nameUz: "", nameEn: "", nameRu: "", price: 0),
                    affairId: affairGet.affairId,
                    count: affairGet.count,
                    startDate: affairGet.startDate,
                  );
                }).toList(),
                discountAmount: _discountAmount != null
                    ? double.parse(_discountAmount.toString())
                    : 0.0,
                isPercentage: _isPercentage,
              ),

              // Extra space at bottom to prevent content from being hidden by the button
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeSelection() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: _timeEmpty ? Colors.red : Colors.transparent,
          width: _timeEmpty ? 1.5 : 0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DeliveryTimeWidget(
            onTimeSelected: (DateTime selectedTime) {
              setState(() {
                _timeEmpty = false;
                _currentTime = selectedTime.toString();
              });
            },
          ),
          if (_timeEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 16, bottom: 8),
              child: Text(
                S.of(context).please_select_time,
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: AnimatedBuilder(
          animation: _buttonController,
          builder: (context, child) {
            return Transform.scale(
              scale: _buttonScaleAnimation.value,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primaryColor,
                  elevation: 2,
                  fixedSize: const Size(double.maxFinite, 54),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _isSubmitting
                    ? null
                    : () {
                        _buttonController.forward().then((_) {
                          _buttonController.reverse();
                        });
                        _submitRequest();
                      },
                child: Text(
                  S.of(context).confirm,
                  style: AppTextstyle.nunitoBold.copyWith(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => UnifiedLoadingAnimation(
        isSuccess: false,
        theme: const LoadingDialogTheme(
          primaryColor: Colors.blue,
          backgroundColor: Colors.white,
        ),
        text: LoadingDialogText(
          loadingTitle: S.of(context).loading,
          loadingSubtitle: S.of(context).please_wait,
          successTitle: S.of(context).successful,
          successSubtitle: S.of(context).order_successfully_created,
        ),
        onComplete: () {},
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => UnifiedLoadingAnimation(
        isSuccess: true,
        theme: const LoadingDialogTheme(
          primaryColor: Colors.blue,
          backgroundColor: Colors.white,
        ),
        text: LoadingDialogText(
          loadingTitle: S.of(context).loading,
          loadingSubtitle: S.of(context).please_wait,
          successTitle: S.of(context).successful,
          successSubtitle: S.of(context).order_successfully_created,
        ),
        onComplete: () {
          context.router.replaceAll([HomeRoute()]);
        },
      ),
    );
  }
}

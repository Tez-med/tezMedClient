import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:tez_med_client/core/constant/storage_keys.dart';
import 'package:tez_med_client/core/routes/app_routes.gr.dart';
import 'package:tez_med_client/core/utils/app_color.dart';
import 'package:tez_med_client/core/utils/app_textstyle.dart';
import 'package:tez_med_client/core/utils/pin_put_theme.dart';
import 'package:tez_med_client/core/widgets/custom_snackbar.dart';
import 'package:tez_med_client/data/local_storage/local_storage_service.dart';
import 'package:tez_med_client/data/profile_update/model/profile_update_model.dart';
import 'package:tez_med_client/domain/notification/repositories/notification_repository.dart';
import 'package:tez_med_client/generated/l10n.dart';
import 'package:tez_med_client/injection.dart';
import 'package:tez_med_client/presentation/auth/widgets/button_widget.dart';
import 'package:tez_med_client/presentation/auth/widgets/resend_button.dart';
import 'package:tez_med_client/presentation/profile/bloc/profile_update/profile_update_bloc.dart';

import '../../../core/error/error_handler.dart';
import '../bloc/verify_user/verify_otp_bloc.dart';

@RoutePage()
class SmsVerifyScreen extends StatefulWidget {
  final String phoneNumber;

  const SmsVerifyScreen({super.key, required this.phoneNumber});

  @override
  State<SmsVerifyScreen> createState() => _SmsVerifyScreenState();
}

class _SmsVerifyScreenState extends State<SmsVerifyScreen> with CodeAutoFill {
  final TextEditingController _pinController = TextEditingController();
  final FocusNode _smsFocusNode = FocusNode();
  bool _isPinComplete = false;
  Timer? _autoVerificationTimer;
  String? appSignature;
  bool isVerifying = false;

  @override
  void initState() {
    super.initState();
    _smsFocusNode.requestFocus();
    _getAppSignature();
    listenForCode();
  }

  @override
  void dispose() {
    _pinController.dispose();
    _smsFocusNode.dispose();
    _autoVerificationTimer?.cancel();
    cancel();
    super.dispose();
  }

  Future<void> _getAppSignature() async {
    appSignature = await SmsAutoFill().getAppSignature;
  }

  @override
  void codeUpdated() {
    if (!isVerifying && code != null && code!.length == 4) {
      setState(() {
        _pinController.text = code!;
        _isPinComplete = true;
      });
      if (_isPinComplete) {
        FocusScope.of(context).unfocus();
        _verifyCode();
      }
    }
  }

  void _onPinChanged(String pin) {
    setState(() {
      _isPinComplete = pin.length == 4;
    });
    if (_isPinComplete) {
      _verifyCode();
    }
  }

  void _verifyCode() {
    if (isVerifying) return;
    setState(() {
      isVerifying = true;
    });

    FocusScope.of(context).unfocus();
    context.read<VerifyOtpBloc>().add(
          VerifyCodeEvent(
              _pinController.text, formatPhoneNumber(widget.phoneNumber)),
        );
  }

  void _clearPinAndShowKeyboard() {
    _pinController.clear();
    setState(() {
      _isPinComplete = false;
      isVerifying = false;
    });
    _smsFocusNode.requestFocus();

    listenForCode();
  }

  Future<void> _handleSuccessfulVerification() async {
    await LocalStorageService().setBool(StorageKeys.isRegister, true);
    if (!mounted) return;
    final token = await getIt<NotificationRepository>().getFcmToken();
    context.read<ProfileUpdateBloc>().add(ProfileUpdate(ProfileUpdateModel(
        birthday: "",
        fullName: "",
        gender: "",
        latitude: "",
        longitude: "",
        phoneNumber: "",
        photo: "",
        fcmToken: token!,
        updatedAt: DateTime.now().toString())));
    await context.router.replaceAll([const MainRoute()]);
  }

  Future<void> _handleVerificationError(ErrorVerifyState state) async {
    if (!mounted) return;

    if (state.error.code == 401) {
      await context.router.push(AddUserRoute(phoneNumber: widget.phoneNumber));
    } else if (state.error.code == 400) {
      AnimatedCustomSnackbar.show(
        context: context,
        message: S.of(context).code_error,
        type: SnackbarType.error,
      );
    } else if (state.error.code == 404) {
      AnimatedCustomSnackbar.show(
        context: context,
        message: S.of(context).error_sms_code,
        type: SnackbarType.error,
      );
    } else {
      ErrorHandler.showError(context, state.error.code);
    }
  }

  String formatPhoneNumber(String phoneNumber) {
    return "+998${phoneNumber.replaceAll(' ', '')}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => context.router.maybePop(),
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColor.primaryColor,
          ),
        ),
      ),
      body: BlocListener<VerifyOtpBloc, VerifyOtpState>(
        listener: (context, state) {
          if (state is ErrorVerifyState) {
            setState(() {
              isVerifying = false;
            });
            _handleVerificationError(state);
          }
          if (state is SuccessVerifyState) {
            _handleSuccessfulVerification();
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                S.of(context).verify_code,
                style: AppTextstyle.nunitoBold.copyWith(fontSize: 28),
              ),
              const SizedBox(height: 20),
              Text(
                S.of(context).enter_sms,
                style: AppTextstyle.nunitoMedium.copyWith(
                  color: AppColor.greyTextColor,
                  fontSize: 17,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                formatPhoneNumber(widget.phoneNumber),
                style: AppTextstyle.nunitoBold.copyWith(fontSize: 17),
              ),
              const SizedBox(height: 40),
              Center(
                child: Pinput(
                  controller: _pinController,
                  onChanged: _onPinChanged,
                  length: 4,
                  focusNode: _smsFocusNode,
                  defaultPinTheme: PinPutTheme.defaultPinTheme,
                  focusedPinTheme: PinPutTheme.focusedPinTheme,
                  submittedPinTheme: PinPutTheme.submittedPinTheme,
                  pinAnimationType: PinAnimationType.scale,
                  animationDuration: const Duration(milliseconds: 200),
                ),
              ),
              const Spacer(),
              Center(
                child: ResendButton(
                  onResend: _clearPinAndShowKeyboard,
                  phone: widget.phoneNumber,
                ),
              ),
              const SizedBox(height: 12),
              BlocBuilder<VerifyOtpBloc, VerifyOtpState>(
                builder: (context, state) {
                  return ButtonWidget(
                    isLoading: state is LoadingVerifyState,
                    consent: _isPinComplete,
                    controller: _pinController,
                    onPressed: _verifyCode,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

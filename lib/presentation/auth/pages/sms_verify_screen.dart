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
import 'dart:io' show Platform;

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
  Timer? _autoVerificationTimer;
  String? appSignature;
  bool isVerifying = false;
  bool _isPinComplete = false;

  // Formatted phone number cache
  late final String _formattedPhoneNumber;

  @override
  void initState() {
    super.initState();
    _formattedPhoneNumber = formatPhoneNumber(widget.phoneNumber);
    _smsFocusNode.requestFocus();
    _setupSmsListener();
    _getAppSignature();
  }

  void _setupSmsListener() {
    if (Platform.isIOS) {
      SmsAutoFill().listenForCode();

      SmsAutoFill().code.listen((code) {
        if (code.isNotEmpty && code.length == 4 && !isVerifying) {
          _updatePinAndVerify(code);
        }
      });

      _autoVerificationTimer = Timer(const Duration(seconds: 60), () {
        SmsAutoFill().unregisterListener();
      });
    } else {
      listenForCode();
    }
  }

  Future<void> _getAppSignature() async {
    try {
      appSignature = await SmsAutoFill().getAppSignature;
    } catch (e) {
      debugPrint('App signature olishda xatolik: $e');
    }
  }

  @override
  void dispose() {
    _pinController.dispose();
    _smsFocusNode.dispose();
    _autoVerificationTimer?.cancel();

    if (Platform.isIOS) {
      SmsAutoFill().unregisterListener();
    } else {
      cancel();
    }

    super.dispose();
  }

  @override
  void codeUpdated() {
    if (code != null && code!.length == 4 && !isVerifying) {
      _updatePinAndVerify(code!);
    }
  }

  void _updatePinAndVerify(String code) {
    // Avoid settate if not needed
    if (_pinController.text != code) {
      setState(() {
        _pinController.text = code;
        _isPinComplete = true;
      });
      Future.microtask(() => _verifyCode());
    }
  }

  void _onPinChanged(String pin) {
    final isPinComplete = pin.length == 4;
    if (_isPinComplete != isPinComplete) {
      setState(() {
        _isPinComplete = isPinComplete;
      });
    }

    if (isPinComplete && !isVerifying) {
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
          VerifyCodeEvent(_pinController.text, _formattedPhoneNumber),
        );
  }

  void _clearPinAndShowKeyboard() {
    _pinController.clear();
    setState(() {
      _isPinComplete = false;
      isVerifying = false;
    });
    _smsFocusNode.requestFocus();
    _setupSmsListener();
  }

  Future<void> _handleSuccessfulVerification() async {
    // Store registration status
    await LocalStorageService().setBool(StorageKeys.isRegister, true);
    if (!mounted) return;

    // Get FCM token and handle null case
    String? fcmToken;
    try {
      fcmToken = await getIt<NotificationRepository>().getFcmToken();
    } catch (e) {
      debugPrint('FCM token olishda xatolik: $e');
    }

    context.read<ProfileUpdateBloc>().add(ProfileUpdate(ProfileUpdateModel(
        birthday: "",
        fullName: "",
        gender: "",
        latitude: "",
        longitude: "",
        phoneNumber: "",
        photo: "",
        fcmToken: fcmToken ?? "",
        updatedAt: DateTime.now().toString())));

    // Navigate to main screen
    await context.router.replaceAll([const MainRoute()]);
  }

  Future<void> _handleVerificationError(ErrorVerifyState state) async {
    if (!mounted) return;

    final errorCode = state.error.code;

    if (errorCode == 401) {
      await context.router.push(AddUserRoute(phoneNumber: widget.phoneNumber));
    } else if (errorCode == 400) {
      AnimatedCustomSnackbar.show(
        context: context,
        message: S.of(context).code_error,
        type: SnackbarType.error,
      );
    } else if (errorCode == 404) {
      AnimatedCustomSnackbar.show(
        context: context,
        message: S.of(context).error_sms_code,
        type: SnackbarType.error,
      );
    } else {
      ErrorHandler.showError(context, errorCode);
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
          } else if (state is SuccessVerifyState) {
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
                _formattedPhoneNumber,
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

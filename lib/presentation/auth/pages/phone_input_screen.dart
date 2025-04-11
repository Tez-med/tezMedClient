import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sms_autofill/sms_autofill.dart';

import 'package:tez_med_client/core/utils/app_color.dart';
import 'package:tez_med_client/core/widgets/enviroment_dialog.dart';
import 'package:tez_med_client/generated/l10n.dart';
import 'package:tez_med_client/presentation/auth/widgets/consent_text.dart';
import '../../../core/error/error_handler.dart';
import '../../../core/routes/app_routes.gr.dart';
import '../../../domain/auth/entity/send_otp_entity.dart';
import '../bloc/send_otp/send_otp_bloc.dart';
import '../widgets/button_widget.dart';
import '../widgets/phone_input.dart';

@RoutePage()
class PhoneInputScreen extends StatefulWidget {
  const PhoneInputScreen({super.key});

  @override
  State<PhoneInputScreen> createState() => _PhoneInputScreenState();
}

class _PhoneInputScreenState extends State<PhoneInputScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController phoneController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusNode _focusNode = FocusNode();
  bool consent = false;
  String? appSignatureCode;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  int _actionButtonPressCount = 0;
  DateTime? _lastPressTime;

  @override
  void initState() {
    super.initState();
    appSignature();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode);
    });

    // Consent animatsiyasi uchun
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.8,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  void _handleActionButtonPress() {
    final now = DateTime.now();

    if (_lastPressTime == null ||
        now.difference(_lastPressTime!) > const Duration(milliseconds: 300)) {
      _actionButtonPressCount = 1;
    } else {
      _actionButtonPressCount++;
    }

    _lastPressTime = now;

    if (_actionButtonPressCount == 4) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return EnvironmentDialog();
        },
      );
      _actionButtonPressCount = 0;
    }
  }

  @override
  void dispose() {
    phoneController.dispose();
    _focusNode.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> appSignature() async {
    appSignatureCode = await SmsAutoFill().getAppSignature;
  }

  void _handleConsent() {
    _animationController.forward().then((_) {
      _animationController.reverse();
    });
    setState(() {
      consent = !consent;
    });
  }

  String formatPhoneNumber(String phoneNumber) {
    return "+998${phoneNumber.replaceAll(' ', '')}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const SizedBox(),
        leadingWidth: 0,
        actions: [
          GestureDetector(
            onTap: _handleActionButtonPress,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                width: 50,
                height: 50,
                color: Colors.transparent,
              ),
            ),
          ),
        ],
      ),
      body: BlocListener<SendOtpBloc, SendOtpState>(
        listener: (context, state) {
          if (state is SuccessOtp && phoneController.text.isNotEmpty) {
            context.router.push(
              SmsVerifyRoute(
                phoneNumber: phoneController.text,
              ),
            );
            phoneController.text = "";
          }
          if (state is ErrorOtp) {
            ErrorHandler.showError(context, state.error.code);
          }
        },
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  S.of(context).your_phone_number,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  S.of(context).send_code_phone_number,
                  style: const TextStyle(
                    color: AppColor.greyTextColor,
                    fontSize: 17,
                  ),
                ),
                const SizedBox(height: 45),
                Text(
                  S.of(context).phone_number,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                PhoneInputField(
                  phoneController: phoneController,
                  focusNode: _focusNode, 
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    GestureDetector(
                      onTap: _handleConsent,
                      child: ScaleTransition(
                        scale: _scaleAnimation,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: consent ? AppColor.primaryColor : null,
                            border: Border.all(
                              color: AppColor.greyTextColor,
                              width: consent ? 0 : 2,
                            ),
                          ),
                          child: consent
                              ? const Icon(Icons.check,
                                  color: Colors.white, size: 18)
                              : null,
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => context.router.push(const PrivacyPolicy()),
                        child: const ConsentText(),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                BlocBuilder<SendOtpBloc, SendOtpState>(
                  builder: (context, state) {
                    return ButtonWidget(
                      isLoading: state is LoadingOtp,
                      consent: consent,
                      controller: phoneController,
                      onPressed: () {
                        if (_formKey.currentState!.validate() && consent) {
                          final formattedPhone =
                              formatPhoneNumber(phoneController.text);
                          context.read<SendOtpBloc>().add(
                                SendCodeEvent(
                                  sendOtp: SendOtpEntity(
                                    phoneNumber: formattedPhone,
                                    appSignatureCode: appSignatureCode ?? "",
                                  ),
                                ),
                              );
                        }
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

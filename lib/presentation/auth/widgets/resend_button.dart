import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:tez_med_client/core/utils/app_color.dart';
import 'package:tez_med_client/core/utils/app_textstyle.dart';
import 'package:tez_med_client/domain/auth/entity/send_otp_entity.dart';
import 'package:tez_med_client/generated/l10n.dart';
import 'package:tez_med_client/presentation/auth/bloc/send_otp/send_otp_bloc.dart';

class ResendButton extends StatefulWidget {
  final String phone;
  final VoidCallback? onResend; // Changed to nullable

  const ResendButton({
    super.key,
    required this.phone,
    required this.onResend,
  });

  @override
  State<ResendButton> createState() => _ResendButtonState();
}

class _ResendButtonState extends State<ResendButton>
    with SingleTickerProviderStateMixin {
  late Timer _timer;
  int _start = 60;
  bool _isTimerActive = true;
  bool _isResendEnabled = true;
  late AnimationController _animationController;
  late Animation<double> _animation;
  String? appSignatureCode;

  @override
  void initState() {
    super.initState();
    startTimer();
    appSignature();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = Tween<double>(begin: 1, end: 0).animate(_animationController);
  }

  Future<void> appSignature() async {
    appSignatureCode = await SmsAutoFill().getAppSignature;
  }

  void startTimer() {
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            _isTimerActive = false;
            _isResendEnabled = true;
            timer.cancel();
          });
          _animationController.forward();
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  void resetTimer() {
    if (!_isResendEnabled || widget.onResend == null) return;

    setState(() {
      _isResendEnabled = false;
    });

    context.read<SendOtpBloc>().add(
          SendCodeEvent(
            sendOtp: SendOtpEntity(
              phoneNumber: widget.phone,
              appSignatureCode: appSignatureCode ?? "",
            ),
          ),
        );

    setState(() {
      _start = 60;
      _isTimerActive = true;
    });
    _animationController.reverse();
    startTimer();
    widget.onResend?.call();
  }

  @override
  void dispose() {
    _timer.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SendOtpBloc, SendOtpState>(
      listener: (context, state) {
        if (state is ErrorOtp) {
          setState(() {
            _isResendEnabled = true;
            _isTimerActive = false;
          });
          _timer.cancel();
          _animationController.forward();
        }
      },
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          if (_isTimerActive) {
            return Text(
              "${S.of(context).send_again}: ${_start ~/ 60}:${(_start % 60).toString().padLeft(2, '0')}",
              style: AppTextstyle.nunitoBold.copyWith(
                fontSize: 18,
                color: AppColor.primaryColor,
              ),
            );
          } else {
            return Transform.scale(
              scale: 1 - _animation.value,
              child: ElevatedButton(
                onPressed: _isResendEnabled ? resetTimer : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isResendEnabled
                      ? AppColor.primaryColor
                      : AppColor.primaryColor.withValues(alpha: 0.5),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  S.of(context).send_again,
                  style: AppTextstyle.nunitoBold.copyWith(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

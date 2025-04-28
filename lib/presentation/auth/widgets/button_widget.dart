import 'package:flutter/material.dart';
import 'package:tez_med_client/core/utils/app_color.dart';
import 'package:tez_med_client/core/utils/app_textstyle.dart';
import 'package:tez_med_client/generated/l10n.dart';

class ButtonWidget extends StatefulWidget {
  const ButtonWidget({
    super.key,
    this.consent = false,
    this.controller,
    required this.onPressed,
    required this.isLoading,
    this.buttonColor,
    this.buttonText,
    this.textColor,
  });

  final VoidCallback? onPressed;
  final bool consent;
  final TextEditingController? controller;
  final bool isLoading;
  final Color? buttonColor;
  final String? buttonText;
  final Color? textColor;

  @override
  State<ButtonWidget> createState() => _ButtonWidgetState();
}

class _ButtonWidgetState extends State<ButtonWidget> {
  bool _isButtonDisabled = false;

  void _handleTap() {
    if (_isButtonDisabled) return; // Agar bloklangan bo'lsa, qaytamiz

    setState(() {
      _isButtonDisabled = true;
    });

    widget.onPressed?.call();

    // 1 sekunddan keyin qayta bosishga ruxsat beramiz
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _isButtonDisabled = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentColor = widget.buttonColor ??
        (widget.consent ? AppColor.primaryColor : AppColor.buttonBackColor);
    final currentTextColor =
        widget.textColor ?? (widget.consent ? Colors.white : Colors.grey);
    final size = MediaQuery.of(context).size;

    return Center(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: widget.isLoading ? 50 : size.width,
        height: 50,
        decoration: BoxDecoration(
          color: currentColor,
          borderRadius: BorderRadius.circular(widget.isLoading ? 25 : 10),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(widget.isLoading ? 25 : 10),
          onTap: (widget.consent && !widget.isLoading && !_isButtonDisabled)
              ? _handleTap
              : null,
          child: Center(
            child: AnimatedCrossFade(
              duration: const Duration(milliseconds: 300),
              reverseDuration: const Duration(milliseconds: 200),
              crossFadeState: widget.isLoading
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              firstChild: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    widget.consent ? Colors.white : Colors.black,
                  ),
                  strokeWidth: 2.5,
                ),
              ),
              secondChild: Text(
                widget.buttonText ?? S.of(context).confirm,
                style: AppTextstyle.nunitoBold.copyWith(
                  color: widget.consent ? currentTextColor : Colors.grey,
                  fontSize: 17,
                ),
              ),
              layoutBuilder:
                  (topChild, topChildKey, bottomChild, bottomChildKey) {
                return Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      key: bottomChildKey,
                      child: bottomChild,
                    ),
                    Positioned(
                      key: topChildKey,
                      child: topChild,
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

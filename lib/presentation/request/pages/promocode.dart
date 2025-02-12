import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tez_med_client/core/utils/app_color.dart';
import 'package:tez_med_client/core/utils/app_textstyle.dart';
import 'package:tez_med_client/core/widgets/custom_snackbar.dart';
import 'package:tez_med_client/generated/l10n.dart';
import 'package:tez_med_client/presentation/request/bloc/promocode/promocode_bloc.dart';

class Promocode extends StatefulWidget {
  final Function(int amount, bool isPercent, String promocodeKey)?
      onPromocodeApplied;

  const Promocode({super.key, this.onPromocodeApplied});

  @override
  State<Promocode> createState() => _PromocodeState();
}

class _PromocodeState extends State<Promocode> {
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;
  bool _success = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _applyPromocode(BuildContext context) {
    final promocode = _controller.text.trim();
    if (promocode.isEmpty) {
      setState(() {
        _success = false;
      });
    } else {
      setState(() {
        _isLoading = true;
      });
      context.read<PromocodeBloc>().add(PromocodeUsing(promocode));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PromocodeBloc, PromocodeState>(
      listener: (context, state) {
        if (state is PromocodeError) {
          if (state.error.code == 50) {
            AnimatedCustomSnackbar.show(
                context: context,
                message: S.of(context).promocode_count,
                type: SnackbarType.info);
          } else if (state.error.code == 51) {
            AnimatedCustomSnackbar.show(
                context: context,
                message: S.of(context).promocode_time,
                type: SnackbarType.info);
          } else {
            AnimatedCustomSnackbar.show(
                context: context,
                message: S.of(context).invalid_promo_code,
                type: SnackbarType.info);
          }
          setState(() {
            _isLoading = false;
            _success = false;
            _controller.text = "";
            widget.onPromocodeApplied?.call(0, false, "");
          });
        } else if (state is PromocodeLoaded) {
          setState(() {
            _isLoading = false;
            final amount = state.promocodeModel.amount != 0
                ? state.promocodeModel.amount
                : state.promocodeModel.percent;
            final isPercent = state.promocodeModel.amount == 0;
            widget.onPromocodeApplied
                ?.call(amount, isPercent, _controller.text);
            _success = true;
          });
        } else if (state is PromocodeLoading) {
          setState(() {
            _success = false;
            _isLoading = true;
          });
        }
      },
      child: Card(
        elevation: 0,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                S.of(context).promocode,
                style: AppTextstyle.nunitoBold.copyWith(fontSize: 20),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      inputFormatters: [
                        UpperCaseTextFormatter(),
                      ],
                      decoration: InputDecoration(
                        suffixIcon: _success
                            ? Icon(
                                CupertinoIcons.checkmark_alt_circle,
                                color: Colors.green,
                              )
                            : null,
                        hintText: S.of(context).promocode,
                        hintStyle: TextStyle(color: Colors.grey.shade400),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: AppColor.primaryColor),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed:
                        _isLoading ? null : () => _applyPromocode(context),
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: AppColor.primaryColor,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            S.of(context).apply,
                            style: AppTextstyle.nunitoRegular.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return newValue.copyWith(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

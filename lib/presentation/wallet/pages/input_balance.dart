import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tez_med_client/core/constant/storage_keys.dart';
import 'package:tez_med_client/core/error/error_handler.dart';
import 'package:tez_med_client/core/utils/app_color.dart';
import 'package:tez_med_client/core/utils/app_textstyle.dart';
import 'package:tez_med_client/data/local_storage/local_storage_service.dart';
import 'package:tez_med_client/domain/payment/entity/post_payment.dart';
import 'package:tez_med_client/gen/assets.gen.dart';
import 'package:tez_med_client/generated/l10n.dart';
import 'package:tez_med_client/presentation/profile/bloc/profile_bloc/profile_bloc.dart';
import 'package:tez_med_client/presentation/wallet/bloc/payment/payment_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

@RoutePage()
class InputBalance extends StatefulWidget {
  const InputBalance({super.key});

  @override
  State<InputBalance> createState() => _InputBalanceState();
}

class _InputBalanceState extends State<InputBalance> {
  final TextEditingController _amountController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final NumberFormat _numberFormat = NumberFormat('#,###');

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          context.read<ProfileBloc>().add(GetProfileData());
          context.router.maybePop();
        }
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          appBar: _buildAppBar(context),
          body: BlocListener<PaymentBloc, PaymentState>(
            listener: _handlePaymentState,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildPaymentOptionTile(context),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 9),
                        child: Card(
                          elevation: 0,
                          color: Colors.white,
                          child: Column(
                            children: [
                              _buildAmountInputSection(context),
                              const SizedBox(height: 16),
                              _buildQuickAmountButtons(),
                              const SizedBox(height: 16),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildSubmitButton(context),
            ),
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        S.of(context).balance_fill,
      ),
    );
  }

  void _handlePaymentState(BuildContext context, PaymentState state) {
    if (state is PaymentError) {
      ErrorHandler.showError(context, state.error.code);
      context.router.maybePop();
    } else if (state is PaymentLoaded) {
      launchUrl(
        Uri.parse(state.url),
        mode: LaunchMode.externalApplication,
      ).then((_) {
        if (context.mounted) {
          context.router.maybePop();
          _amountController.clear();
          context.read<ProfileBloc>().add(GetProfileData());
        }
      }).catchError((error) {});
    } else if (state is PaymentLoading) {
      showDialog(
        context: context,
        barrierColor: Colors.black.withValues(alpha: .4),
        builder: (context) => Center(
          child: Assets.lottie.loading.lottie(
            width: 100,
            height: 100,
          ),
        ),
      );
    }
  }

  Widget _buildPaymentOptionTile(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Row(
          children: [
            _buildPaymentIcon(),
            const SizedBox(width: 12),
            _buildPaymentDetails(context),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentIcon() {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: AppColor.buttonBackColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Assets.images.payme
              .image(fit: BoxFit.contain, width: 40, height: 40),
        ),
      ),
    );
  }

  Widget _buildPaymentDetails(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).payme,
            style: AppTextstyle.nunitoBold.copyWith(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          Text(
            S.of(context).payme_with_fill,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmountInputSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).fill_price,
            style: AppTextstyle.nunitoBold.copyWith(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _amountController,
            decoration: InputDecoration(
              hintText: S.of(context).enter_amount,
              hintStyle: TextStyle(color: Colors.grey[400]),
              filled: true,
              fillColor: AppColor.buttonBackColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: AppColor.primaryColor,
                  width: 1.5,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(15),
              TextInputFormatter.withFunction(_formatInputValue),
            ],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return S.of(context).please_amount;
              }

              // Faqat raqamlarni olish
              final numericValue =
                  int.parse(value.replaceAll(RegExp(r'\s+'), ''));

              if (numericValue < 1000) {
                return S.of(context).minimum_amount_error;
              }

              return null;
            },
            style: AppTextstyle.nunitoBold.copyWith(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  TextEditingValue _formatInputValue(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.length < oldValue.text.length) return newValue;

    final formatted = _formatNumber(newValue.text);
    final selectionIndex =
        formatted.length - (oldValue.text.length - oldValue.selection.end);
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(
        offset: selectionIndex.clamp(0, formatted.length),
      ),
    );
  }

  Widget _buildQuickAmountButtons() {
    final amounts = ["10 000", "30 000", "50 000", "100 000"]
        .map((amount) => amount)
        .toList();

    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: amounts.length,
        itemBuilder: (context, index) {
          return _buildAmountButton(amounts[index].toString());
        },
      ),
    );
  }

  Widget _buildAmountButton(String amount) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 5),
      child: ElevatedButton(
        onPressed: () => setState(() {
          _amountController.text = amount;
        }),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.buttonBackColor,
          foregroundColor: Colors.black,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          "$amount ${S.of(context).sum}",
          style: AppTextstyle.nunitoBold.copyWith(
            color: Colors.black,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return ElevatedButton(
      onPressed: _onSubmit,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColor.primaryColor,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 5,
        shadowColor: AppColor.primaryColor.withValues(alpha: 0.4),
      ),
      child: Text(
        S.of(context).Continue,
        style: AppTextstyle.nunitoBold.copyWith(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
    );
  }

  void _onSubmit() {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState?.validate() ?? false) {
      final clientId = LocalStorageService().getString(StorageKeys.userId);
      final price =
          int.parse(_amountController.text.replaceAll(RegExp(r'\s+'), ''));

      // Minimum summa tekshiruvi qayta
      if (price >= 1000) {
        context.read<PaymentBloc>().add(
              PostPay(
                PostPayment(
                  createdAt: DateTime.now().toString(),
                  clientId: clientId,
                  price: price,
                ),
              ),
            );
      }
    }
  }

  String _formatNumber(String value) {
    if (value.isEmpty) return '';
    final numericString = value.replaceAll(RegExp(r'[^\d]'), '');
    return _numberFormat.format(int.parse(numericString));
  }
}

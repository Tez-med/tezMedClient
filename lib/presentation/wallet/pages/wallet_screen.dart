import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tez_med_client/core/routes/app_routes.gr.dart';
import 'package:tez_med_client/core/utils/app_color.dart';
import 'package:tez_med_client/core/utils/app_textstyle.dart';
import 'package:tez_med_client/core/widgets/no_interner_connection.dart';
import 'package:tez_med_client/core/widgets/server_connection.dart';
import 'package:tez_med_client/gen/assets.gen.dart';
import 'package:tez_med_client/generated/l10n.dart';
import 'package:tez_med_client/presentation/wallet/bloc/payment_history/payment_history_bloc.dart';
import '../../../data/payment_history/model/payment_history_model.dart';

@RoutePage()
class WalletScreen extends StatefulWidget {
  final String amount;
  const WalletScreen({super.key, required this.amount});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  String _formatAmount(String amount) => amount.replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[0]} ');

  Map<String, List<Payment>> _groupPaymentsByDate(List<Payment> payments) {
    final grouped = <String, List<Payment>>{};
    final dateFormatter = DateFormat('d MMMM yyyy');

    for (final payment in payments) {
      final date = _parseAndFormatDate(payment.createdAt, dateFormatter);
      (grouped[date] ??= []).add(payment);
    }

    return Map.fromEntries(grouped.entries.toList()
      ..sort((a, b) => _compareDates(b.key, a.key, dateFormatter)));
  }

  String _parseAndFormatDate(String dateStr, DateFormat formatter) {
    try {
      final date = DateFormat("yyyy/MM/dd HH:mm:ss").parse(dateStr.trim());
      return formatter.format(date);
    } catch (e) {
      return "Noma'lum sana";
    }
  }

  int _compareDates(String a, String b, DateFormat formatter) {
    try {
      final dateA = formatter.parse(a);
      final dateB = formatter.parse(b);
      return dateA.compareTo(dateB);
    } catch (e) {
      return 0;
    }
  }

  String _formatUzTime(String utcTimeString) {
    try {
      final utcTime = DateTime.parse(utcTimeString.replaceAll('/', '-').trim());
      final uzTime = utcTime.add(const Duration(hours: 5));
      return DateFormat('HH:mm').format(uzTime);
    } catch (e) {
      return "Noma'lum vaqt";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(context),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        S.of(context).wallet,
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWalletCard(context),
          _buildPaymentHistory(context),
        ],
      ),
    );
  }

  Widget _buildWalletCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Text(
                "${_formatAmount(widget.amount)} ${S.of(context).sum}",
                style: AppTextstyle.nunitoBold.copyWith(
                  fontSize: 30,
                  color: Colors.black,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 20),
              _buildTopUpButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopUpButton(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColor.primaryColor,
            AppColor.primaryColor.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () => context.router.push(InputBalance()),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 12),
            child: Text(
              S.of(context).wallet_filling,
              style: AppTextstyle.nunitoBold.copyWith(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentHistory(BuildContext context) {
    return BlocBuilder<PaymentHistoryBloc, PaymentHistoryState>(
      bloc: context.read<PaymentHistoryBloc>()
        ..add(FilterPayments(PaymentFilter.all)),
      builder: (context, state) {
        if (state is PaymentHistoryLoading) {
          return _buildLoadingSkeleton();
        }

        if (state is PaymentHistoryError) {
          return _buildErrorWidget(context, state.error.code);
        }

        if (state is PaymentHistoryLoaded) {
          // if (state.paymentHistoryModel.payments.isEmpty) {
          //   return Center(child: _buildEmptyState(context));
          // }

          // if (state.filteredPayments.isEmpty) {
          //   return Center(child: _buildEmptyState(context));
          // }
          return _buildPaymentList(
            context,
            state.filteredPayments,
            state.filter,
          );
        }

        return const SizedBox();
      },
    );
  }

  Widget _buildPaymentList(
    BuildContext context,
    List<Payment> payments,
    PaymentFilter currentFilter,
  ) {
    final groupedPayments = _groupPaymentsByDate(payments);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Card(
        elevation: 0,
        color: Colors.white,
        child: Column(
          children: [
            _buildFilterButtons(context, currentFilter),
            payments.isEmpty
                ? _buildEmptyState(context)
                : _buildPaymentGroups(groupedPayments),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterButtons(
      BuildContext context, PaymentFilter currentFilter) {
    return Row(
      children: [
        SizedBox(width: 8),
        _filterButton(
          S.of(context).all,
          currentFilter == PaymentFilter.all,
          () => context.read<PaymentHistoryBloc>().add(
                FilterPayments(PaymentFilter.all),
              ),
        ),
        SizedBox(width: 8),
        _filterButton(
          S.of(context).filled,
          currentFilter == PaymentFilter.positive,
          () => context.read<PaymentHistoryBloc>().add(
                FilterPayments(PaymentFilter.positive),
              ),
        ),
        SizedBox(width: 8),
        _filterButton(
          S.of(context).order,
          currentFilter == PaymentFilter.negative,
          () => context.read<PaymentHistoryBloc>().add(
                FilterPayments(PaymentFilter.negative),
              ),
        ),
      ],
    );
  }

  Widget _filterButton(String text, bool isSelected, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 16),
          backgroundColor: AppColor.buttonBackColor,
          foregroundColor: isSelected ? AppColor.primaryColor : Colors.black,
          textStyle: AppTextstyle.nunitoBold,
        ),
        child: Text(text),
      ),
    );
  }

  Widget _buildPaymentGroups(Map<String, List<Payment>> groupedPayments) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: groupedPayments.entries.map((entry) {
        return _buildPaymentGroup(entry.key, entry.value);
      }).toList(),
    );
  }

  Widget _buildPaymentGroup(String date, List<Payment> payments) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10, top: 10),
          child: Text(
            date,
            style: AppTextstyle.nunitoBold.copyWith(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
        ),
        ...payments.map((payment) => _buildPaymentTile(payment, payments)),
      ],
    );
  }

  Widget _buildPaymentTile(Payment payment, List<Payment> groupPayments) {
    return Column(
      children: [
        ListTile(
          leading: _buildPaymentIcon(payment),
          title: _buildPaymentTitle(payment),
          subtitle: Text(
            _formatUzTime(payment.createdAt),
            style: AppTextstyle.nunitoBold.copyWith(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
          trailing: _buildPaymentAmount(payment),
        ),
        if (payment != groupPayments.last)
          Divider(height: 1, color: AppColor.buttonBackColor),
      ],
    );
  }

  Widget _buildPaymentIcon(Payment payment) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: payment.type == 'payme'
          ? Assets.icons.payme.image(width: 25, height: 25)
          : Assets.icons.paymentOrder.svg(width: 25, height: 25),
    );
  }

  Widget _buildPaymentTitle(Payment payment) {
    return Text(
      payment.type == 'payme' ? "Payme" : "№: ${payment.number}",
      maxLines: 1,
      style: AppTextstyle.nunitoBold.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }

  Widget _buildPaymentAmount(Payment payment) {
    return Text(
      "${payment.price < 0 ? "" : "+"} ${_formatAmount(payment.price.toString())} ${S.of(context).sum}",
      style: AppTextstyle.nunitoBold.copyWith(
        fontSize: 16,
        color: payment.price < 0 ? Colors.red : Colors.green,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 50),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Assets.icons.noPaymentHistory.svg(width: 200, height: 200),
            SizedBox(height: 20),
            Text(
              S.of(context).not_payment_history,
              style: AppTextstyle.nunitoBold.copyWith(
                  fontSize: 18, color: Colors.black54, letterSpacing: 0.5),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingSkeleton() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 1,
      itemBuilder: (context, groupIndex) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Card(
            elevation: 0,
            color: Colors.white,
            child: Column(
              children: [
                _buildFilterButtons(context, PaymentFilter.all),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 10, top: 10, bottom: 8),
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          width: 120,
                          height: 15,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 5,
                      separatorBuilder: (context, index) => Divider(
                        height: 1,
                        color: AppColor.buttonBackColor,
                      ),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 8,
                          ),
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(8),
                                  margin: const EdgeInsets.only(left: 8),
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                // Title and Subtitle
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 120,
                                          height: 15,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Container(
                                          width: 70,
                                          height: 10,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                // Trailing (Price and Type)
                                Padding(
                                  padding: const EdgeInsets.only(right: 16),
                                  child: Container(
                                    width: 90,
                                    height: 15,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildErrorWidget(BuildContext context, int errorCode) {
    if (errorCode == 500) {
      return NoInternetConnectionWidget(
        onRetry: () => context
            .read<PaymentHistoryBloc>()
            .add(FilterPayments(PaymentFilter.all)),
      );
    } else if (errorCode == 400) {
      return ServerConnection(
        onRetry: () => context
            .read<PaymentHistoryBloc>()
            .add(FilterPayments(PaymentFilter.all)),
      );
    }
    return Center(
      child: Text(
        S.of(context).unexpected_error,
        style: AppTextstyle.nunitoBold.copyWith(fontSize: 20),
      ),
    );
  }
}

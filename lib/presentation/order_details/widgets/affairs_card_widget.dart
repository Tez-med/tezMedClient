import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tez_med_client/core/bloc/language/language_bloc.dart';
import 'package:tez_med_client/core/utils/app_textstyle.dart';
import 'package:tez_med_client/data/requests_get/model/get_by_id_request_model.dart';
import 'package:tez_med_client/generated/l10n.dart';
import '../../request/widgets/check_widget.dart';

class AffairsCard extends StatelessWidget {
  const AffairsCard({
    super.key,
    required this.requestss,
  });

  final GetByIdRequestModel requestss;

  @override
  Widget build(BuildContext context) {
    final lang = context.read<LanguageBloc>().state.locale.languageCode;
    final format = NumberFormat("#,###");

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).order_details,
            style: AppTextstyle.nunitoBold.copyWith(fontSize: 20),
          ),
          const SizedBox(height: 20),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: requestss.requestAffairs.length,
            itemBuilder: (context, index) {
              final affair = requestss.requestAffairs[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${index + 1}. ${lang == 'uz' ? affair.nameUz : lang == 'en' ? affair.nameEn : affair.nameRu}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          '${affair.count} x ${format.format(affair.price)}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                        ),
                        const Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: DottedLine(),
                          ),
                        ),
                        Text(
                          '${format.format(affair.price * affair.count)} ${S.of(context).sum}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
          if (requestss.promocodeAmount != 0) ...[
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: DottedLine(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  S.of(context).discount_price,
                  style: AppTextstyle.nunitoBold.copyWith(fontSize: 18),
                ),
                Text(
                  '-${format.format(requestss.promocodeAmount)} ${S.of(context).sum}',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.red,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: DottedLine(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                S.of(context).price_going,
                style: AppTextstyle.nunitoBold.copyWith(fontSize: 18),
              ),
              Text(
                '${format.format(requestss.requestAffairs.first.typeModel.price)} ${S.of(context).sum}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: DottedLine(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                S.of(context).total_price,
                style: AppTextstyle.nunitoBold.copyWith(fontSize: 18),
              ),
              Text(
                '${format.format(requestss.price)} ${S.of(context).sum}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

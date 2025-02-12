import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tez_med_client/core/bloc/language/language_bloc.dart';
import 'package:tez_med_client/core/utils/app_textstyle.dart';
import 'package:tez_med_client/data/requests_get/model/active_request_model.dart';
import 'package:tez_med_client/generated/l10n.dart';

class CheckWidget extends StatelessWidget {
  final List<RequestAffairGet> requestAffairs;
  final double? discountAmount;
  final bool isPercentage;
  final int servicePrice;
  const CheckWidget({
    super.key,
    required this.requestAffairs,
    this.discountAmount,
    this.isPercentage = false,
    required this.servicePrice,
  });

  @override
  Widget build(BuildContext context) {
    final lang = context.read<LanguageBloc>().state.locale.languageCode;
    final format = NumberFormat("#,###");
    double totalSum = 0;

    for (var affair in requestAffairs) {
      final price = affair.price * affair.count;
      totalSum += price;
    }

    double discount = 0;
    final total = (totalSum + servicePrice) - discount;
    if (discountAmount != null) {
      if (isPercentage) {
        discount = total * (discountAmount! / 100);
      } else {
        discount = discountAmount!;
      }
    }

    final finalSum = (totalSum + servicePrice) - discount;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).your_check,
            style: AppTextstyle.nunitoBold.copyWith(fontSize: 20),
          ),
          const SizedBox(height: 20),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: requestAffairs.length,
            itemBuilder: (context, index) {
              final affair = requestAffairs[index];
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
                          '${(format.format(affair.price * affair.count))} ${S.of(context).sum}',
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
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: DottedLine(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                S.of(context).price_going,
                style: AppTextstyle.nunitoBold.copyWith(fontSize: 20),
              ),
              Text(
                "${format.format(servicePrice)} ${S.of(context).sum}",
                style: AppTextstyle.nunitoBold.copyWith(fontSize: 18),
              ),
            ],
          ),
          if (discountAmount != 0.0) ...[
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: DottedLine(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  S.of(context).discount_price,
                  style: AppTextstyle.nunitoBold
                      .copyWith(fontSize: 20, color: Colors.green),
                ),
                Text(
                  "- ${format.format(discount)} ${S.of(context).sum}",
                  style: AppTextstyle.nunitoBold
                      .copyWith(fontSize: 18, color: Colors.green),
                ),
              ],
            ),
          ],
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: DottedLine(),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                S.of(context).total,
                style: AppTextstyle.nunitoBold.copyWith(fontSize: 20),
              ),
              Text(
                "${format.format(finalSum)} ${S.of(context).sum}",
                style: AppTextstyle.nunitoBold.copyWith(fontSize: 18),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DottedLine extends StatelessWidget {
  const DottedLine({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(double.infinity, 1),
      painter: DottedLinePainter(),
    );
  }
}

class DottedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black26
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round;

    double dashWidth = 4;
    double dashSpace = 4;
    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, 0),
        Offset(startX + dashWidth, 0),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

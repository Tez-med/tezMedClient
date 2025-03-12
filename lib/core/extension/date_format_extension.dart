import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tez_med_client/core/bloc/language/language_bloc.dart';

extension DateFormatter on BuildContext {
  String formatDate({required DateTime date, required String pattern}) {
    String locale = read<LanguageBloc>().state.locale.languageCode;
    String formattedDate = DateFormat(pattern, locale).format(date);

    return formattedDate.isNotEmpty
        ? formattedDate[0].toUpperCase() + formattedDate.substring(1)
        : formattedDate;
  }
}

import 'package:flutter/material.dart';
import 'package:tez_med_client/core/widgets/no_interner_connection.dart';
import 'package:tez_med_client/core/widgets/server_connection.dart';
import 'package:tez_med_client/generated/l10n.dart';

class ErrorDisplayWidget extends StatelessWidget {
  final int errorCode;
  final VoidCallback onRetry;

  const ErrorDisplayWidget({
    super.key,
    required this.errorCode,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    switch (errorCode) {
      case 400:
        return NoInternetConnectionWidget(onRetry: onRetry);
      case 500:
        return ServerConnection(onRetry: onRetry);
      default:
        return Center(
          child: Text(S.of(context).unexpected_error),
        );
    }
  }
}

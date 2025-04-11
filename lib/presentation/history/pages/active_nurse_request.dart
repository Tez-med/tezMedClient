import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tez_med_client/core/utils/app_textstyle.dart';
import 'package:tez_med_client/core/widgets/no_interner_connection.dart';
import 'package:tez_med_client/core/widgets/server_connection.dart';
import 'package:tez_med_client/gen/assets.gen.dart';
import 'package:tez_med_client/generated/l10n.dart';
import 'package:tez_med_client/presentation/history/bloc/active_request_bloc/active_request_bloc.dart';
import 'package:tez_med_client/presentation/history/widgets/request_card.dart';
import 'package:tez_med_client/presentation/history/widgets/request_loading.dart';

@RoutePage()
class ActiveRequestScreen extends StatelessWidget {
  const ActiveRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ActiveRequestBloc, ActiveRequestState>(
        bloc: context.read<ActiveRequestBloc>()..add(GetActiveRequest()),
        builder: (context, state) {
          if (state is ActiveRequestLoading) {
            return const RequestLoadingWidget();
          } else if (state is ActiveRequestLoaded) {
            if (state.requestss.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Assets.icons.historyEmpty
                        .svg(width: 150, height: 150, fit: BoxFit.cover),
                    const SizedBox(height: 10),
                    Text(
                      S.of(context).no_current_order,
                      style: AppTextstyle.nunitoBold.copyWith(fontSize: 20),
                    ),
                  ],
                ),
              );
            }
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: ListView.builder(
                itemCount: state.requestss.length,
                itemBuilder: (context, index) {
                  final data = state.requestss[index];
                  return RequestCard(data: data);
                },
              ),
            );
          } else if (state is ActiveRequestError) {
            if (state.error.code == 400) {
              return NoInternetConnectionWidget(
                onRetry: () =>
                    context.read<ActiveRequestBloc>().add(GetActiveRequest()),
              );
            } else if (state.error.code == 500) {
              return ServerConnection(
                onRetry: () =>
                    context.read<ActiveRequestBloc>().add(GetActiveRequest()),
              );
            }
          }
          return Center(
            child: Text(
              S.of(context).unexpected_error,
              style: AppTextstyle.nunitoBold.copyWith(fontSize: 20),
            ),
          );
        },
      ),
    );
  }
}

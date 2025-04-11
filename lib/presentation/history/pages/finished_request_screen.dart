import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tez_med_client/core/utils/app_textstyle.dart';
import 'package:tez_med_client/core/widgets/no_interner_connection.dart';
import 'package:tez_med_client/core/widgets/server_connection.dart';
import 'package:tez_med_client/gen/assets.gen.dart';
import 'package:tez_med_client/generated/l10n.dart';
import 'package:tez_med_client/presentation/history/bloc/active_request_bloc/active_request_bloc.dart';
import 'package:tez_med_client/presentation/history/bloc/finished_request_bloc/finished_bloc.dart';
import 'package:tez_med_client/presentation/history/widgets/request_card.dart';
import 'package:tez_med_client/presentation/history/widgets/request_loading.dart';

@RoutePage()
class FinishedRequestScreen extends StatelessWidget {
  const FinishedRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.router.maybePop(),
          icon: Icon(Icons.arrow_back_ios_new_rounded),
        ),
        centerTitle: true,
        title: Text(
          S.of(context).order_history,
        ),
      ),
      body: BlocBuilder<FinishedBloc, FinishedState>(
        bloc: context.read<FinishedBloc>()..add(GetFinishedRequest()),
        builder: (context, state) {
          if (state is FinishedLoading) {
            return const RequestLoadingWidget();
          } else if (state is FinishedLoaded) {
            if (state.requestss.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Assets.icons.historyEmpty
                        .svg(width: 150, height: 150, fit: BoxFit.cover),
                    const SizedBox(height: 10),
                    Text(
                      S.of(context).no_complated_order,
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
          } else if (state is FinishedError) {
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

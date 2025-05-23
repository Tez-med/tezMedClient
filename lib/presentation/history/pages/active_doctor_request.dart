import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tez_med_client/core/utils/app_textstyle.dart';
import 'package:tez_med_client/core/widgets/no_interner_connection.dart';
import 'package:tez_med_client/core/widgets/server_connection.dart';
import 'package:tez_med_client/gen/assets.gen.dart';
import 'package:tez_med_client/generated/l10n.dart';
import 'package:tez_med_client/presentation/history/bloc/active_doctor_bloc/active_doctor_request_bloc.dart';
import 'package:tez_med_client/presentation/history/widgets/request_loading.dart';

import '../widgets/doctor_card.dart';

@RoutePage()
class ActiveDoctorRequest extends StatelessWidget {
  const ActiveDoctorRequest({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ActiveDoctorRequestBloc, ActiveDoctorRequestState>(
        bloc: context.read<ActiveDoctorRequestBloc>()..add(GetSchedule()),
        builder: (context, state) {
          if (state is ActiveDoctorRequestLoading) {
            return const RequestLoadingWidget();
          } else if (state is ActiveDoctorRequestLoaded) {
            if (state.scheduleModel.schedules.isEmpty) {
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
                itemCount: state.scheduleModel.schedules
                    .where((element) => element.status != "done")
                    .length,
                itemBuilder: (context, index) {
                  final data = state.scheduleModel.schedules
                      .where((element) => element.status != "done")
                      .toList()[index];
                  return DoctorCardWidget(
                    data: data,
                  );
                },
              ),
            );
          } else if (state is ActiveDoctorRequestError) {
            if (state.error.code == 400) {
              return NoInternetConnectionWidget(
                onRetry: () =>
                    context.read<ActiveDoctorRequestBloc>().add(GetSchedule()),
              );
            } else if (state.error.code == 500) {
              return ServerConnection(
                onRetry: () =>
                    context.read<ActiveDoctorRequestBloc>().add(GetSchedule()),
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

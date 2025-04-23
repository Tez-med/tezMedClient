import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tez_med_client/core/utils/app_textstyle.dart';
import 'package:tez_med_client/core/widgets/no_interner_connection.dart';
import 'package:tez_med_client/core/widgets/server_connection.dart';
import 'package:tez_med_client/gen/assets.gen.dart';
import 'package:tez_med_client/generated/l10n.dart';
import 'package:tez_med_client/presentation/history/bloc/active_doctor_bloc/active_doctor_request_bloc.dart';
import 'package:tez_med_client/presentation/history/bloc/finished_request_bloc/finished_bloc.dart';
import 'package:tez_med_client/presentation/history/widgets/doctor_card.dart';
import 'package:tez_med_client/presentation/history/widgets/request_card.dart';
import 'package:tez_med_client/presentation/history/widgets/request_loading.dart';

@RoutePage()
class FinishedRequestScreen extends StatefulWidget {
  const FinishedRequestScreen({super.key});

  @override
  State<FinishedRequestScreen> createState() => _FinishedRequestScreenState();
}

class _FinishedRequestScreenState extends State<FinishedRequestScreen> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    context.read<FinishedBloc>().add(GetFinishedRequest());
    context.read<ActiveDoctorRequestBloc>().add(GetSchedule());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.router.maybePop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        centerTitle: true,
        title: Text(S.of(context).order_history),
      ),
      body: RefreshIndicator(
        onRefresh: () async => _loadData(),
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return BlocBuilder<FinishedBloc, FinishedState>(
      builder: (context, finishedState) {
        return BlocBuilder<ActiveDoctorRequestBloc, ActiveDoctorRequestState>(
          builder: (context, doctorState) {
            // Error holatlarini tekshirish
            if (finishedState is FinishedError) {
              return _buildErrorWidget(finishedState.error.code);
            }

            if (doctorState is ActiveDoctorRequestError) {
              return _buildErrorWidget(doctorState.error.code);
            }

            // Loading holatini tekshirish
            if (finishedState is FinishedLoading ||
                doctorState is ActiveDoctorRequestLoading) {
              return const RequestLoadingWidget();
            }

            // Ma'lumotlarni olish
            final finishedRequests =
                finishedState is FinishedLoaded ? finishedState.requestss : [];

            final doneSchedules = doctorState is ActiveDoctorRequestLoaded
                ? doctorState.scheduleModel.schedules
                    .where((e) => e.status == "done")
                    .toList()
                : [];

            // Ikkalasi ham bo'sh bo'lsa, empty state ko'rsatish
            if (finishedRequests.isEmpty && doneSchedules.isEmpty) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: _buildEmptyState(
                      icon: Assets.icons.historyEmpty,
                      message: S.of(context).no_complated_order,
                    ),
                  ),
                ],
              );
            }

            // Ma'lumotlar bor bo'lsa ko'rsatish
            return CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                // Tugatilgan so'rovlar
                if (finishedRequests.isNotEmpty)
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) =>
                            RequestCard(data: finishedRequests[index]),
                        childCount: finishedRequests.length,
                      ),
                    ),
                  ),

                // Tugatilgan shifokor uchrashuvlari
                if (doneSchedules.isNotEmpty)
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) =>
                            DoctorCardWidget(data: doneSchedules[index]),
                        childCount: doneSchedules.length,
                      ),
                    ),
                  ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildEmptyState(
      {required SvgGenImage icon, required String message}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon.svg(width: 150, height: 150, fit: BoxFit.cover),
          const SizedBox(height: 10),
          Text(
            message,
            style: AppTextstyle.nunitoBold.copyWith(fontSize: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(int errorCode) {
    if (errorCode == 400) {
      return NoInternetConnectionWidget(onRetry: _loadData);
    } else if (errorCode == 500) {
      return ServerConnection(onRetry: _loadData);
    }

    return _buildUnexpectedErrorWidget();
  }

  Widget _buildUnexpectedErrorWidget() {
    return Center(
      child: Text(
        S.of(context).unexpected_error,
        style: AppTextstyle.nunitoBold.copyWith(fontSize: 20),
      ),
    );
  }
}

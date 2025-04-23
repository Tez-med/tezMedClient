import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tez_med_client/core/routes/app_routes.gr.dart';
import 'package:tez_med_client/core/widgets/error_display_widget.dart';
import 'package:tez_med_client/presentation/clinic/bloc/clinic_bloc.dart';
import 'package:tez_med_client/presentation/clinic/widgets/clinic_loaded_widget.dart';
import 'package:tez_med_client/presentation/clinic/widgets/clinics_loading.dart';

@RoutePage()
class ClinicsScreen extends StatefulWidget {
  const ClinicsScreen({super.key});

  @override
  State<ClinicsScreen> createState() => _ClinicsScreenState();
}

class _ClinicsScreenState extends State<ClinicsScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadClinicsIfNeeded();
    });
  }

  void _loadClinicsIfNeeded() {
    final currentState = context.read<ClinicBloc>().state;
    if (currentState is! ClinicLoaded) {
      context.read<ClinicBloc>().add(const GetClinicsEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Klinikalar'),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              context.router.push(const ClinicsMapRoute());
            },
            icon: const Icon(FontAwesomeIcons.map),
          ),
        ],
      ),
      body: BlocBuilder<ClinicBloc, ClinicState>(
        buildWhen: (previous, current) {
          return current is ClinicLoading ||
              current is ClinicLoaded ||
              current is ClinicError;
        },
        builder: (context, state) {
          if (state is ClinicLoading) {
            return ClinicsLoading();
          } else if (state is ClinicLoaded) {
            return ClinicsLoadedView(
              clinicsModel: state.clinicsModel,
            );
          } else if (state is ClinicError) {
            return ErrorDisplayWidget(
              errorCode: state.message.code,
              onRetry: () {
                context.read<ClinicBloc>().add(const GetClinicsEvent());
              },
            );
          }
          return const Center(child: SizedBox());
        },
      ),
    );
  }
}

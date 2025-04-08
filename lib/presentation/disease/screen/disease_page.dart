import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tez_med_client/core/utils/app_color.dart';
import 'package:tez_med_client/core/utils/app_textstyle.dart';
import 'package:tez_med_client/core/widgets/no_interner_connection.dart';
import 'package:tez_med_client/core/widgets/server_connection.dart';
import 'package:tez_med_client/data/disease/model/disease_model.dart';
import 'package:tez_med_client/presentation/disease/bloc/disease_bloc.dart';
import 'package:tez_med_client/generated/l10n.dart';
import 'package:tez_med_client/presentation/disease/widgets/disease_card.dart';

@RoutePage()
class DiseasesScreen extends StatefulWidget {
  const DiseasesScreen({super.key});

  @override
  State<DiseasesScreen> createState() => _DiseasesScreenState();
}

class _DiseasesScreenState extends State<DiseasesScreen> {
  @override
  void initState() {
    super.initState();
    context.read<DiseaseBloc>().add(FetchDiseases());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.buttonBackColor,
      appBar: AppBar(
          leading: IconButton(
              onPressed: () => context.router.maybePop(),
              icon: const Icon(Icons.arrow_back_ios_new_rounded)),
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            S.of(context).diseaseCards,
            style: AppTextstyle.nunitoBold.copyWith(fontSize: 18),
          )),
      body: BlocBuilder<DiseaseBloc, DiseaseState>(
        builder: (context, state) {
          if (state is DiseaseInitial) {
            return Center(child: Text(S.of(context).waitingForData));
          } else if (state is DiseaseLoading) {
            return ListView.builder(
              itemCount: 3,
              padding: const EdgeInsets.all(12),
              itemBuilder: (context, index) {
                return Skeletonizer(
                  child: DiseaseCard(
                      disease: Diseasess(
                          id: "",
                          clientId: "",
                          scheduleId: "",
                          name: "",
                          photo: [],
                          description: "",
                          status: "",
                          createdAt: "2025/03/27 08:07:44")),
                );
              },
            );
          } else if (state is DiseaseEmpty) {
            return _buildEmptyState(context);
          } else if (state is DiseaseLoaded) {
            return _buildDiseasesList(context, state.diseases);
          } else if (state is DiseaseError) {
            return _buildErrorState(context, state.error.code);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.medical_information_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            S.of(context).noDiseaseCardsAvailable,
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, int code) {
    if (code == 400) {
      return NoInternetConnectionWidget(
        onRetry: () => context.read<DiseaseBloc>().add(FetchDiseases()),
      );
    } else if (code == 500) {
      return ServerConnection(
        onRetry: () => context.read<DiseaseBloc>().add(FetchDiseases()),
      );
    }
    return Center(child: Text(S.of(context).unexpected_error));
  }

  Widget _buildDiseasesList(BuildContext context, List<Diseasess> diseases) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(12),
      itemCount: diseases.length,
      itemBuilder: (context, index) {
        final disease = diseases[index];
        return DiseaseCard(disease: disease);
      },
    );
  }
}

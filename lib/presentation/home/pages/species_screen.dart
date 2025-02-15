import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tez_med_client/core/utils/app_color.dart';
import 'package:tez_med_client/core/utils/app_textstyle.dart';
import 'package:tez_med_client/core/widgets/no_interner_connection.dart';
import 'package:tez_med_client/core/widgets/server_connection.dart';
import 'package:tez_med_client/presentation/home/bloc/category_bloc/category_bloc.dart';
import 'package:tez_med_client/presentation/home/bloc/species_bloc/species_bloc.dart';
import 'package:tez_med_client/presentation/category/widgets/category_card.dart';
import 'package:tez_med_client/presentation/banner/screen/custom_banner.dart';
import 'package:tez_med_client/presentation/home/widgets/species_loading.dart';
import 'package:tez_med_client/presentation/request/widgets/yandex_map_service/location_service.dart';
import '../../../generated/l10n.dart';

class SpeciesScreen extends StatefulWidget {
  final int initialIndex;
  const SpeciesScreen({super.key, this.initialIndex = 0});

  @override
  State<SpeciesScreen> createState() => _SpeciesScreenState();
}

class _SpeciesScreenState extends State<SpeciesScreen> {
  late final LocationService _locationService;

  @override
  void initState() {
    super.initState();
    _locationService = LocationService();
    _locationService.getCurrentLocation();
  }

  Future<void> _refreshCategories() async {
    context.read<SpeciesBloc>().add(GetSpecies());
    _locationService.getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: RefreshIndicator(
        backgroundColor: Colors.white,
        color: AppColor.primaryColor,
        onRefresh: _refreshCategories,
        child: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(child: const CustomBanner()),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 16, right: 16, top: 16, bottom: 16),
                child: Text(
                  S.of(context).our_service,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 24,
                    color: Color(0xff1D2D50),
                    height: 29.05 / 24,
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: BlocBuilder<SpeciesBloc, SpeciesState>(
                builder: (context, speciesState) {
                  if (speciesState is SpeciesError) {
                    return _handleCategoryError(speciesState);
                  }
                  return _handleSpeciesState(speciesState);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _handleCategoryError(SpeciesError state) {
    if (state.error.code == 400) {
      return NoInternetConnectionWidget(
        onRetry: () {
          _locationService.getCurrentLocation();

          context.read<SpeciesBloc>().add(GetSpecies());
        },
      );
    } else if (state.error.code == 500) {
      return ServerConnection(
        onRetry: () {
          _locationService.getCurrentLocation();
          context.read<SpeciesBloc>().add(GetSpecies());
        },
      );
    }
    return Center(
      child: Text(
        S.of(context).unexpected_error,
        style: AppTextstyle.nunitoBold.copyWith(fontSize: 20),
      ),
    );
  }

  Widget _handleSpeciesState(SpeciesState state) {
    if (state is SpeciesLoading) {
      return const SpeciesLoadingWidget();
    } else if (state is SpeciesError) {
      if (state.error.code == 400) {
        return NoInternetConnectionWidget(
          onRetry: () {
            _locationService.getCurrentLocation();
            context.read<CategoryBloc>().add(GetCategory());
          },
        );
      } else if (state.error.code == 500) {
        return ServerConnection(
          onRetry: () {
            _locationService.getCurrentLocation();

            context.read<CategoryBloc>().add(GetCategory());
          },
        );
      }
      return Center(
        child: Text(
          S.of(context).unexpected_error,
          style: AppTextstyle.nunitoBold.copyWith(fontSize: 20),
        ),
      );
    } else if (state is SpeciesLoaded) {
      final speciesList = state.speciesModel.speciess;
      if (speciesList.isEmpty) {
        return Center(
          child: Icon(
            CupertinoIcons.doc_on_clipboard,
            size: 80,
            color: Colors.grey[400],
          ),
        );
      }
      return ListView.builder(
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        padding: EdgeInsets.only(left: 10, right: 10),
        itemCount: speciesList.length,
        itemBuilder: (context, index) {
          final species = speciesList[index];
          return CategoryCard(speciess: species);
        },
      );
    }
    return const SizedBox.shrink();
  }
}

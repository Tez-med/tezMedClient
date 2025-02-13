import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tez_med_client/core/bloc/language/language_bloc.dart';
import 'package:tez_med_client/core/utils/app_color.dart';
import 'package:tez_med_client/core/utils/app_textstyle.dart';
import 'package:tez_med_client/core/widgets/no_interner_connection.dart';
import 'package:tez_med_client/core/widgets/server_connection.dart';
import 'package:tez_med_client/presentation/home/bloc/category_bloc/category_bloc.dart';
import 'package:tez_med_client/presentation/home/bloc/species_bloc/species_bloc.dart';
import 'package:tez_med_client/presentation/category/widgets/category_card.dart';
import 'package:tez_med_client/presentation/home/widgets/category_loading.dart';
import 'package:tez_med_client/presentation/banner/screen/custom_banner.dart';
import 'package:tez_med_client/presentation/home/widgets/sliver_tabs_delegate.dart';
import 'package:tez_med_client/presentation/home/widgets/species_loading.dart';
import 'package:tez_med_client/presentation/request/widgets/yandex_map_service/location_service.dart';
import '../../../generated/l10n.dart';

class SpeciesScreen extends StatefulWidget {
  final int initialIndex;
  const SpeciesScreen({super.key, this.initialIndex = 0});

  @override
  State<SpeciesScreen> createState() => _SpeciesScreenState();
}

class _SpeciesScreenState extends State<SpeciesScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final ValueNotifier<int> categoryIndexNotifier = ValueNotifier<int>(0);
  late final LocationService _locationService;
  late SpeciesBloc speciesBloc;

  @override
  void initState() {
    super.initState();
    _locationService = LocationService();
    _locationService.getCurrentLocation();
    speciesBloc = context.read<SpeciesBloc>();
    context.read<CategoryBloc>().add(GetCategory());
  }

  Future<void> _refreshCategories() async {
    context.read<CategoryBloc>().add(GetCategory());
    categoryIndexNotifier.value = 0;
  }

  @override
  void dispose() {
    _tabController.dispose();
    categoryIndexNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: BlocBuilder<CategoryBloc, CategoryState>(
        builder: (context, state) {
          if (state is CategoryError) {
            return _handleCategoryError(state);
          } else if (state is CategoryLoading) {
            return const CategoryShimmerLoading();
          } else if (state is CategoryLoaded) {
            final activeCategories =
                state.category.where((element) => element.isActive).toList();

            if (activeCategories.isEmpty) {
              return const Center(child: Text("Kategoriya topilmadi."));
            }

            _tabController = TabController(
              initialIndex: widget.initialIndex,
              length: activeCategories.length,
              vsync: this,
            );

            speciesBloc
                .add(GetSpecies(activeCategories[widget.initialIndex].id));

            return RefreshIndicator(
              backgroundColor: Colors.white,
              color: AppColor.primaryColor,
              onRefresh: _refreshCategories,
              child: CustomScrollView(
                physics: BouncingScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(child: const CustomBanner()),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 16, right: 16, top: 16),
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
                  SliverPersistentHeader(
                    delegate: SliverTabBarDelegate(
                      tabBar: TabBar(
                        tabAlignment: TabAlignment.start,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        controller: _tabController,
                        isScrollable: true,
                        labelPadding: const EdgeInsets.symmetric(horizontal: 5),
                        dividerColor: Colors.transparent,
                        indicatorColor: Colors.transparent,
                        labelColor: Colors.transparent,
                        overlayColor:
                            const WidgetStatePropertyAll(Colors.transparent),
                        onTap: (value) {
                          categoryIndexNotifier.value = value;
                          speciesBloc
                              .add(GetSpecies(activeCategories[value].id));
                        },
                        tabs: List.generate(
                          activeCategories.length,
                          (index) => ValueListenableBuilder<int>(
                            valueListenable: categoryIndexNotifier,
                            builder: (context, selectedIndex, _) {
                              bool isSelected = selectedIndex == index;
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColor.primaryColor
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: BlocBuilder<LanguageBloc, LanguageState>(
                                  builder: (context, langState) {
                                    final langg = langState.locale.languageCode;
                                    return Text(
                                      langg == 'uz'
                                          ? activeCategories[index].nameUz
                                          : langg == 'en'
                                              ? activeCategories[index].nameEn
                                              : activeCategories[index].nameRu,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14.0,
                                        letterSpacing: 1.5,
                                        color: isSelected
                                            ? Colors.white
                                            : Colors.black87,
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    floating: false,
                  ),
                  SliverToBoxAdapter(
                    child: BlocBuilder<SpeciesBloc, SpeciesState>(
                      bloc: speciesBloc,
                      builder: (context, speciesState) {
                        return _handleSpeciesState(speciesState);
                      },
                    ),
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _handleCategoryError(CategoryError state) {
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

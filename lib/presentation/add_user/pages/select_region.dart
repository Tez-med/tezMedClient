import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tez_med_client/core/bloc/language/language_bloc.dart';
import 'package:tez_med_client/core/utils/app_color.dart';
import 'package:tez_med_client/core/utils/app_textstyle.dart';
import 'package:tez_med_client/presentation/add_user/bloc/region/region_bloc.dart';

import '../../../generated/l10n.dart';

class RegionSelector extends StatelessWidget {
  final String? selectedRegion;
  final Function(String region, String regionId) onRegionSelected;

  const RegionSelector({
    super.key,
    this.selectedRegion,
    required this.onRegionSelected,
  });

  void _showRegionSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: _RegionSelectorSheet(
            selectedRegion: selectedRegion,
            onRegionSelected: onRegionSelected,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showRegionSelector(context),
          borderRadius: BorderRadius.circular(15),
          child: Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                color: selectedRegion == null
                    ? Colors.grey
                    : AppColor.primaryColor,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  selectedRegion ?? S.of(context).select_region,
                  style: AppTextstyle.nunitoMedium.copyWith(
                    fontSize: 16,
                    color: selectedRegion == null ? Colors.grey : Colors.black,
                  ),
                ),
              ),
              const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}

class _RegionSelectorSheet extends StatefulWidget {
  final String? selectedRegion;
  final Function(String region, String regionId) onRegionSelected;

  const _RegionSelectorSheet({
    this.selectedRegion,
    required this.onRegionSelected,
  });

  @override
  State<_RegionSelectorSheet> createState() => _RegionSelectorSheetState();
}

class _RegionSelectorSheetState extends State<_RegionSelectorSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  String? _countryId;
  bool _isLoadingRegions = false;
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _filteredRegions = [];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
    _fetchCountry();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _fetchCountry() {
    context.read<RegionBloc>().add(FetchCountry());
  }

  void _fetchRegions(String countryId) {
    if (_countryId != countryId) {
      setState(() {
        _countryId = countryId;
        _isLoadingRegions = true;
      });
      context.read<RegionBloc>().add(FetchRegion(countryId));
    }
  }

  void _filterRegions(String query, List<dynamic> regions) {
    setState(() {
      if (query.isEmpty) {
        _filteredRegions = regions;
      } else {
        _filteredRegions = regions
            .where((region) =>
                region.nameUz.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.read<LanguageBloc>().state.locale;
    return FadeTransition(
      opacity: _animation,
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Text(
              S.of(context).select_region,
              style: AppTextstyle.nunitoBold.copyWith(fontSize: 20),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: S.of(context).search_region,
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  final state = context.read<RegionBloc>().state;
                  if (state is RegionLoaded) {
                    _filterRegions(value, state.regionModel.regions);
                  }
                }
              },
            ),
          ),
          Expanded(
            child: BlocConsumer<RegionBloc, RegionState>(
              listener: (context, state) {
                if (state is CountryLoaded) {
                  final uzbekistan = state.countryModel.countries.firstWhere(
                    (element) => element.nameEn.toLowerCase() == 'uzbekistan',
                    orElse: () => state.countryModel.countries.first,
                  );
                  _fetchRegions(uzbekistan.id);
                }
                if (state is RegionLoaded) {
                  setState(() {
                    _isLoadingRegions = false;
                    _filteredRegions = state.regionModel.regions;
                  });
                }
              },
              builder: (context, state) {
                if (state is RegionLoading || _isLoadingRegions) {
                  return _buildLoadingList();
                }

                if (state is RegionError) {
                  return _buildErrorView();
                }

                if (state is RegionLoaded) {
                  if (_filteredRegions.isEmpty &&
                      _searchController.text.isNotEmpty) {
                    return _buildEmptySearchResult();
                  }
                  return _buildRegionList(
                      _filteredRegions.isEmpty
                          ? state.regionModel.regions
                          : _filteredRegions,
                      lang.toString());
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingList() {
    return ListView.builder(
      itemCount: 8,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      itemBuilder: (context, index) => Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          height: 60,
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline_rounded,
            color: Colors.red,
            size: 60,
          ),
          const SizedBox(height: 16),
          Text(
            S.of(context).region_error,
            style: AppTextstyle.nunitoBold.copyWith(fontSize: 18),
          ),
          const SizedBox(height: 8),
          Text(
            S.of(context).region_error_desc,
            style: AppTextstyle.nunitoMedium.copyWith(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _fetchCountry,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Text(
              S.of(context).retry,
              style: AppTextstyle.nunitoBold.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptySearchResult() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.search_off_rounded,
            color: Colors.grey,
            size: 60,
          ),
          const SizedBox(height: 16),
          Text(
            S.of(context).region_empty,
            style: AppTextstyle.nunitoBold.copyWith(fontSize: 18),
          ),
          const SizedBox(height: 8),
          Text(
            S.of(context).region_empty_desc,
            style: AppTextstyle.nunitoMedium.copyWith(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildRegionList(List<dynamic> regions, String lang) {
    return ListView.builder(
      itemCount: regions.length,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      itemBuilder: (context, index) {
        final region = regions[index];
        final isSelected = (lang == 'uz'
                ? region.nameUz
                : lang == 'en'
                    ? region.nameEn
                    : region.nameRu) ==
            widget.selectedRegion;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.only(bottom: 8),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                widget.onRegionSelected(region.nameUz, region.id);
                Navigator.pop(context);
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColor.primaryColor.withValues(alpha: 0.1)
                      : Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  border: isSelected
                      ? Border.all(color: AppColor.primaryColor)
                      : null,
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      color: isSelected ? AppColor.primaryColor : Colors.grey,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        lang == 'uz'
                            ? region.nameUz
                            : lang == 'en'
                                ? region.nameEn
                                : region.nameRu,
                        style: AppTextstyle.nunitoMedium.copyWith(
                          color:
                              isSelected ? AppColor.primaryColor : Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    if (isSelected)
                      const Icon(
                        Icons.check_circle,
                        color: AppColor.primaryColor,
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

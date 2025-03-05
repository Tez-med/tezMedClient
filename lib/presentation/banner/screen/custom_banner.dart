import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tez_med_client/core/bloc/language/language_bloc.dart';
import 'package:tez_med_client/core/widgets/custom_cached_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tez_med_client/presentation/banner/bloc/banner_bloc.dart';

class CustomBanner extends StatefulWidget {
  const CustomBanner({super.key});

  @override
  State<CustomBanner> createState() => _CustomBannerState();
}

class _CustomBannerState extends State<CustomBanner> {
  late PageController _pageController;
  Timer? _timer;
  List<String> _banners = [];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
        initialPage: 1000, viewportFraction: 0.94, keepPage: true);
    _startAutoPlay();
  }

  void _startAutoPlay() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_pageController.hasClients) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 1000),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LanguageBloc, LanguageState>(
      listener: (context, state) {
        setState(() {}); // Til o'zgarsa UI ni yangilash
      },
      child: BlocBuilder<BannerBloc, BannerState>(
        builder: (context, state) {
          final lang = context.read<LanguageBloc>().state.locale.languageCode;
          final screenHeight = MediaQuery.of(context).size.height;
          final bannerHeight = screenHeight * 0.23;

          if (state is BannerLoading) {
            return _buildShimmer(bannerHeight);
          } else if (state is BannerLoaded) {
            _banners = state.data.banners
                .map((banner) => lang == "uz"
                    ? banner.photoSmUz
                    : lang == 'en'
                        ? banner.photoSmEn
                        : banner.photoSmRu)
                .toList();
            return _buildBannerView(_banners, bannerHeight);
          }
          return _buildShimmer(bannerHeight);
        },
      ),
    );
  }

  Widget _buildShimmer(double height) {
    return Container(
      height: height,
      margin: const EdgeInsets.only(top: 16),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[350]!,
        highlightColor: Colors.grey[300]!,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 5,
          padding: const EdgeInsets.symmetric(horizontal: 4),
          itemBuilder: (context, index) => Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: MediaQuery.of(context).size.width * 0.88,
            height: height,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBannerView(List<String> banners, double height) {
    return Container(
      height: height,
      color: const Color(0xffF9F9F9),
      margin: const EdgeInsets.only(top: 16),
      child: PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final banner = banners[index % banners.length]; // Cheksiz aylanish
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: CustomCachedImage(
              image: banner,
              borderRadius: BorderRadius.circular(20),
              fit: BoxFit.fill,
            ),
          );
        },
      ),
    );
  }
}

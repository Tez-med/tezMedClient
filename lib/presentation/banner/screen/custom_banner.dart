import 'dart:async';
import 'dart:io';
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
          final screenWidth = MediaQuery.of(context).size.width;
          final screenHeight = MediaQuery.of(context).size.height;

          // iPad qurilmasini aniqlash
          final bool isIpad = Platform.isIOS && screenWidth >= 768;

          // iPad uchun balandlikni kattaroq qilish
          final bannerHeight =
              isIpad ? screenHeight * 0.3 : screenHeight * 0.23;

          if (state is BannerLoading) {
            return _buildShimmer(bannerHeight, isIpad);
          } else if (state is BannerLoaded) {
            // iPad uchun photoXl va boshqa qurilmalar uchun photoSm tanlash
            _banners = state.data.banners.map((banner) {
              if (isIpad) {
                // iPad uchun photoXl variantini ishlatamiz
                return lang == "uz"
                    ? banner.photoLgUz
                    : lang == 'en'
                        ? banner.photoLgEn
                        : banner.photoLgRu;
              } else {
                // Boshqa qurilmalar uchun photoSm variantini ishlatamiz
                return lang == "uz"
                    ? banner.photoSmUz
                    : lang == 'en'
                        ? banner.photoSmEn
                        : banner.photoSmRu;
              }
            }).toList();
            return _buildBannerView(_banners, bannerHeight, isIpad);
          }
          return _buildShimmer(bannerHeight, isIpad);
        },
      ),
    );
  }

  Widget _buildShimmer(double height, bool isIpad) {
    return Container(
      height: height,
      margin: EdgeInsets.only(top: isIpad ? 24 : 16),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[350]!,
        highlightColor: Colors.grey[300]!,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 5,
          padding: EdgeInsets.symmetric(horizontal: isIpad ? 8 : 4),
          itemBuilder: (context, index) => Container(
            margin: EdgeInsets.symmetric(horizontal: isIpad ? 8 : 4),
            // iPad uchun kengroq banner
            width: MediaQuery.of(context).size.width * (isIpad ? 0.92 : 0.88),
            height: height,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(isIpad ? 30 : 24),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBannerView(List<String> banners, double height, bool isIpad) {
    return Container(
      height: height,
      color: const Color(0xffF9F9F9),
      margin: EdgeInsets.only(top: isIpad ? 24 : 16),
      child: PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final banner = banners[index % banners.length]; // Cheksiz aylanish
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: isIpad ? 8 : 4),
            child: CustomCachedImage(
              image: banner,
              borderRadius: BorderRadius.circular(isIpad ? 26 : 20),
              fit: BoxFit.fill,
            ),
          );
        },
      ),
    );
  }
}

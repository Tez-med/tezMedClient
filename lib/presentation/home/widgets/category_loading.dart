import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tez_med_client/generated/l10n.dart';
import 'package:tez_med_client/presentation/banner/screen/custom_banner.dart';

class CategoryShimmerLoading extends StatelessWidget {
  const CategoryShimmerLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBannerSection(),
          SizedBox(height: 10),
          Padding(
            padding:
                const EdgeInsets.only(left: 16, right: 16, top: 9, bottom: 5),
            child: Text(
              S.of(context).our_service,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 24,
                color: Color(0xff1D2D50),
                height: 29.05 / 24,
              ),
            ),
          ),
          SizedBox(
            height: 40,
            child: ListView.builder(
              padding: EdgeInsets.only(left: 10, right: 10, top: 5),
              itemCount: 2,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Container(
                      width: 100,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: ListView.builder(
          //     shrinkWrap: true,
          //     physics: const NeverScrollableScrollPhysics(),
          //     itemCount: 6,
          //     itemBuilder: (context, index) {
          //       return Card(
          //         elevation: 0,
          //         color: Colors.white,
          //         child: Padding(
          //           padding: const EdgeInsets.all(8.0),
          //           child: Shimmer.fromColors(
          //             baseColor: Colors.grey[300]!,
          //             highlightColor: Colors.grey[100]!,
          //             child: Row(
          //               crossAxisAlignment: CrossAxisAlignment.start,
          //               children: [
          //                 Shimmer.fromColors(
          //                   baseColor: Colors.grey[300]!,
          //                   highlightColor: Colors.grey[100]!,
          //                   child: Container(
          //                     width: 90,
          //                     height: 81,
          //                     decoration: BoxDecoration(
          //                       color: Colors.white,
          //                       borderRadius: BorderRadius.circular(15),
          //                     ),
          //                   ),
          //                 ),
          //                 const SizedBox(width: 12),
          //                 // Column with text widgets
          //                 Column(
          //                   mainAxisAlignment: MainAxisAlignment.start,
          //                   crossAxisAlignment: CrossAxisAlignment.start,
          //                   children: [
          //                     // First shimmer text
          //                     Shimmer.fromColors(
          //                       baseColor: Colors.grey[300]!,
          //                       highlightColor: Colors.grey[100]!,
          //                       child: Container(
          //                         width: 120,
          //                         height: 16,
          //                         color: Colors.white,
          //                       ),
          //                     ),
          //                     const SizedBox(height: 6),
          //                     // Second shimmer text
          //                     Shimmer.fromColors(
          //                       baseColor: Colors.grey[300]!,
          //                       highlightColor: Colors.grey[100]!,
          //                       child: Container(
          //                         width: 150,
          //                         height: 16,
          //                         color: Colors.white,
          //                       ),
          //                     ),
          //                   ],
          //                 ),
          //               ],
          //             ),
          //           ),
          //         ),
          //       );
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildBannerSection() {
    return const CustomBanner();
  }
}

import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tez_med_client/core/utils/app_color.dart';
import 'package:tez_med_client/gen/assets.gen.dart';

class DoctorDetailsSkeleton extends StatelessWidget {
  const DoctorDetailsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
      child: Scaffold(
        backgroundColor: const Color(0xffF9F9F9),
        body: Skeletonizer(
          enabled: true,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [
                  // Handle bar
                  Container(
                    width: 60,
                    height: 5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color(0xffB6B6B6),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Profile Image
                  Container(
                    width: 100,
                    height: 100,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Doctor Name
                  const Text(
                    "Dr. John Doe Smith Wilson",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 22,
                      height: 26.63 / 22,
                      letterSpacing: 0.5,
                      color: AppColor.textColor,
                    ),
                  ),
                  const Text(
                    "Kardiolog mutaxassis",
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColor.greyTextColor,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Stats Container
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildExperienceItem(),
                        Container(
                          width: 1.5,
                          height: 40,
                          color: AppColor.buttonBackColor,
                        ),
                        _buildRatingItem(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Calendar Section
                  Row(
                    children: [
                      Text(
                        "Sana va vaqtni tanlang",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          height: 16.94 / 14,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),

                  // Calendar Container
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: _buildCalendarSkeleton(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExperienceItem() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFFF5F7FB),
          ),
          child: Assets.icons.expirense.svg(),
        ),
        const SizedBox(width: 8),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Ish tajribasi",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColor.greyTextColor,
              ),
            ),
            Text(
              "8 yil",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1C1E),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRatingItem() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFFF5F7FB),
          ),
          child: Assets.icons.doctorStar.svg(),
        ),
        const SizedBox(width: 10),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Reyting",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColor.greyTextColor,
              ),
            ),
            Text(
              "4.8",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1C1E),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCalendarSkeleton() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Monthhhhhhhhh"),
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColor.buttonBackColor,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 5),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColor.buttonBackColor,
                    shape: BoxShape.circle,
                  ),
                )
              ],
            )
          ],
        ),
        SizedBox(height: 10),
        // Days Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            7,
            (index) => Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  "${index + 1}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ),

        // Time Slots Grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 2.5,
          ),
          itemCount: 9,
          itemBuilder: (context, index) => Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Text(
                "00:00",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

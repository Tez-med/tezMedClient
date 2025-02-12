import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tez_med_client/core/routes/app_routes.gr.dart';
import 'package:tez_med_client/core/widgets/custom_cached_image.dart';
import 'package:shimmer/shimmer.dart'; // Import the shimmer package

import '../../../core/utils/app_color.dart';
import '../../../data/profile/model/client_model.dart';

class ProfileHeader extends StatelessWidget {
  final ClientModel? clientModel;
  final VoidCallback? onEditPressed;

  const ProfileHeader({
    super.key,
    this.clientModel,
    this.onEditPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () {
          if (clientModel != null) {
            context.router.push(ProfileUpdateRoute(clientModel: clientModel!));
          }
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: clientModel == null
              ? _buildShimmerLoading()
              : Row(
                  children: [
                    SizedBox(
                      width: 50,
                      height: 50,
                      child: ClipOval(
                        child: clientModel!.photo.isEmpty
                            ? Icon(
                                CupertinoIcons.person_alt_circle_fill,
                                color: Colors.grey.shade400,
                                size: 55,
                              )
                            : CustomCachedImage(
                                image: clientModel!.photo,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                    Expanded(
                      child: ListTile(
                        title: Text(
                          clientModel!.fullName,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        subtitle: Row(
                          children: [
                            Icon(
                              Icons.phone_outlined,
                              size: 16,
                              color: Colors.grey.shade600,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              clientModel!.phoneNumber,
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: AppColor.primaryColor,
                      size: 17,
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  // Shimmer loading effect
  Widget _buildShimmerLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: 16,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 100,
                    height: 14,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

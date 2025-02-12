import 'package:flutter/material.dart';
import 'package:tez_med_client/core/widgets/custom_cached_image.dart';
import 'package:tez_med_client/data/profile/model/client_model.dart';

class ProfileAvatarWidget extends StatelessWidget {
  final ClientModel clientModel;

  const ProfileAvatarWidget({super.key, required this.clientModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: clientModel.photo.isEmpty
            ? Text(
                clientModel.fullName.substring(0, 1),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade700,
                ),
              )
            : CircleAvatar(
                backgroundColor: Colors.white,
                radius: 50,
                child: CustomCachedImage(
                  isProfile: true,
                  image:  clientModel.photo,
                  fit: BoxFit.cover,
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}

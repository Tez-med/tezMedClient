import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tez_med_client/core/widgets/custom_cached_image.dart';
import 'package:tez_med_client/presentation/profile/pages/profile_update_screen.dart';
import 'package:tez_med_client/presentation/request/bloc/file_upload/file_upload_bloc.dart';

class ProfileImage extends StatelessWidget {
  const ProfileImage({
    super.key,
    this.imageFile,
    required this.widget,
    required this.state,
  });

  final File? imageFile;
  final ProfileUpdateScreen widget;
  final FileUploadState state;

  @override
  Widget build(BuildContext context) {
    if (state is ImageUploadProgress) {
      return Stack(
        alignment: Alignment.center,
        children: [
          if (imageFile != null)
            CircleAvatar(
              radius: 40,
              backgroundImage: FileImage(imageFile!),
            )
          else if (widget.clientModel.photo.isNotEmpty)
            CircleAvatar(
              radius: 40,
              child: CustomCachedImage(
                image: widget.clientModel.photo,
                isProfile: true,
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
            )
          else
            const CircleAvatar(
              radius: 40,
              backgroundColor: Colors.grey,
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black.withValues(alpha: 0.5),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(
                  value: state.progress,
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 3,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${(state.progress * 100).toInt()}%',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      );
    } else if (imageFile != null) {
      return CircleAvatar(
        radius: 50,
        backgroundImage: FileImage(imageFile!),
      );
    } else if (widget.clientModel.photo.isNotEmpty) {
      return CircleAvatar(
        backgroundColor: Colors.white,
        radius: 50,
        child: CustomCachedImage(
          image: widget.clientModel.photo,
          isProfile: true,
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
      );
    } else {
      return const CircleAvatar(
        radius: 40,
        backgroundColor: Colors.grey,
        child: Icon(
          Icons.person,
          size: 50,
          color: Colors.white,
        ),
      );
    }
  }
}

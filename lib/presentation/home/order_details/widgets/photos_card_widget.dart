import 'package:flutter/material.dart';
import 'package:tez_med_client/core/utils/app_textstyle.dart';
import 'package:tez_med_client/core/widgets/custom_cached_image.dart';
import 'package:tez_med_client/data/requests_get/model/get_by_id_request_model.dart';
import 'package:tez_med_client/generated/l10n.dart';
import 'package:tez_med_client/presentation/home/order_details/widgets/photo_view.dart';

class PhotosCard extends StatelessWidget {
  const PhotosCard({
    super.key,
    required this.requestss,
  });

  final GetByIdRequestModel requestss;

  void _openGallery(BuildContext context, int initialIndex) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GalleryPhotoViewWrapper(
          galleryItems: requestss.photos,
          initialIndex: initialIndex,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              S.of(context).order_photo,
              style: AppTextstyle.nunitoBold.copyWith(fontSize: 20),
            ),
            const SizedBox(height: 10),
            if (requestss.photos.isNotEmpty)
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: requestss.photos.length,
                  itemBuilder: (context, index) {
                    final image = requestss.photos[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: GestureDetector(
                        onTap: () => _openGallery(context, index),
                        child: Hero(
                          tag: image,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: CustomCachedImage(
                              image:  image,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              )
          ],
        ),
      ),
    );
  }
}

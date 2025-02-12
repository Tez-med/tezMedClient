
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:tez_med_client/core/constant/image_url.dart';
import 'package:tez_med_client/core/utils/app_color.dart';

class GalleryPhotoViewWrapper extends StatefulWidget {
  const GalleryPhotoViewWrapper({
    super.key,
    required this.galleryItems,
    this.initialIndex = 0,
  });

  final List<String> galleryItems;
  final int initialIndex;

  @override
  State<GalleryPhotoViewWrapper> createState() =>
      _GalleryPhotoViewWrapperState();
}

class _GalleryPhotoViewWrapperState extends State<GalleryPhotoViewWrapper> {
  late int currentIndex = widget.initialIndex;
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          "${currentIndex + 1} / ${widget.galleryItems.length}",
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: PhotoViewGallery.builder(
        scrollPhysics: const BouncingScrollPhysics(),
        builder: (BuildContext context, int index) {
          return PhotoViewGalleryPageOptions(
            imageProvider: CachedNetworkImageProvider(
              imageUrl + widget.galleryItems[index],
            ),
            initialScale: PhotoViewComputedScale.contained,
            heroAttributes: PhotoViewHeroAttributes(
              tag: widget.galleryItems[index],
            ),
          );
        },
        itemCount: widget.galleryItems.length,
        loadingBuilder: (context, event) => const Center(
          child: CircularProgressIndicator(
            color: AppColor.primaryColor,
          ),
        ),
        pageController: pageController,
        onPageChanged: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}

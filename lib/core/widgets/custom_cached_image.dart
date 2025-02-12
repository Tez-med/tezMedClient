import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tez_med_client/config/environment.dart';
import 'package:tez_med_client/core/constant/image_url.dart';

class CustomCachedImage extends StatelessWidget {
  final String image;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final Widget? errorWidget;
  final Widget? placeholder;
  final BorderRadius? borderRadius;
  final Duration? fadeInDuration;
  final bool showLoading;
  final Widget Function(BuildContext, ImageProvider<Object>)? imageBuilder;
  final bool showShimmer;
  final bool isProfile;
  final bool isCategory;

  const CustomCachedImage({
    super.key,
    required this.image,
    this.width,
    this.height,
    this.imageBuilder,
    this.fit = BoxFit.cover,
    this.errorWidget,
    this.placeholder,
    this.borderRadius,
    this.fadeInDuration = const Duration(milliseconds: 500),
    this.showLoading = true,
    this.showShimmer = true,
    this.isProfile = false,
    this.isCategory = false,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: isProfile || isCategory
          ? const BorderRadius.all(Radius.circular(0))
          : (borderRadius ?? BorderRadius.zero),
      child: isProfile || isCategory
          ? ClipOval(
              child: _buildCachedImage(),
            )
          : _buildCachedImage(),
    );
  }

  Widget _buildCachedImage() {
    return CachedNetworkImage(
      imageUrl:
          (EnvironmentConfig.instance.isProd ? imageUrl : imageUrlDev) + image,
      width: width,
      height: height,
      imageBuilder: imageBuilder,
      fit: fit,
      fadeInDuration: fadeInDuration!,
      placeholder: (context, url) => placeholder ?? _buildShimmerEffect(),
      errorWidget: (context, url, error) =>
          errorWidget ?? _buildErrorWidget(context),
    );
  }

  Widget _buildShimmerEffect() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: isProfile || isCategory
            ? null
            : (borderRadius ?? BorderRadius.zero),
        shape: isProfile || isCategory ? BoxShape.circle : BoxShape.rectangle,
      ),
      child: showShimmer
          ? Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                width: width,
                height: height,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: isProfile || isCategory
                      ? null
                      : (borderRadius ?? BorderRadius.zero),
                  shape: isProfile || isCategory
                      ? BoxShape.circle
                      : BoxShape.rectangle,
                ),
              ),
            )
          : Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: isProfile || isCategory
                    ? null
                    : (borderRadius ?? BorderRadius.zero),
                shape: isProfile || isCategory
                    ? BoxShape.circle
                    : BoxShape.rectangle,
              ),
              child: Center(
                child: SizedBox(
                  width: isProfile || isCategory ? (width ?? 100) * 0.3 : 24,
                  height: isProfile || isCategory ? (height ?? 100) * 0.3 : 24,
                  child: CircularProgressIndicator(
                    strokeWidth:
                        isProfile || isCategory ? (width ?? 100) * 0.03 : 2,
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildErrorWidget(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: isProfile || isCategory
            ? null
            : (borderRadius ?? BorderRadius.zero),
        shape: isProfile || isCategory ? BoxShape.circle : BoxShape.rectangle,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Orqa fon pattern
          Positioned.fill(
            child: CustomPaint(
              painter:
                  isProfile || isCategory ? CircleGridPainter() : GridPainter(),
            ),
          ),
          // Asosiy error container
          Container(
            width: (width ?? 100) * (isProfile || isCategory ? 0.6 : 0.4),
            height: (height ?? 100) * (isProfile || isCategory ? 0.6 : 0.4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.9),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Icon(
              _getErrorIcon(),
              size: (width ?? 100) * (isProfile || isCategory ? 0.35 : 0.2),
              color: Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getErrorIcon() {
    if (isProfile) {
      return Icons.person_rounded;
    } else if (isCategory) {
      return Icons
          .medical_services_rounded; // Tibbiyot kategoriyasi uchun ikonka
    } else {
      return Icons.medical_information; // Oddiy tibbiyot rasmlari uchun ikonka
    }
  }
}

// Circle pattern chizish uchun custom painter
class CircleGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey[200]!
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width / 2;
    const spacing = 8.0;

    for (double radius = spacing; radius <= maxRadius; radius += spacing) {
      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Grid pattern chizish uchun custom painter
class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey[200]!
      ..strokeWidth = 1.0;

    const int spacing = 10;

    // Gorizontal chiziqlar
    for (var i = 0; i < size.height; i += spacing) {
      canvas.drawLine(
        Offset(0, i.toDouble()),
        Offset(size.width, i.toDouble()),
        paint,
      );
    }

    // Vertikal chiziqlar
    for (var i = 0; i < size.width; i += spacing) {
      canvas.drawLine(
        Offset(i.toDouble(), 0),
        Offset(i.toDouble(), size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

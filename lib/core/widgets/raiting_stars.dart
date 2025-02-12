import 'package:flutter/material.dart';

class PreciseRatingStars extends StatelessWidget {
  final double rating;
  final double size;
  final Color activeColor;
  final Color inactiveColor;
  final bool showRating;
  final TextStyle? ratingTextStyle;
  final EdgeInsets? padding;

  const PreciseRatingStars({
    super.key,
    required this.rating,
    this.size = 20,
    this.activeColor = Colors.amber,
    this.inactiveColor = Colors.grey,
    this.showRating = true,
    this.ratingTextStyle,
    this.padding,
  }) : assert(rating >= 0 && rating <= 5, 'Rating must be between 0 and 5');

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: _buildStars(),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildStars() {
    final List<Widget> stars = [];
    final int fullStars = rating.floor();
    final double partial = _calculatePartialStar(rating);

    // To'liq yulduzlar
    for (int i = 0; i < fullStars; i++) {
      stars.add(_buildStar(1.0));
    }

    // Qisman to'ldirilgan yulduz
    if (fullStars < 5) {
      if (partial > 0) {
        stars.add(_buildPartialStar(partial));
      }

      // Bo'sh yulduzlar
      for (int i = 0; i < 4 - fullStars - (partial > 0 ? 0 : -1); i++) {
        stars.add(_buildStar(0.0));
      }
    }

    return stars;
  }

  Widget _buildStar(double fill) {
    return Icon(
      fill > 0 ? Icons.star_rounded : Icons.star_outline_rounded,
      color: fill > 0 ? activeColor : inactiveColor,
      size: size,
    );
  }

  Widget _buildPartialStar(double partial) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          // Bo'sh yulduz orqa fonda
          Icon(
            Icons.star_rounded,
            color: inactiveColor,
            size: size,
          ),
          // Qisman to'ldirilgan yulduz
          ClipRect(
            child: Align(
              alignment: Alignment.centerLeft,
              widthFactor: partial,
              child: Icon(
                Icons.star_rounded,
                color: activeColor,
                size: size,
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _calculatePartialStar(double rating) {
    final double partial = rating - rating.floor();
    // Aniqlikni oshirish uchun yaxlitlash
    return (partial * 10).round() / 10;
  }
}

// Rating Provider - Reytingni aniq hisoblash uchun
class RatingCalculator {
  /// Reytingni 0.1 aniqlik bilan hisoblaydi
  static double calculatePreciseRating(double rating) {
    // 0.1 aniqlikkacha yaxlitlash
    return (rating * 10).round() / 10;
  }

  /// Yulduzlarni to'ldirish darajasini hisoblaydi (0.0 dan 1.0 gacha)
  static double calculateStarFill(double rating, int starIndex) {
    if (rating >= starIndex + 1) return 1.0;
    if (rating < starIndex) return 0.0;
    return rating - starIndex;
  }

  /// Reytingni tekst formatiga o'tkazadi
  static String formatRating(double rating) {
    if (rating == 0) return '0';
    if (rating == rating.roundToDouble()) {
      return rating.toStringAsFixed(0);
    }
    String formatted = rating.toStringAsFixed(2);
    // Oxiridagi nollarni olib tashlash
    while (formatted.endsWith('0')) {
      formatted = formatted.substring(0, formatted.length - 1);
    }
    if (formatted.endsWith('.')) {
      formatted = formatted.substring(0, formatted.length - 1);
    }
    return formatted;
  }
}

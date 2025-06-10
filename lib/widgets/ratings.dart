import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MaskedRatingBar extends StatelessWidget {
  final double rating;
  final int starCount;
  final double starSize;
  final Color filledColor;
  final Color unfilledColor;

  const MaskedRatingBar({
    super.key,
    required this.rating,
    this.starCount = 5,
    this.starSize = 14,
    this.filledColor = const Color.fromARGB(255, 249, 207, 38),
    this.unfilledColor = const Color.fromARGB(255, 214, 214, 214),
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            starCount,
            (_) => Icon(Icons.star, color: unfilledColor, size: starSize),
          ),
        ),

        ClipRect(
          clipper: _RatingClipper(rating / starCount),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              starCount,
              (_) => Icon(
                CupertinoIcons.star_fill,
                color: filledColor,
                size: starSize,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _RatingClipper extends CustomClipper<Rect> {
  final double percent;

  _RatingClipper(this.percent);

  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(0, 0, size.width * percent, size.height);
  }

  @override
  bool shouldReclip(_RatingClipper oldClipper) {
    return oldClipper.percent != percent;
  }
}

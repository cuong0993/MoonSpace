import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_custom_carousel/flutter_custom_carousel.dart';

class AnimatedCarousel extends StatefulWidget {
  const AnimatedCarousel({
    super.key,
    required this.cardWidth,
    required this.cardHeight,
    required this.scaleRatio,
    required this.translateRatio,
    required this.opacityRatio,
    this.overlap =
        0.0, // Add overlap parameter (0.0 = no overlap, 1.0 = full overlap)
  }) : assert(
         overlap >= 0.0 && overlap <= 1.0,
         'Overlap must be between 0.0 and 1.0',
       );

  final double cardWidth;
  final double cardHeight;
  final double scaleRatio;
  final double translateRatio;
  final double opacityRatio;
  final double overlap; // New parameter

  @override
  State<AnimatedCarousel> createState() => _AnimatedCarouselState();
}

class _AnimatedCarouselState extends State<AnimatedCarousel> {
  late CustomCarouselScrollController _controller;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = CustomCarouselScrollController(initialItem: _selectedIndex);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Calculate margin based on overlap
    final horizontalMargin = widget.cardWidth * (1.0 - widget.overlap);

    return SizedBox(
      height: widget.cardHeight,
      child: CustomCarousel(
        itemCountBefore: 2,
        itemCountAfter: 2,
        scrollDirection: Axis.horizontal,
        loop: true,
        controller: _controller,
        alignment: Alignment.center,
        effectsBuilder: (_, ratio, child) {
          // Adjust translation to account for card width and overlap

          final translation =
              ratio *
              (widget.cardWidth + horizontalMargin) *
              widget.translateRatio;
          return Transform.translate(
            offset: Offset(translation, 0),
            child: Transform.scale(
              scale: 1.0 - (ratio.abs() * widget.scaleRatio),
              child: Opacity(
                opacity: 1,
                // opacity: 1.0 - (ratio.abs() * widget.opacityRatio),
                child: child,
              ),
            ),
          );
        },
        onSelectedItemChanged: (value) => setState(() {
          _selectedIndex = value;
        }),
        children: List.generate(
          5,
          (index) => _CarouselCard(
            index: index,
            isSelected: index == _selectedIndex,
            width: widget.cardWidth,
            height: widget.cardHeight,
            color: Color(
              (math.Random().nextDouble() * 0xFFFFFF).toInt(),
            ).withOpacity(1.0),
            horizontalMargin: horizontalMargin / 2, // Pass calculated margin
          ),
        ),
      ),
    );
  }
}

class _CarouselCard extends StatelessWidget {
  const _CarouselCard({
    required this.index,
    required this.isSelected,
    required this.width,
    required this.height,
    required this.color,
    required this.horizontalMargin,
  });

  final int index;
  final bool isSelected;
  final double width;
  final double height;
  final Color color;
  final double horizontalMargin;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      // Apply half of the margin to each side
      margin: EdgeInsets.symmetric(horizontal: horizontalMargin / 2),
      decoration: BoxDecoration(
        color: color.withOpacity(1.0),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Text(
          'Card ${index + 1}',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

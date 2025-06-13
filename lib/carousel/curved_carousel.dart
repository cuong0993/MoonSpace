import 'package:flutter/widgets.dart';
import 'package:flutter_custom_carousel/flutter_custom_carousel.dart';

class CurvedCarousel extends StatelessWidget {
  const CurvedCarousel({
    super.key,
    required this.count,
    this.height = 100,
    this.width = 170,
    this.controller,
    this.rotationMultiplier = 0.2,
    this.yMultiplier = 50,
    this.scaleMin = 0.9,
    this.opacityMin = 0.5,
    this.alignment = Alignment.center,
    required this.builder,
  });

  final int count;
  final CustomCarouselScrollController? controller;
  final double height;
  final double width;
  final double rotationMultiplier;
  final double scaleMin;
  final double opacityMin;
  final double yMultiplier;
  final Alignment? alignment;
  final Widget Function(int index) builder;

  @override
  Widget build(BuildContext context) {
    // Build a list of widgets for the carousel items:
    List<Widget> items = List.generate(count, (i) => builder(i));

    Widget carousel = CustomCarousel(
      itemCountBefore: 2,
      itemCountAfter: 2,
      controller: controller,
      alignment: alignment,
      scrollDirection: Axis.horizontal,
      loop: true,
      depthOrder: DepthOrder.selectedInFront,
      tapToSelect: false,
      effectsBuilder: (_, ratio, child) {
        double angle = ratio * rotationMultiplier;
        double distance = ratio.abs();

        double scale = (1 - distance).clamp(scaleMin, 1.0);
        double opacity = (1 - distance).clamp(opacityMin, 1.0);

        double yOffset = distance * yMultiplier;

        return Opacity(
          opacity: opacity,
          child: Transform.translate(
            offset: Offset(ratio * width * 3, yOffset),
            child: Transform.rotate(
              angle: angle,
              child: Transform.scale(scale: scale, child: child),
            ),
          ),
        );
      },
      // Pass in the list of widgets we created above:
      children: items,
    );

    return SizedBox(height: height, child: carousel);
  }
}

import 'dart:math';

import 'package:flutter/material.dart';

class AnimatedSlideButton extends StatefulWidget {
  const AnimatedSlideButton({super.key, this.radius, this.width, this.height});

  final double? radius;
  final double? width;
  final double? height;

  @override
  State<AnimatedSlideButton> createState() => _AnimatedSlideButtonState();
}

class _AnimatedSlideButtonState extends State<AnimatedSlideButton>
    with SingleTickerProviderStateMixin {
  double position = 0;
  bool dragging = false;
  double stop = 0;
  late double width;
  late double height;
  late double radius;
  @override
  void initState() {
    width = widget.width ?? 100;
    height = widget.height ?? 50;
    radius = widget.radius ?? 40;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragStart: (details) {
        dragging = true;
      },
      onHorizontalDragEnd: (details) {
        stop = position;
        dragging = false;
        setState(() {});
      },
      onHorizontalDragUpdate: (details) {
        position = details.localPosition.dx;
        position = position < 0 ? 0 : position;
        position = position > (width - radius) ? (width - radius) : position;

        setState(() {});
      },
      onTapUp: (details) {
        if (!dragging) {
          position = details.localPosition.dx;
          setState(() {});
        }
      },
      child: Container(
        color: Colors.yellow,
        width: width,
        height: height,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Positioned(
            //   left: 0,
            //   child: ShimmerBox(
            //     isLoading: position > width / 2,
            //     loadingChild: Container(color: Colors.red),
            //     child: Container(
            //       color: Colors.blue,
            //       child: const Text('Left'),
            //     ),
            //   ),
            // ),
            // Positioned(
            //   right: 0,
            //   child: ShimmerBox(
            //     isLoading: position > width / 2,
            //     loadingChild: Container(color: Colors.red),
            //     child: Container(
            //       color: Colors.blue,
            //       child: const Text('Right'),
            //     ),
            //   ),
            // ),
            TweenAnimationBuilder<double>(
              duration: Duration(milliseconds: 100),
              tween: Tween<double>(
                begin: position,
                end: dragging
                    ? position
                    : (position < width / 2 ? 0 : width - radius),
              ),
              curve: Curves.easeInOut,
              builder: (context, value, child) {
                return Positioned(
                  left: dragging ? position : value,
                  top: height / 2 - radius / 2,
                  child: Transform.rotate(
                    angle: 2 *
                        pi, // * ((dragging ? position : value) / (width - radius)),
                    child: Container(
                      color: Colors.red,
                      width: radius,
                      height: radius,
                      child: Text(
                        '$value ${position.toStringAsFixed(1)}',
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:math';

import 'package:flutter/material.dart';

class NeonButton extends StatefulWidget {
  final Color color;
  final Widget Function(bool completed) builder;
  final Duration? duration;
  final VoidCallback? onTap;
  final bool animateAfterChanges;

  const NeonButton({
    super.key,
    this.duration,
    this.onTap,
    this.animateAfterChanges = true,
    required this.color,
    required this.builder,
  });

  @override
  State<NeonButton> createState() => _NeonButtonState();
}

class _NeonButtonState extends State<NeonButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final ValueNotifier<bool> _notifierCompleted = ValueNotifier(false);

  @override
  void didUpdateWidget(NeonButton oldWidget) {
    if (widget.animateAfterChanges) {
      _notifierCompleted.value = false;
      _controller.forward(from: 0.0);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration ?? const Duration(milliseconds: 2000),
    );
    _controller.forward();
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _notifierCompleted.value = true;
      }
    });

    // _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const padding = 20.0;
    return Padding(
      padding: const EdgeInsets.all(padding),
      child: CustomPaint(
        painter: _NeonLinePainter(animation: _controller, color: widget.color),
        child: ValueListenableBuilder<bool>(
          valueListenable: _notifierCompleted,
          builder: (context, completed, _) {
            return Material(
              color: Colors.transparent,
              // color: completed ? widget.color : Colors.transparent,
              child: InkWell(
                onTap: () {
                  // _controller?.reset();
                  widget.onTap?.call();
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  alignment: Alignment.center,
                  // decoration: BoxDecoration(
                  //   boxShadow: completed
                  //       ? [
                  //           BoxShadow(
                  //             blurRadius: padding,
                  //             spreadRadius: padding,
                  //             color: widget.color.withAlpha(200),
                  //           ),
                  //         ]
                  //       : null,
                  // ),
                  child: Padding(
                    padding: const EdgeInsets.all(padding),
                    child: FittedBox(child: widget.builder(completed)),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _NeonLinePainter extends CustomPainter {
  final Animation? animation;
  final Color color;

  _NeonLinePainter({this.animation, this.color = Colors.transparent})
    : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final Paint paint = Paint()..color = Colors.transparent;
    final progress = animation!.value;

    if (progress < 1.0) {
      paint.color = Colors.black;
      paint.shader = SweepGradient(
        colors: const [
          Colors.red,
          Colors.blue,
          Colors.yellow,
          Colors.green,
          Colors.white,
          Colors.black,
        ],
        stops: const [0.0, 0.2, 0.4, 0.6, 0.8, 1.0],
        startAngle: pi / 8,
        endAngle: pi / 2,
        transform: GradientRotation(pi * 2 * progress),
      ).createShader(rect);

      final rr = RRect.fromRectAndRadius(rect, Radius.circular(32));

      final path = Path.combine(
        PathOperation.xor,
        Path()..addRRect(rr),
        Path()..addRRect(rr.deflate(4.0)),
      );
      canvas.drawPath(path, paint);
    }

    if (progress == 1.0) {
      final rr = RRect.fromRectAndRadius(rect, Radius.circular(32));

      final path = Path()..addRRect(rr);

      paint.color = color;

      // final path = Path.combine(
      //   PathOperation.xor,
      //   Path()..addRRect(rr),
      //   Path()..addRRect(rr.deflate(4.0)),
      // );
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(_NeonLinePainter oldDelegate) => true;
}

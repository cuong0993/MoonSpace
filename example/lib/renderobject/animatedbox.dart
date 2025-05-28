import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class AnimatedBox extends LeafRenderObjectWidget {
  final double width;
  final double height;
  final Duration duration;
  final Color color;

  const AnimatedBox({
    super.key,
    required this.width,
    required this.height,
    this.duration = const Duration(milliseconds: 300),
    this.color = Colors.blue,
  });

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderAnimatedBox()
      ..targetSize = Size(width, height)
      ..duration = duration
      ..color = color;
  }

  @override
  void updateRenderObject(
    BuildContext context,
    RenderAnimatedBox renderObject,
  ) {
    renderObject
      ..targetSize = Size(width, height)
      ..duration = duration
      ..color = color;
  }
}

class RenderAnimatedBox extends RenderBox {
  Size _currentSize = Size.zero;
  Size _targetSize = Size.zero;
  Duration _duration = const Duration(milliseconds: 300);
  Color _color = Colors.blue;

  late final Ticker _ticker;
  double _t = 1.0;
  DateTime _startTime = DateTime.now();

  RenderAnimatedBox() {
    _ticker = Ticker(_tick);
  }

  set targetSize(Size value) {
    if (value != _targetSize) {
      _targetSize = value;
      _startAnimation();
    }
  }

  set duration(Duration value) {
    _duration = value;
  }

  set color(Color value) {
    if (value != _color) {
      _color = value;
      markNeedsPaint();
    }
  }

  void _startAnimation() {
    _t = 0;
    _startTime = DateTime.now();

    if (!_ticker.isActive) {
      _ticker.start();
    }
  }

  void _tick(Duration elapsed) {
    final elapsedMs = DateTime.now().difference(_startTime).inMilliseconds;
    final totalMs = _duration.inMilliseconds;
    _t = (elapsedMs / totalMs).clamp(0, 1);
    if (_t >= 1) {
      _ticker.stop();
      _currentSize = _targetSize;
    }
    markNeedsLayout();
    markNeedsPaint();
  }

  @override
  bool hitTestSelf(Offset position) => true;

  @override
  void performLayout() {
    _currentSize = Size.lerp(_currentSize, _targetSize, _t)!;
    size = constraints.constrain(_currentSize);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final paint = Paint()..color = _color;
    context.canvas.drawRect(offset & size, paint);
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }
}

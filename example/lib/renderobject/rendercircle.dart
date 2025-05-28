import 'package:flutter/material.dart';

// Step 4: Create a widget that uses the RenderObject
class CircleBox extends LeafRenderObjectWidget {
  const CircleBox({super.key, required this.color, required this.diameter});

  final Color color;
  final double diameter;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderCircleBox(color: color, diameter: diameter);
  }

  @override
  void updateRenderObject(BuildContext context, RenderCircleBox renderObject) {
    renderObject
      ..color = color
      ..diameter = diameter;
  }
}

// Step 1: Create a RenderObject
class RenderCircleBox extends RenderBox {
  RenderCircleBox({required Color color, required double diameter})
    : _color = color,
      _diameter = diameter;

  Color _color;
  double _diameter;

  // Getters and setters for properties
  Color get color => _color;
  set color(Color value) {
    if (_color == value) return;
    _color = value;
    markNeedsPaint();
  }

  double get diameter => _diameter;
  set diameter(double value) {
    if (_diameter == value) return;
    _diameter = value;
    markNeedsLayout();
  }

  // Step 2: Override performLayout to set size
  @override
  void performLayout() {
    size = Size(_diameter, _diameter);
  }

  // Step 3: Override paint to draw the circle
  @override
  void paint(PaintingContext context, Offset offset) {
    context.canvas.drawCircle(
      offset + Offset(_diameter / 2, _diameter / 2),
      _diameter / 2,
      Paint()..color = _color,
    );
  }
}

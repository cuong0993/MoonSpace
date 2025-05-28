import 'package:flutter/widgets.dart';

// 1. A Widget that creates the RenderObject
class RedBox extends SingleChildRenderObjectWidget {
  const RedBox({super.key, super.child});

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderRedBox();
  }
}

// 2. The RenderObject that does layout and painting
class RenderRedBox extends RenderBox {
  @override
  void performLayout() {
    // Constrain to 100x100 or parent's constraints
    size = constraints.constrain(Size(100, 100));
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final Paint paint = Paint()..color = const Color(0xFFFF0000);
    context.canvas.drawRect(offset & size, paint);
  }
}

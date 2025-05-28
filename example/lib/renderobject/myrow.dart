import 'dart:math' as math;
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class MyRow extends MultiChildRenderObjectWidget {
  const MyRow({super.key, required super.children});

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderMyRow();
  }
}

class MyRowParentData extends ContainerBoxParentData<RenderBox> {}

class RenderMyRow extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, MyRowParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, MyRowParentData> {
  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! MyRowParentData) {
      child.parentData = MyRowParentData();
    }
  }

  @override
  void performLayout() {
    double dx = 0;
    double maxHeight = 0;

    RenderBox? child = firstChild;
    while (child != null) {
      final MyRowParentData childParentData =
          child.parentData as MyRowParentData;

      child.layout(constraints.loosen(), parentUsesSize: true);
      childParentData.offset = Offset(dx, 0);
      dx += child.size.width;
      maxHeight = math.max(maxHeight, child.size.height);

      child = childParentData.nextSibling;
    }

    size = constraints.constrain(Size(dx, maxHeight));
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    RenderBox? child = firstChild;
    while (child != null) {
      final MyRowParentData childParentData =
          child.parentData as MyRowParentData;
      context.paintChild(child, offset + childParentData.offset);
      child = childParentData.nextSibling;
    }
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    RenderBox? child = lastChild;
    while (child != null) {
      final MyRowParentData childParentData =
          child.parentData as MyRowParentData;
      final bool isHit = result.addWithPaintOffset(
        offset: childParentData.offset,
        position: position,
        hitTest: (BoxHitTestResult result, Offset transformed) {
          return child!.hitTest(result, position: transformed);
        },
      );
      if (isHit) return true;
      child = childParentData.previousSibling;
    }
    return false;
  }
}

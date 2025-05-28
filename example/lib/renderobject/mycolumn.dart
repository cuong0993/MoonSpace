import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:example/renderobject/myrow.dart';

enum MyMainAxisAlignment {
  start,
  center,
  end,
  spaceBetween,
  spaceAround,
  spaceEvenly,
}

class MyColumn extends MultiChildRenderObjectWidget {
  final MyMainAxisAlignment alignment;
  final double spacing;

  const MyColumn({
    super.key,
    required super.children,
    this.alignment = MyMainAxisAlignment.start,
    this.spacing = 0.0,
  });

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderMyColumn(alignment: alignment, spacing: spacing);
  }

  @override
  void updateRenderObject(
    BuildContext context,
    covariant RenderMyColumn renderObject,
  ) {
    renderObject
      ..alignment = alignment
      ..spacing = spacing;
  }
}

class RenderMyColumn extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, MyRowParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, MyRowParentData> {
  RenderMyColumn({
    required MyMainAxisAlignment alignment,
    required double spacing,
  }) : _alignment = alignment,
       _spacing = spacing;

  MyMainAxisAlignment _alignment;
  double _spacing;

  set alignment(MyMainAxisAlignment value) {
    if (_alignment != value) {
      _alignment = value;
      markNeedsLayout();
    }
  }

  set spacing(double value) {
    if (_spacing != value) {
      _spacing = value;
      markNeedsLayout();
    }
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! MyRowParentData) {
      child.parentData = MyRowParentData();
    }
  }

  @override
  void performLayout() {
    // Step 1: Layout all children to get sizes
    double totalChildHeight = 0;
    double maxWidth = 0;
    int childCount = 0;

    RenderBox? child = firstChild;
    while (child != null) {
      final MyRowParentData childParentData =
          child.parentData as MyRowParentData;
      child.layout(constraints.loosen(), parentUsesSize: true);
      totalChildHeight += child.size.height;
      maxWidth = math.max(maxWidth, child.size.width);
      childCount++;
      child = childParentData.nextSibling;
    }

    // Step 2: Calculate total height including spacing
    double usedSpacing = 0;
    if (_alignment == MyMainAxisAlignment.start ||
        _alignment == MyMainAxisAlignment.center ||
        _alignment == MyMainAxisAlignment.end) {
      usedSpacing = _spacing * (childCount > 1 ? childCount - 1 : 0);
    }

    double totalHeight = totalChildHeight + usedSpacing;
    size = constraints.constrain(Size(maxWidth, totalHeight));

    // Step 3: Calculate spacing offset
    double yOffset = 0;
    double gap = _spacing;

    switch (_alignment) {
      case MyMainAxisAlignment.start:
        yOffset = 0;
        break;
      case MyMainAxisAlignment.center:
        yOffset = (size.height - totalHeight) / 2;
        break;
      case MyMainAxisAlignment.end:
        yOffset = size.height - totalHeight;
        break;
      case MyMainAxisAlignment.spaceBetween:
        yOffset = 0;
        gap = childCount > 1
            ? (size.height - totalChildHeight) / (childCount - 1)
            : 0;
        break;
      case MyMainAxisAlignment.spaceAround:
        gap = childCount > 0
            ? (size.height - totalChildHeight) / childCount
            : 0;
        yOffset = gap / 2;
        break;
      case MyMainAxisAlignment.spaceEvenly:
        gap = childCount > 0
            ? (size.height - totalChildHeight) / (childCount + 1)
            : 0;
        yOffset = gap;
        break;
    }

    // Step 4: Position children
    child = firstChild;
    while (child != null) {
      final MyRowParentData childParentData =
          child.parentData as MyRowParentData;
      childParentData.offset = Offset(
        (size.width - child.size.width) / 2,
        yOffset,
      );
      yOffset += child.size.height + gap;
      child = childParentData.nextSibling;
    }
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
}

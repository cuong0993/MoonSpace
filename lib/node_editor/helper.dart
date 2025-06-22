import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:moonspace/node_editor/types.dart';

Offset rotateAroundCenter(Offset point, Offset center, double angle) {
  final dx = point.dx - center.dx;
  final dy = point.dy - center.dy;

  final cosA = math.cos(angle);
  final sinA = math.sin(angle);

  final rotatedDx = dx * cosA - dy * sinA;
  final rotatedDy = dx * sinA + dy * cosA;

  return Offset(rotatedDx + center.dx, rotatedDy + center.dy);
}

Offset globalToCanvasOffset(Offset localPos, BuildContext context) {
  final renderBox = context.findRenderObject() as RenderBox;
  final global = renderBox.localToGlobal(localPos);
  final matrixInverse = EditorNotifier.of(
    context,
  ).interactiveController.value.clone()..invert();
  return MatrixUtils.transformPoint(matrixInverse, global);
}

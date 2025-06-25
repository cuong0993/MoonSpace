import 'dart:math' as math;

import 'package:flutter/material.dart';

Offset rotateAroundCenter(Offset point, Offset center, double angle) {
  final dx = point.dx - center.dx;
  final dy = point.dy - center.dy;

  final cosA = math.cos(angle);
  final sinA = math.sin(angle);

  final rotatedDx = dx * cosA - dy * sinA;
  final rotatedDy = dx * sinA + dy * cosA;

  return Offset(rotatedDx + center.dx, rotatedDy + center.dy);
}

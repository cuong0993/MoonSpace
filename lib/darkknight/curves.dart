import 'dart:math';
import 'package:flutter/animation.dart';

class CurveModSin extends Curve {
  final double period;

  const CurveModSin([this.period = pi]);

  @override
  double transformInternal(double t) {
    double sin2 = sin(t * period);
    return sin2 * (sin2 < 1 ? 1 : -1);
  }
}

class CurveSquareSin extends Curve {
  final double period;

  const CurveSquareSin([this.period = pi]);

  @override
  double transformInternal(double t) {
    double sin2 = sin(t * period);
    return sin2 * sin2;
  }
}

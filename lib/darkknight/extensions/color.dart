import 'dart:math' show max, min, Random;
import 'package:flutter/material.dart' show Color, Colors, HSVColor, immutable;
import 'package:moonspace/darkknight/extensions/string.dart';

@immutable
class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    return int.parse(hexColor, radix: 16);
  }

  static Color random() {
    return Color(0xFF000000 + Random().nextInt(0xFFFFFF));
  }
}

extension Shade on Color {
  Color shade(int r, [int? g, int? b, int? a]) {
    g = g ?? r;
    b = b ?? r;
    a = a ?? 0;
    return Color.fromARGB(
      max(min(alpha + a, 255), 0),
      max(min(red + r, 255), 0),
      max(min(green + g, 255), 0),
      max(min(blue + b, 255), 0),
    );
  }

  HSVColor get hsv => HSVColor.fromColor(this);
  bool get isDark => hsv.value < 0.6;
  Color get op => isDark ? Colors.white : Colors.black;
  Color get mop => isDark ? lighten(.9) : darken(.1);

  Color grey(int lighten) {
    int oo = (((red + blue + green) ~/ 3) + lighten) % 255;
    return Color.fromARGB(alpha, oo, oo, oo);
  }

  Color get i {
    return Color.fromARGB(alpha, 255 - red, 255 - green, 255 - blue);
  }

  Color darken(double v) {
    assert(v >= 0 && v <= 1);
    return Color.fromARGB(
      alpha,
      (red * v).round(),
      (green * v).round(),
      (blue * v).round(),
    );
  }

  Color lighten(double v) {
    assert(v >= 0 && v <= 1);
    return Color.fromARGB(
      alpha,
      (red + ((255 - red) * v)).round(),
      (green + ((255 - green) * v)).round(),
      (blue + ((255 - blue) * v)).round(),
    );
  }

  Color avg(Color other) {
    final red = (this.red + other.red) ~/ 2;
    final green = (this.green + other.green) ~/ 2;
    final blue = (this.blue + other.blue) ~/ 2;
    final alpha = (this.alpha + other.alpha) ~/ 2;
    return Color.fromARGB(alpha, red, green, blue);
  }

  String get hexCode => '0x${value.toRadixString(16)}';
}

extension AsHtmlColorToColor on String {
  Color htmlColorToColor() => Color(
        int.parse(
          removeAll(['0x', '#']).padLeft(8, 'ff'),
          radix: 16,
        ),
      );

  Color? tryToColor() {
    final rgbRegex = RegExp(r'^rgb\((\d+),\s*(\d+),\s*(\d+)\)$');
    final rgbaRegex = RegExp(r'^rgba\((\d+),\s*(\d+),\s*(\d+),\s*([\d.]+)\)$');
    final hexRegex = RegExp(r'^(0x|#)([0-9A-Fa-f]{6}|[0-9A-Fa-f]{8})$');

    if (rgbRegex.hasMatch(this)) {
      final match = rgbRegex.firstMatch(this);
      if (match != null && match.groupCount == 3) {
        final r = int.tryParse(match.group(1)!);
        final g = int.tryParse(match.group(2)!);
        final b = int.tryParse(match.group(3)!);
        if (r != null && g != null && b != null) {
          return Color.fromARGB(255, r, g, b);
        }
      }
    } else if (rgbaRegex.hasMatch(this)) {
      final match = rgbaRegex.firstMatch(this);
      if (match != null && match.groupCount == 4) {
        final r = int.tryParse(match.group(1)!);
        final g = int.tryParse(match.group(2)!);
        final b = int.tryParse(match.group(3)!);
        final a = double.tryParse(match.group(4)!);
        if (r != null && g != null && b != null && a != null) {
          return Color.fromARGB((a * 255).toInt(), r, g, b);
        }
      }
    } else if (hexRegex.hasMatch(this)) {
      final match = hexRegex.firstMatch(this);
      if (match != null && match.groupCount == 2) {
        final hexValue = int.tryParse(match.group(2)!, radix: 16);
        if (hexValue != null) {
          if (match.group(2)!.length == 6) {
            // 6-character hex format without alpha
            return Color(hexValue).withAlpha(255);
          } else {
            // 8-character hex format with alpha
            return Color(hexValue);
          }
        }
      }
    }

    return null; // Return null if parsing fails
  }
}

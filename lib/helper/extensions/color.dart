import 'dart:math' show Random;
import 'package:flutter/material.dart' show Color, Colors, HSVColor, immutable;
import 'package:moonspace/helper/extensions/string.dart';

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
  HSVColor get hsv => HSVColor.fromColor(this);
  bool get isDark => hsv.value < 0.6;
  Color get op => isDark ? Colors.white : Colors.black;

  String get hexCode => '0x${toARGB32().toRadixString(16)}';
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

Color lerpGradient(List<Color> colors, List<double> stops, double t) {
  if (stops.length != colors.length) return Colors.red;
  for (var s = 0; s < stops.length - 1; s++) {
    final leftStop = stops[s], rightStop = stops[s + 1];
    final leftColor = colors[s], rightColor = colors[s + 1];
    if (t <= leftStop) {
      return leftColor;
    } else if (t < rightStop) {
      final sectionT = (t - leftStop) / (rightStop - leftStop);
      return Color.lerp(leftColor, rightColor, sectionT)!;
    }
  }
  return colors.last;
}

import 'package:flutter/material.dart';

enum ScreenSize {
  xs,
  sm,
  md,
  lg,
  xl,
  xxl;

  bool get isLarge =>
      this == ScreenSize.lg || this == ScreenSize.xl || this == ScreenSize.xxl;

  double get breakpoint {
    switch (this) {
      case ScreenSize.xs:
        return 576;
      case ScreenSize.sm:
        return 576;
      case ScreenSize.md:
        return 768;
      case ScreenSize.lg:
        return 992;
      case ScreenSize.xl:
        return 1200;
      case ScreenSize.xxl:
        return 1400;
    }
  }

  static ScreenSize of(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= ScreenSize.sm.breakpoint) {
      return ScreenSize.xs;
    } else if (screenWidth <= ScreenSize.md.breakpoint) {
      return ScreenSize.sm;
    } else if (screenWidth <= ScreenSize.lg.breakpoint) {
      return ScreenSize.md;
    } else if (screenWidth <= ScreenSize.xl.breakpoint) {
      return ScreenSize.lg;
    } else if (screenWidth <= ScreenSize.xxl.breakpoint) {
      return ScreenSize.xl;
    } else {
      return ScreenSize.xxl;
    }
  }

  static int gridCrossAxisCount(BuildContext context) {
    switch (ScreenSize.of(context)) {
      case ScreenSize.xs:
      case ScreenSize.sm:
        return 1;
      case ScreenSize.md:
        return 2;
      case ScreenSize.lg:
        return 3;
      case ScreenSize.xl:
        return 4;
      case ScreenSize.xxl:
        return 5;
    }
  }
}

class RecipesLayout {
  final BuildContext context;

  RecipesLayout(this.context);

  static RecipesLayout of(BuildContext context) {
    return RecipesLayout(context);
  }

  int get gridCrossAxisCount {
    switch (ScreenSize.of(context)) {
      case ScreenSize.xs:
      case ScreenSize.sm:
        return 1;
      case ScreenSize.md:
        return 2;
      case ScreenSize.lg:
      case ScreenSize.xl:
      case ScreenSize.xxl:
        return 3;
    }
  }

  double get gridChildAspectRatio {
    switch (ScreenSize.of(context)) {
      case ScreenSize.xs:
      case ScreenSize.sm:
        return 1.5;
      case ScreenSize.md:
        return 2;
      case ScreenSize.lg:
        return 1.5;
      case ScreenSize.xl:
        return 1.5;
      case ScreenSize.xxl:
        return 1.5;
    }
  }

  double get recipeImageSize {
    double screenWidth = MediaQuery.of(context).size.width;
    return screenWidth * 0.45 / gridCrossAxisCount;
  }
}

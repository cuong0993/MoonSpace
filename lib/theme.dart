import 'dart:math';
import 'package:flutter/material.dart';
import 'package:moonspace/helper/extensions/color.dart';

extension AppThemeNumber on num {
  double get a => (this * AppTheme.a).toDouble();
  double get s => (this * AppTheme.s).toDouble();
  double get m => (this * AppTheme.m).toDouble();
  double get c => (this * AppTheme.c).toDouble();
  double get mins => max(this, s).toDouble();
  double get maxs => min(this, s).toDouble();
  double get minc => max(this, c).toDouble();
  double get maxc => min(this, c).toDouble();
}

extension AppThemeRange on (num, num) {
  double get s => ($1 + ($2 - $1) * AppTheme.rs).toDouble();
  double get c => ($1 + ($2 - $1) * AppTheme.rc).toDouble();
}

class AppTheme {
  final String name;
  final Size size;
  final Size maxSize;
  final Size designSize;

  final bool dark;
  final Color primary;
  final Color secondary;
  final Color tertiary;

  final (int, int) borderRadius;
  final (int, int) padding;

  AppTheme copyWith({Size? size}) {
    return AppTheme(
      name: name,
      size: size ?? this.size,
      maxSize: maxSize,
      designSize: designSize,
      dark: dark,
      primary: primary,
      secondary: secondary,
      tertiary: tertiary,
      borderRadius: borderRadius,
      padding: padding,
    );
  }

  AppTheme({
    required this.name,
    required this.size,
    required this.maxSize,
    required this.designSize,
    required this.dark,
    required this.primary,
    required this.secondary,
    required this.tertiary,
    required this.borderRadius,
    required this.padding,
  });

  static List<AppTheme> themes = [
    AppTheme(
      name: "Light",
      dark: false,

      size: const Size(360, 780),
      maxSize: const Size(1366, 1024),
      designSize: const Size(360, 780),

      borderRadius: (8, 10),
      padding: (14, 16),

      primary: Colors.blue,
      secondary: Colors.pink,
      tertiary: Colors.yellow,
    ),
    AppTheme(
      name: "Night",
      dark: true,

      size: const Size(360, 780),
      maxSize: const Size(1366, 1024),
      designSize: const Size(360, 780),

      borderRadius: (8, 10),
      padding: (14, 16),

      primary: Colors.blue,
      secondary: Colors.pink,
      tertiary: Colors.yellow,
    ),
  ];

  static int currentThemeIndex = 0;
  static AppTheme currentTheme = themes[currentThemeIndex];

  static bool get isMobile => currentTheme.size.width < 500;
  static bool get isTab => currentTheme.size.width < 900;
  static bool get isDesktop => currentTheme.size.width < 1200;

  static bool get isDark => currentTheme.dark;

  static double get w => currentTheme.size.width;
  static double get dw => currentTheme.designSize.width;
  static double get mw => currentTheme.maxSize.width;
  static double get h => currentTheme.size.height;
  static double get dh => currentTheme.designSize.height;
  static double get mh => currentTheme.maxSize.height;

  static num get a => (AppTheme.w / AppTheme.dw) * (AppTheme.h / AppTheme.dh);
  static num get m =>
      min((AppTheme.w / AppTheme.dw), (AppTheme.h / AppTheme.dh));
  static num get s =>
      pow((AppTheme.w / AppTheme.dw) * (AppTheme.h / AppTheme.dh), 1 / 2);
  static num get c =>
      pow((AppTheme.w / AppTheme.dw) * (AppTheme.h / AppTheme.dh), 0.2);
  static num get maxs =>
      pow((AppTheme.mw / AppTheme.dw) * (AppTheme.mh / AppTheme.dh), 1 / 2);
  static num get maxc =>
      pow((AppTheme.mw / AppTheme.dw) * (AppTheme.mh / AppTheme.dh), 0.2);
  static num get rs => min(1, max(0, AppTheme.s - 1) / (AppTheme.maxs - 1));
  static num get rc => min(1, max(0, AppTheme.c - 1) / (AppTheme.maxc - 1));

  static TextTheme get tx => currentTheme.textTheme;

  ColorScheme buildColorScheme() {
    final surface = isDark
        ? const Color.fromARGB(255, 28, 28, 28)
        : Colors.white;
    final outline = isDark
        ? const Color.fromARGB(255, 117, 117, 117)
        : const Color.fromARGB(255, 208, 208, 208);

    return ColorScheme(
      brightness: isDark ? Brightness.dark : Brightness.light,

      primary: primary,
      onPrimary: primary.getOnColor(),
      primaryContainer: primary,
      onPrimaryContainer: primary.getOnColor(),

      secondary: secondary,
      onSecondary: secondary.getOnColor(),
      secondaryContainer: secondary,
      onSecondaryContainer: secondary.getOnColor(),

      tertiary: tertiary,
      onTertiary: tertiary.getOnColor(),
      tertiaryContainer: tertiary,
      onTertiaryContainer: tertiary.getOnColor(),

      surface: surface,
      onSurface: surface.getOnColor(),

      onSurfaceVariant: surface.lighten(isDark ? 0.6 : -0.6),
      surfaceTint: primary,

      error: isDark ? Color(0xffffb4ab) : Color(0xffba1a1a),
      onError: isDark ? Color(0xff690005) : Color(0xffffffff),
      errorContainer: isDark ? Color(0xff93000a) : Color(0xffffdad6),
      onErrorContainer: isDark ? Color(0xffffdad6) : Color(0xff93000a),

      outline: outline,
      outlineVariant: outline.lighten(isDark ? -.1 : .1),
      shadow: primary.lighten(isDark ? -.4 : 0.4),
      scrim: secondary.lighten(isDark ? -.4 : 0.4),

      inverseSurface: surface.lighten(isDark ? 0.25 : -0.25),
      inversePrimary: primary.lighten(isDark ? -.1 : .1),

      primaryFixed: primary,
      onPrimaryFixed: primary.getOnColor(),
      primaryFixedDim: primary,
      onPrimaryFixedVariant: primary.getOnColor(),

      secondaryFixed: secondary,
      onSecondaryFixed: secondary.getOnColor(),
      secondaryFixedDim: secondary,
      onSecondaryFixedVariant: secondary.getOnColor(),

      tertiaryFixed: tertiary,
      onTertiaryFixed: tertiary.getOnColor(),
      tertiaryFixedDim: tertiary,
      onTertiaryFixedVariant: tertiary.getOnColor(),

      surfaceDim: surface.lighten(isDark ? -0.04 : 0.04),
      surfaceBright: surface.lighten(isDark ? -0.03 : 0.03),
      surfaceContainerLowest: surface.lighten(isDark ? -0.02 : 0.02),
      surfaceContainerLow: surface.lighten(isDark ? 0.02 : -0.02),
      surfaceContainer: surface.lighten(isDark ? 0.03 : -0.03),
      surfaceContainerHigh: surface.lighten(isDark ? 0.03 : -0.03),
      surfaceContainerHighest: surface.lighten(isDark ? 0.05 : -0.05),
    );
  }

  TextTheme get textTheme => TextTheme(
    displayLarge: TextStyle(letterSpacing: 1.c, fontSize: (50, 60).c),
    displayMedium: TextStyle(letterSpacing: 1.c, fontSize: (44, 54).c),
    displaySmall: TextStyle(letterSpacing: 1.c, fontSize: (36, 46).c),

    headlineLarge: TextStyle(letterSpacing: 1.c, fontSize: (32, 42).c),
    headlineMedium: TextStyle(letterSpacing: 1.c, fontSize: (30, 40).c),
    headlineSmall: TextStyle(fontSize: (26, 32).c),

    //Appbar
    titleLarge: TextStyle(letterSpacing: 0.c, fontSize: (22, 24).c),

    //CupertinoListTile, ListTile Title, Textfield label
    titleMedium: TextStyle(
      letterSpacing: 1.c,
      fontSize: (17, 19).c,
      fontWeight: FontWeight.w400,
    ),

    //TextFormField, CupertinoFormSection header, ListTile, SwitchTile, RadioTile
    bodyLarge: TextStyle(fontSize: (16, 18).c),

    // Tabs
    titleSmall: TextStyle(fontSize: (14, 16).c, fontWeight: FontWeight.w400),
    //Text,  Textfield font, Tile subtitle
    bodyMedium: TextStyle(fontSize: (14, 16).c, fontWeight: FontWeight.w400),
    //Buttons
    labelLarge: TextStyle(fontSize: (14, 16).c, fontWeight: FontWeight.w400),

    //ListTile subtitle, errortext
    bodySmall: TextStyle(fontSize: (12, 14).c),
    //BottomNavBar, Navigation
    labelMedium: TextStyle(fontSize: (12, 14).c, fontWeight: FontWeight.w400),

    labelSmall: TextStyle(fontSize: (30, 12).c, fontWeight: FontWeight.w400),
  );

  ThemeData get theme {
    final colorScheme = buildColorScheme();

    return ThemeData(
      //
      brightness: dark ? Brightness.dark : Brightness.light,
      useMaterial3: true,
      colorScheme: colorScheme,

      textTheme: textTheme.apply(
        // bodyColor: colorScheme.onSurface,
        // displayColor: colorScheme.onSurface,
      ),

      //
      dividerTheme: DividerThemeData(),

      //
      inputDecorationTheme: InputDecorationTheme(
        // focusedBorder: OutlineInputBorder(
        //   borderRadius: BorderRadius.circular(8),
        //   borderSide: BorderSide(color: seedColor),
        // ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius.c),
        ),
        filled: true,
        contentPadding: EdgeInsets.all(padding.c),
      ),

      // splashColor: ,
      appBarTheme: AppBarTheme(surfaceTintColor: Colors.white),

      //
      listTileTheme: ListTileThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius.c),
        ),
        // titleTextStyle: AppTheme.tx.bodyLarge,
        // subtitleTextStyle: AppTheme.tx.bodySmall,
      ),

      //
      iconButtonTheme: IconButtonThemeData(style: IconButton.styleFrom()),
      floatingActionButtonTheme: FloatingActionButtonThemeData(),

      //
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius.c),
          ),
          padding: EdgeInsets.all(padding.c),
          textStyle: TextStyle(fontSize: (15, 17).c),
          // foregroundColor: const Color.fromARGB(255, 255, 255, 255),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius.c),
          ),
          padding: EdgeInsets.all(padding.c),
          // textStyle: TextStyle(fontSize: (15, 17).c),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius.c),
          ),
          padding: EdgeInsets.all(padding.c),
          // textStyle: TextStyle(fontSize: (15, 17).c),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          padding: EdgeInsets.all(padding.c),
          foregroundColor: colorScheme.secondary,
        ),
      ),

      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        // selectedLabelStyle: AppTheme.tx.labelMedium,
        // unselectedLabelStyle: AppTheme.tx.labelMedium,
        // selectedIconTheme: IconThemeData(size: (24, 28).c),
        // unselectedIconTheme: IconThemeData(size: (24, 28).c),
      ),
      tabBarTheme: const TabBarThemeData(),

      //
      dialogTheme: DialogThemeData(
        elevation: 2,
        actionsPadding: EdgeInsets.all(padding.c),
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius.c),
          side: BorderSide.none,
        ),
      ),

      //
      cardTheme: CardThemeData(
        // color: AppTheme.isDark
        //     ? const Color.fromARGB(255, 68, 61, 71)
        //     : const Color.fromARGB(255, 250, 239, 255),
        elevation: 0,
      ),
    );
  }

  @override
  String toString() {
    return 'AppTheme(size: $size, maxSize: $maxSize, designSize: $designSize, dark: $dark)';
  }
}

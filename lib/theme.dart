import 'dart:math';
import 'package:flutter/cupertino.dart';
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
  double get c =>
      AppTheme.currentTheme.baseunit *
      ($1 + ($2 - $1) * AppTheme.rc).toDouble();
}

class AppTheme {
  final String name;
  final IconData icon;

  final Size size;
  final Size maxSize;
  final Size designSize;

  final bool dark;
  final Color primary;
  final Color secondary;
  final Color tertiary;
  final ColorScheme? themedata;

  final (int, int) borderRadius;
  final (int, int) padding;

  final double baseunit;

  AppTheme copyWith({Size? size}) {
    return AppTheme(
      name: name,
      icon: icon,

      size: size ?? this.size,
      maxSize: maxSize,
      designSize: designSize,

      dark: dark,
      primary: primary,
      secondary: secondary,
      tertiary: tertiary,
      themedata: themedata,

      borderRadius: borderRadius,
      padding: padding,

      baseunit: baseunit,
    );
  }

  AppTheme({
    required this.name,
    required this.icon,

    required this.size,
    required this.maxSize,
    required this.designSize,

    required this.dark,
    required this.primary,
    required this.secondary,
    required this.tertiary,
    this.themedata,

    required this.borderRadius,
    required this.padding,

    required this.baseunit,
  });

  // static List<AppTheme> themes = [
  static List<AppTheme> get themes => [
    AppTheme(
      name: "Sun",
      icon: CupertinoIcons.sun_min,

      dark: false,

      size: const Size(360, 780),
      maxSize: const Size(1366, 1024),
      designSize: const Size(360, 780),

      borderRadius: (8, 10),
      padding: (14, 16),

      primary: const Color(0xff717171),
      secondary: const Color(0xff7e73c0),
      tertiary: const Color(0xff71c783),

      baseunit: 1.0,
    ),
    AppTheme(
      name: "Moon",
      icon: CupertinoIcons.moon,

      dark: true,

      size: const Size(360, 780),
      maxSize: const Size(1366, 1024),
      designSize: const Size(360, 780),

      borderRadius: (8, 10),
      padding: (14, 16),

      primary: const Color(0xff8a73cf),
      secondary: const Color(0xffbed18c),
      tertiary: const Color(0xffffffff),

      baseunit: 1.0,
    ),
    AppTheme(
      name: "Happy",
      icon: Icons.icecream_outlined,

      dark: false,

      size: const Size(360, 780),
      maxSize: const Size(1366, 1024),
      designSize: const Size(360, 780),

      borderRadius: (8, 10),
      padding: (14, 16),

      primary: const Color(0xfff7ec1a),
      secondary: const Color(0xff4281d4),
      tertiary: const Color(0xffefae35),

      baseunit: 1.0,
    ),
    AppTheme(
      name: "HappyNight",
      icon: Icons.icecream_outlined,

      dark: true,

      size: const Size(360, 780),
      maxSize: const Size(1366, 1024),
      designSize: const Size(360, 780),

      borderRadius: (8, 10),
      padding: (14, 16),

      primary: const Color(0xfff7ec1a),
      secondary: const Color(0xff4281d4),
      tertiary: const Color(0xffefae35),

      baseunit: 1.0,
    ),
    AppTheme(
      name: "Monochrome",
      icon: Icons.icecream_outlined,

      dark: false,

      size: const Size(360, 780),
      maxSize: const Size(1366, 1024),
      designSize: const Size(360, 780),

      borderRadius: (8, 10),
      padding: (14, 16),

      primary: const Color.fromARGB(255, 105, 187, 255),
      secondary: const Color.fromARGB(255, 255, 109, 157),
      tertiary: Colors.yellow,

      themedata: ColorScheme.fromSeed(
        seedColor: Colors.green,
        brightness: Brightness.light,
        dynamicSchemeVariant: DynamicSchemeVariant.monochrome,
      ),

      baseunit: 1.0,
    ),
    AppTheme(
      name: "MonochromeNight",
      icon: Icons.icecream_outlined,

      dark: true,

      size: const Size(360, 780),
      maxSize: const Size(1366, 1024),
      designSize: const Size(360, 780),

      borderRadius: (8, 10),
      padding: (14, 16),

      primary: const Color.fromARGB(255, 105, 187, 255),
      secondary: const Color.fromARGB(255, 255, 109, 157),
      tertiary: Colors.yellow,

      themedata: ColorScheme.fromSeed(
        seedColor: Colors.green,
        brightness: Brightness.dark,
        dynamicSchemeVariant: DynamicSchemeVariant.monochrome,
      ),

      baseunit: 1.0,
    ),
  ];

  static int currentThemeIndex = 0;
  static AppTheme currentTheme = themes[currentThemeIndex];

  static bool get isMobile => currentTheme.size.width < 800;
  static bool get isTab =>
      currentTheme.size.width < 800 && currentTheme.size.width < 1400;
  static bool get isDesktop => currentTheme.size.width > 1400;

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
      primaryContainer: Colors.red, //primary,
      onPrimaryContainer: Colors.red, //primary.getOnColor(),

      secondary: secondary,
      onSecondary: secondary.getOnColor(),
      secondaryContainer: secondary,
      onSecondaryContainer: secondary.getOnColor(),

      tertiary: tertiary,
      onTertiary: tertiary.getOnColor(),
      tertiaryContainer: Colors.red, //tertiary,
      onTertiaryContainer: Colors.red, //tertiary.getOnColor(),

      surface: surface,
      onSurface: surface.getOnColor(),

      onSurfaceVariant: surface.lighten(isDark ? 0.6 : -0.6),
      surfaceTint: primary,

      error: isDark ? Color(0xffffb4ab) : Color.fromARGB(255, 238, 70, 70),
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
      primaryFixedDim: Colors.red, //primary,
      onPrimaryFixedVariant: Colors.red, //primary.getOnColor(),

      secondaryFixed: secondary,
      onSecondaryFixed: secondary.getOnColor(),
      secondaryFixedDim: Colors.red, // secondary,
      onSecondaryFixedVariant: Colors.red, //secondary.getOnColor(),

      tertiaryFixed: tertiary,
      onTertiaryFixed: tertiary.getOnColor(),
      tertiaryFixedDim: Colors.red, // tertiary,
      onTertiaryFixedVariant: Colors.red, //tertiary.getOnColor(),

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
    displayLarge: TextStyle(letterSpacing: 1.c, fontSize: (46, 50).c),
    displayMedium: TextStyle(letterSpacing: 1.c, fontSize: (40, 46).c),
    displaySmall: TextStyle(letterSpacing: 1.c, fontSize: (36, 40).c),

    headlineLarge: TextStyle(letterSpacing: 1.c, fontSize: (30, 36).c),
    headlineMedium: TextStyle(letterSpacing: 1.c, fontSize: (24, 30).c),
    headlineSmall: TextStyle(fontSize: (20, 24).c),

    //Appbar
    titleLarge: TextStyle(letterSpacing: 0.c, fontSize: (17, 20).c),

    //CupertinoListTile, ListTile Title, Textfield label
    titleMedium: TextStyle(
      letterSpacing: 1.c,
      fontSize: (14, 15).c,
      fontWeight: FontWeight.w400,
    ),

    //TextFormField, CupertinoFormSection header, ListTile, SwitchTile, RadioTile
    bodyLarge: TextStyle(fontSize: (13, 14).c),

    // Tabs
    titleSmall: TextStyle(fontSize: (12, 13).c, fontWeight: FontWeight.w400),
    //Text,  Textfield font, Tile subtitle
    bodyMedium: TextStyle(fontSize: (12, 13).c, fontWeight: FontWeight.w400),
    //Buttons
    labelLarge: TextStyle(fontSize: (12, 13).c, fontWeight: FontWeight.w400),

    //ListTile subtitle, errortext
    bodySmall: TextStyle(fontSize: (11, 12).c),
    //BottomNavBar, Navigation
    labelMedium: TextStyle(fontSize: (11, 12).c, fontWeight: FontWeight.w400),

    labelSmall: TextStyle(fontSize: (10, 11).c, fontWeight: FontWeight.w400),
  );

  ThemeData get theme {
    final colorScheme = themedata ?? buildColorScheme();

    return ThemeData(
      //
      useMaterial3: true,
      brightness: dark ? Brightness.dark : Brightness.light,
      colorScheme: colorScheme,
      textTheme: textTheme,

      //
      dividerTheme: DividerThemeData(),

      //
      inputDecorationTheme: InputDecorationTheme(
        // focusedBorder: OutlineInputBorder(
        //   borderRadius: BorderRadius.circular(8),
        //   borderSide: BorderSide(color: seedColor),
        // ),
        // border: OutlineInputBorder(
        //   borderRadius: BorderRadius.circular(borderRadius.c),
        // ),
        // filled: true,
        contentPadding: EdgeInsets.all(padding.c),
      ),

      // splashColor: ,
      appBarTheme: AppBarTheme(surfaceTintColor: Colors.white),

      //
      listTileTheme: ListTileThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius.c),
        ),
      ),

      //
      iconButtonTheme: IconButtonThemeData(style: IconButton.styleFrom()),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.tertiary,
        foregroundColor: colorScheme.onTertiary,
      ),

      //
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius.c),
          ),
          padding: EdgeInsets.all(padding.c),
          // foregroundColor: const Color.fromARGB(255, 255, 255, 255),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius.c),
          ),
          padding: EdgeInsets.all(padding.c),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius.c),
          ),
          padding: EdgeInsets.all(padding.c),
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
    return 'AppTheme(size: $size, maxSize: $maxSize, designSize: $designSize, dark: $dark, primary: ${primary.hexCode}, secondary: ${secondary.hexCode}, tertiary: ${tertiary.hexCode})';
  }
}

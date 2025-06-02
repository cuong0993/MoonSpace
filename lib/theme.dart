import 'dart:math';
import 'package:flutter/material.dart';

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
  final Size size;
  final Size maxSize;
  final Size designSize;

  final bool dark;

  final ColorScheme colorScheme;

  final (int, int) borderRadius;
  final (int, int) padding;

  AppTheme({
    required this.size,
    required this.maxSize,
    required this.designSize,
    required this.dark,
    required this.colorScheme,
    required this.borderRadius,
    required this.padding,
  });

  static ColorScheme get appColorScheme => currentAppTheme.colorScheme;
  static Color get seedColor => currentAppTheme.colorScheme.primary;

  static AppTheme currentAppTheme = AppTheme(
    size: const Size(360, 780),
    maxSize: const Size(1366, 1024),
    designSize: const Size(360, 780),
    dark: false,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.purple,
      brightness: Brightness.light,
      dynamicSchemeVariant: DynamicSchemeVariant.tonalSpot,
    ),
    borderRadius: (8, 10),
    padding: (14, 16),
  );

  static bool get isMobile => currentAppTheme.size.width < 500;
  static bool get isTab => currentAppTheme.size.width < 900;
  static bool get isDesktop => currentAppTheme.size.width < 1200;

  static bool get isDark => currentAppTheme.dark;

  static double get w => currentAppTheme.size.width;
  static double get dw => currentAppTheme.designSize.width;
  static double get mw => currentAppTheme.maxSize.width;
  static double get h => currentAppTheme.size.height;
  static double get dh => currentAppTheme.designSize.height;
  static double get mh => currentAppTheme.maxSize.height;

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

  static TextTheme get tx => currentAppTheme.textTheme;

  TextTheme get textTheme => TextTheme(
    displayLarge: TextStyle(letterSpacing: 1.c, fontSize: (50, 60).c),
    displayMedium: TextStyle(letterSpacing: 1.c, fontSize: (44, 54).c),
    displaySmall: TextStyle(letterSpacing: 1.c, fontSize: (36, 46).c),

    headlineLarge: TextStyle(letterSpacing: 1.c, fontSize: (32, 42).c),
    headlineMedium: TextStyle(letterSpacing: 1.c, fontSize: (30, 40).c),
    headlineSmall: TextStyle(fontSize: (26, 32).c),

    //Appbar
    titleLarge: TextStyle(letterSpacing: 1.c, fontSize: (18, 20).c),

    //CupertinoListTile, ListTile Title, Textfield label
    titleMedium: TextStyle(
      letterSpacing: 1.c,
      fontSize: (17, 19).c,
      fontWeight: FontWeight.w400,
    ),

    titleSmall: TextStyle(
      letterSpacing: .5.c,
      fontSize: (14, 16).c,
      fontWeight: FontWeight.w400,
    ),

    //CupertinoFormSection header, ListTile Title,
    bodyLarge: TextStyle(fontSize: (16, 18).c),
    //Textfield font
    bodyMedium: TextStyle(fontSize: (15, 17).c),
    //ListTile subtitle
    bodySmall: TextStyle(fontSize: (14, 16).c),

    //Buttons
    labelLarge: TextStyle(
      letterSpacing: .5.c,
      fontSize: (13, 15).c,
      fontWeight: FontWeight.w500,
    ),
    //BottomNavBar
    labelMedium: TextStyle(fontSize: (12, 14).c, fontWeight: FontWeight.w400),
    labelSmall: TextStyle(fontSize: (10, 12).c, fontWeight: FontWeight.w400),
  );

  ThemeData get theme => ThemeData(
    //
    brightness: dark ? Brightness.dark : Brightness.light,
    useMaterial3: true,
    colorScheme: colorScheme,
    textTheme: textTheme,

    scaffoldBackgroundColor: dark
        ? const Color.fromARGB(255, 23, 23, 23)
        : Colors.white,

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
      style: TextButton.styleFrom(padding: EdgeInsets.zero),
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

  @override
  String toString() {
    return 'AppTheme(size: $size, maxSize: $maxSize, designSize: $designSize, dark: $dark)';
  }
}

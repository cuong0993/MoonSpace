import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moonspace/form/color.dart';
import 'package:moonspace/helper/extensions/color.dart';
import 'package:moonspace/helper/extensions/theme_ext.dart';
import 'package:moonspace/theme.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:moonspace/provider/pref.dart';

part 'global_theme.g.dart';

enum ThemeType {
  system(Icon(CupertinoIcons.cloud_sun_rain)),
  dark(Icon(CupertinoIcons.moon_stars)),
  light(Icon(CupertinoIcons.sun_min)),
  custom(Icon(CupertinoIcons.cloud_moon));

  final Icon icon;

  const ThemeType(this.icon);

  static ThemeType from(String? v) {
    v = v ?? ThemeType.system.toString();

    return ThemeType.values.where((e) => e.toString() == v).first;
  }

  Brightness get brightness {
    if (this == ThemeType.dark) {
      return Brightness.dark;
    }
    if (this == ThemeType.light) {
      return Brightness.light;
    }
    return SchedulerBinding.instance.platformDispatcher.platformBrightness;
  }
}

class GlobalAppTheme {
  final ThemeType type;

  final int themeIndex;

  final Color primary;
  final Color secondary;
  final Color tertiary;

  GlobalAppTheme({
    required this.type,
    required this.themeIndex,
    required this.primary,
    required this.secondary,
    required this.tertiary,
  });
}

const String _themetype = 'themetype';
const String _themeindex = 'themeindex';
const String _primary = 'primary';
const String _secondary = 'secondary';
const String _tertiary = 'tertiary';

@Riverpod(keepAlive: true)
class GlobalTheme extends _$GlobalTheme {
  @override
  GlobalAppTheme build() {
    ref.watch(prefProvider);
    ThemeType theme = ThemeType.from(
      ref.read(prefProvider.notifier).getString(_themetype),
    );
    int appthemeIndex =
        ref.read(prefProvider.notifier).getInt(_themeindex) ?? 0;
    Color? primary = ref
        .read(prefProvider.notifier)
        .getString(_primary)
        ?.tryToColor();
    Color? secondary = ref
        .read(prefProvider.notifier)
        .getString(_secondary)
        ?.tryToColor();
    Color? tertiary = ref
        .read(prefProvider.notifier)
        .getString(_tertiary)
        ?.tryToColor();

    if (theme == ThemeType.custom) {
      AppTheme.currentTheme = AppTheme(
        name: "custom",
        icon: CupertinoIcons.cloud_sun_bolt,

        dark: false,
        size: const Size(100, 100),
        maxSize: const Size(1366, 1024),
        designSize: const Size(430, 932),

        primary: primary ?? Colors.red,
        secondary: secondary ?? Colors.blue,
        tertiary: tertiary ?? Colors.green,

        borderRadius: (8, 10),
        padding: (14, 16),
      );
    } else {
      AppTheme.currentThemeIndex = appthemeIndex;
      AppTheme.currentTheme = AppTheme.themes[appthemeIndex];
    }

    return GlobalAppTheme(
      type: theme,
      themeIndex: appthemeIndex,
      primary: primary ?? const Color.fromARGB(255, 143, 111, 223),
      secondary: secondary ?? const Color.fromARGB(255, 255, 126, 193),
      tertiary: tertiary ?? Colors.yellow,
    );
  }

  void setTheme({
    ThemeType? type,
    String? name,
    Color? primary,
    Color? secondary,
    Color? tertiary,
  }) {
    int? themeIndex = -1;
    if (name != null) {
      themeIndex = AppTheme.themes.indexWhere((t) => name == t.name);
    }
    if (type != null) {
      themeIndex = AppTheme.themes.indexWhere((apptheme) {
        if ((type.brightness == Brightness.dark) == apptheme.dark) {
          return true;
        }
        return false;
      });
    }

    final ctype = type ?? state.type;
    final cthemeIndex = themeIndex >= 0 ? themeIndex : state.themeIndex;
    final cPrimary = primary ?? state.primary;
    final cSecondary = secondary ?? state.secondary;
    final cTertiary = tertiary ?? state.tertiary;

    if (ctype == ThemeType.custom) {
      AppTheme.currentTheme = AppTheme(
        name: "custom",
        icon: CupertinoIcons.cloud_sun_bolt,

        dark: false,
        size: const Size(100, 100),
        maxSize: const Size(1366, 1024),
        designSize: const Size(430, 932),

        primary: cPrimary,
        secondary: cSecondary,
        tertiary: cTertiary,

        borderRadius: (8, 10),
        padding: (14, 16),
      );
    } else {
      AppTheme.currentThemeIndex = cthemeIndex;
      AppTheme.currentTheme = AppTheme.themes[cthemeIndex];
    }

    state = GlobalAppTheme(
      type: ctype,
      themeIndex: cthemeIndex,
      primary: cPrimary,
      secondary: cSecondary,
      tertiary: cTertiary,
    );

    ref
        .read(prefProvider.notifier)
        .saveString(_themetype, state.type.toString());
    ref.read(prefProvider.notifier).saveInt(_themeindex, cthemeIndex);
    ref.read(prefProvider.notifier).saveString(_primary, cPrimary.hexCode);
    ref.read(prefProvider.notifier).saveString(_secondary, cSecondary.hexCode);
    ref.read(prefProvider.notifier).saveString(_tertiary, cTertiary.hexCode);
  }
}

class ThemeSelector extends ConsumerWidget {
  const ThemeSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    GlobalAppTheme globalAppTheme = ref.watch(globalThemeProvider);

    return SizedBox(
      width: 200,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ThemeTypePopupButton(),

            if (globalAppTheme.type != ThemeType.custom) ThemePopupButton(),

            if (globalAppTheme.type == ThemeType.custom)
              ColorPicker(
                title: Text("Primary"),
                showHexCode: true,
                initialColor: globalAppTheme.primary,
                onChange: (color) {
                  ref
                      .read(globalThemeProvider.notifier)
                      .setTheme(primary: color);
                },
              ),

            if (globalAppTheme.type == ThemeType.custom)
              ColorPicker(
                title: Text("Secondary"),
                showHexCode: true,
                initialColor: globalAppTheme.secondary,
                onChange: (color) {
                  ref
                      .read(globalThemeProvider.notifier)
                      .setTheme(secondary: color);
                },
              ),

            if (globalAppTheme.type == ThemeType.custom)
              ColorPicker(
                title: Text("Tertiary"),
                showHexCode: true,
                initialColor: globalAppTheme.tertiary,
                onChange: (color) {
                  ref
                      .read(globalThemeProvider.notifier)
                      .setTheme(tertiary: color);
                },
              ),
          ],
        ),
      ),
    );
  }
}

class ThemePopupButton extends ConsumerWidget {
  const ThemePopupButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopupMenuButton<AppTheme>(
      itemBuilder: (context) {
        return AppTheme.themes
            .map<PopupMenuEntry<AppTheme>>(
              (e) => PopupMenuItem(
                value: e,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text(e.name.toUpperCase()), Icon(e.icon)],
                ),
              ),
            )
            .toList();
      },
      onSelected: (apptheme) {
        ref.read(globalThemeProvider.notifier).setTheme(name: apptheme.name);
      },
      position: PopupMenuPosition.under,
      offset: const Offset(1, -120),
      child: ListTile(
        visualDensity: VisualDensity.compact,
        title: Text('Theme', style: context.tm),
        subtitle: Text(AppTheme.currentTheme.name),
        trailing: Icon(AppTheme.currentTheme.icon),
      ),
    );
  }
}

class ThemeTypePopupButton extends ConsumerWidget {
  const ThemeTypePopupButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopupMenuButton<ThemeType>(
      itemBuilder: (context) {
        return ThemeType.values
            .map<PopupMenuEntry<ThemeType>>(
              (e) => PopupMenuItem(
                value: e,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text(e.name.toUpperCase()), e.icon],
                ),
              ),
            )
            .toList();
      },
      onSelected: (type) {
        ref.read(globalThemeProvider.notifier).setTheme(type: type);
      },
      position: PopupMenuPosition.under,
      offset: const Offset(1, -120),
      child: ListTile(
        visualDensity: VisualDensity.compact,
        title: Text('Type', style: context.tm),
        subtitle: Text(AppTheme.currentTheme.name),
        trailing: Icon(AppTheme.currentTheme.icon),
      ),
    );
  }
}

class ThemeBrightnessButton extends ConsumerWidget {
  const ThemeBrightnessButton({super.key, this.showTooltipBelow = true});

  final bool showTooltipBelow;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    GlobalAppTheme globalAppTheme = ref.watch(globalThemeProvider);

    return Tooltip(
      preferBelow: showTooltipBelow,
      message: 'Toggle brightness',
      child: IconButton(
        icon: globalAppTheme.type.icon,
        onPressed: () {
          final type = AppTheme.currentTheme.dark
              ? ThemeType.light
              : ThemeType.dark;

          ref.read(globalThemeProvider.notifier).setTheme(type: type);
        },
      ),
    );
  }
}

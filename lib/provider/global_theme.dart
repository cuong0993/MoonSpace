import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moonspace/form/color.dart';
import 'package:moonspace/helper/extensions/color.dart';
import 'package:moonspace/helper/extensions/theme_ext.dart';
import 'package:moonspace/theme.dart';
import 'package:moonspace/widgets/functions.dart';
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
  final ThemeType theme;

  final int appThemeIndex;

  final Color primary;
  final Color secondary;
  final Color tertiary;

  GlobalAppTheme({
    required this.theme,
    required this.appThemeIndex,
    required this.primary,
    required this.secondary,
    required this.tertiary,
  });

  GlobalAppTheme copyWith({
    ThemeType? type,
    int? appThemeIndex,
    Color? primary,
    Color? secondary,
    Color? tertiary,
  }) {
    return GlobalAppTheme(
      theme: type ?? this.theme,
      appThemeIndex: appThemeIndex ?? this.appThemeIndex,
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      tertiary: tertiary ?? this.tertiary,
    );
  }
}

const String _theme = 'theme';
const String _apptheme = 'apptheme';
const String _primary = 'primary';
const String _secondary = 'secondary';
const String _tertiary = 'tertiary';

@Riverpod(keepAlive: true)
class GlobalTheme extends _$GlobalTheme {
  @override
  GlobalAppTheme build() {
    ref.watch(prefProvider);
    ThemeType theme = ThemeType.from(
      ref.read(prefProvider.notifier).getString(_theme),
    );
    int? appthemeIndex = ref.read(prefProvider.notifier).getInt(_apptheme);
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

    return GlobalAppTheme(
      theme: theme,
      appThemeIndex: appthemeIndex ?? 0,
      primary: primary ?? const Color.fromARGB(255, 143, 111, 223),
      secondary: secondary ?? const Color.fromARGB(255, 255, 126, 193),
      tertiary: tertiary ?? Colors.yellow,
    );
  }

  void setThemeType(ThemeType type) {
    final themeIndex = AppTheme.themes.indexWhere((t) {
      if ((type.brightness == Brightness.dark) == t.dark) {
        return true;
      }
      return false;
    });

    AppTheme.currentThemeIndex = themeIndex;

    state = state.copyWith(type: type, appThemeIndex: themeIndex);
    ref.read(prefProvider.notifier).saveString(_theme, state.theme.toString());
    ref.read(prefProvider.notifier).saveInt(_apptheme, themeIndex);
  }

  void setThemeIndex(int themeIndex) {
    state = state.copyWith(appThemeIndex: themeIndex);
    ref.read(prefProvider.notifier).saveInt(_apptheme, themeIndex);
  }

  void setPrimary(Color primary) {
    state = state.copyWith(primary: primary);
    ref.read(prefProvider.notifier).saveString(_primary, primary.hexCode);
  }

  void setSecondary(Color secondary) {
    state = state.copyWith(secondary: secondary);
    ref.read(prefProvider.notifier).saveString(_secondary, secondary.hexCode);
  }

  void setTertiary(Color tertiary) {
    state = state.copyWith(tertiary: tertiary);
    ref.read(prefProvider.notifier).saveString(_tertiary, tertiary.hexCode);
  }
}

class ThemeColorSelector extends ConsumerWidget {
  const ThemeColorSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    GlobalAppTheme globalAppTheme = ref.watch(globalThemeProvider);

    return IconButton(
      onPressed: () {
        context.showFormDialog(
          builder: (context) {
            return Container(
              width: 200,
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DropdownButtonFormField(
                      hint: Text("Type"),
                      value: globalAppTheme.theme,
                      items: ThemeType.values
                          .map(
                            (e) =>
                                DropdownMenuItem(value: e, child: Text(e.name)),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          ref
                              .read(globalThemeProvider.notifier)
                              .setThemeType(value);
                        }
                      },
                    ),

                    DropdownButtonFormField(
                      hint: Text("Theme"),
                      value: AppTheme.currentTheme.name,
                      items: AppTheme.themes.indexed
                          .map(
                            (e) => DropdownMenuItem(
                              value: e.$2.name,
                              child: Text(e.$2.name.toString()),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          ref
                              .read(globalThemeProvider.notifier)
                              .setThemeIndex(
                                AppTheme.themes.indexWhere(
                                  (t) => t.name == value,
                                ),
                              );
                        }
                      },
                    ),

                    ColorPicker(
                      title: Text("Primary"),
                      showHexCode: true,
                      initialColor: globalAppTheme.primary,
                      onChange: (color) {
                        ref
                            .read(globalThemeProvider.notifier)
                            .setPrimary(color);
                      },
                    ),

                    ColorPicker(
                      title: Text("Secondary"),
                      showHexCode: true,
                      initialColor: globalAppTheme.secondary,
                      onChange: (color) {
                        ref
                            .read(globalThemeProvider.notifier)
                            .setSecondary(color);
                      },
                    ),

                    ColorPicker(
                      title: Text("Tertiary"),
                      showHexCode: true,
                      initialColor: globalAppTheme.tertiary,
                      onChange: (color) {
                        ref
                            .read(globalThemeProvider.notifier)
                            .setTertiary(color);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      icon: Icon(Icons.color_lens_outlined),
    );
  }
}

class ThemePopupButton extends ConsumerWidget {
  const ThemePopupButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    GlobalAppTheme globalAppTheme = ref.watch(globalThemeProvider);

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
      onSelected: (v) {
        ref.read(globalThemeProvider.notifier).setThemeType(v);
      },
      position: PopupMenuPosition.under,
      offset: const Offset(1, -120),
      child: ListTile(
        visualDensity: VisualDensity.compact,
        title: Text('Theme', style: context.tm),
        subtitle: Text(globalAppTheme.theme.name),
        trailing: globalAppTheme.theme.icon,
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

    final isBright = Theme.of(context).brightness == Brightness.light;
    return Tooltip(
      preferBelow: showTooltipBelow,
      message: 'Toggle brightness',
      child: IconButton(
        icon: globalAppTheme.theme.icon,
        onPressed: () {
          ref
              .read(globalThemeProvider.notifier)
              .setThemeType(isBright ? ThemeType.dark : ThemeType.light);
        },
      ),
    );
  }
}

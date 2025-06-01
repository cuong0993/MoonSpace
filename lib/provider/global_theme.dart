import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moonspace/helper/extensions/color.dart';
import 'package:moonspace/helper/extensions/theme_ext.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:moonspace/provider/pref.dart';

part 'global_theme.g.dart';

enum ThemeType {
  system(Icon(CupertinoIcons.cloud_sun_rain)),
  dark(Icon(CupertinoIcons.moon_stars)),
  light(Icon(CupertinoIcons.sun_min));

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
  final Color color;

  GlobalAppTheme({required this.theme, required this.color});

  GlobalAppTheme copyWith({ThemeType? theme, Color? color}) {
    return GlobalAppTheme(
      theme: theme ?? this.theme,
      color: color ?? this.color,
    );
  }
}

const String _theme = 'theme';
const String _color = 'color';

@Riverpod(keepAlive: true)
class GlobalTheme extends _$GlobalTheme {
  @override
  GlobalAppTheme build() {
    ref.watch(prefProvider);
    ThemeType theme = ThemeType.from(
      ref.read(prefProvider.notifier).getString(_theme),
    );
    Color? color = ref
        .read(prefProvider.notifier)
        .getString(_color)
        ?.tryToColor();
    return GlobalAppTheme(theme: theme, color: color ?? Colors.indigo);
  }

  void setThemeType(ThemeType theme) {
    state = state.copyWith(theme: theme);
    ref.read(prefProvider.notifier).saveString(_theme, state.theme.toString());
  }

  void setColor(Color color) {
    state = state.copyWith(color: color);
    ref.read(prefProvider.notifier).saveString(_color, state.color.hexCode);
  }
}

class ThemeColorSelector extends ConsumerWidget {
  const ThemeColorSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    GlobalAppTheme globalAppTheme = ref.watch(globalThemeProvider);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: Colors.primaries
              .map(
                (c) => Semantics(
                  label: 'Color',
                  button: true,
                  enabled: true,
                  child: InkWell(
                    onTap: () {
                      ref.read(globalThemeProvider.notifier).setColor(c);
                    },
                    child: Container(
                      width: 48,
                      height: 48,
                      margin: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          globalAppTheme.color.hexCode == c.hexCode ? 32 : 4,
                        ),
                        color: c,
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ),
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

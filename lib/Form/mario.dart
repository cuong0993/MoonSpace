// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:moonspace/helper/extensions/theme_ext.dart';
import 'package:moonspace/helper/validator/type_check.dart';

class MAction {
  final String text;
  final Function(BuildContext context) fn;
  final bool destructive;
  final bool defaultAction;
  final IconData? icon;

  MAction({
    required this.text,
    required this.fn,
    this.icon,
    this.destructive = false,
    this.defaultAction = false,
  });

  Widget popup(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        // const SizedBox(width: 10),
        if (icon != null) Icon(icon),
        const SizedBox(width: 8),
        Text(
          text,
          style: destructive ? context.tm.c(Colors.red) : context.tm,
        ),
      ],
    );
  }

  CupertinoActionSheetAction cupertinoSheetAction(BuildContext context) {
    return CupertinoActionSheetAction(
      onPressed: () => fn.call(context),
      isDestructiveAction: destructive,
      isDefaultAction: defaultAction,
      child: popup(context),
    );
  }

  CupertinoDialogAction cupertinoDialogAction(BuildContext context) => CupertinoDialogAction(
        onPressed: () => fn.call(context),
        isDestructiveAction: destructive,
        isDefaultAction: defaultAction,
        child: popup(context),
      );

  CupertinoContextMenuAction cupertinoContextMenuAction(BuildContext context) => CupertinoContextMenuAction(
        onPressed: () => fn.call(context),
        isDestructiveAction: destructive,
        isDefaultAction: defaultAction,
        trailingIcon: icon,
        child: popup(context),
      );
}

extension SuperMAction on List<MAction> {
  List<Widget> toButtonBar(BuildContext context) => fold(
        [],
        (previousValue, e) => [
          ...previousValue,

          //
          (e == last)
              ? FilledButton(
                  onPressed: () => e.fn.call(context),
                  style: FilledButton.styleFrom(padding: const EdgeInsets.all(0)),
                  child: Text(e.text),
                )
              : OutlinedButton(
                  onPressed: () => e.fn.call(context),
                  style: OutlinedButton.styleFrom(padding: const EdgeInsets.all(0)),
                  child: Text(e.text),
                ),

          //
          // const SizedBox(width: 4),
        ],
      );
}

class PopupMenu extends StatelessWidget {
  const PopupMenu({super.key, required this.actions, this.child});

  final List<MAction?> actions;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      icon: child == null ? const Icon(Icons.more_vert) : null,
      iconSize: 20,
      color: context.theme.canvas,
      surfaceTintColor: Colors.white,
      splashRadius: 24,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      itemBuilder: (context) {
        return actions
            .asMap()
            .entries
            .map<PopupMenuEntry<int>>(
              (e) =>
                  cast<PopupMenuEntry<int>>(
                    (e.value != null)
                        ? PopupMenuItem<int>(
                            value: e.key,
                            child: /*e.value?.widget ??*/ e.value?.popup(context),
                          )
                        : const PopupMenuDivider(),
                  ) ??
                  const PopupMenuDivider(),
            )
            .toList();
      },
      onSelected: (value) {
        (actions[value]?.fn ?? () {})();
      },
      child: child,
    );
  }
}

void marioBar({
  required BuildContext context,
  required String content,
  String? title,
  Widget? icon,
  List<Widget>? actions,
  bool close = true,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      // margin: (deco?.mar ?? e8).copyWith(bottom: 6),
      // behavior: SnackBarBehavior.floating,
      // animation: ,
      dismissDirection: DismissDirection.horizontal,
      duration: const Duration(seconds: 4),
      content: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(width: 10),
          if (icon != null) icon,
          if (icon != null) const SizedBox(width: 20),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title != null) Text(title),
              const SizedBox(height: 6),
              Text(content),
            ],
          ),
          const SizedBox(width: 10),
          ...?actions,
          const SizedBox(width: 10),
        ],
      ),
      showCloseIcon: close,
    ),
  );
}

void marioBanner({
  required BuildContext context,
  required String title,
  Widget? icon,
  required String content,
  List<Widget>? actions,
}) {
  ScaffoldMessenger.of(context).showMaterialBanner(
    MaterialBanner(
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  ScaffoldMessenger.of(context).removeCurrentMaterialBanner();
                },
              ),
            ],
          ),
          Text(content),
        ],
      ),
      leading: icon,
      actions: actions ?? [],
    ),
  );
}

Future<T?> marioActionSheet<T>({
  required BuildContext context,
  String? title,
  String? message,
  required List<MAction> actions,
}) async {
  return await showCupertinoModalPopup<T>(
    context: context,
    builder: (context) {
      return CupertinoActionSheet(
        title: title != null ? Text(title) : null,
        message: message != null ? Text(message) : null,
        actions: actions
            .map(
              (e) => e.cupertinoSheetAction(context),
            )
            .toList(),
        cancelButton: CupertinoActionSheetAction(
          onPressed: () {
            context.nav.pop();
          },
          isDefaultAction: true,
          child: const Text('Cancel'),
        ),
      );
    },
  );
}

Future<T?> marioSheet<T>({
  required BuildContext context,
  required List<Widget> Function(BuildContext context) children,
  void Function(bool didPop)? onPopInvoked,
  GlobalKey<FormState>? formKey,
  VoidCallback? onChanged,
  double? width,
  double? height,
  Widget? title,
  Color? color,
  Color? titleColor,
  bool showDragHandle = true,
  double horizontalPadding = 12,
  ShapeBorder? border,
  Widget Function(BuildContext context)? actions,
}) async {
  return await showModalBottomSheet<T>(
    context: context,
    // showDragHandle: showDragHandle,
    useSafeArea: true,
    shape: border, //1.bs.c(Colors.green).round.r(12),
    clipBehavior: Clip.hardEdge,
    constraints: BoxConstraints(
      maxWidth: context.mq.w - horizontalPadding,
    ),
    backgroundColor: color,

    //
    // useRootNavigator: true,
    // isScrollControlled: true,

    builder: (context) {
      return PopScope(
        onPopInvoked: onPopInvoked,
        child: Form(
          key: formKey,
          onChanged: onChanged,
          child: MarioBox(
            title: title,
            sheet: true,
            actions: actions,
            width: width,
            height: height,
            titleColor: titleColor,
            children: children,
          ),
        ),
      );
    },
  );
}

Future<T?> marioDialog<T>({
  required BuildContext context,
  required List<Widget> Function(BuildContext context) children,
  GlobalKey<FormState>? formKey,
  VoidCallback? onChanged,
  void Function(bool didPop)? onPopInvoked,
  double? width,
  double? height,
  Widget? title,
  Color? color,
  Color? titleColor,
  ShapeBorder? border,
  EdgeInsets? insetPadding,
  Widget Function(BuildContext context)? actions,
}) {
  return showDialog<T>(
    context: context,
    builder: (BuildContext context) {
      return PopScope(
        onPopInvoked: onPopInvoked,
        child: Dialog(
          insetPadding: insetPadding ?? const EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0),
          backgroundColor: color,
          clipBehavior: Clip.hardEdge,
          shape: border,
          child: Form(
            key: formKey,
            onChanged: onChanged,
            child: MarioBox(
              title: title,
              actions: actions,
              width: width,
              height: height,
              titleColor: titleColor,
              children: children,
            ),
          ),
        ),
      );
    },
  );
}

class MarioChoice<T> extends StatelessWidget {
  const MarioChoice({
    super.key,
    required this.choices,
    this.selected = const {},
    this.multi = false,
    required this.child,
    this.semanticLabel,
    required this.title,
    required this.actions,
  });

  final Widget child;
  final Set<T> choices;
  final Set<T> selected;
  final bool multi;
  final String? semanticLabel;
  final Widget title;
  final Widget Function(BuildContext context, Set<T> selectedRadio) actions;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      button: true,
      enabled: true,
      child: InkWell(
        child: child,
        onTap: () {
          marioDialog(
            title: title,
            context: context,
            height: 400,
            children: (context) => [
              MarioChoiceBox(
                choices: choices,
                title: title,
                actions: actions,
                multi: multi,
                child: child,
              ),
            ],
          );
        },
      ),
    );
  }
}

class MarioChoiceBox<T> extends StatefulWidget {
  const MarioChoiceBox({
    super.key,
    required this.choices,
    this.selected = const {},
    this.multi = false,
    required this.child,
    this.semanticLabel,
    required this.title,
    required this.actions,
  });

  final Widget child;
  final Set<T> choices;
  final Set<T> selected;
  final bool multi;
  final String? semanticLabel;
  final Widget title;
  final Widget Function(BuildContext context, Set<T> selectedRadio) actions;

  @override
  State<MarioChoiceBox<T>> createState() => _MarioChoiceBoxState<T>();
}

class _MarioChoiceBoxState<T> extends State<MarioChoiceBox<T>> {
  Set<T> selectedRadio = {};
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...List<Widget>.generate(
          widget.choices.length,
          (index) {
            return widget.multi
                ? CheckboxListTile(
                    contentPadding: const EdgeInsets.only(left: 10),
                    title: Text(widget.choices.elementAt(index).toString()),
                    value: selectedRadio.contains(widget.choices.elementAt(index)),
                    onChanged: (value) {
                      if (value == true) {
                        setState(() => selectedRadio.add(widget.choices.elementAt(index)));
                      } else {
                        setState(() => selectedRadio.remove(widget.choices.elementAt(index)));
                      }
                    },
                  )
                : RadioListTile<T>(
                    contentPadding: const EdgeInsets.only(left: 10),
                    title: Text(widget.choices.elementAt(index).toString()),
                    value: widget.choices.elementAt(index),
                    groupValue: selectedRadio.length == 1 ? selectedRadio.first : null,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => selectedRadio = {value});
                      }
                    },
                  );
          },
        ),
        widget.actions.call(context, selectedRadio),
      ],
    );
  }
}

class MarioBox extends StatelessWidget {
  const MarioBox({
    super.key,
    this.title,
    required this.children,
    this.actions,
    this.width,
    this.height,
    this.sheet = false,
    this.titleColor,
  });

  final Widget? title;
  final List<Widget> Function(BuildContext context) children;
  final bool sheet;
  final Widget Function(BuildContext context)? actions;
  final double? width;
  final double? height;
  final Color? titleColor;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Container(
              color: titleColor,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: title,
            ),
          ConstrainedBox(
            constraints: BoxConstraints(minHeight: 0, maxHeight: height ?? 500),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                children: [...children(context)],
              ),
            ),
          ),
          if (actions != null)
            Container(
              color: titleColor,
              padding: const EdgeInsets.all(8.0),
              child: actions?.call(context),
              // child: Row(
              //   mainAxisAlignment: mEnd,
              //   children: actions.toButtonBar(context),
              // ),
            ),
          if (sheet) const SizedBox(height: 20),
        ],
      ),
    );
  }
}

Future<T?> marioAlertDialog<T>({
  required BuildContext context,
  required String title,
  String? content,
  IconData? icon,
  required List<MAction> Function(BuildContext context) actions,
}) {
  if (Device.isWeb || !Device.isIos) {
    return showDialog<T>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: content != null ? Text(content) : null,
          icon: icon != null ? Icon(icon) : null,
          actions: actions(context).toButtonBar(context),
          semanticLabel: title,
        );
      },
    );
  } else {
    return showCupertinoDialog<T>(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(title),
          content: content != null ? Text(content) : null,
          actions: actions(context).map((e) => e.cupertinoDialogAction(context)).toList(),
        );
      },
    );
  }
}

Future<bool> showYesNo({required BuildContext context, required String title, String? content}) async {
  return (await marioAlertDialog<bool>(
        context: context,
        title: title,
        content: content,
        actions: (context) {
          return [
            MAction(
              text: 'cancel',
              fn: (context) => Navigator.pop(context, false),
            ),
            MAction(
              text: 'yes',
              fn: (context) => Navigator.pop(context, true),
            ),
          ];
        },
      ) ??
      false);
}

/////////////////////////

class MySearchDelegate extends SearchDelegate {
  List<String> searchRes = [
    'Earth',
    'Sun',
    'Saturn',
    'Mercury',
    'Moon',
  ];

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          if (query.isEmpty) {
            close(context, null);
          }
          query = '';
        },
      ),
      IconButton(
        icon: const Icon(Icons.translate),
        onPressed: () {},
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center(child: Text(query));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> res = searchRes.where((e) {
      return e.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return Column(
      children: [
        Expanded(
          flex: 1,
          child: Container(
            height: 300,
            width: 300,
            color: Colors.red,
          ),
        ),
        Expanded(
          flex: 1,
          child: ListView.builder(
            itemBuilder: (context, i) {
              return ListTile(
                title: Text(res[i]),
                onTap: () {
                  query = res[i];

                  showResults(context);
                },
              );
            },
            itemCount: res.length,
          ),
        ),
      ],
    );
  }
}

//////|___________|//////
//////|           |//////
//////|  Overlay  |//////
//////|           |//////
//////|___________|//////

typedef CloseLoadingScreen = bool Function();
typedef UpdateLoadingScreen = bool Function(String text);

@immutable
class LoadingScreenController {
  final CloseLoadingScreen close;
  final UpdateLoadingScreen update;

  const LoadingScreenController({required this.close, required this.update});
}

class LoadingScreen {
  static final LoadingScreen _shared = LoadingScreen._sharedInstance();
  LoadingScreen._sharedInstance();
  factory LoadingScreen() => _shared;

  LoadingScreenController? controller;

  LoadingScreenController? show({
    required BuildContext context,
    required String text,
    Widget? action,
    bool hideable = true,
  }) {
    if (controller?.update(text) ?? false) {
    } else {
      controller = _showOverlay(
        context: context,
        text: text,
        action: action,
        hideable: hideable,
      );
    }
    return controller;
  }

  void hide() {
    controller?.close();
    controller = null;
  }

  LoadingScreenController _showOverlay({
    required BuildContext context,
    required String text,
    Widget? action,
    bool hideable = true,
  }) {
    final infoText = StreamController<String>();
    infoText.add(text);

    final state = Overlay.of(context);
    // final renderBox = context.findRenderObject() as RenderBox;
    // final size = renderBox.size;

    final overlay = OverlayEntry(
      builder: (context) {
        return LoadingBox(
          textStream: infoText,
          action: action,
          hideable: hideable,
        );
      },
    );

    state.insert(overlay);

    return LoadingScreenController(
      close: () {
        infoText.close();
        overlay.remove();
        overlay.dispose();
        return true;
      },
      update: (text) {
        infoText.add(text);
        return true;
      },
    );
  }
}

class LoadingBox extends StatelessWidget {
  const LoadingBox({
    super.key,
    required this.textStream,
    this.action,
    this.hideable = true,
  });

  final StreamController<String> textStream;
  final Widget? action;
  final bool hideable;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (hideable) {
          LoadingScreen().hide();
        }
      },
      child: Animate(
        effects: const [
          FadeEffect(
            begin: 0,
            end: 1,
            duration: Duration(milliseconds: 300),
          ),
        ],
        child: Material(
          color: Colors.blue.withAlpha(40),
          child: Center(
            child: Container(
              constraints: const BoxConstraints(
                maxWidth: 400,
                maxHeight: 300,
                minWidth: 300,
                // maxHeight: size.height * 0.8,
                // minWidth: min(size.width * 0.5, 400),
              ),
              decoration: BoxDecoration(
                color: context.theme.scafBg,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: AspectRatio(
                aspectRatio: 1,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: StreamBuilder(
                          stream: textStream.stream,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Stack(
                                children: [
                                  Center(
                                    child: SizedBox(
                                      width: 200,
                                      height: 200,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 10,
                                        value: double.tryParse(snapshot.data ?? '0')?.clamp(0, 1),
                                      ),
                                    ),
                                  ),
                                  Center(
                                    child: Text(
                                      snapshot.data as String,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              );
                            } else {
                              return Container();
                            }
                          },
                        ),
                      ),
                      if (action != null) action!
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AnimatedOverlay extends StatefulWidget {
  const AnimatedOverlay({
    super.key,
    required this.builder,
    this.duration,
    required this.scafSize,
    required this.offset,
    this.alignment = Alignment.bottomCenter,
  });

  final Widget Function(bool hide, Size scafSize, Offset offset) builder;
  final Duration? duration;
  final Offset offset;
  final Size scafSize;
  final AlignmentGeometry alignment;

  static LoadingScreenController? controller;

  static void show({
    required BuildContext context,
    required Widget Function(bool hide, Size scafSize, Offset offset) builder,
    Duration? duration,
    AlignmentGeometry alignment = Alignment.bottomCenter,
  }) {
    hide();
    final state = Overlay.of(context);

    final renderBox = context.findRenderObject() as RenderBox;
    final offsetSize = renderBox.size;
    final Offset offset = renderBox.localToGlobal(Offset(offsetSize.width / 2, 0));
    final scafSize = (Scaffold.of(context).context.findRenderObject() as RenderBox).size;

    final overlay = OverlayEntry(
      builder: (context) {
        return AnimatedOverlay(
          duration: duration,
          builder: builder,
          scafSize: scafSize,
          offset: offset,
          alignment: alignment,
        );
      },
    );

    state.insert(overlay);

    controller = LoadingScreenController(
      close: () {
        overlay.remove();
        overlay.dispose();
        return true;
      },
      update: (text) {
        return true;
      },
    );
  }

  static void hide() {
    controller?.close();
    controller = null;
  }

  @override
  State<AnimatedOverlay> createState() => _AnimatedOverlayState();
}

class _AnimatedOverlayState extends State<AnimatedOverlay> {
  bool hide = false;

  late final Timer timer;

  @override
  void initState() {
    if (widget.duration != null) {
      timer = Timer(widget.duration!, () {
        if (mounted) {
          hide = true;
          setState(() {});
        }
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.deferToChild,
      onTap: () => setState(() => hide = true),
      onVerticalDragStart: (details) {
        if (mounted) {
          setState(() => hide = true);
        }
      },
      onHorizontalDragStart: (details) {
        if (mounted) {
          setState(() => hide = true);
        }
      },
      child: SafeArea(
        top: false,
        child: Material(
          type: (widget.duration != null) ? MaterialType.transparency : MaterialType.canvas,
          color: Colors.transparent,
          child: Stack(
            alignment: widget.alignment,
            children: [
              widget.builder(hide, widget.scafSize, widget.offset),
            ],
          ),
        ),
      ),
    );
  }
}

class AnimatedSnackbar extends StatelessWidget {
  const AnimatedSnackbar({
    super.key,
    this.hide = true,
    this.duration = const Duration(seconds: 3),
    required this.content,
    required this.title,
    this.icon,
    this.decoration,
    this.padding,
    this.margin,
    this.action = const [],
  });

  final bool hide;
  final Duration duration;
  final String content;
  final String title;
  final Icon? icon;
  final BoxDecoration? decoration;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final List<Widget> action;

  AnimatedSnackbar copyWith({
    bool? hide,
    Duration? duration,
    String? content,
    String? title,
    Icon? icon,
    BoxDecoration? decoration,
    EdgeInsets? padding,
    EdgeInsets? margin,
    List<Widget>? action,
  }) {
    return AnimatedSnackbar(
      hide: hide ?? this.hide,
      duration: duration ?? this.duration,
      content: content ?? this.content,
      title: title ?? this.title,
      icon: icon ?? this.icon,
      decoration: decoration ?? this.decoration,
      padding: padding ?? this.padding,
      margin: margin ?? this.margin,
      action: action ?? this.action,
    );
  }

  void show(
    BuildContext context, {
    Duration? duration,
    AlignmentGeometry alignment = Alignment.bottomCenter,
  }) {
    AnimatedOverlay.show(
      context: context,
      alignment: alignment,
      duration: duration ?? const Duration(seconds: 3),
      builder: (hide, scafSize, offset) {
        return copyWith(hide: hide);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      duration: duration,
      tween: Tween(begin: hide ? 1.0 : 0.0, end: hide ? 0.0 : 1.0),
      curve: Curves.easeInOut,
      onEnd: () {
        if (hide) {
          AnimatedOverlay.hide();
        }
      },
      builder: (context, value, child) {
        final v = clampDouble(value * 4, 0, 1);
        return Transform.translate(
          offset: Offset(300 - v * 300, 0),
          child: Opacity(
            opacity: v,
            child: Container(
              decoration: decoration ??
                  BoxDecoration(
                    color: context.theme.csOnSur,
                    border: const Border(left: BorderSide(width: 10, color: Colors.green)),
                    borderRadius: 16.br,
                  ),
              margin: margin ?? const EdgeInsets.all(8),
              clipBehavior: Clip.antiAlias,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: padding ?? const EdgeInsets.all(8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: icon ??
                              Icon(
                                Icons.star_border,
                                color: context.theme.csSur,
                              ),
                        ),
                        // const SizedBox(height: 30, child: VerticalDivider()),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(title, style: context.tl.c(context.theme.csSur)),
                              // const Divider(),
                              Text(content, style: context.ts.c(context.theme.csSur)),
                            ],
                          ),
                        ),

                        //
                        ...action,
                        IconButton(
                          color: context.theme.csSur,
                          onPressed: () {
                            AnimatedOverlay.hide();
                          },
                          icon: const Icon(Icons.close),
                        )
                      ],
                    ),
                  ),
                  LinearProgressIndicator(value: value),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class AnimatedDialogBox extends StatelessWidget {
  const AnimatedDialogBox({
    super.key,
    this.hide = true,
    required this.boxSize,
    this.scafSize = Size.zero,
    this.offset = Offset.zero,
    required this.child,
  });

  final bool hide;
  final Size boxSize;
  final Offset offset;
  final Size scafSize;
  final Widget child;

  AnimatedDialogBox copyWith({
    bool? hide,
    Widget? child,
    Size? boxSize,
    Offset? offset,
    Size? scafSize,
  }) {
    return AnimatedDialogBox(
      hide: hide ?? this.hide,
      boxSize: boxSize ?? this.boxSize,
      offset: offset ?? this.offset,
      scafSize: scafSize ?? this.scafSize,
      child: child ?? this.child,
    );
  }

  void show(
    BuildContext context, {
    Duration? duration,
    AlignmentGeometry alignment = Alignment.bottomCenter,
  }) {
    AnimatedOverlay.show(
      context: context,
      alignment: alignment,
      builder: (hide, scafSize, offset) {
        return copyWith(
          hide: hide,
          scafSize: scafSize,
          offset: offset,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      duration: const Duration(milliseconds: 300),
      tween: Tween(begin: hide ? 0.9 : 0.0, end: hide ? 0.0 : 0.9),
      curve: Curves.easeInOut,
      onEnd: () {
        if (hide) {
          AnimatedOverlay.hide();
        }
      },
      builder: (context, value, child) {
        final x = offset.dx - (value * (boxSize.width / 2));
        final y = offset.dy - (value * boxSize.height) - 10;
        return Positioned(
          left: clampDouble(x, 10, scafSize.width - value * boxSize.width - 10),
          top: clampDouble(y, 100, scafSize.height - value * boxSize.height - 100),
          child: Semantics(
            label: 'Dialog box',
            child: Container(
              width: value * boxSize.width,
              clipBehavior: Clip.antiAlias,
              height: value * boxSize.height,
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 1,
                    spreadRadius: 1,
                    offset: Offset(0, 2),
                  ),
                ],
                borderRadius: BorderRadius.circular((1 - value) * 200),
              ),
              child: Opacity(
                opacity: value,
                child: Theme(
                  data: Theme.of(context).copyWith(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                  ),
                  child: GestureDetector(
                    onTap: () {},
                    onHorizontalDragStart: (details) {},
                    onVerticalDragStart: (details) {},
                    child: child,
                  ),
                ),
              ),
            ),
          ),
        );
      },
      child: child,
    );
  }
}

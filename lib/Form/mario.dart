import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:moonspace/helper/extensions/theme_ext.dart';
import 'package:moonspace/helper/validator/type_check.dart';

class MAction {
  final String text;
  final VoidCallback fn;
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

  Widget popup() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        // const SizedBox(width: 10),
        if (icon != null) Icon(icon),
        const SizedBox(width: 8),
        Text(text),
      ],
    );
  }

  CupertinoActionSheetAction cupertinoSheetAction() {
    return CupertinoActionSheetAction(
      onPressed: fn,
      isDestructiveAction: destructive,
      isDefaultAction: defaultAction,
      child: popup(),
    );
  }

  CupertinoDialogAction cupertinoDialogAction() => CupertinoDialogAction(
        onPressed: fn,
        isDestructiveAction: destructive,
        isDefaultAction: defaultAction,
        child: popup(),
      );

  CupertinoContextMenuAction cupertinoContextMenuAction() =>
      CupertinoContextMenuAction(
        onPressed: fn,
        isDestructiveAction: destructive,
        isDefaultAction: defaultAction,
        trailingIcon: icon,
        child: popup(),
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
                  onPressed: e.fn,
                  style:
                      FilledButton.styleFrom(padding: const EdgeInsets.all(0)),
                  child: Text(e.text),
                )
              : OutlinedButton(
                  onPressed: e.fn,
                  style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.all(0)),
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
                            child: /*e.value?.widget ??*/ e.value?.popup(),
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

// void rootPop(BuildContext context) {
//   Navigator.of(context).popUntil((route) {
//     print(ModalRoute.of(context)?.settings);
//     print(route.settings.name);
//     return true;
//     return route.settings.name == '/';
//   });
// }

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
              (e) => e.cupertinoSheetAction(),
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
  required List<Widget> children,
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
  Widget? actions,
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
  required List<Widget> children,
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
  Widget? actions,
}) {
  return showDialog<T>(
    context: context,
    builder: (BuildContext context) {
      return PopScope(
        onPopInvoked: onPopInvoked,
        child: Dialog(
          insetPadding: insetPadding ??
              const EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0),
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
    required this.selectionUpdate,
    this.multi = false,
  });

  final Set<T> choices;
  final Set<T> selected;
  final Function(Set<T> selection) selectionUpdate;
  final bool multi;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Set<T> selectedRadio = {};

        marioDialog(
          title: const Text('Mario Choice'),
          context: context,
          height: 400,
          children: [
            StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: List<Widget>.generate(choices.length, (index) {
                    return multi
                        ? CheckboxListTile.adaptive(
                            title: Text(choices.elementAt(index).toString()),
                            value: selectedRadio
                                .contains(choices.elementAt(index)),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() => selectedRadio
                                    .add(choices.elementAt(index)));
                              }
                            },
                          )
                        : RadioListTile<T>.adaptive(
                            title: Text(choices.elementAt(index).toString()),
                            value: choices.elementAt(index),
                            groupValue: selectedRadio.length == 1
                                ? selectedRadio.first
                                : null,
                            onChanged: (value) {
                              // print(value);
                              if (value != null) {
                                setState(() => selectedRadio = {value});
                              }
                            },
                          );
                  }),
                );
              },
            ),
          ],
          actions: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                child: const Text('CANCEL'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  selectionUpdate(selectedRadio);

                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
      child: Text(selected.toString()),
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
  final List<Widget> children;
  final bool sheet;
  final Widget? actions;
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
                children: [...children],
              ),
            ),
          ),
          if (actions != null)
            Container(
              color: titleColor,
              padding: const EdgeInsets.all(8.0),
              child: actions,
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
  required List<MAction> actions,
}) {
  if (Device.isWeb || !Device.isIos) {
    return showDialog<T>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: content != null ? Text(content) : null,
          icon: icon != null ? Icon(icon) : null,
          actions: actions.toButtonBar(context),
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
          actions: actions.map((e) => e.cupertinoDialogAction()).toList(),
        );
      },
    );
  }
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
                                        value: double.tryParse(
                                                snapshot.data ?? '0')
                                            ?.clamp(0, 1),
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

class ContextMenu extends StatelessWidget {
  const ContextMenu({
    super.key,
    required this.child,
    required this.optionChild,
    required this.boxSize,
  });

  final Widget child;
  final Widget optionChild;
  final Size boxSize;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ContextOverlay().show(
          context: context,
          child: optionChild,
          boxSize: boxSize,
        );
      },
      child: child,
    );
  }

  static void hide() {
    ContextOverlay._shared.hide();
  }
}

class ContextOverlay {
  static final ContextOverlay _shared = ContextOverlay._sharedInstance();
  ContextOverlay._sharedInstance();
  factory ContextOverlay() => _shared;

  LoadingScreenController? controller;

  void show(
      {required BuildContext context,
      required Widget child,
      required Size boxSize}) {
    controller = showOverlay(context: context, child: child, boxSize: boxSize);
  }

  void hide() {
    controller?.close();
    controller = null;
  }

  LoadingScreenController showOverlay({
    required BuildContext context,
    required Widget child,
    required Size boxSize,
  }) {
    ContextMenu.hide();
    final state = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    // final offsetSize = renderBox.size;
    final Offset offset = renderBox.localToGlobal(Offset.zero);

    final scafSize =
        (Scaffold.of(context).context.findRenderObject() as RenderBox).size;

    final overlay = OverlayEntry(
      builder: (context) {
        return AnimatedDialog(
          scafSize: scafSize,
          offset: offset,
          boxSize: boxSize,
          child: child,
        );
      },
    );

    state.insert(overlay);

    return LoadingScreenController(
      close: () {
        overlay.remove();
        return true;
      },
      update: (text) {
        return true;
      },
    );
  }
}

class AnimatedDialog extends StatefulWidget {
  const AnimatedDialog({
    super.key,
    required this.scafSize,
    required this.offset,
    required this.boxSize,
    required this.child,
  });

  final Widget child;
  final Size scafSize;
  final Offset offset;
  final Size boxSize;

  @override
  State<AnimatedDialog> createState() => _AnimatedDialogState();
}

class _AnimatedDialogState extends State<AnimatedDialog> {
  bool hide = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.deferToChild,
      onTap: () => setState(() => hide = true),
      onVerticalDragStart: (details) => setState(() => hide = true),
      onHorizontalDragStart: (details) => setState(() => hide = true),
      child: Material(
        color: const Color.fromARGB(0, 243, 103, 33),
        child: Stack(
          children: [
            TweenAnimationBuilder(
              duration: const Duration(milliseconds: 300),
              tween: Tween(begin: hide ? 0.9 : 0.0, end: hide ? 0.0 : 0.9),
              curve: Curves.easeInOut,
              onEnd: () {
                if (hide) {
                  ContextOverlay().hide();
                }
              },
              builder: (context, value, child) {
                final x =
                    widget.offset.dx - (value * (widget.boxSize.width / 2));
                final y =
                    widget.offset.dy - (value * widget.boxSize.height) - 10;
                return Positioned(
                  left: clampDouble(
                      x,
                      10,
                      widget.scafSize.width -
                          value * widget.boxSize.width -
                          10),
                  top: clampDouble(
                      y,
                      100,
                      widget.scafSize.height -
                          value * widget.boxSize.height -
                          100),
                  child: Container(
                    width: value * widget.boxSize.width,
                    clipBehavior: Clip.antiAlias,
                    height: value * widget.boxSize.height,
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
                );
              },
              child: widget.child,
            ),
          ],
        ),
      ),
    );
  }
}

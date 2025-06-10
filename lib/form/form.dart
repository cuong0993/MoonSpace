import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:moonspace/helper/extensions/theme_ext.dart';

class ButtonData {
  final String text;
  final Function(BuildContext context) fn;
  final bool destructive;
  final bool defaultAction;
  final IconData? icon;
  final bool enabled;

  ButtonData({
    required this.text,
    required this.fn,
    this.icon,
    this.destructive = false,
    this.defaultAction = false,
    this.enabled = true,
  });

  Widget popup(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        // const SizedBox(width: 10),
        if (icon != null) Icon(icon),
        const SizedBox(width: 8),
        Text(text, style: destructive ? context.tm.c(Colors.red) : context.tm),
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

  CupertinoDialogAction cupertinoDialogAction(BuildContext context) =>
      CupertinoDialogAction(
        onPressed: () => fn.call(context),
        isDestructiveAction: destructive,
        isDefaultAction: defaultAction,
        child: popup(context),
      );

  CupertinoContextMenuAction cupertinoContextMenuAction(BuildContext context) =>
      CupertinoContextMenuAction(
        onPressed: () => fn.call(context),
        isDestructiveAction: destructive,
        isDefaultAction: defaultAction,
        trailingIcon: icon,
        child: popup(context),
      );
}

extension SuperMAction on List<ButtonData> {
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

  final List<ButtonData?> actions;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      icon: child == null ? const Icon(Icons.more_vert) : null,
      iconSize: 20,
      tooltip: 'tooltip',
      surfaceTintColor: Colors.white,
      splashRadius: 24,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      itemBuilder: (context) {
        return actions.asMap().entries.map<PopupMenuEntry<int>>((e) {
          return (e.value != null)
              ? PopupMenuItem<int>(
                  value: e.key,
                  enabled: e.value!.enabled,
                  child: /*e.value?.widget ??*/ e.value?.popup(context),
                )
              : const PopupMenuDivider();
        }).toList();
      },
      onSelected: (value) {
        (actions[value]?.fn ?? () {})();
      },
      child: child,
    );
  }
}

class Box extends StatelessWidget {
  const Box({
    super.key,
    this.title,
    required this.children,
    this.actions,
    this.width,
    this.height,
    this.padbottom = false,
  });

  final Widget? title;
  final List<Widget> Function(BuildContext context) children;
  final bool padbottom;
  final Widget Function(BuildContext context)? actions;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: title,
            ),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: width ?? double.infinity,
              maxHeight: height ?? double.infinity,
            ),
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
              padding: const EdgeInsets.all(8.0),
              child: actions?.call(context),
            ),
          if (padbottom) const SizedBox(height: 20),
        ],
      ),
    );
  }
}

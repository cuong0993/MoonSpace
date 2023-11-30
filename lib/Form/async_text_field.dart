import 'dart:async';

import 'package:flutter/material.dart';
import 'package:moonspace/helper/stream/functions.dart';
import 'package:moonspace/helper/validator/debug_functions.dart';
import 'package:moonspace/widgets/animated/animated_buttons.dart';

typedef AsyncText = ({String? error, bool load});

class AsyncTextFormField extends StatefulWidget {
  const AsyncTextFormField({
    super.key,
    this.con,
    required this.asyncValidator,
    this.style,
    this.initialValue,
    this.decoration,
    this.autofocus = false,
    this.enabled = true,
    this.showPrefix = true,
    this.showSubmitSuffix = true,
    this.suffix = const [],
    this.heading,
    this.milliseconds = 300,
    this.textAlign = TextAlign.start,
    this.maxLines,
    this.textInputAction,
    this.onSubmit,
    this.onTap,
    this.onEditingComplete,
  });

  final TextEditingController? con;
  final Future<String?> Function(String value) asyncValidator;
  final InputDecoration Function(AsyncText asyncText, TextEditingController textCon)? decoration;
  final String? initialValue;
  final bool autofocus;
  final bool showPrefix;
  final bool enabled;
  final bool showSubmitSuffix;
  final List<Widget> suffix;
  final Widget? heading;
  final int milliseconds;
  final TextStyle? style;
  final TextAlign textAlign;
  final int? maxLines;
  final TextInputAction? textInputAction;
  final Future<void> Function(TextEditingController controller)? onSubmit;
  final Future<void> Function(TextEditingController controller)? onTap;
  final Future<void> Function(TextEditingController controller)? onEditingComplete;

  @override
  State<AsyncTextFormField> createState() => _AsyncTextFormFieldState();
}

class _AsyncTextFormFieldState extends State<AsyncTextFormField> {
  AsyncText asyncText = (error: null, load: false);
  final focusNode = FocusNode(debugLabel: 'AsyncTextFormField');
  final key = GlobalKey<FormFieldState>();

  late TextEditingController textCon;

  late final StreamController<String> fnStream;

  @override
  void initState() {
    textCon = widget.con ?? TextEditingController(text: widget.initialValue);

    fnStream = createDebounceFunc(widget.milliseconds, (String name) async {
      asyncText = (error: 'Checking...', load: true);
      setState(() {});
      key.currentState?.validate();
      asyncText = (error: (await widget.asyncValidator(name)), load: false);
      setState(() {});
      key.currentState?.validate();
    });

    super.initState();
  }

  @override
  void dispose() {
    fnStream.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final child = TextFormField(
      controller: textCon,
      key: key,
      textAlign: widget.textAlign,

      autofocus: widget.autofocus,

      //
      onTapOutside: (event) => focusNode.unfocus(),
      onEditingComplete: () => widget.onEditingComplete?.call(textCon),
      onFieldSubmitted: (value) async {
        final res = await widget.asyncValidator(value);
        if (res == null) {
          widget.onSubmit?.call(textCon);
        }
      },
      onSaved: (v) => owl(v),
      onTap: () => widget.onTap?.call(textCon),
      //
      focusNode: focusNode,
      maxLines: widget.maxLines,
      enabled: widget.enabled,

      //
      style: widget.style,

      decoration: widget.decoration?.call(asyncText, textCon).copyWith(
            isDense: true,
            prefixIcon: !widget.showPrefix
                ? null
                : Container(
                    alignment: Alignment.center,
                    width: 20,
                    height: 20,
                    margin: const EdgeInsets.all(16),
                    child: (asyncText.error == null)
                        ? const Icon(Icons.done)
                        : (asyncText.load == true
                            ? const CircularProgressIndicator()
                            : const Icon(Icons.error_outline)),
                  ),
            suffixIcon: !widget.enabled
                ? null
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ...widget.suffix,
                      if (widget.showSubmitSuffix)
                        asyncText.load
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(),
                              )
                            : (widget.initialValue == textCon.text)
                                ? const Icon(Icons.edit)
                                : (asyncText.error != null)
                                    ? const Icon(Icons.error)
                                    : AsyncLock(
                                        builder: (isLoading, status, lock, open, setStatus) {
                                          return IconButton.filledTonal(
                                            icon: const Icon(Icons.done),
                                            onPressed: () async {
                                              lock();
                                              await widget.onSubmit?.call(textCon);
                                              open();
                                            },
                                          );
                                        },
                                      )
                    ],
                  ),
          ),
      onChanged: (value) => fnStream.add(value),
      validator: (value) {
        lava(value);
        if ((asyncText.load)) {
          return 'Checking';
        }
        return asyncText.error;
      },
      textInputAction: TextInputAction.done,
    );

    return widget.heading == null
        ? child
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              widget.heading!,
              child,
            ],
          );
  }
}

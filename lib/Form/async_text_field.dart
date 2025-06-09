import 'dart:async';

import 'package:flutter/material.dart';
import 'package:moonspace/helper/stream/debounce.dart';
import 'package:moonspace/helper/validator/debug_functions.dart';
import 'package:moonspace/widgets/async_lock.dart';

typedef AsyncTextType = ({String? error, bool load});

class AsyncTextFormField extends StatefulWidget {
  const AsyncTextFormField({
    super.key,
    this.controller,
    required this.asyncValidator,
    this.style,
    this.initialValue,
    this.decoration,
    this.autofocus = false,
    this.enabled = true,
    this.showPrefix = false,
    this.showSubmitSuffix = false,
    this.showClear = false,
    this.autocorrect = true,
    this.enableSuggestions = true,
    this.suffix = const [],
    this.milliseconds = 300,
    this.textAlign = TextAlign.start,
    this.textAlignVertical = TextAlignVertical.center,
    this.minLines,
    this.maxLines,
    this.maxLength,
    this.autofillHints,
    this.keyboardType,
    this.textInputAction,
    this.onChanged,
    this.onSubmit,
    this.onTap,
    this.clearFunc,
    this.onEditingComplete,
    this.buildCounter,
    this.scrollPhysics,
  });

  final TextEditingController? controller;
  final Future<String?> Function(String value) asyncValidator;
  final InputDecoration Function(
    AsyncTextType asyncText,
    TextEditingController textCon,
  )?
  decoration;
  final String? initialValue;
  final bool autofocus;
  final bool showPrefix;
  final bool enabled;
  final bool showSubmitSuffix;
  final bool showClear;
  final bool autocorrect;
  final bool enableSuggestions;
  final List<Widget> suffix;
  final int milliseconds;
  final TextStyle? style;
  final TextAlign textAlign;
  final TextAlignVertical textAlignVertical;
  final int? minLines;
  final int? maxLines;
  final int? maxLength;
  final Iterable<String>? autofillHints;
  final TextInputType? keyboardType;

  final TextInputAction? textInputAction;
  final void Function(String)? onChanged;
  final Future<void> Function(TextEditingController controller)? onSubmit;
  final Future<void> Function(TextEditingController controller)? onTap;
  final Future<void> Function(TextEditingController controller)?
  onEditingComplete;
  final Widget? Function(
    BuildContext, {
    required int currentLength,
    required bool isFocused,
    required int? maxLength,
  })?
  buildCounter;
  final void Function()? clearFunc;
  final ScrollPhysics? scrollPhysics;

  @override
  State<AsyncTextFormField> createState() => _AsyncTextFormFieldState();
}

class _AsyncTextFormFieldState extends State<AsyncTextFormField> {
  AsyncTextType asynctype = (error: null, load: false);
  final focusNode = FocusNode(debugLabel: 'AsyncTextFormField');
  final key = GlobalKey<FormFieldState>();

  late TextEditingController textCon;

  late final StreamController<String> validateStream;

  @override
  void initState() {
    textCon =
        widget.controller ?? TextEditingController(text: widget.initialValue);

    validateStream = createDebounceFunc(widget.milliseconds, (
      String name,
    ) async {
      asynctype = (error: 'Checking...', load: true);
      setState(() {});
      key.currentState?.validate();
      asynctype = (error: (await widget.asyncValidator(name)), load: false);
      setState(() {});
      key.currentState?.validate();
    });

    super.initState();
  }

  @override
  void dispose() {
    validateStream.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textCon,
      key: key,
      textAlign: widget.textAlign,
      textAlignVertical: widget.textAlignVertical,

      autofocus: widget.autofocus,

      //
      autocorrect: widget.autocorrect,
      enableSuggestions: widget.enableSuggestions,

      //
      onTapOutside: (event) => focusNode.unfocus(),
      onEditingComplete: () => widget.onEditingComplete?.call(textCon),
      onFieldSubmitted: (value) async {
        final res = await widget.asyncValidator(value);
        if (res == null && widget.initialValue != textCon.text) {
          widget.onSubmit?.call(textCon);
        }
      },
      onSaved: (v) => owl(v),
      onTap: () => widget.onTap?.call(textCon),
      //
      focusNode: focusNode,

      minLines: widget.minLines,
      maxLines: widget.maxLines,
      maxLength: widget.maxLength,
      enabled: widget.enabled,
      scrollPhysics: widget.scrollPhysics,

      //
      buildCounter: widget.buildCounter,

      //
      style: widget.style,

      decoration: widget.decoration
          ?.call(asynctype, textCon)
          .copyWith(
            isDense: true,
            prefixIcon: !widget.showPrefix
                ? null
                : Container(
                    alignment: Alignment.center,
                    width: 20,
                    height: 20,
                    margin: const EdgeInsets.all(16),
                    child: (asynctype.error == null)
                        ? const Icon(Icons.done)
                        : (asynctype.load == true
                              ? const CircularProgressIndicator()
                              : const Icon(Icons.error_outline)),
                  ),
            suffixIcon:
                (!widget.enabled ||
                    (widget.suffix.isEmpty &&
                        !widget.showSubmitSuffix &&
                        !widget.showClear))
                ? null
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ...widget.suffix,
                      if (widget.showClear && textCon.text.isNotEmpty)
                        IconButton.filledTonal(
                          icon: const Icon(Icons.clear),
                          onPressed: () async {
                            textCon.clear();
                            widget.clearFunc?.call();
                          },
                        ),
                      if (widget.showSubmitSuffix)
                        asynctype.load
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(),
                              )
                            : (widget.initialValue == textCon.text)
                            ? const Icon(Icons.edit)
                            : (asynctype.error != null)
                            ? const Icon(Icons.error)
                            : (widget.onSubmit == null)
                            ? const SizedBox()
                            : AsyncLock(
                                builder:
                                    (isLoading, status, lock, open, setStatus) {
                                      return IconButton.filledTonal(
                                        icon: const Icon(Icons.done),
                                        onPressed: () async {
                                          lock();
                                          await widget.onSubmit?.call(textCon);
                                          open();
                                        },
                                      );
                                    },
                              ),
                    ],
                  ),
          ),
      onChanged: (value) {
        widget.onChanged?.call(value);
        validateStream.add(value);
      },
      validator: (value) {
        lava(value);
        if ((asynctype.load)) {
          return 'Checking';
        }
        return asynctype.error;
      },
      textInputAction: widget.textInputAction ?? TextInputAction.next,
      autofillHints: widget.autofillHints,
      keyboardType: widget.keyboardType,
    );
  }
}

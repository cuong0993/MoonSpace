import 'dart:async';

import 'package:flutter/material.dart';
import 'package:moonspace/helper/stream/functions.dart';
import 'package:moonspace/helper/validator/debug_functions.dart';

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
    this.showPrefix = true,
    this.milliseconds = 300,
    this.textAlign = TextAlign.start,
    this.textInputAction,
    this.onSubmit,
  });

  final TextEditingController? con;
  final Future<String?> Function(String value) asyncValidator;
  final InputDecoration Function(AsyncText asyncText, TextEditingController textCon)? decoration;
  final String? initialValue;
  final bool autofocus;
  final bool showPrefix;
  final int milliseconds;
  final TextStyle? style;
  final TextAlign textAlign;
  final TextInputAction? textInputAction;
  final void Function(String value)? onSubmit;

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
    return TextFormField(
      controller: textCon,
      key: key,
      textAlign: widget.textAlign,

      autofocus: widget.autofocus,

      //
      onTapOutside: (event) => focusNode.unfocus(),
      onEditingComplete: () => owl('onEditingComplete'),
      onFieldSubmitted: widget.onSubmit,
      onSaved: (v) => owl(v),
      onTap: () => owl('onTap'),
      //
      focusNode: focusNode,

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
  }
}

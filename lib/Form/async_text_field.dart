import 'dart:async';

import 'package:flutter/material.dart';
import 'package:moonspace/Helper/debug_functions.dart';
import 'package:moonspace/Helper/functions.dart';

class AsyncTextFormField extends StatefulWidget {
  const AsyncTextFormField({
    super.key,
    this.con,
    required this.asyncFn,
    this.style,
    this.intialValue,
    this.decoration,
    this.autofocus = false,
    this.showPrefix = true,
    this.milliseconds = 300,
  });

  final TextEditingController? con;
  final Future<bool> Function(String value) asyncFn;
  final InputDecoration? decoration;
  final String? intialValue;
  final bool autofocus;
  final bool showPrefix;
  final int milliseconds;
  final TextStyle? style;

  @override
  State<AsyncTextFormField> createState() => _AsyncTextFormFieldState();
}

class _AsyncTextFormFieldState extends State<AsyncTextFormField> {
  ({bool valid, bool load})? allowedtText;
  final focusNode = FocusNode(debugLabel: 'AsyncTextFormField');
  final key = GlobalKey<FormFieldState>();

  late final StreamController<String> fnStream;

  @override
  void initState() {
    fnStream = createDebounceFunc(widget.milliseconds, (String name) async {
      allowedtText = (valid: false, load: true);
      setState(() {});
      key.currentState?.validate();
      allowedtText = (valid: (await widget.asyncFn(name)), load: false);
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
      controller: widget.con,
      key: key,
      initialValue: widget.intialValue,

      autofocus: widget.autofocus,

      //
      onTapOutside: (event) => focusNode.unfocus(),
      onEditingComplete: () => owl('onEditingComplete'),
      onFieldSubmitted: (value) => owl('onFieldSubmitted'),
      onSaved: (v) => owl(v),
      onTap: () => owl('onTap'),
      //
      focusNode: focusNode,

      //
      style: widget.style,

      decoration: widget.decoration?.copyWith(
        isDense: true,
        prefixIcon: !widget.showPrefix
            ? null
            : Container(
                alignment: Alignment.center,
                width: 20,
                height: 20,
                margin: const EdgeInsets.all(16),
                child: (allowedtText?.valid == true)
                    ? const Icon(Icons.done)
                    : (allowedtText?.load == true
                        ? const CircularProgressIndicator()
                        : (allowedtText == null
                            ? const Icon(Icons.account_circle_outlined)
                            : const Icon(Icons.error_outline))),
              ),
      ),
      onChanged: (value) => fnStream.add(value),
      validator: (name) {
        lava(name);
        if (name == null) {
          return 'Empty not allowed';
        }
        if ((allowedtText?.load ?? false)) {
          return 'Checking';
        }
        if (!(allowedtText?.valid ?? false)) {
          return 'Not Allowed';
        }
        return null;
      },
    );
  }
}

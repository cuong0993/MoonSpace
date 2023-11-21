import 'dart:async';

import 'package:flutter/material.dart';
import 'package:moonspace/helper/stream/functions.dart';
import 'package:moonspace/helper/validator/debug_functions.dart';

class AsyncTextFormField extends StatefulWidget {
  const AsyncTextFormField({
    super.key,
    this.con,
    required this.asyncFn,
    this.style,
    this.initialValue,
    this.decoration,
    this.autofocus = false,
    this.showPrefix = true,
    this.milliseconds = 300,
  });

  final TextEditingController? con;
  final Future<String?> Function(String value) asyncFn;
  final InputDecoration? decoration;
  final String? initialValue;
  final bool autofocus;
  final bool showPrefix;
  final int milliseconds;
  final TextStyle? style;

  @override
  State<AsyncTextFormField> createState() => _AsyncTextFormFieldState();
}

class _AsyncTextFormFieldState extends State<AsyncTextFormField> {
  ({String? valid, bool load})? allowedtText;
  final focusNode = FocusNode(debugLabel: 'AsyncTextFormField');
  final key = GlobalKey<FormFieldState>();

  late final StreamController<String> fnStream;

  @override
  void initState() {
    fnStream = createDebounceFunc(widget.milliseconds, (String name) async {
      allowedtText = (valid: 'Checking...', load: true);
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
      initialValue: widget.initialValue,

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
      validator: (value) {
        lava(value);
        if ((allowedtText?.load ?? false)) {
          return 'Checking';
        }
        return allowedtText?.valid;
      },
    );
  }
}

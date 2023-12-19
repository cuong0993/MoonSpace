import 'package:flutter/material.dart';

class TextWithNamesEditingController extends TextEditingController {
  TextWithNamesEditingController({super.text});

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    final exp = RegExp(r'@\w*|[^@]+');
    return TextSpan(
      children: [
        ...exp.allMatches(value.text).map((RegExpMatch match) {
          final text = value.text.substring(match.start, match.end);
          return TextSpan(
            text: text,
            style: (text.isNotEmpty && text[0] == '@') //
                ? const TextStyle(color: Colors.blue)
                : null,
          );
        }),
      ],
      style: style,
    );
  }
}

typedef TextFieldNamesRequester = List<String> Function(BuildContext context);

class TextFieldWithNames extends StatefulWidget {
  const TextFieldWithNames({
    super.key,
    required this.controller,
    required this.onNamesRequested,
  });

  final TextWithNamesEditingController controller;
  final TextFieldNamesRequester onNamesRequested;

  @override
  State<TextFieldWithNames> createState() => _TextFieldWithNamesState();
}

class _TextFieldWithNamesState extends State<TextFieldWithNames> {
  final editableTextKey = GlobalKey<EditableTextState>();
  final _overlayController = OverlayPortalController();
  final _overlayPosition = ValueNotifier<Offset>(Offset.zero);
  late final FocusNode _focusNode;

  TextEditingValue get editingValue => widget.controller.value;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode(debugLabel: 'TextFieldWithNamesState#$hashCode');
    widget.controller.addListener(_onTextValueChanged);
  }

  @override
  void didUpdateWidget(covariant TextFieldWithNames oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller.removeListener(_onTextValueChanged);
      widget.controller.addListener(_onTextValueChanged);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextValueChanged);
    _focusNode.dispose();
    super.dispose();
  }

  void _updateOverlayPosition() {
    final rect = editableTextKey.currentState!.renderEditable.getLocalRectForCaret(TextPosition(
      offset: editingValue.selection.baseOffset,
      affinity: editingValue.selection.affinity,
    ));
    final box = editableTextKey.currentContext!.findRenderObject() as RenderBox;
    _overlayPosition.value = box.localToGlobal(
      rect.bottomLeft,
      ancestor: Overlay.of(context).context.findRenderObject(),
    );
  }

  void _onTextValueChanged() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (editingValue.selection.isCollapsed) {
        final text = editingValue.text;
        final offset = editingValue.selection.baseOffset;
        if (offset - 1 >= 0) {
          if (text.substring(offset - 1, offset) == '@') {
            _updateOverlayPosition();
            if (_overlayController.isShowing == false) {
              _overlayController.show();
            }
            return;
          }
        }
      }
      if (_overlayController.isShowing) {
        _overlayController.hide();
      }
    });
  }

  void _insertTextAndDismiss(String text) {
    _overlayController.hide();
    final offset = editingValue.selection.baseOffset;
    widget.controller.value = editingValue.replaced(TextRange.collapsed(offset), text);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectionStyle = DefaultSelectionStyle.of(context);
    return OverlayPortal(
      controller: _overlayController,
      overlayChildBuilder: (BuildContext context) {
        return ValueListenableBuilder(
          valueListenable: _overlayPosition,
          builder: (BuildContext context, Offset position, Widget? child) {
            final names = widget.onNamesRequested(context);
            return Positioned(
              left: position.dx,
              top: position.dy,
              child: IntrinsicWidth(
                child: Material(
                  type: MaterialType.canvas,
                  elevation: 8.0,
                  child: ListTileTheme.merge(
                    visualDensity: VisualDensity.compact,
                    child: ListBody(
                      children: [
                        for (final item in names) //
                          ListTile(
                            onTap: () => _insertTextAndDismiss(item),
                            title: Text(item),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
      child: InputDecorator(
        decoration: const InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 2.0),
          ),
        ),
        child: EditableText(
          key: editableTextKey,
          focusNode: _focusNode,
          controller: widget.controller,
          cursorColor: selectionStyle.cursorColor ?? Colors.black,
          backgroundCursorColor: Colors.grey,
          maxLines: null,
          style: theme.textTheme.titleMedium!,
        ),
      ),
    );
  }
}

class FruitColorizer extends TextEditingController {
  final Map<String, TextStyle> mapping;
  final Pattern pattern;

  FruitColorizer(this.mapping) : pattern = RegExp(mapping.keys.map((key) => RegExp.escape(key)).join('|'));

  FruitColorizer.fromColors(Map<String, Color> colorMap)
      : this(colorMap.map((text, color) => MapEntry(text, TextStyle(color: color))));

  @override
  TextSpan buildTextSpan({required BuildContext context, TextStyle? style, required bool withComposing}) {
    List<InlineSpan> children = [];

    text.splitMapJoin(
      pattern,
      onMatch: (Match match) {
        mapping.forEach((key, value) {
          if (match[0] != null && RegExp(key).hasMatch(match[0]!)) {}
        });

        children.add(
          TextSpan(
            text: match[0],
            style: style?.merge(mapping[match[0]]),
          ),
        );
        return '${match[0]}';
      },
      onNonMatch: (String text) {
        children.add(
          TextSpan(
            text: text,
            style: style,
          ),
        );
        return text;
      },
    );
    return TextSpan(style: style, children: children);
  }
}

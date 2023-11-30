import 'package:flutter/material.dart';

class Marque extends StatefulWidget {
  const Marque({
    super.key,
    this.style,
    required this.text,
    required this.width,
    this.boxDecoration,
  });

  final TextStyle? style;
  final BoxDecoration? boxDecoration;
  final String text;
  final double width;

  @override
  State<Marque> createState() => _MarqueState();
}

class _MarqueState extends State<Marque> with SingleTickerProviderStateMixin {
  late final AnimationController anim;
  ScrollController scroll = ScrollController();

  late final TextStyle textStyle;
  late final Size txtSize;

  late final String padText;
  late final Size padTextSize;

  String get text => widget.text;

  @override
  void initState() {
    textStyle = widget.style ?? const TextStyle();

    anim = AnimationController(vsync: this, duration: const Duration(seconds: 10));

    anim.forward();
    anim.repeat();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      anim.addListener(() {
        scroll.jumpTo(anim.value * (txtSize.width + 2 * padTextSize.width));
      });
    });

    final spaceSize = _textSize(' ', textStyle);
    txtSize = _textSize(text, textStyle);
    padText = List.generate((widget.width / spaceSize.width).round() + 4, (index) => ' ').join().toString();
    padTextSize = _textSize(padText, textStyle);
    // print('Text : $txtSize  pad : $padTextSize');

    super.initState();
  }

  @override
  void dispose() {
    scroll.dispose();
    anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      decoration: widget.boxDecoration,
      height: txtSize.height,
      child: SingleChildScrollView(
        controller: scroll,
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        child: Text(
          padText + text,
          style: textStyle,
          softWrap: false,
          overflow: TextOverflow.clip,
          maxLines: 1,
        ),
      ),
    );
  }

  Size _textSize(String text, TextStyle style) {
    final TextPainter textPainter =
        TextPainter(text: TextSpan(text: text, style: style), maxLines: 1, textDirection: TextDirection.ltr)
          ..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size;
  }
}

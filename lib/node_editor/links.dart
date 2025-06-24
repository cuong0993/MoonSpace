import 'package:flutter/material.dart';
import 'package:moonspace/node_editor/types.dart';

class LinkStyle {
  final LinkType linkType;
  final double linkWidth;
  final double weight;
  final Color linkColor;
  final Color tempLinkColor;

  const LinkStyle({
    this.linkType = LinkType.bezier,
    this.linkWidth = 4,
    this.weight = .2,
    this.linkColor = Colors.blue,
    this.tempLinkColor = Colors.red,
  });

  Map<String, dynamic> toJson() => {
    'linkType': linkType.name,
    'linkWidth': linkWidth,
    'weight': weight,
    'linkColor': linkColor.value,
    'tempLinkColor': tempLinkColor.value,
  };

  factory LinkStyle.fromJson(Map<String, dynamic> json) => LinkStyle(
    linkType: LinkType.values.byName(json['linkType']),
    linkWidth: (json['linkWidth'] as num).toDouble(),
    weight: (json['weight'] as num).toDouble(),
    linkColor: Color(json['linkColor']),
    tempLinkColor: Color(json['tempLinkColor']),
  );
}

enum LinkType { straight, manhattan, bezier }

class LinkPainter extends CustomPainter {
  final EditorChangeNotifier editor;
  final Animation<double> repaint;

  LinkPainter(this.editor, {required this.repaint}) : super(repaint: repaint);

  @override
  void paint(Canvas canvas, Size size) {
    final progress = repaint.value;

    final linkStyle = editor.linkStyle;

    final paint = Paint()
      ..color = linkStyle.linkColor
      ..strokeWidth = linkStyle.linkWidth
      ..style = PaintingStyle.stroke;

    editor.activeLinkId = null;

    for (final link in editor.links.entries) {
      Offset start = editor.getPortOffset(link.value.outputPort);
      Offset end = editor.getPortOffset(link.value.inputPort);

      final path = approximateLinkPath(start, end, linkStyle);

      bool isHovered = editor.mousePosition == null
          ? false
          : pathHovered(path, editor.mousePosition!, linkStyle.linkWidth);

      if (isHovered) {
        editor.activeLinkId = link.value.id;
      }

      paint.color = isHovered ? Colors.blue : linkStyle.linkColor;
      canvas.drawPath(path, paint);

      animatedTravelLink(start, end, linkStyle, canvas, paint, progress);
    }

    if (editor.mousePosition != null) {
      canvas.drawCircle(editor.mousePosition!, 4, paint);
    }

    final tempPaint = Paint()
      ..color = linkStyle.tempLinkColor
      ..strokeWidth = linkStyle.linkWidth
      ..style = PaintingStyle.stroke;

    if (editor.tempLinkStartPort != null) {
      final start = editor.getPortOffset(editor.tempLinkStartPort!);
      final end = editor.tempLinkEndPos;

      if (end != null) {
        canvas.drawCircle(end, 4, tempPaint);

        canvas.drawPath(approximateLinkPath(start, end, linkStyle), tempPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class LinkBuilder extends StatefulWidget {
  const LinkBuilder({super.key, required this.editor, this.animate = true});

  final EditorChangeNotifier editor;
  final bool animate;

  @override
  State<LinkBuilder> createState() => _LinkBuilderState();
}

class _LinkBuilderState extends State<LinkBuilder>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    if (widget.animate) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant LinkBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.animate && !_controller.isAnimating) {
      _controller.repeat();
    } else if (!widget.animate && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: LinkPainter(widget.editor, repaint: _controller),
      isComplex: true,
      willChange: true,
    );
  }
}

Path approximateLinkPath(Offset start, Offset end, LinkStyle linkStyle) {
  final weight = linkStyle.weight;

  final path = Path();
  switch (linkStyle.linkType) {
    case LinkType.straight:
      path.moveTo(start.dx, start.dy);
      path.lineTo(end.dx, end.dy);
      break;
    case LinkType.manhattan:
      final midx1 = (weight * start.dx + end.dx) / (weight + 1);
      final midx2 = (start.dx + weight * end.dx) / (weight + 1);
      path.moveTo(start.dx, start.dy);
      path.lineTo(midx1, start.dy);
      path.lineTo(midx2, end.dy);
      path.lineTo(end.dx, end.dy);
      break;
    case LinkType.bezier:
      final midx1 = (weight * start.dx + end.dx) / (weight + 1);
      final midx2 = (start.dx + weight * end.dx) / (weight + 1);
      final cp1 = Offset(midx1, start.dy);
      final cp2 = Offset(midx2, end.dy);
      path.moveTo(start.dx, start.dy);
      path.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, end.dx, end.dy);
      break;
  }
  return path;
}

bool pathHovered(Path path, Offset point, double dis) {
  final bounds = path.getBounds().inflate(dis);
  if (!bounds.contains(point)) return false;

  final metrics = path.computeMetrics();
  for (final metric in metrics) {
    final length = metric.length;
    final steps = (length / 5).ceil(); // sampling granularity
    for (int i = 0; i <= steps; i++) {
      final distance = i * 5.0;
      final tangent = metric.getTangentForOffset(distance);
      if (tangent == null) continue;
      final pos = tangent.position;
      if ((pos - point).distance <= dis) {
        return true;
      }
    }
  }
  return false;
}

void animatedTravelLink(
  Offset start,
  Offset end,
  LinkStyle linkStyle,
  Canvas canvas,
  Paint paint,
  double progress,
) {
  final path = approximateLinkPath(start, end, linkStyle);
  canvas.drawPath(path, paint);

  // Animate multiple dots
  final metric = path.computeMetrics().first;
  const dotCount = 5;
  const spacing = 0.2; // offset between dots

  for (int i = 0; i < dotCount; i++) {
    final t = (progress + i * spacing) % 1.0;
    final offset = metric.getTangentForOffset(metric.length * t)?.position;
    if (offset != null) {
      canvas.drawCircle(offset, 4, Paint()..color = Colors.orange);
    }
  }
}

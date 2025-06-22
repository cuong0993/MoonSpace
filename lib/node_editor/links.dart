import 'package:flutter/material.dart';
import 'package:moonspace/node_editor/types.dart';

enum LinkStyle { straight, manhattan, bezier }

class LinkPainter extends CustomPainter {
  final EditorChangeNotifier editor;

  LinkPainter(this.editor);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    for (final link in editor.links) {
      if (link.inputPort != null && link.outputPort != null) {
        Offset p1 = editor.getPortOffset(link.inputPort!);
        Offset p2 = editor.getPortOffset(link.outputPort!);

        drawLink(canvas, p1, p2, paint, LinkStyle.bezier);
      }
    }

    final tempPaint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    if (editor.startPort != null) {
      final start = editor.getPortOffset(editor.startPort!);
      final end = editor.tempLinkEndPos;

      if (end != null) {
        canvas.drawCircle(end, 4, tempPaint);

        drawLink(canvas, start, end, tempPaint, LinkStyle.manhattan);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

void drawLink(
  Canvas canvas,
  Offset start,
  Offset end,
  Paint paint,
  LinkStyle style,
) {
  switch (style) {
    case LinkStyle.straight:
      canvas.drawLine(start, end, paint);
      break;

    case LinkStyle.manhattan:
      final s = 1;
      final midx1 = (s * start.dx + end.dx) / (s + 1);
      final midx2 = (start.dx + s * end.dx) / (s + 1);

      final path = Path()
        ..moveTo(start.dx, start.dy)
        ..lineTo(midx1, start.dy)
        ..lineTo(midx2, end.dy)
        ..lineTo(end.dx, end.dy);
      canvas.drawPath(path, paint);
      break;

    case LinkStyle.bezier:
      final s = .2;
      final midx1 = (s * start.dx + end.dx) / (s + 1);
      final midx2 = (start.dx + s * end.dx) / (s + 1);

      final cp1 = Offset(midx1, start.dy);
      final cp2 = Offset(midx2, end.dy);

      final path = Path()
        ..moveTo(start.dx, start.dy)
        ..cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, end.dx, end.dy);
      canvas.drawPath(path, paint);
      break;
  }
}

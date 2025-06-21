import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moonspace/node_editor/node.dart';
import 'package:moonspace/node_editor/types.dart';

class NodeEditor extends StatefulWidget {
  const NodeEditor({super.key});

  @override
  State<NodeEditor> createState() => _NodeEditorState();
}

class _NodeEditorState extends State<NodeEditor> {
  final TransformationController _controller = TransformationController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final matrix = _controller.value;
      final zoom = matrix.getMaxScaleOnAxis();
      final offset = Offset(matrix.row0[3], matrix.row1[3]);
      final editor = EditorNotifier.of(context);
      editor.updateZoom(zoom);
      editor.updateOffset(offset);
    });
  }

  @override
  Widget build(BuildContext context) {
    final editor = EditorNotifier.of(context);
    final focusNode = FocusNode();

    return KeyboardListener(
      focusNode: focusNode,
      onKeyEvent: (KeyEvent event) {
        if (event is KeyDownEvent) {
          EditorNotifier.of(context).updateKey(event.logicalKey);
        } else if (event is KeyUpEvent) {
          EditorNotifier.of(context).updateKey(null);
        }
      },
      child: Focus(
        autofocus: true,
        child: SizedBox.expand(
          child: InteractiveViewer(
            constrained: false,
            panEnabled: editor.activeNodeId == null,
            transformationController: _controller,
            boundaryMargin: const EdgeInsets.all(double.infinity),
            onInteractionEnd: (details) {
              editor.updateActive(null, null);
            },
            onInteractionUpdate: (details) {
              final activeId = editor.activeNodeId;
              final activeFunction = editor.activeFunction;

              final control = editor.activeKey == LogicalKeyboardKey.metaLeft;

              if (activeId != null && activeFunction != null) {
                if (activeFunction == ActiveFunction.move) {
                  final current = editor.getNodePosition(activeId);
                  editor.updateNodePosition(
                    activeId,
                    current + details.focalPointDelta,
                  );
                } else if (activeFunction == ActiveFunction.rotate) {
                  final current = editor.getNodeRotation(activeId);
                  double rotation =
                      (current +
                      (control ? 0.08 : 0.005) *
                          (details.focalPointDelta.dx +
                              details.focalPointDelta.dy));

                  if (control) {
                    final snapStep = math.pi / 12;
                    rotation = (rotation / snapStep).round() * snapStep;
                  }

                  editor.updateNodeRotation(
                    activeId,
                    (rotation % (math.pi * 2)),
                  );
                } else if (activeFunction == ActiveFunction.resize) {
                  final current = editor.getNodeSize(activeId);
                  final newSize = Size(
                    (current.width + details.focalPointDelta.dx).clamp(50, 500),
                    (current.height + details.focalPointDelta.dy).clamp(
                      30,
                      500,
                    ),
                  );
                  editor.updateNodeSize(activeId, newSize);
                }
              }
            },
            minScale: 0.5,
            maxScale: 2.5,
            child: SizedBox(
              width: 2000,
              height: 2000,
              child: Stack(
                children: [
                  const SizedBox(
                    width: 2000,
                    height: 2000,
                    child: GridPaper(
                      color: Color.fromARGB(255, 1, 1, 1),
                      divisions: 20,
                      subdivisions: 1,
                      interval: 400,
                    ),
                  ),

                  ...editor.nodes.entries.map((entry) {
                    final node = entry.value;
                    return CustomNode(
                      node: node,
                      innerWidget: editor.buildNodeWidget(context, node),
                    );
                  }),

                  CustomPaint(painter: LinkPainter(editor)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class LinkPainter extends CustomPainter {
  final EditorChangeNotifier editor;

  LinkPainter(this.editor);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    for (final link in editor.links) {
      if (link.inputId != null && link.outputId != null) {
        final iPos = editor.getNodePosition(link.inputId!);
        final iSize = editor.getNodeSize(link.inputId!) + PortWidget.size;
        final iRot = editor.getNodeRotation(link.inputId!);

        final oPos = editor.getNodePosition(link.outputId!);
        final oSize = editor.getNodeSize(link.outputId!) + PortWidget.size;
        final oRot = editor.getNodeRotation(link.outputId!);

        final isx = iSize.width * link.inputOffset.dx;
        final isy = iSize.height * link.inputOffset.dy;
        final osx = oSize.width * link.outputOffset.dx;
        final osy = oSize.height * link.outputOffset.dy;

        final iCenter = iPos + iSize.center(Offset.zero);
        final oCenter = oPos + oSize.center(Offset.zero);

        final iOffset = Offset(isx, isy) - iSize.center(Offset.zero);
        final oOffset = Offset(osx, osy) - oSize.center(Offset.zero);

        final p1 = rotateAroundCenter(iCenter + iOffset, iCenter, iRot);
        final p2 = rotateAroundCenter(oCenter + oOffset, oCenter, oRot);

        // final cp1 = Offset(p1.dx + 50, p1.dy);
        // final cp2 = Offset(p2.dx - 50, p2.dy);

        final path = Path()
          ..moveTo(p1.dx, p1.dy)
          ..lineTo(p2.dx, p2.dy);
        // ..cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, p2.dx, p2.dy);

        canvas.drawPath(path, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

Offset rotateAroundCenter(Offset point, Offset center, double angle) {
  final dx = point.dx - center.dx;
  final dy = point.dy - center.dy;

  final cosA = math.cos(angle);
  final sinA = math.sin(angle);

  final rotatedDx = dx * cosA - dy * sinA;
  final rotatedDy = dx * sinA + dy * cosA;

  return Offset(rotatedDx + center.dx, rotatedDy + center.dy);
}

class EditorState extends StatelessWidget {
  const EditorState({super.key});

  @override
  Widget build(BuildContext context) {
    final editor = EditorNotifier.of(context);
    return Container(
      decoration: BoxDecoration(color: Colors.white, border: Border.all()),
      padding: EdgeInsets.all(4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Zoom: ${editor.zoom.toStringAsFixed(2)}'),
          Text(
            'Offset: ${editor.offset.dx.toStringAsFixed(1)},${editor.offset.dy.toStringAsFixed(1)}',
          ),
          Text('Active: ${editor.activeNodeId}'),
          Text('Function: ${editor.activeFunction}'),
          Text('Nodes: ${editor.nodes.length}'),
          Text(
            'Links: ${editor.links.length}, ${editor.linkMap.length}, ${editor.nodeLinkMap.length}',
          ),
          Text('Key: ${editor.activeKey}'),
          Text('Control: ${editor.activeKey == LogicalKeyboardKey.metaLeft}'),

          ...editor.nodes.entries.map((node) {
            return TextButton(
              onPressed: () {
                editor.updateActive(node.value.id, null);
              },
              child: Text(node.value.id),
            );
          }),
        ],
      ),
    );
  }
}

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:moonspace/helper/extensions/color.dart';
import 'package:moonspace/node_editor/helper.dart';
import 'package:moonspace/node_editor/types.dart';

enum ActiveFunction { move, rotate, resize }

class CustomNode extends StatefulWidget {
  final Node node;
  final Widget innerWidget;

  const CustomNode({super.key, required this.node, required this.innerWidget});

  @override
  State<CustomNode> createState() => _CustomNodeState();
}

class _CustomNodeState extends State<CustomNode> {
  Offset startDiffpos = Offset.zero;

  ActiveFunction? activeFunction;

  String debug = "";

  @override
  Widget build(BuildContext context) {
    final editor = EditorNotifier.of(context);
    final size = editor.getNodeById(widget.node.id)!.size;

    final cs = Theme.of(context).colorScheme;

    return Positioned(
      left: widget.node.position.dx,
      top: widget.node.position.dy,
      child: Transform.rotate(
        angle: widget.node.rotation,
        child: Card(
          clipBehavior: Clip.hardEdge,
          elevation: 8,
          shape: BeveledRectangleBorder(
            side: BorderSide(),
            borderRadius: BorderRadiusGeometry.circular(8),
          ),
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.hardEdge,
            children: [
              //
              GestureDetector(
                onPanStart: (details) {
                  final globalPos =
                      (details.globalPosition - editor.editorOffset) /
                      editor.izoom;

                  final center = widget.node.center;

                  startDiffpos = globalPos - widget.node.position;

                  final topcen =
                      widget.node.position +
                      Offset(8 + 0.5 * size.width, 8 + 0 * size.height);
                  final rottop = rotateAroundCenter(
                    topcen,
                    center,
                    widget.node.rotation,
                  );

                  final disTopCenter = (globalPos - rottop).distance;

                  final bottomRight =
                      widget.node.position +
                      Offset(-8 + size.width, -8 + size.height);
                  final rotBottomRight = rotateAroundCenter(
                    bottomRight,
                    center,
                    widget.node.rotation,
                  );

                  final disBottomCorner = (globalPos - rotBottomRight).distance;

                  if (disTopCenter < 20 * editor.izoom) {
                    activeFunction = ActiveFunction.rotate;
                  } else if (disBottomCorner < 20 * editor.izoom) {
                    activeFunction = ActiveFunction.resize;
                  } else {
                    activeFunction = ActiveFunction.move;
                  }
                },
                onPanUpdate: (details) {
                  final globalPos =
                      (details.globalPosition - editor.editorOffset) /
                      editor.izoom;

                  final center = widget.node.center;

                  if (activeFunction == ActiveFunction.rotate) {
                    final centerToGlobalPos = globalPos - center;
                    widget.node.rotation =
                        math.atan2(centerToGlobalPos.dy, centerToGlobalPos.dx) +
                        3.14 / 2;
                  }
                  if (activeFunction == ActiveFunction.move) {
                    widget.node.position = globalPos - startDiffpos;
                  }
                  if (activeFunction == ActiveFunction.resize) {
                    final rev = rotateAroundCenter(
                      globalPos,
                      center,
                      -widget.node.rotation,
                    );

                    widget.node.size = Size(
                      rev.dx - widget.node.position.dx,
                      rev.dy - widget.node.position.dy,
                    );
                  }

                  setState(() {});
                },
                onPanEnd: (details) {
                  activeFunction = null;
                  editor.notifyEditor();
                },
                child: Stack(
                  children: [
                    Container(
                      color: editor.activeNodeId == widget.node.id
                          ? cs.surfaceContainerHigh
                          : cs.surface,
                      width: size.width,
                      height: size.height,
                      child: Center(child: widget.innerWidget),
                      // child: Padding(
                      //   padding: const EdgeInsets.all(16.0),
                      //   child: Text(debug),
                      // ),
                    ),

                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Icon(
                        Icons.drag_handle,
                        size: 16,
                        color: Colors.red,
                      ),
                    ),

                    Positioned(
                      left: widget.node.size.width / 2,
                      top: 0,
                      child: Icon(
                        Icons.rotate_right,
                        size: 16,
                        color: Colors.red,
                      ),
                    ),

                    Positioned(
                      left: 0,
                      top: 0,
                      child: Material(
                        color: cs.primary,
                        child: InkWell(
                          hoverColor: Colors.red,
                          onTap: () {
                            editor.removeNodeById(widget.node.id);
                          },
                          child: Icon(
                            Icons.clear,
                            size: 16,
                            color: cs.onPrimary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              //
              ...widget.node.ports.map((port) {
                final inputOffset = port.offsetRatio;

                return Positioned(
                  right: inputOffset.dx > .5
                      ? (1 - inputOffset.dx) * size.width
                      : null,
                  left: inputOffset.dx > .5
                      ? null
                      : inputOffset.dx * size.width,

                  bottom: inputOffset.dy > .5
                      ? (1 - inputOffset.dy) * size.height
                      : null,
                  top: inputOffset.dy > .5
                      ? null
                      : inputOffset.dy * size.height,

                  // width: PortWidget.size.dx * 2,
                  // height: PortWidget.size.dy * 2,
                  child: PortWidget(port: port),
                );
              }),

              //
            ],
          ),
        ),
      ),
    );
  }
}

class PortWidget extends StatelessWidget {
  const PortWidget({super.key, required this.port});

  final Port port;

  @override
  Widget build(BuildContext context) {
    final editor = EditorNotifier.of(context);

    final color = colorFromType(port);

    return MouseRegion(
      onEnter: (event) {
        if (editor.tempLinkStartPort != null &&
            editor.tempLinkStartPort != port) {
          final a = editor.tempLinkStartPort!;
          final inputPort = a.input ? a : port;
          final outputPort = a.input ? port : a;
          editor.addLinks([Link(inputPort: inputPort, outputPort: outputPort)]);
        }
      },
      child: GestureDetector(
        onPanStart: (details) {
          // if (port.linkId != null) {
          //   final linkedPort = editor.getLinkedPort(port);
          //   editor.tempLinkStartPort ??= linkedPort;
          //   editor.removeLinkById(port.linkId!);
          // } else
          {
            editor.tempLinkStartPort ??= port;
          }
        },
        onPanUpdate: (details) {
          if (editor.tempLinkStartPort != null) {
            editor.tempLinkEndPos =
                (details.globalPosition - editor.editorOffset) / editor.izoom;
            editor.notifyEditor();
            // editor.updateTempLinkPosition(details.localPosition, context);
          }
        },
        onPanEnd: (details) {
          editor.removeTempLink();
        },
        child: Container(
          width: 16,
          height: 16,
          padding: EdgeInsets.all(2),
          alignment: Alignment.center,
          decoration: port.input
              ? ShapeDecoration(
                  color: Colors.red,
                  shape: StarBorder.polygon(
                    sides: 3.00,
                    rotation: -90,
                    pointRounding: .4,
                    squash: 0.25,
                  ),
                )
              : BoxDecoration(
                  color: editor.tempLinkStartPort == port
                      ? Colors.black
                      : color,
                ),
          // child: Text(
          //   // "${port.value}",
          //   "${port.id} ${port.value}",
          //   style: TextStyle(color: onColor),
          // ),
        ),
      ),
    );
  }
}

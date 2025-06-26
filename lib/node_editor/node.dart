import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  double resizeAspectRatio = 1;

  ActiveFunction? activeFunction;

  @override
  Widget build(BuildContext context) {
    final editor = EditorNotifier.of(context);
    final node = widget.node;

    return Positioned(
      left: node.position.dx,
      top: node.position.dy,
      child:
          //
          Transform.rotate(
            angle: node.rotation,
            child:
                //
                GestureDetector(
                  onTapDown: (details) {
                    final globalPos = editor.globalToCanvas(
                      details.globalPosition,
                    );

                    final isInTopRight = editor.isInRegion(
                      editor.topright(node),
                      globalPos,
                    );
                    if (isInTopRight) {
                      editor.removeNodeById(node.id);
                    }

                    // editor.updateDebugMousePosition(globalPos);
                  },

                  onPanStart: (details) {
                    final globalPos = editor.globalToCanvas(
                      details.globalPosition,
                    );

                    editor.tempLinkEndPos = globalPos;
                    editor.notifyEditor();

                    startDiffpos = globalPos - node.position;
                    resizeAspectRatio = node.size.width / node.size.height;

                    for (var port in node.ports) {
                      final isInPort = editor.isInPort(node, port, globalPos);

                      if (isInPort) {
                        editor.tempLinkStartPort ??= port;
                        return;
                      }
                    }

                    final isInTopCenter = editor.isInRegion(
                      editor.topcenter(node),
                      globalPos,
                    );
                    final isInBottomRight = editor.isInRegion(
                      editor.bottomright(node),
                      globalPos,
                    );

                    if (isInTopCenter) {
                      activeFunction = ActiveFunction.rotate;
                    } else if (isInBottomRight) {
                      activeFunction = ActiveFunction.resize;
                    } else {
                      activeFunction = ActiveFunction.move;
                    }
                  },

                  onPanUpdate: (details) {
                    final controlPressed =
                        editor.activeKey == LogicalKeyboardKey.metaLeft;

                    final globalPos = editor.globalToCanvas(
                      details.globalPosition,
                    );

                    editor.tempLinkEndPos = globalPos;

                    // editor.updateDebugEditGlobalPosition(globalPos);

                    if (activeFunction == ActiveFunction.rotate) {
                      const snapStep = math.pi / 12; // 15 degrees in radians

                      final cenpos = globalPos - node.center;
                      double rawAngle =
                          math.atan2(cenpos.dy, cenpos.dx) + math.pi / 2;

                      if (controlPressed) {
                        rawAngle = (rawAngle / snapStep).round() * snapStep;
                      }

                      node.rotation = rawAngle;
                    }
                    if (activeFunction == ActiveFunction.move) {
                      Offset newPos = globalPos - startDiffpos;

                      if (controlPressed) {
                        const snapSize = 10.0; // Snap every 10 pixels
                        newPos = Offset(
                          (newPos.dx / snapSize).round() * snapSize,
                          (newPos.dy / snapSize).round() * snapSize,
                        );
                      }

                      node.position = newPos;
                    }
                    if (activeFunction == ActiveFunction.resize) {
                      final rev =
                          rotateAroundCenter(
                            globalPos,
                            node.center,
                            -node.rotation,
                          ) -
                          node.position;

                      double width = rev.dx;
                      double height = rev.dy;

                      if (controlPressed) {
                        height = width / resizeAspectRatio;
                      }

                      node.size = Size(
                        math.max(100, width),
                        math.max(100, height),
                      );
                    }

                    setState(() {});
                  },

                  onPanEnd: (details) {
                    activeFunction = null;
                    editor.removeTempLink();
                    setState(() {});
                  },

                  //
                  child: Container(
                    padding: EdgeInsets.all(2 * editor.zoneRadius),
                    decoration: BoxDecoration(
                      color: activeFunction != null
                          ? const Color.fromARGB(10, 0, 0, 0)
                          : const Color.fromARGB(37, 255, 144, 144),
                    ),
                    width: node.size.width,
                    height: node.size.height,
                    child: Container(
                      decoration: BoxDecoration(border: Border.all()),
                    ),
                    // child: widget.innerWidget,
                  ),
                ),
          ),
    );
  }
}

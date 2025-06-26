import 'dart:math' as math;

import 'package:flutter/material.dart';
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
                MouseRegion(
                  onEnter: (event) {
                    final pos = editor.localToCanvasOffset(
                      event.localPosition,
                      context,
                    );
                    final globalPos = rotateAroundCenter(
                      pos,
                      node.center,
                      node.rotation,
                    );
                    editor.updateDebugMousePosition(globalPos);

                    for (var port in node.ports) {
                      final isInPortRegion = node.isInRegion(
                        port.offsetRatio,
                        globalPos,
                        editor.zoneRadius,
                      );
                      if (isInPortRegion) {
                        final port = node.ports.first;

                        if (editor.tempLinkStartPort != null &&
                            editor.tempLinkStartPort != port) {
                          final a = editor.tempLinkStartPort!;
                          final inputPort = a.input ? a : port;
                          final outputPort = a.input ? port : a;
                          editor.addLinks([
                            Link(inputPort: inputPort, outputPort: outputPort),
                          ]);
                        }

                        return;
                      }
                    }
                  },
                  //
                  child: GestureDetector(
                    //
                    child: Container(
                      color: activeFunction != null
                          ? const Color.fromARGB(10, 0, 0, 0)
                          : const Color.fromARGB(37, 255, 144, 144),
                      width: node.size.width,
                      height: node.size.height,
                      child: widget.innerWidget,
                    ),

                    onTapDown: (details) {
                      final globalPos = editor.globalToCanvas(
                        details.globalPosition,
                      );

                      final isInTopRight = node.isInRegion(
                        offsetTopRightRatio,
                        globalPos,
                        editor.zoneRadius,
                      );
                      if (isInTopRight) {
                        editor.removeNodeById(node.id);
                      }

                      editor.updateDebugMousePosition(globalPos);
                    },

                    onPanStart: (details) {
                      final globalPos = editor.globalToCanvas(
                        details.globalPosition,
                      );

                      startDiffpos = globalPos - node.position;

                      for (var port in node.ports) {
                        final isInPortRegion = node.isInRegion(
                          port.offsetRatio,
                          globalPos,
                          editor.zoneRadius,
                        );
                        if (isInPortRegion) {
                          editor.tempLinkStartPort ??= port;
                          return;
                        }
                      }

                      final isInTopCenter = node.isInRegion(
                        offsetTopCenterRatio,
                        globalPos,
                        editor.zoneRadius,
                      );
                      final isInBottomRight = node.isInRegion(
                        offsetBottomRightRatio,
                        globalPos,
                        editor.zoneRadius,
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
                      final globalPos = editor.globalToCanvas(
                        details.globalPosition,
                      );

                      editor.tempLinkEndPos = globalPos;

                      editor.updateDebugEditGlobalPosition(globalPos);

                      if (activeFunction == ActiveFunction.rotate) {
                        final cenpos = globalPos - node.center;
                        node.rotation =
                            math.atan2(cenpos.dy, cenpos.dx) + 3.14 / 2;
                      }
                      if (activeFunction == ActiveFunction.move) {
                        node.position = globalPos - startDiffpos;
                      }
                      if (activeFunction == ActiveFunction.resize) {
                        final rev =
                            rotateAroundCenter(
                              globalPos,
                              node.center,
                              -node.rotation,
                            ) -
                            node.position;

                        node.size = Size(
                          math.max(100, rev.dx),
                          math.max(100, rev.dy),
                        );
                      }

                      setState(() {});
                    },

                    onPanEnd: (details) {
                      activeFunction = null;
                      editor.tempLinkStartPort = null;
                      editor.tempLinkEndPos = null;
                      editor.notifyEditor();
                      setState(() {});
                    },
                  ),
                ),
          ),
    );
  }
}

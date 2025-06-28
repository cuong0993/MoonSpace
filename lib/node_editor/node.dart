import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moonspace/node_editor/helper.dart';
import 'package:moonspace/node_editor/types.dart';

enum ActiveFunction { move, rotate, resize }

class CustomNode extends StatefulWidget {
  final Node node;

  final Map<String, NodeBuilderEntry> nodeBuilderRegistry;
  final Map<String, PortBuilderEntry> portBuilderRegistry;

  const CustomNode({
    super.key,
    required this.node,
    required this.nodeBuilderRegistry,
    required this.portBuilderRegistry,
  });

  @override
  State<CustomNode> createState() => _CustomNodeState();
}

class _CustomNodeState extends State<CustomNode> {
  Offset startDiffpos = Offset.zero;
  double resizeAspectRatio = 1;

  ActiveFunction? activeFunction;

  Widget buildNodeWidget(BuildContext context) {
    final entry = widget.nodeBuilderRegistry[widget.node.type];
    if (entry == null) return Text('Unknown type: ${widget.node.type}');

    return entry.builder(context, widget.node);

    // return Container(
    //   decoration: BoxDecoration(border: Border.all()),
    //   alignment: Alignment.center,
    //   child: Column(
    //     children: [Text(node.type), Text(node.runtimeType.toString())],
    //   ),
    // );
  }

  Widget buildPortWidget(BuildContext context, Port port) {
    final entry = widget.portBuilderRegistry[port.type];
    final portWidget =
        entry?.builder?.call(context, port) ??
        Icon(Icons.stop_circle_outlined, size: 20, color: port.color);
    return portWidget;
    // return Row(children: [portWidget, Text(port.runtimeType.toString())]);
  }

  @override
  Widget build(BuildContext context) {
    final editor = EditorNotifier.of(context);
    final node = widget.node;
    final cs = Theme.of(context).colorScheme;

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

                    if (editor.isInRegion(editor.topright(node), globalPos)) {
                      editor.removeNodeById(node.id);
                    } else if (editor.isInRegion(
                      editor.bottomleft(node),
                      globalPos,
                    )) {
                      editor.nodes.remove(node.id);
                      editor.addNodes([node]);
                    }
                  },

                  onPanStart: (details) {
                    final globalPos = editor.globalToCanvas(
                      details.globalPosition,
                    );

                    // editor.tempLinkEndPos = globalPos;
                    // editor.notifyEditor();

                    editor.toggleLinkRebuild(true);

                    startDiffpos = globalPos - node.position;
                    resizeAspectRatio = node.size.dx / node.size.dy;

                    for (var port in node.ports) {
                      final isInPort = editor.isInPort(node, port, globalPos);

                      if (isInPort) {
                        editor.tempLinkStartPort ??= port;
                        return;
                      }
                    }

                    if (editor.isInRegion(editor.topcenter(node), globalPos)) {
                      activeFunction = ActiveFunction.rotate;
                    } else if (editor.isInRegion(
                      editor.bottomright(node),
                      globalPos,
                    )) {
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

                    if (editor.tempLinkStartPort != null) {
                      editor.tempLinkEndPos = globalPos;
                      return;
                    }

                    if (activeFunction == ActiveFunction.rotate) {
                      final cenpos = globalPos - node.center;
                      double rawAngle =
                          math.atan2(cenpos.dy, cenpos.dx) + degree90;

                      if (controlPressed) {
                        rawAngle =
                            (rawAngle / rotationSnapStep).round() *
                            rotationSnapStep;
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

                      node.size = Offset(
                        math.max(120, width),
                        math.max(120, height),
                      );
                    }

                    setState(() {});
                  },

                  onPanEnd: (details) {
                    activeFunction = null;
                    editor.removeTempLink();
                  },

                  //
                  child: Stack(
                    //
                    clipBehavior: Clip.none,
                    //
                    children: [
                      Container(
                        padding: EdgeInsets.all(2 * editor.zoneRadius),
                        decoration: BoxDecoration(
                          color: activeFunction != null
                              ? cs.surfaceContainer
                              : Colors.transparent,
                        ),
                        width: node.size.dx,
                        height: node.size.dy,
                        child: buildNodeWidget(context),
                      ),

                      ...node.ports.map((port) {
                        final pos = node.ratioToLocal(
                          port.offsetRatio,
                          editor.zoneRadius,
                        );
                        return Positioned(
                          left: pos.dx,
                          top: pos.dy,
                          child: buildPortWidget(context, port),
                        );
                      }),

                      Positioned(
                        left: 0,
                        top: node.size.dy - editor.zoneRadius * 2,
                        child: Icon(Icons.workspaces_outlined, size: 20),
                      ),

                      Positioned(
                        left: node.size.dx - editor.zoneRadius * 2,
                        top: 0,
                        child: Icon(Icons.clear, size: 20),
                      ),

                      Positioned(
                        left: node.size.dx / 2 - editor.zoneRadius,
                        top: 0,
                        child: Icon(Icons.circle_outlined, size: 20),
                      ),

                      Positioned(
                        left: node.size.dx - editor.zoneRadius * 2,
                        top: node.size.dy - editor.zoneRadius * 2,
                        child: Icon(Icons.zoom_out_map_outlined, size: 20),
                      ),
                    ],
                  ),
                ),
          ),
    );
  }
}

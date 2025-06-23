import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moonspace/node_editor/links.dart';
import 'package:moonspace/node_editor/node.dart';
import 'package:moonspace/node_editor/types.dart';

class NodeEditor extends StatefulWidget {
  const NodeEditor({super.key});

  @override
  State<NodeEditor> createState() => _NodeEditorState();
}

class _NodeEditorState extends State<NodeEditor> {
  late TransformationController _controller;
  bool _listenerAttached = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _controller = EditorNotifier.of(context).interactiveController;

    if (!_listenerAttached) {
      _controller.addListener(() {
        final matrix = _controller.value;
        final zoom = matrix.getMaxScaleOnAxis();
        final offset = Offset(matrix.row0[3], matrix.row1[3]);
        final editor = EditorNotifier.of(context);
        editor.updateZoom(zoom);
        editor.updateOffset(offset);
      });
      _listenerAttached = true;
    }
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
                final current = editor.getNode(activeId)!.position;
                editor.updateNodePosition(
                  activeId,
                  current + details.focalPointDelta,
                );
              } else if (activeFunction == ActiveFunction.rotate) {
                final current = editor.getNode(activeId)!.rotation;
                double rotation =
                    (current +
                    (control ? 0.08 : 0.005) *
                        (details.focalPointDelta.dx +
                            details.focalPointDelta.dy));

                if (control) {
                  final snapStep = math.pi / 12;
                  rotation = (rotation / snapStep).round() * snapStep;
                }

                editor.updateNodeRotation(activeId, (rotation % (math.pi * 2)));
              } else if (activeFunction == ActiveFunction.resize) {
                final current = editor.getNode(activeId)!.size;
                final newSize = Size(
                  (current.width + details.focalPointDelta.dx).clamp(50, 500),
                  (current.height + details.focalPointDelta.dy).clamp(30, 500),
                );
                editor.updateNodeSize(activeId, newSize);
              }
            }
          },
          minScale: 0.5,
          maxScale: 2.5,
          child: Stack(
            children: [
              Listener(
                onPointerDown: (event) {
                  // editor.secondaryMouseClick = false;
                  if (event.kind == PointerDeviceKind.mouse &&
                      event.buttons == kSecondaryMouseButton) {
                    // editor.secondaryMouseClick = true;

                    if (editor.activeLinkId != null) {
                      final offset = event.position;

                      final linkId = editor.activeLinkId;

                      showMenu(
                        context: context,
                        menuPadding: EdgeInsets.zero,
                        position: RelativeRect.fromLTRB(
                          offset.dx,
                          offset.dy,
                          offset.dx + 200,
                          offset.dy + 200,
                        ),
                        items: [
                          PopupMenuItem(
                            child: Text('Delete link'),
                            onTap: () {
                              editor.removeLinkById(linkId!);
                            },
                          ),
                        ],
                      );
                    }
                  }
                },
                child: MouseRegion(
                  onHover: (event) {
                    editor.updateMousePosition(event.position, context);
                  },
                  onExit: (event) {
                    editor.updateMousePosition(null, context);
                  },
                  child: Container(
                    color: Colors.transparent,
                    width: editor.divisions * editor.interval,
                    height: editor.divisions * editor.interval,
                    child: GridPaper(
                      color: Theme.of(context).colorScheme.primary,
                      divisions: editor.divisions,
                      subdivisions: 1,
                      interval: editor.interval,
                    ),
                  ),
                ),
              ),

              LinkBuilder(
                editor: editor,
                animate: editor.tempLinkEndPos != null,
              ),

              ...editor.nodes.entries.map((entry) {
                final node = entry.value;
                return CustomNode(
                  node: node,
                  innerWidget: editor.buildNodeWidget(context, node),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class EditorState extends StatelessWidget {
  const EditorState({super.key});

  @override
  Widget build(BuildContext context) {
    final editor = EditorNotifier.of(context);
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.primary),
      ),
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
          Column(children: editor.links.values.map((v) => Text(v.id)).toList()),
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

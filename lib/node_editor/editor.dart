import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moonspace/helper/extensions/theme_ext.dart';
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

  final GlobalKey _viewerKey = GlobalKey();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _controller = EditorNotifier.of(context).interactiveController;

    final editor = EditorNotifier.of(context);

    if (!_listenerAttached) {
      _controller.addListener(() {
        final matrix = _controller.value;
        final zoom = matrix.getMaxScaleOnAxis();
        final offset = Offset(matrix.row0[3], matrix.row1[3]);
        editor.updateInteractiveZoom(zoom);
        editor.updateInteractiveOffset(offset);
      });
      _listenerAttached = true;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final box = _viewerKey.currentContext?.findRenderObject() as RenderBox?;
      if (box != null) {
        setState(() {
          final off = box.localToGlobal(Offset.zero);
          editor.left = off.dx;
          editor.top = off.dy;
          editor.width = box.size.width;
          editor.height = box.size.height;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final editor = EditorNotifier.of(context);
    final focusNode = FocusNode();

    return EditorNotifier(
      key: _viewerKey,
      model: editor,
      child: KeyboardListener(
        focusNode: focusNode,
        onKeyEvent: (KeyEvent event) {
          if (event is KeyDownEvent) {
            EditorNotifier.of(context).updateKeyboardKey(event.logicalKey);
          } else if (event is KeyUpEvent) {
            EditorNotifier.of(context).updateKeyboardKey(null);
          }
        },
        child: Focus(
          autofocus: true,
          child: InteractiveViewer(
            constrained: false,
            panEnabled: editor.activeNodeId == null,
            transformationController: _controller,
            // boundaryMargin: const EdgeInsets.all(double.infinity),
            onInteractionEnd: (details) {
              editor.updateActiveFunction(null, null);
            },
            onInteractionUpdate: (details) {
              onInteractionUpdate(editor, details);
            },
            minScale: 0.5,
            maxScale: 2.5,
            child: Listener(
              onPointerDown: (event) {
                editorPointerDown(editor, context, event);
              },
              child: Stack(
                children: [
                  Container(
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

                  Positioned.fill(
                    child: LinkBuilder(
                      editor: editor,
                      animate: editor.tempLinkEndPos != null,
                    ),
                  ),

                  ...renderNodes(context, editor),
                ],
              ),
            ),
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
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.primary),
      ),
      padding: EdgeInsets.all(4),
      child: ListView(
        children: [
          Text('Size: ${context.mq.size}'),
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
          FilledButton(
            onPressed: () {
              editor.interactiveController.value = Matrix4.identity();
            },
            child: Text("Center"),
          ),

          ...editor.nodes.entries.map((node) {
            return FilledButton(
              onPressed: () {
                editor.updateActiveFunction(node.value.id, null);
                editor.interactiveAnimateTo(node.value.center, context);
              },
              child: Text("Focus ${node.value.id}"),
            );
          }),
        ],
      ),
    );
  }
}

void onInteractionUpdate(
  EditorChangeNotifier editor,
  ScaleUpdateDetails details,
) {
  final activeId = editor.activeNodeId;
  final activeFunction = editor.activeFunction;

  final control = editor.activeKey == LogicalKeyboardKey.metaLeft;

  if (activeId != null && activeFunction != null) {
    if (activeFunction == ActiveFunction.move) {
      final current = editor.getNodeById(activeId)!.position;
      editor.updateNodePosition(activeId, current + details.focalPointDelta);
    } else if (activeFunction == ActiveFunction.rotate) {
      final current = editor.getNodeById(activeId)!.rotation;
      double rotation =
          (current +
          (control ? 0.08 : 0.005) *
              (details.focalPointDelta.dx + details.focalPointDelta.dy));

      if (control) {
        final snapStep = math.pi / 12;
        rotation = (rotation / snapStep).round() * snapStep;
      }

      editor.updateNodeRotation(activeId, (rotation % (math.pi * 2)));
    } else if (activeFunction == ActiveFunction.resize) {
      final current = editor.getNodeById(activeId)!.size;
      final newSize = Size(
        (current.width + details.focalPointDelta.dx).clamp(50, 500),
        (current.height + details.focalPointDelta.dy).clamp(30, 500),
      );
      editor.updateNodeSize(activeId, newSize);
    }
  }
}

void editorPointerDown(
  EditorChangeNotifier editor,
  BuildContext context,
  PointerDownEvent event,
) {
  if (event.kind == PointerDeviceKind.mouse &&
      event.buttons == kSecondaryMouseButton) {
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
}

List<Widget> renderNodes(BuildContext context, EditorChangeNotifier editor) {
  List<Widget> visibleNodes = [];

  for (final entry in editor.nodes.entries) {
    final node = entry.value;
    final isVisible = checkIfNodeVisible(editor, node);
    if (isVisible) {
      visibleNodes.add(
        CustomNode(
          node: node,
          innerWidget: editor.buildNodeWidget(context, node),
        ),
      );
    } else {
      print("Avoid ${node.id}");
    }
  }
  return visibleNodes;
}

bool checkIfNodeVisible(
  EditorChangeNotifier editor,
  Node node, {
  double padding = 0,
}) {
  // Viewport in scene space
  final screenWidth = editor.width;
  final screenHeight = editor.height;

  final sceneTopLeft = (Offset.zero - editor.offset) / editor.zoom;
  final sceneBottomRight =
      (Offset(screenWidth, screenHeight) - editor.offset) / editor.zoom;

  // Expand viewport with padding (converted to scene scale)
  final scenePadding = padding / 1; //zoom;
  final viewport = Rect.fromPoints(
    sceneTopLeft,
    sceneBottomRight,
  ).inflate(scenePadding);

  final nodeRect = Rect.fromLTWH(
    node.position.dx,
    node.position.dy,
    node.size.width,
    node.size.height,
  );

  return nodeRect.overlaps(viewport);
}

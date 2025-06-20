import 'dart:math';

import 'package:flutter/material.dart';

class NodeEditorScaffold extends StatefulWidget {
  const NodeEditorScaffold({super.key});

  @override
  State<NodeEditorScaffold> createState() => _NodeEditorScaffoldState();
}

class _NodeEditorScaffoldState extends State<NodeEditorScaffold> {
  final editorModel = EditorChangeNotifier()
    ..addNode(
      NodeData(
        id: 'nodeA',
        position: const Offset(200, 200),
        rotation: 0,
        size: const Size(150, 80),
      ),
    );

  @override
  Widget build(BuildContext context) {
    return EditorNotifier(
      model: editorModel,
      child: MaterialApp(
        home: Scaffold(body: Stack(children: [NodeEditor(), EditorState()])),
      ),
    );
  }
}

////
////
////

enum ActiveFunction { move, rotate, resize }

class NodeData {
  final String id;
  Offset position;
  double rotation;
  Size size;

  NodeData({
    required this.id,
    required this.position,
    required this.rotation,
    required this.size,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'position': {'dx': position.dx, 'dy': position.dy},
    'rotation': rotation,
    'size': {'width': size.width, 'height': size.height},
  };

  factory NodeData.fromJson(Map<String, dynamic> json) => NodeData(
    id: json['id'],
    position: Offset(json['position']['dx'], json['position']['dy']),
    rotation: json['rotation'],
    size: Size(json['size']['width'], json['size']['height']),
  );
}

class EditorChangeNotifier extends ChangeNotifier {
  EditorChangeNotifier();

  final Map<String, NodeData> nodes = {};

  String? activeNodeId;
  ActiveFunction? activeFunction;

  double zoom = 1.0;
  Offset offset = Offset.zero;

  void updateZoom(double z) {
    zoom = z;
    notifyListeners();
  }

  void updateOffset(Offset o) {
    offset = o;
    notifyListeners();
  }

  void addNode(NodeData node) {
    nodes[node.id] = node;
    notifyListeners();
  }

  NodeData? getNode(String id) => nodes[id];

  void updateNodePosition(String id, Offset pos) {
    if (nodes.containsKey(id)) {
      nodes[id]!.position = pos;
      notifyListeners();
    }
  }

  void updateNodeRotation(String id, double rot) {
    if (nodes.containsKey(id)) {
      nodes[id]!.rotation = rot;
      notifyListeners();
    }
  }

  void updateNodeSize(String id, Size size) {
    if (nodes.containsKey(id)) {
      nodes[id]!.size = size;
      notifyListeners();
    }
  }

  void updateActive(String? id, ActiveFunction? function) {
    activeNodeId = id;
    activeFunction = function;
    notifyListeners();
  }

  Offset getNodePosition(String id) => nodes[id]?.position ?? Offset.zero;
  double getNodeRotation(String id) => nodes[id]?.rotation ?? 0;
  Size getNodeSize(String id) => nodes[id]?.size ?? const Size(150, 80);

  Map<String, dynamic> toJson() => {
    'zoom': zoom,
    'offset': {'dx': offset.dx, 'dy': offset.dy},
    'nodes': nodes.map((key, value) => MapEntry(key, value.toJson())),
  };

  factory EditorChangeNotifier.fromJson(Map<String, dynamic> json) {
    final editor = EditorChangeNotifier();
    editor.zoom = json['zoom'];
    editor.offset = Offset(json['offset']['dx'], json['offset']['dy']);
    final nodeMap = (json['nodes'] as Map<String, dynamic>).map(
      (key, value) => MapEntry(key, NodeData.fromJson(value)),
    );
    editor.nodes.addAll(nodeMap);
    return editor;
  }
}

class EditorNotifier extends InheritedNotifier<EditorChangeNotifier> {
  const EditorNotifier({
    super.key,
    required EditorChangeNotifier model,
    required super.child,
  }) : super(notifier: model);

  static EditorChangeNotifier of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<EditorNotifier>()!.notifier!;
}

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

    return SizedBox.expand(
      child: InteractiveViewer(
        constrained: false,
        panEnabled: false,
        transformationController: _controller,
        boundaryMargin: const EdgeInsets.all(double.infinity),
        onInteractionUpdate: (details) {
          // If dragging a node
          final activeId = editor.activeNodeId;
          final activeFunction = editor.activeFunction;
          if (activeId != null && activeFunction != null) {
            if (activeFunction == ActiveFunction.move) {
              final current = editor.getNodePosition(activeId);
              editor.updateNodePosition(
                activeId,
                current + details.focalPointDelta,
              );
            } else if (activeFunction == ActiveFunction.rotate) {
              final current = editor.getNodeRotation(activeId);
              editor.updateNodeRotation(
                activeId,
                current + 0.01 * details.focalPointDelta.dx,
              );
            } else if (activeFunction == ActiveFunction.resize) {
              final current = editor.getNodeSize(activeId);
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
        child: SizedBox(
          width: 2000,
          height: 2000,
          child: Stack(
            children: [
              const SizedBox(
                width: 2000,
                height: 2000,
                child: GridPaper(
                  color: Colors.blue,
                  divisions: 20,
                  subdivisions: 1,
                  interval: 400,
                ),
              ),
              ...editor.nodes.entries.map((entry) {
                final node = entry.value;
                return CustomNode(
                  id: node.id,
                  position: node.position,
                  onTap: (id) => print('$id'),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 241, 255, 232),
                    border: Border.all(),
                  ),
                  innerWidget: Builder(
                    builder: (context) {
                      final pos = EditorNotifier.of(
                        context,
                      ).getNodePosition(node.id);
                      return Column(
                        children: [
                          Text("Node ${node.id}"),
                          Text(
                            "${pos.dx.toStringAsFixed(2)},${pos.dy.toStringAsFixed(2)}",
                          ),
                        ],
                      );
                    },
                  ),
                  onDrag: (delta) {
                    final current = editor.getNodePosition(node.id);
                    editor.updateNodePosition(node.id, current + delta);
                  },
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
        ],
      ),
    );
  }
}

class CustomNode extends StatefulWidget {
  final String id;
  final Offset position;
  final BoxDecoration? decoration;
  final Function(String id)? onTap;
  final Widget innerWidget;
  final void Function(Offset delta) onDrag;
  final double? initialWidth;
  final double? initialHeight;

  const CustomNode({
    super.key,
    required this.id,
    required this.position,
    this.initialWidth,
    this.initialHeight,
    this.decoration,
    this.onTap,
    required this.innerWidget,
    required this.onDrag,
  });

  @override
  State<CustomNode> createState() => _CustomNodeState();
}

class _CustomNodeState extends State<CustomNode> {
  @override
  Widget build(BuildContext context) {
    final editor = EditorNotifier.of(context);
    final size = editor.getNodeSize(widget.id);
    final rotation = editor.getNodeRotation(widget.id);

    return Positioned(
      left: widget.position.dx,
      top: widget.position.dy,
      child: GestureDetector(
        onPanUpdate: editor.activeNodeId != null
            ? null
            : (details) {
                editor.updateNodePosition(
                  widget.id,
                  details.globalPosition.translate(
                    -size.width / 2,
                    -size.height / 2,
                  ),
                );
              },
        onTap: () => widget.onTap?.call(widget.id),
        child: Transform.rotate(
          angle: rotation,
          child: Container(
            width: size.width,
            height: size.height,
            padding: EdgeInsets.all(8),
            decoration: widget.decoration,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Main node body with rotation
                Center(child: widget.innerWidget),

                // Input port (left outside)
                const Positioned(
                  left: -8,
                  top: 30,
                  child: PortWidget(color: Colors.green),
                ),

                // Output port (right outside)
                const Positioned(
                  right: -8,
                  top: 30,
                  child: PortWidget(color: Colors.red),
                ),

                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Material(
                    color: Colors.yellow,
                    child: InkWell(
                      hoverColor: Colors.red,
                      onTapDown: (_) {
                        final editor = EditorNotifier.of(context);
                        editor.updateActive(widget.id, ActiveFunction.resize);
                      },
                      onTapUp: (_) {
                        final editor = EditorNotifier.of(context);
                        editor.updateActive(null, null);
                      },
                      child: const Icon(Icons.drag_handle, size: 16),
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Material(
                    color: Colors.yellow,
                    child: InkWell(
                      hoverColor: Colors.red,
                      // onPanUpdate: (details) {
                      //   final editor = EditorNotifier.of(context);
                      //   final deltaRot = details.delta.dx > 0 ? .1 : -0.1;
                      //   editor.updateNodeRotation(
                      //     widget.id,
                      //     rotation + deltaRot,
                      //   );
                      //   print(details);
                      // },
                      // onPanEnd: (details) {
                      //   editor.updateActive(null, null);
                      // },
                      onTapDown: (_) {
                        final editor = EditorNotifier.of(context);
                        editor.updateActive(widget.id, ActiveFunction.rotate);
                        print("onTapDown");
                      },
                      onTapCancel: () {
                        print("onTapDown");
                      },
                      onTapUp: (_) {
                        final editor = EditorNotifier.of(context);
                        editor.updateActive(null, null);
                        print("onTapUp");
                      },
                      child: const Icon(Icons.rotate_right, size: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PortWidget extends StatelessWidget {
  final Color color;

  const PortWidget({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.black),
      ),
    );
  }
}

import 'dart:convert';
import 'dart:math';

import 'package:example/pages/recipe.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moonspace/helper/extensions/string.dart';
import 'package:moonspace/helper/extensions/theme_ext.dart';
import 'package:moonspace/node_editor/export.dart';
import 'package:moonspace/node_editor/links.dart';

enum NodeTypes { recipe, slider }

final typeRegistry = {
  //
  NodeTypes.recipe.toString(): TypeBuilderEntry(
    builder: (context, node) => RecipeBox(node: node),
    deserialize: (json) => Recipe.deserialize(json),
    serialize: (val) => (val is Recipe) ? val.serialize() : null,
  ),

  //
  NodeTypes.slider.toString(): TypeBuilderEntry(
    builder: (context, node) => SliderBox(node: node),
    deserialize: (json) => json,
    serialize: (value) => value,
  ),
};

class NodeEditorScaffold extends StatefulWidget {
  const NodeEditorScaffold({super.key});

  @override
  State<NodeEditorScaffold> createState() => _NodeEditorScaffoldState();
}

class _NodeEditorScaffoldState extends State<NodeEditorScaffold> {
  late final EditorChangeNotifier editor;

  @override
  void initState() {
    super.initState();

    editor =
        EditorChangeNotifier(
            ioffset: Offset(0, 0),
            izoom: 1,
            linkStyle: LinkStyle(
              linkColor: Colors.blue,
              linkType: LinkType.bezier,
              weight: 0,
              linkWidth: 2,
            ),
            idivisions: 8,
            iinterval: 160,
            typeRegistry: typeRegistry,
          )
          ..addNodes([
            Node<double>(
              id: 'nodeA',
              type: NodeTypes.slider.toString(),
              position: const Offset(20, 300),
              rotation: 0,
              size: const Size(120, 120),
              value: .5,
              ports: [
                Port<double>(input: false, offsetRatio: Offset(1, 0.3)),
                Port<double>(input: false, offsetRatio: Offset(1, 0.7)),
              ],
            ),
            Node<Recipe>(
              id: 'nodeB',
              type: NodeTypes.recipe.toString(),
              position: const Offset(200, 100),
              rotation: 0,
              size: const Size(240, 200),
              value: Recipe(index: 0),
              ports: [
                Port<double>(input: true, offsetRatio: Offset(0, 0.3)),
                Port<String>(input: false, offsetRatio: Offset(0, 0.7)),
              ],
            ),
          ])
          ..addLinksByPort([
            (
              nodeId1: "nodeA",
              index1: 0,
              nodeId2: "nodeB",
              index2: 0,
              value: .5,
            ),
          ]);
  }

  @override
  Widget build(BuildContext context) {
    return EditorNotifier(
      model: editor,
      child: Scaffold(
        body: Stack(
          children: [
            Positioned(
              left: (context.mq.size.width - 500) / 2,
              top: (context.mq.size.height - 500) / 2,
              width: 500,
              height: 500,
              child: Container(
                color: Theme.of(context).colorScheme.surfaceContainerHigh,
                child: NodeEditor(),
              ),
            ),
            Align(alignment: Alignment.topLeft, child: EditorState()),
          ],
        ),
      ),
    );
  }
}

class Recipe {
  final int index;

  Recipe({required this.index});

  static Recipe deserialize(dynamic json) {
    return Recipe(index: json['index'] ?? 0);
  }

  Map<String, dynamic> serialize() {
    return {'index': index};
  }
}

class RecipeBox extends StatelessWidget {
  const RecipeBox({super.key, required this.node});

  final Node node;

  @override
  Widget build(BuildContext context) {
    if (node.value is! Recipe) return Text("Undefined");
    Recipe value = node.value;

    return AbsorbPointer(
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          RecipeCard(
            index: value.index % RecipesData.dessertMenu.length,
            delayMs: 0,
            downScroll: false,
          ),
          Text(randomString(5)),
        ],
      ),
    );
  }
}

class SliderBox extends StatefulWidget {
  const SliderBox({super.key, required this.node});

  final Node node;

  @override
  State<SliderBox> createState() => _SliderBoxState();
}

class _SliderBoxState extends State<SliderBox> {
  int buildCount = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.node.value is! double) return Text("Undefined");

    final editor = EditorNotifier.of(context);

    buildCount++;

    return Card(
      elevation: 8,
      shape: BeveledRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(buildCount.toString()),
          Text(widget.node.id),

          Text(widget.node.value!.toStringAsFixed(2)),
          Slider(
            value: widget.node.value!,
            onChanged: (value) {
              final p1 = widget.node.ports.isNotEmpty
                  ? widget.node.ports.first
                  : null;

              setState(() {
                widget.node.value = value;
                if (p1 != null) {
                  editor.updatePortValue(p1, (value * 100).toInt() / 100);
                  final linkedPort = editor.getLinkedPort(p1);
                  if (linkedPort != null) {
                    editor.updateNodeRotation(
                      linkedPort.nodeId!,
                      (value * 6.28),
                    );
                  }
                }
              });
            },
          ),
        ],
      ),
    );
  }
}

class EditorState extends StatefulWidget {
  const EditorState({super.key});

  @override
  State<EditorState> createState() => _EditorStateState();
}

class _EditorStateState extends State<EditorState> {
  bool showDrawer = false;

  String savedState = "";
  late final EditorChangeNotifier editor;

  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_initialized) {
      editor = EditorNotifier.of(context);
      savedState = jsonEncode(editor.toMap());
      _initialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (showDrawer)
          Container(
            width: 200,
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).colorScheme.primary),
              color: Theme.of(context).canvasColor,
            ),
            padding: EdgeInsets.all(4),
            child: ListView(
              children: [
                Text('Offset: ${editor.editorOffset}'),
                Text('Zoom: ${editor.izoom.toStringAsFixed(2)}'),
                Text(
                  'IOffset: ${editor.ioffset.dx.toStringAsFixed(1)},${editor.ioffset.dy.toStringAsFixed(1)}',
                ),
                Text('Active: ${editor.activeNodeId}'),
                Text('Nodes: ${editor.nodes.length}'),
                Column(
                  children: editor.links.values.map((v) => Text(v.id)).toList(),
                ),
                Text('Key: ${editor.activeKey}'),
                Text(
                  'Control: ${editor.activeKey == LogicalKeyboardKey.metaLeft}',
                ),
                FilledButton(
                  onPressed: () {
                    savedState = jsonEncode(editor.toMap());
                  },
                  child: Text("Serialize state"),
                ),
                FilledButton(
                  onPressed: () {
                    editor.clear();
                  },
                  child: Text("Clear state"),
                ),
                FilledButton(
                  onPressed: () {
                    final deserializedState = EditorChangeNotifier.fromMap(
                      jsonDecode(savedState),
                      typeRegistry,
                    );
                    editor.overwriteState(deserializedState);
                  },
                  child: Text("Reset state"),
                ),
                FilledButton(
                  onPressed: () {
                    editor.interactiveController.value = Matrix4.identity();
                  },
                  child: Text("Center"),
                ),

                ...editor.nodes.entries.map((node) {
                  return FilledButton(
                    onPressed: () {
                      editor.updateActiveNode(node.value.id);
                      editor.interactiveAnimateTo(node.value.center, context);
                    },
                    child: Text("Focus ${node.value.id}"),
                  );
                }),

                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: editor.typeRegistry.entries
                      .map(
                        (e) => InkWell(
                          onTap: () {
                            editor.addNodes(
                              List.generate(
                                50,
                                (c) => Node<double>(
                                  id: 'node$c',
                                  type: NodeTypes.slider.toString(),
                                  position: Offset(
                                    Random().nextDouble() * 800,
                                    Random().nextDouble() * 800,
                                  ),
                                  rotation: 0,
                                  size: const Size(150, 100),
                                  value: .5,
                                  ports: [
                                    Port<double>(
                                      input: false,
                                      offsetRatio: Offset(1, 0.3),
                                    ),
                                    Port<double>(
                                      input: false,
                                      offsetRatio: Offset(1, 0.7),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          child: Container(
                            width: 80,
                            height: 80,
                            margin: EdgeInsets.all(8),
                            color: Colors.red,
                            child: Text(e.key),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
        IconButton.filled(
          onPressed: () {
            showDrawer = !showDrawer;
            setState(() {});
          },
          icon: Icon(Icons.keyboard_arrow_right),
        ),
      ],
    );
  }
}

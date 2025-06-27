import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:example/pages/recipe.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moonspace/helper/extensions/theme_ext.dart';
import 'package:moonspace/node_editor/export.dart';
import 'package:moonspace/node_editor/links.dart';

enum NodeTypes { recipe, slider, timer }

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

  //
  NodeTypes.timer.toString(): TypeBuilderEntry(
    builder: (context, node) => TimerBox(node: node),
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
              linkWidth: 4,
            ),
            idivisions: 8,
            iinterval: 160,
            typeRegistry: typeRegistry,
          )
          ..addNodes([
            Node<double>(
              id: 'nodeTimer1',
              type: NodeTypes.timer.toString(),
              position: const Offset(20, 100),
              rotation: 0,
              size: Offset(120, 120),
              value: .5,
              ports: [
                Port<double>(
                  input: false,
                  offsetRatio: Offset(1, 0.3),
                  value: 0.5,
                ),
                Port<String>(
                  input: false,
                  offsetRatio: Offset(1, 0.7),
                  value: "Hello",
                ),
                Port<int>(input: false, offsetRatio: Offset(0, 0.3), value: 1),
                // Port<DateTime>(
                //   input: false,
                //   offsetRatio: Offset(0, 0.7),
                //   value: DateTime.now(),
                // ),
                Port<Map<String, String>>(
                  input: false,
                  offsetRatio: Offset(0.3, 1),
                  value: {"hello": "Hello"},
                ),
                // Port<Recipe>(
                //   input: false,
                //   offsetRatio: Offset(0.7, 1),
                //   value: Recipe(index: 1),
                // ),
                // Port<(double, double)>(
                //   input: false,
                //   offsetRatio: Offset(0.3, 0),
                //   value: (2, 3),
                // ),
                // Port<({String title, String subtitle})>(
                //   input: false,
                //   offsetRatio: Offset(0.7, 0),
                //   value: (title: "Hello", subtitle: "hello"),
                // ),
              ],
            ),
            Node<double>(
              id: 'nodeSlider1',
              type: NodeTypes.slider.toString(),
              position: const Offset(20, 300),
              rotation: 0,
              size: Offset(120, 120),
              value: .5,
              ports: [
                Port<double>(input: false, offsetRatio: Offset(1, 0.3)),
                Port<double>(input: false, offsetRatio: Offset(1, 0.7)),
              ],
            ),
            Node<Recipe>(
              id: 'nodeRecipe1',
              type: NodeTypes.recipe.toString(),
              position: const Offset(200, 100),
              rotation: 0,
              size: const Offset(250, 250),
              value: Recipe(index: 2),
              ports: [
                Port<double>(input: true, offsetRatio: Offset(0, 0.3)),
                Port<String>(
                  input: false,
                  offsetRatio: Offset(0, 0.7),
                  value: "Hello",
                ),
              ],
            ),
          ])
          ..addLinksByPort([
            (
              nodeId1: "nodeSlider1",
              index1: 0,
              nodeId2: "nodeRecipe1",
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

    return RecipeCard(
      index: value.index % RecipesData.dessertMenu.length,
      delayMs: 0,
      downScroll: false,
    );
  }
}

class TimerBox extends StatefulWidget {
  const TimerBox({super.key, required this.node});

  final Node node;

  @override
  State<TimerBox> createState() => _TimerBoxState();
}

class _TimerBoxState extends State<TimerBox> {
  int time = 0;

  @override
  void initState() {
    super.initState();

    Timer.periodic(Duration(seconds: 1), (t) {
      if (mounted) {
        time++;
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(8),
      child: Text(time.toString()),
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
                                  size: const Offset(150, 100),
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

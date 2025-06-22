import 'package:flutter/material.dart';
import 'package:moonspace/node_editor/export.dart';

class ColumnText {
  final String title;
  final String subtitle;

  ColumnText({required this.title, required this.subtitle});

  factory ColumnText.fromJson(Map<String, dynamic> json) =>
      ColumnText(title: json['title'] ?? '', subtitle: json['subtitle'] ?? '');

  dynamic toJson() => {'title': title, 'subtitle': subtitle};
}

class SliderBox extends StatefulWidget {
  const SliderBox({super.key, required this.node});

  final Node node;

  @override
  State<SliderBox> createState() => _SliderBoxState();
}

class _SliderBoxState extends State<SliderBox> {
  @override
  Widget build(BuildContext context) {
    final editor = EditorNotifier.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(widget.node.value.toStringAsFixed(2)),
        Slider(
          value: widget.node.value,
          onChanged: (value) {
            setState(() {
              widget.node.value = value;
              editor.updateLinkValue(
                editor.getLinksForNode(widget.node.id).first.id,
                value,
              );
            });
          },
        ),
      ],
    );
  }
}

class NodeEditorScaffold extends StatelessWidget {
  const NodeEditorScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    final editor =
        EditorChangeNotifier(
          typeRegistry: {
            'columntext': TypeRegistryEntry<ColumnText>(
              builder: (context, node) {
                final editor = EditorNotifier.of(context);
                final pos = node.position;
                if (node.value is! ColumnText) return Text("Undefined");
                final ColumnText val = node.value;
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(val.title),
                    Text(val.subtitle),
                    Text(node.id),
                    Text("Rot ${node.rotation.toStringAsFixed(2)}"),
                    Text("Links ${editor.links.length}"),
                    Text("Links ${editor.links.length}"),
                    ...editor.links.map(
                      (e) => Text(
                        "${e.id} ${(e.value as double).toStringAsFixed(2)}",
                      ),
                    ),
                    Text(
                      "Pos ${pos.dx.toStringAsFixed(0)},${pos.dy.toStringAsFixed(0)}",
                    ),
                  ],
                );
              },
              fromJson: (json) => ColumnText.fromJson(json),
              toJson: (dynamic val) => val.toJson(),
            ),
            'slider': TypeRegistryEntry<double>(
              builder: (context, Node node) {
                if (node.value is! double) return Text("Undefined");
                return SliderBox(node: node);
              },
              fromJson: (json) => json as double,
              toJson: (dynamic value) => value as dynamic,
            ),
          },
        )..addNodes([
          Node(
            id: 'nodeA',
            type: "columntext",
            position: const Offset(250, 100),
            rotation: 0,
            size: const Size(150, 200),
            backgroundColor: Colors.white,
            borderRadius: 8,
            value: ColumnText(title: 'Hello', subtitle: 'World'),
            ports: [
              Port(
                index: 0,
                nodeId: "nodeA",
                // linkId: "linkAB1",
                offsetRatio: Offset(0, 0.5),
                value: 2.0,
              ),
            ],
          ),
          Node(
            id: 'nodeB',
            type: "slider",
            position: const Offset(20, 250),
            rotation: 0,
            size: const Size(150, 100),
            backgroundColor: Colors.white,
            borderRadius: 8,
            value: .5,
            ports: [
              Port(
                index: 0,
                nodeId: "nodeB",
                // linkId: "linkAB1",
                offsetRatio: Offset(1, 0.5),
                value: 2.0,
              ),
            ],
          ),
        ]);

    return EditorNotifier(
      model: editor,
      child: Scaffold(body: Stack(children: [NodeEditor(), EditorState()])),
    );
  }
}

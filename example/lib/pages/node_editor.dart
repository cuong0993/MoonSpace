import 'package:flutter/material.dart';
import 'package:moonspace/node_editor/export.dart';
import 'package:moonspace/node_editor/links.dart';

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
              editor.updatePortValue(widget.node.ports.first, value);
              editor.updateNodeRotation(
                editor
                    .getLinkById(widget.node.ports.first.linkId!)!
                    .outputPort
                    .nodeId,
                value * 6.28,
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
          linkStyle: LinkStyle(
            linkColor: Colors.yellow,
            linkType: LinkType.bezier,
            weight: 0,
          ),
          divisions: 4,
          interval: 250,
          typeRegistry: {
            'columntext': TypeRegistryEntry<ColumnText>(
              builder: (context, node) {
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
            position: const Offset(250, 50),
            rotation: 0,
            size: const Size(180, 250),
            value: ColumnText(title: 'Hello', subtitle: 'World'),
            ports: [
              Port(
                index: 0,
                nodeId: "nodeA",
                origin: true,
                linkId: "linkAB1",
                offsetRatio: Offset(0, 0.5),
                value: 2.0,
              ),
            ],
          ),
          Node(
            id: 'nodeB',
            type: "slider",
            position: const Offset(20, 300),
            rotation: 0,
            size: const Size(150, 100),

            value: .5,
            ports: [
              Port(
                index: 0,
                nodeId: "nodeB",
                origin: false,
                linkId: "linkAB1",
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

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

  final NodeData node;

  @override
  State<SliderBox> createState() => _SliderBoxState();
}

class _SliderBoxState extends State<SliderBox> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(widget.node.value.toStringAsFixed(2)),
        Slider(
          value: widget.node.value,
          onChanged: (value) {
            setState(() {
              widget.node.value = value;
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
                final pos = EditorNotifier.of(context).getNodePosition(node.id);
                if (node.value is! ColumnText) return Text("Undefined");
                final ColumnText val = node.value;
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(val.title),
                    Text(val.subtitle),
                    Text(node.id),
                    Text(node.rotation.toStringAsFixed(2)),
                    Text(
                      "${pos.dx.toStringAsFixed(2)},${pos.dy.toStringAsFixed(2)}",
                    ),
                  ],
                );
              },
              fromJson: (json) => ColumnText.fromJson(json),
              toJson: (dynamic val) => val.toJson(),
            ),
            'slider': TypeRegistryEntry<double>(
              builder: (context, NodeData node) {
                if (node.value is! double) return Text("Undefined");
                return SliderBox(node: node);
              },
              fromJson: (json) => json as double,
              toJson: (dynamic value) => value as dynamic,
            ),
          },
        )..addNodes([
          NodeData(
            id: 'nodeA',
            type: "columntext",
            position: const Offset(200, 200),
            rotation: 0,
            size: const Size(150, 150),
            backgroundColor: Colors.white,
            borderRadius: 8,
            value: ColumnText(title: 'Hello', subtitle: 'World'),
            ports: [
              PortData(id: "nodeAPort1", offset: Offset(0, .5)),
              PortData(id: "nodeAPort2", offset: Offset(1, .5)),
            ],
          ),
          NodeData(
            id: 'nodeB',
            type: "slider",
            position: const Offset(200, 20),
            rotation: 0,
            size: const Size(150, 100),
            backgroundColor: Colors.white,
            borderRadius: 8,
            value: .5,
          ),
        ]);

    return EditorNotifier(
      model: editor,
      child: MaterialApp(
        home: Scaffold(
          backgroundColor: Colors.white,
          body: Stack(children: [NodeEditor(), EditorState()]),
        ),
      ),
    );
  }
}

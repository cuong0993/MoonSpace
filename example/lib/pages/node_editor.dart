import 'package:flutter/material.dart';
import 'package:moonspace/node_editor/export.dart';
import 'package:moonspace/node_editor/links.dart';

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
                  if (node.value == null) {
                    return Text("Empty");
                  }
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(node.value!.title),
                      Text(node.value!.subtitle),
                      Text(node.id),
                      Text("Rot ${node.rotation.toStringAsFixed(2)}"),
                      Text(
                        "Pos ${pos.dx.toStringAsFixed(0)},${pos.dy.toStringAsFixed(0)}",
                      ),
                    ],
                  );
                },
                deserialize: (json) => ColumnText.deserialize(json),
                serialize: (val) => val.serialize(),
              ),
              'slider': TypeRegistryEntry<double>(
                builder: (context, node) {
                  if (node.value is! double) return Text("Undefined");
                  return SliderBox(node: node);
                },
                deserialize: (json) => json,
                serialize: (value) => value,
              ),
            },
          )
          ..addNodes([
            Node<ColumnText>(
              id: 'nodeA',
              type: "columntext",
              position: const Offset(250, 50),
              rotation: 0,
              size: const Size(180, 150),
              value: ColumnText(title: 'Hello', subtitle: 'World'),
              ports: [
                Port<double>(input: true, offsetRatio: Offset(0, 0.25)),
                Port<String>(input: false, offsetRatio: Offset(0, 0.5)),
              ],
            ),
            Node<double>(
              id: 'nodeB',
              type: "slider",
              position: const Offset(20, 300),
              rotation: 0,
              size: const Size(150, 100),
              value: .5,
              ports: [
                Port<double>(input: false, offsetRatio: Offset(1, 0.3)),
                Port<double>(input: false, offsetRatio: Offset(1, 0.7)),
              ],
            ),
          ])
          ..addLinksByPort([(("nodeA", 0), ("nodeB", 0))]);

    return EditorNotifier(
      model: editor,
      child: Scaffold(
        body: Stack(
          children: [
            NodeEditor(),
            EditorState(),
            Positioned(
              bottom: 0,
              left: 0,
              child: Column(
                children: editor.typeRegistry.entries
                    .map((e) => Text(e.key))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ColumnText {
  final String title;
  final String subtitle;

  ColumnText({required this.title, required this.subtitle});

  static ColumnText deserialize(dynamic json) {
    return ColumnText(
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
    );
  }

  Map<String, String> serialize() {
    return {'title': title, 'subtitle': subtitle};
  }
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
        Text(widget.node.ports.first.id),
        Slider(
          value: widget.node.value,
          onChanged: (value) {
            setState(() {
              widget.node.value = value;
              editor.updatePortValue(
                widget.node.ports.first,
                (value * 100).toInt() / 100,
              );

              final linkedPort = editor.getLinkedPort(widget.node.ports.first);
              if (linkedPort != null) {
                editor.updateNodeRotation(linkedPort.nodeId!, (value * 6.28));
              }
            });
          },
        ),
      ],
    );
  }
}

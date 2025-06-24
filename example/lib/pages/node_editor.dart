import 'dart:math';

import 'package:flutter/material.dart';
import 'package:moonspace/helper/extensions/string.dart';
import 'package:moonspace/helper/extensions/theme_ext.dart';
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
            interval: 400,
            typeRegistry: {
              //
              //
              'columntext': TypeRegistryEntry<ColumnText>(
                builder: (context, node) {
                  if (node.value is! ColumnText) return Text("Undefined");
                  final pos = node.position;
                  if (node.value == null) {
                    return Text("Empty");
                  }
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(randomString(5)),
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

              //
              //
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
            // Node<ColumnText>(
            //   id: 'nodeA',
            //   type: "columntext",
            //   position: const Offset(300, 200),
            //   rotation: 0,
            //   size: const Size(180, 150),
            //   value: ColumnText(title: 'Hello', subtitle: 'World'),
            //   ports: [
            //     Port<double>(input: true, offsetRatio: Offset(0, 0.25)),
            //     Port<String>(input: false, offsetRatio: Offset(0, 0.5)),
            //   ],
            // ),
            Node<double>(
              id: 'nodeB',
              type: "slider",
              position: const Offset(100, 100),
              rotation: 0,
              size: const Size(200, 200),
              value: .5,
              ports: [
                Port<double>(input: false, offsetRatio: Offset(1, 0.3)),
                Port<double>(input: false, offsetRatio: Offset(1, 0.7)),
              ],
            ),
          ])
          ..addLinksByPort([
            (nodeId1: "nodeA", index1: 0, nodeId2: "nodeB", index2: 0),
          ]);

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
                color: const Color.fromARGB(255, 39, 39, 39),
                child: NodeEditor(),
              ),
            ),
            Align(alignment: Alignment.bottomLeft, child: EditorState()),
            Align(
              alignment: Alignment.bottomRight,
              child: Column(
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
                                type: "slider",
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
                          color: Colors.white,
                          child: Text(e.key),
                        ),
                      ),
                    )
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

    return Padding(
      padding: EdgeInsetsGeometry.all(8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(randomString(5)),
          Text(widget.node.id),

          Text(widget.node.value.toStringAsFixed(2)),
          Slider(
            value: widget.node.value,
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

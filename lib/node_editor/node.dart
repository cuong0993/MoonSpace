import 'package:flutter/material.dart';
import 'package:moonspace/helper/extensions/color.dart';
import 'package:moonspace/node_editor/types.dart';

class CustomNode extends StatefulWidget {
  final Node node;
  final Widget innerWidget;

  const CustomNode({super.key, required this.node, required this.innerWidget});

  @override
  State<CustomNode> createState() => _CustomNodeState();
}

class _CustomNodeState extends State<CustomNode> {
  @override
  Widget build(BuildContext context) {
    final editor = EditorNotifier.of(context);
    final size = editor.getNodeById(widget.node.id)!.size;
    final rotation = editor.getNodeById(widget.node.id)!.rotation;

    final cs = Theme.of(context).colorScheme;

    return Positioned(
      left: widget.node.position.dx,
      top: widget.node.position.dy,
      child: Transform.rotate(
        angle: rotation,
        child: Card(
          clipBehavior: Clip.hardEdge,
          elevation: 8,
          shape: BeveledRectangleBorder(
            side: BorderSide(),
            borderRadius: BorderRadiusGeometry.circular(8),
          ),
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              //
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: GestureDetector(
                  onTapDown: (details) {
                    editor.updateActiveFunction(
                      widget.node.id,
                      ActiveFunction.move,
                    );
                  },
                  onTapUp: (details) {
                    editor.updateActiveFunction(null, null);
                  },
                  child: Container(
                    color: editor.activeNodeId == widget.node.id
                        ? cs.surfaceContainerHigh
                        : cs.surface,
                    width: size.width,
                    height: size.height,
                    child: Center(child: widget.innerWidget),
                  ),
                ),
              ),

              //
              ...widget.node.ports.map((port) {
                final inputOffset = port.offsetRatio;

                return Positioned(
                  right: inputOffset.dx > .5
                      ? (1 - inputOffset.dx) * size.width
                      : null,
                  left: inputOffset.dx > .5
                      ? null
                      : inputOffset.dx * size.width,

                  bottom: inputOffset.dy > .5
                      ? (1 - inputOffset.dy) * size.height
                      : null,
                  top: inputOffset.dy > .5
                      ? null
                      : inputOffset.dy * size.height,

                  // width: PortWidget.size.dx * 2,
                  // height: PortWidget.size.dy * 2,
                  child: PortWidget(port: port),
                );
              }),

              //
              Positioned(
                right: 0,
                bottom: 0,
                child: Material(
                  color: Theme.of(context).colorScheme.primary,

                  child: InkWell(
                    hoverColor: Colors.red,
                    onTapDown: (_) {
                      editor.updateActiveFunction(
                        widget.node.id,
                        ActiveFunction.resize,
                      );
                    },
                    onTapUp: (_) {
                      editor.updateActiveFunction(null, null);
                    },
                    child: Icon(
                      Icons.drag_handle,
                      size: 16,
                      color: cs.onPrimary,
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 0,
                top: 0,
                child: Material(
                  color: Theme.of(context).colorScheme.primary,

                  child: InkWell(
                    hoverColor: Colors.red,
                    onTapDown: (_) {
                      editor.updateActiveFunction(
                        widget.node.id,
                        ActiveFunction.rotate,
                      );
                    },
                    onTapUp: (_) {
                      editor.updateActiveFunction(null, null);
                    },
                    child: Icon(
                      Icons.rotate_right,
                      size: 16,
                      color: cs.onPrimary,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                top: 0,
                child: Material(
                  color: cs.primary,
                  child: InkWell(
                    hoverColor: Colors.red,
                    onTap: () {
                      editor.removeNodeById(widget.node.id);
                    },
                    child: Icon(Icons.clear, size: 16, color: cs.onPrimary),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PortWidget extends StatelessWidget {
  const PortWidget({super.key, required this.port});

  final Port port;

  static const size = Offset(16, 16);

  @override
  Widget build(BuildContext context) {
    final editor = EditorNotifier.of(context);

    final color = colorFromType(port);
    final onColor = color.getOnColor();

    return MouseRegion(
      onEnter: (event) {
        if (editor.tempLinkStartPort != null &&
            editor.tempLinkStartPort != port) {
          final a = editor.tempLinkStartPort!;
          final inputPort = a.input ? a : port;
          final outputPort = a.input ? port : a;
          editor.addLinks([Link(inputPort: inputPort, outputPort: outputPort)]);
        }
      },
      child: GestureDetector(
        onPanStart: (details) {
          // if (port.linkId != null) {
          //   final linkedPort = editor.getLinkedPort(port);
          //   editor.tempLinkStartPort ??= linkedPort;
          //   editor.removeLinkById(port.linkId!);
          // } else
          {
            editor.tempLinkStartPort ??= port;
          }
        },
        onPanUpdate: (details) {
          if (editor.tempLinkStartPort != null) {
            editor.updateTempLinkPosition(details.localPosition, context);
          }
        },
        onPanEnd: (details) {
          editor.removeTempLink();
        },
        child: Container(
          width: size.dx * 2,
          height: size.dy * 2,
          padding: EdgeInsets.all(2),
          alignment: Alignment.center,
          decoration: port.input
              ? ShapeDecoration(
                  color: Colors.red,
                  shape: StarBorder.polygon(
                    sides: 3.00,
                    rotation: -90,
                    pointRounding: .4,
                    squash: 0.25,
                  ),
                )
              : BoxDecoration(
                  color: editor.tempLinkStartPort == port
                      ? Colors.black
                      : color,
                ),
          // child: Text(
          //   // "${port.value}",
          //   "${port.id} ${port.value}",
          //   style: TextStyle(color: onColor),
          // ),
        ),
      ),
    );
  }
}

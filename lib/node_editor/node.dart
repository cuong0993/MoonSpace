import 'package:flutter/material.dart';
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
    final size = editor.getNode(widget.node.id)!.size;
    final rotation = editor.getNode(widget.node.id)!.rotation;

    return Positioned(
      left: widget.node.position.dx,
      top: widget.node.position.dy,
      child: Transform.rotate(
        angle: rotation,
        child: Container(
          decoration: BoxDecoration(
            color: widget.node.backgroundColor,
            border: Border.all(),
            borderRadius: BorderRadius.circular(widget.node.borderRadius),
          ),
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Material(
                  child: InkWell(
                    splashColor: Colors.transparent,
                    overlayColor: WidgetStateColor.resolveWith(
                      (c) => Theme.of(context).colorScheme.onSecondary,
                    ),
                    onTapDown: (_) {
                      editor.updateActive(widget.node.id, ActiveFunction.move);
                    },
                    onTapUp: (_) {
                      editor.updateActive(null, null);
                    },
                    child: SizedBox(
                      width: size.width,
                      height: size.height,
                      child: Center(child: widget.innerWidget),
                    ),
                  ),
                ),
              ),

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

                  width: PortWidget.size.dx * 2,
                  height: PortWidget.size.dy * 2,

                  child: PortWidget(port: port, right: inputOffset.dx > .5),
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
                      editor.updateActive(
                        widget.node.id,
                        ActiveFunction.resize,
                      );
                    },
                    onTapUp: (_) {
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
                  color: Theme.of(context).colorScheme.primary,

                  child: InkWell(
                    hoverColor: Colors.red,
                    onTapDown: (_) {
                      editor.updateActive(
                        widget.node.id,
                        ActiveFunction.rotate,
                      );
                    },
                    onTapUp: (_) {
                      editor.updateActive(null, null);
                    },
                    child: const Icon(Icons.rotate_right, size: 16),
                  ),
                ),
              ),

              Positioned(
                left: 0,
                top: 0,
                child: Material(
                  color: Theme.of(context).colorScheme.primary,
                  child: InkWell(
                    hoverColor: Colors.red,
                    onTap: () {
                      editor.removeNode(widget.node);
                    },
                    child: const Icon(Icons.clear, size: 16),
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
  const PortWidget({super.key, required this.port, required this.right});

  final Port port;

  final bool right;

  static const size = Offset(16, 16);

  @override
  Widget build(BuildContext context) {
    final editor = EditorNotifier.of(context);

    return Transform.translate(
      offset: Offset(right ? 16 : -16, -8),
      child: Material(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(16),
        child: MouseRegion(
          onEnter: (event) {
            if (editor.startPort != null && editor.startPort != port) {
              editor.addLinks([
                Link(inputPort: editor.startPort, outputPort: port, value: 2.2),
              ]);
            }
          },
          child: GestureDetector(
            onPanStart: (details) {
              editor.startPort ??= port;
            },
            onPanUpdate: (details) {
              if (editor.startPort != null) {
                editor.updateTempLinkPosition(details.localPosition, context);
              }
            },
            onPanEnd: (details) {
              editor.removeTempLink();
            },
            child: Container(
              alignment: Alignment.center,
              child: Text(port.value.toString()),
            ),
          ),
        ),
      ),
    );
  }
}

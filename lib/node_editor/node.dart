import 'package:flutter/material.dart';
import 'package:moonspace/node_editor/types.dart';

class CustomNode extends StatefulWidget {
  final NodeData node;
  final Widget innerWidget;

  const CustomNode({super.key, required this.node, required this.innerWidget});

  @override
  State<CustomNode> createState() => _CustomNodeState();
}

class _CustomNodeState extends State<CustomNode> {
  @override
  Widget build(BuildContext context) {
    final editor = EditorNotifier.of(context);
    final size = editor.getNodeSize(widget.node.id);
    final rotation = editor.getNodeRotation(widget.node.id);

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
            clipBehavior: Clip.none,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Material(
                  child: InkWell(
                    splashColor: Colors.transparent,
                    overlayColor: WidgetStateColor.resolveWith(
                      (c) => const Color.fromARGB(255, 239, 255, 217),
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

              ...editor.getLinksForNode(widget.node.id).map((p) {
                if (p.inputId == widget.node.id) {
                  return Positioned(
                    right: p.inputOffset.dx > .5
                        ? (1 - p.inputOffset.dx) * size.width
                        : null,
                    left: p.inputOffset.dx > .5
                        ? null
                        : p.inputOffset.dx * size.width,
                    top: p.inputOffset.dy * size.height,
                    child: PortWidget(
                      color: Colors.red,
                      value: p.value.toString(),
                    ),
                  );
                }
                return Positioned(
                  right: p.outputOffset.dx > .5
                      ? (1 - p.outputOffset.dx) * size.width
                      : null,
                  left: p.outputOffset.dx > .5
                      ? null
                      : p.outputOffset.dx * size.width,

                  top: p.outputOffset.dy * size.height,
                  child: PortWidget(
                    color: Colors.green,
                    value: p.value.toString(),
                  ),
                );
              }),

              //
              Positioned(
                right: 0,
                bottom: 0,
                child: Material(
                  color: Colors.transparent,
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
                  color: Colors.transparent,
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
                  color: Colors.transparent,
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
  const PortWidget({super.key, required this.color, required this.value});

  final Color color;
  final String value;

  static const size = Offset(32, 32);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: size.dx,
      height: size.dy,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.black),
      ),
      child: Text(value),
    );
  }
}

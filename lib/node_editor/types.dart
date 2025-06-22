import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:moonspace/node_editor/helper.dart';
import 'package:moonspace/node_editor/node.dart';

class Port<T> {
  final int index;
  final String nodeId;
  final String? linkId;
  final Offset offsetRatio; // (0 to 1, 0 to 1)
  T? value;

  Port({
    required this.index,
    required this.nodeId,
    this.linkId,
    required this.offsetRatio,
    required this.value,
  });

  Map<String, dynamic> toJson() => {
    'index': index,
    'nodeId': nodeId,
    'linkId': linkId,
    'offsetRatio': {'dx': offsetRatio.dx, 'dy': offsetRatio.dy},
    'value': value,
  };

  String get id => '${nodeId}_$index';

  factory Port.fromJson(Map<String, dynamic> json) => Port(
    index: json['index'],
    nodeId: json['nodeId'],
    linkId: json['linkId'],
    offsetRatio: Offset(json['offsetRatio']['dx'], json['offsetRatio']['dy']),
    value: json['value'],
  );
}

enum ActiveFunction { move, rotate, resize }

class Link<T> {
  final Port? inputPort;
  final Port? outputPort;
  T? value;

  String get id => "";

  Link({this.inputPort, this.outputPort, this.value});

  Map<String, dynamic> toJson() => {
    'inputPort': inputPort?.toJson(),
    'outputPort': outputPort?.toJson(),
    'value': value,
  };

  factory Link.fromJson(Map<String, dynamic> json) => Link(
    inputPort: json['inputPort'] != null
        ? Port.fromJson(json['inputPort'])
        : null,
    outputPort: json['outputPort'] != null
        ? Port.fromJson(json['outputPort'])
        : null,
    value: json['value'],
  );
}

class TypeRegistryEntry<T> {
  final Widget Function(BuildContext context, Node node) builder;
  final T Function(dynamic json) fromJson;
  final dynamic Function(T value) toJson;

  TypeRegistryEntry({
    required this.builder,
    required this.fromJson,
    required this.toJson,
  });
}

class Node<T> {
  final String id;
  final String type;
  Offset position;
  double rotation;
  Size size;
  Color backgroundColor;
  double borderRadius;
  T value;
  List<Port> ports;

  Node({
    required this.id,
    required this.type,
    required this.position,
    required this.rotation,
    required this.size,
    this.backgroundColor = const Color(0xFFFFFFFF),
    this.borderRadius = 12.0,
    required this.value,
    required this.ports,
  });

  Map<String, dynamic> toJson(Map<String, TypeRegistryEntry> registry) {
    final entry = registry[type];

    return {
      'id': id,
      'type': entry != null ? type : null,
      'position': {'dx': position.dx, 'dy': position.dy},
      'rotation': rotation,
      'size': {'width': size.width, 'height': size.height},
      'backgroundColor': backgroundColor.value,
      'borderRadius': borderRadius,
      'value': entry?.toJson(value),
      'ports': ports.map((p) => p.toJson()).toList(),
    };
  }

  factory Node.fromJson(
    Map<String, dynamic> json,
    Map<String, TypeRegistryEntry> typeRegistry,
  ) {
    final type = json['type'];
    final registry = typeRegistry[type];

    final dynamic value = registry?.fromJson(json['value']);

    return Node(
      id: json['id'],
      type: registry != null ? type : '__error__',
      position: Offset(json['position']['dx'], json['position']['dy']),
      rotation: json['rotation'],
      size: Size(json['size']['width'], json['size']['height']),
      backgroundColor: Color(json['backgroundColor']),
      borderRadius: json['borderRadius'],
      value: value,
      ports:
          (json['ports'] as List?)?.map((p) => Port.fromJson(p)).toList() ?? [],
    );
  }
}

class EditorChangeNotifier extends ChangeNotifier {
  EditorChangeNotifier({required this.typeRegistry});

  final Map<String, Node> nodes = {};

  final Map<String, Set<String>> nodeLinkMap = {}; // nodeId → Set of link IDs
  final Map<String, Link> linkMap = {}; // linkId → LinkData
  final List<Link> links = [];

  final Map<String, TypeRegistryEntry> typeRegistry;

  String? activeNodeId;
  ActiveFunction? activeFunction;

  Port? startPort;
  Offset? tempLinkEndPos;

  LogicalKeyboardKey? activeKey;

  double zoom = 1.0;
  Offset offset = Offset.zero;

  final TransformationController interactiveController =
      TransformationController();

  void updateZoom(double z) {
    zoom = z;
    notifyListeners();
  }

  void updateOffset(Offset o) {
    offset = o;
    notifyListeners();
  }

  void addNodes(List<Node> nodelist) {
    for (var node in nodelist) {
      nodes[node.id] = node;
    }

    final List<Link> newLinks = [];
    for (var inputNode in nodelist) {
      for (var outputNode in nodes.entries) {
        for (final inputport in inputNode.ports) {
          for (final outputport in outputNode.value.ports) {
            if (inputport.linkId != null &&
                (inputport != outputport) &&
                !linkMap.containsKey(outputport.linkId)) {
              newLinks.add(
                Link(
                  inputPort: inputport,
                  outputPort: outputport,
                  value: inputport.value,
                ),
              );
            }
          }
        }
      }
    }
    addLinks(newLinks);

    notifyListeners();
  }

  void addLinks(List<Link> linklist) {
    for (var link in linklist) {
      links.add(link);
      linkMap[link.id] = link;

      void mapNode(String? nodeId) {
        if (nodeId == null) return;
        nodeLinkMap.putIfAbsent(nodeId, () => {}).add(link.id);
      }

      mapNode(link.inputPort?.nodeId);
      mapNode(link.outputPort?.nodeId);
    }

    notifyListeners();
  }

  void updateNodePosition(String id, Offset pos) {
    if (nodes.containsKey(id)) {
      nodes[id]!.position = pos;
      notifyListeners();
    }
  }

  void updateNodeRotation(String id, double rot) {
    if (nodes.containsKey(id)) {
      nodes[id]!.rotation = rot;
      notifyListeners();
    }
  }

  void updateNodeSize(String id, Size size) {
    if (nodes.containsKey(id)) {
      nodes[id]!.size = size;
      notifyListeners();
    }
  }

  void updateActive(String? id, ActiveFunction? function) {
    activeNodeId = id;
    activeFunction = function;
    notifyListeners();
  }

  void updateKey(LogicalKeyboardKey? key) {
    activeKey = key;
    notifyListeners();
  }

  List<Link> getLinksForNode(String nodeId) {
    final ids = nodeLinkMap[nodeId] ?? {};
    return ids.map((id) => linkMap[id]!).toList();
  }

  Link? getLinkById(String id) {
    return linkMap[id];
  }

  void updateLinkValue(String linkId, dynamic value) {
    final link = linkMap[linkId];
    if (link != null) {
      link.value = value;
      link.inputPort?.value = value;
      link.outputPort?.value = value;
      notifyListeners();
    }
  }

  void updateTempLinkPosition(Offset pos, BuildContext context) {
    tempLinkEndPos = globalToCanvasOffset(pos, context);
    notifyListeners();
  }

  void removeTempLink() {
    startPort = null;
    tempLinkEndPos = null;
    notifyListeners();
  }

  void removeNode(Node node) {
    nodes.remove(node.id);

    // Collect affected link IDs
    final affectedLinkIds = linkMap.entries
        .where(
          (entry) =>
              entry.value.inputPort?.nodeId == node.id ||
              entry.value.outputPort?.nodeId == node.id,
        )
        .map((entry) => entry.key)
        .toList();

    for (final id in affectedLinkIds) {
      removeLinkById(id);
    }

    notifyListeners();
  }

  void removeLinkById(String id) {
    final link = linkMap.remove(id);
    if (link != null) {
      links.remove(link);

      void unmapNode(String? nodeId) {
        if (nodeId == null) return;
        nodeLinkMap[nodeId]?.remove(id);
        if (nodeLinkMap[nodeId]?.isEmpty ?? false) {
          nodeLinkMap.remove(nodeId);
        }
      }

      unmapNode(link.inputPort?.nodeId);
      unmapNode(link.outputPort?.nodeId);
    }

    notifyListeners();
  }

  Offset getPortOffset(Port<dynamic> port) {
    final iPos = getNode(port.nodeId)!.position;
    final iSize = getNode(port.nodeId)!.size + PortWidget.size;
    final iRot = getNode(port.nodeId)!.rotation;
    final iCenter = iPos + iSize.center(Offset.zero);
    final isx = iSize.width * port.offsetRatio.dx;
    final isy = iSize.height * port.offsetRatio.dy;
    final iOffset = Offset(isx, isy) - iSize.center(Offset.zero);
    final p1 = rotateAroundCenter(iCenter + iOffset, iCenter, iRot);
    return p1;
  }

  Node? getNode(String id) => nodes[id];

  Widget buildNodeWidget(BuildContext context, Node node) {
    final entry = typeRegistry[node.type];
    if (entry == null) return Text('Unknown type: ${node.type}');
    return entry.builder(context, node);
  }

  Map<String, dynamic> toJson() => {
    'zoom': zoom,
    'offset': {'dx': offset.dx, 'dy': offset.dy},
    'nodes': nodes.map(
      (key, value) => MapEntry(key, value.toJson(typeRegistry)),
    ),
  };

  factory EditorChangeNotifier.fromJson(
    Map<String, dynamic> json,
    Map<String, TypeRegistryEntry<dynamic>> typeRegistry,
  ) {
    final editor = EditorChangeNotifier(typeRegistry: typeRegistry);
    editor.zoom = json['zoom'];
    editor.offset = Offset(json['offset']['dx'], json['offset']['dy']);
    final nodeMap = (json['nodes'] as Map<String, dynamic>).map(
      (key, nodedata) => MapEntry(key, Node.fromJson(nodedata, typeRegistry)),
    );
    editor.nodes.addAll(nodeMap);
    return editor;
  }
}

class EditorNotifier extends InheritedNotifier<EditorChangeNotifier> {
  const EditorNotifier({
    super.key,
    required EditorChangeNotifier model,
    required super.child,
  }) : super(notifier: model);

  static EditorChangeNotifier of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<EditorNotifier>()!.notifier!;
}

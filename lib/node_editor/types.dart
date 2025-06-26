import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moonspace/node_editor/helper.dart';
import 'package:moonspace/node_editor/links.dart';
import 'package:moonspace/node_editor/node.dart';

class Port<T> {
  int? index;
  String? nodeId;
  final bool input;

  /// (x : 0 to 1, y : 0 to 1)
  final Offset offsetRatio;

  T? value;

  Port({
    this.index,
    this.nodeId,
    this.input = false,
    required this.offsetRatio,
    this.value,
  });

  Map<String, dynamic> toMap() => {
    'index': index,
    'nodeId': nodeId,
    'input': input,
    'offsetRatio': {'dx': offsetRatio.dx, 'dy': offsetRatio.dy},
    'value': value,
  };

  String get id => '${nodeId}_$index';

  factory Port.fromMap(Map<String, dynamic> json) => Port(
    index: json['index'],
    nodeId: json['nodeId'],
    input: json['input'],
    offsetRatio: Offset(json['offsetRatio']['dx'], json['offsetRatio']['dy']),
    value: json['value'],
  );
}

class Link<T> {
  final Port inputPort;
  final Port outputPort;

  String get id => inputPort.input
      ? "${inputPort.id}_${outputPort.id}"
      : "${outputPort.id}_${inputPort.id}";

  Link({required this.inputPort, required this.outputPort});

  Map<String, dynamic> toMap() => {
    'inputPort': inputPort.toMap(),
    'outputPort': outputPort.toMap(),
  };

  factory Link.fromMap(Map<String, dynamic> json) => Link(
    inputPort: Port.fromMap(json['inputPort']),
    outputPort: Port.fromMap(json['outputPort']),
  );
}

class TypeBuilderEntry {
  final Widget Function(BuildContext context, Node node) builder;
  final dynamic Function(dynamic state) deserialize;
  final dynamic Function(dynamic state) serialize;

  TypeBuilderEntry({
    required this.builder,
    required this.deserialize,
    required this.serialize,
  });
}

class Node<T> {
  final String id;
  final String type;
  Offset position;
  double rotation;
  Size size;
  T? value;
  List<Port> ports;

  Node({
    required this.id,
    required this.type,
    required this.position,
    required this.rotation,
    required this.size,
    this.value,
    required this.ports,
  });

  Map<String, dynamic> toJson(Map<String, TypeBuilderEntry> registry) {
    final entry = registry[type];

    return {
      'id': id,
      'type': entry != null ? type : null,
      'position': {'dx': position.dx, 'dy': position.dy},
      'rotation': rotation,
      'size': {'width': size.width, 'height': size.height},
      'value': entry?.serialize(value),
      'ports': ports.map((p) => p.toMap()).toList(),
    };
  }

  factory Node.fromJson(
    Map<String, dynamic> json,
    Map<String, TypeBuilderEntry> registry,
  ) {
    final type = json['type'];
    final entry = registry[type];

    final dynamic value = entry?.deserialize(json['value']);

    return Node(
      id: json['id'],
      type: entry != null ? type : '__error__',
      position: Offset(json['position']['dx'], json['position']['dy']),
      rotation: json['rotation'],
      size: Size(json['size']['width'], json['size']['height']),
      value: value,
      ports:
          (json['ports'] as List?)?.map((p) => Port.fromMap(p)).toList() ?? [],
    );
  }

  Port? getPortById(int index) {
    if (index >= 0 && index < ports.length) {
      return ports[index];
    }
    return null;
  }

  Offset get center =>
      Offset(position.dx + size.width / 2, position.dy + size.height / 2);

  Offset ratioToGlobal(Offset localRatio, double radius) {
    final dia = 2 * radius;
    final xpadr = dia / size.width;
    final ypadr = dia / size.height;

    final leftside = localRatio.dx < xpadr;
    final rightside = (1 - localRatio.dx) < xpadr;

    final topside = localRatio.dy < ypadr;
    final bottomside = (1 - localRatio.dy) < ypadr;

    final push = Offset(
      leftside ? radius : (rightside ? -radius : 0),
      topside ? radius : (bottomside ? -radius : 0),
    );

    final unrotpos =
        position +
        Offset(localRatio.dx * size.width, localRatio.dy * size.height) +
        push;

    Offset rotpos = rotateAroundCenter(unrotpos, center, rotation);

    return rotpos;
  }
}

class EditorChangeNotifier extends ChangeNotifier {
  EditorChangeNotifier({
    required this.typeRegistry,

    //
    this.izoom = 1.0,
    this.ioffset = Offset.zero,
    this.iinterval = 500,
    this.idivisions = 4,

    this.editorOffset = Offset.zero,
    this.editorSize = const Offset(500, 500),

    //
    this.linkStyle = const LinkStyle(),
  });

  /// nodeid → Node
  final Map<String, Node> nodes = {};

  /// linkId → Link
  final Map<String, Link> links = {};

  final Map<String, TypeBuilderEntry> typeRegistry;

  String? activeNodeId;

  Port? tempLinkStartPort;
  Offset? tempLinkEndPos;

  String? activeLinkId;

  LogicalKeyboardKey? activeKey;

  double izoom;
  Offset ioffset;
  double iinterval;
  int idivisions;

  double zoneRadius = 12;

  Offset editorOffset;
  Offset editorSize;

  final LinkStyle linkStyle;

  // Offset? debugEditGlobalPosition;
  // Offset? debugMousePosition;

  // void updateDebugEditGlobalPosition(Offset off) {
  //   debugEditGlobalPosition = off;
  // }

  // void updateDebugMousePosition(Offset off) {
  //   debugMousePosition = off;
  // }

  final TransformationController interactiveController =
      TransformationController();

  //----------------

  Map<String, dynamic> toMap() => {
    'izoom': izoom,
    'ioffset': {'dx': ioffset.dx, 'dy': ioffset.dy},
    'iinterval': iinterval,
    'idivisions': idivisions,

    //
    'nodes': nodes.map(
      (key, value) => MapEntry(key, value.toJson(typeRegistry)),
    ),
    'links': links.values.map((link) => link.toMap()).toList(),
  };

  factory EditorChangeNotifier.fromMap(
    Map<String, dynamic> json,
    Map<String, TypeBuilderEntry> typeRegistry,
  ) {
    final editor = EditorChangeNotifier(typeRegistry: typeRegistry);

    editor.izoom = json['izoom'];
    editor.ioffset = Offset(json['ioffset']['dx'], json['ioffset']['dy']);
    editor.iinterval = json['iinterval'];
    editor.idivisions = json['idivisions'];

    final nodeMap = (json['nodes'] as Map<String, dynamic>).map(
      (key, nodedata) => MapEntry(key, Node.fromJson(nodedata, typeRegistry)),
    );
    editor.nodes.addAll(nodeMap);

    final linkList = (json['links'] as List<dynamic>?) ?? [];
    final parsedLinks = linkList
        .map((linkJson) => Link.fromMap(linkJson))
        .toList();

    editor.addLinks(parsedLinks);

    return editor;
  }

  void overwriteState(EditorChangeNotifier other) {
    // izoom = other.izoom;
    // ioffset = other.ioffset;
    // iinterval = other.iinterval;
    // idivisions = other.idivisions;
    nodes
      ..clear()
      ..addAll(other.nodes);
    links
      ..clear()
      ..addAll(other.links);
    notifyListeners();
  }

  void mergeState(EditorChangeNotifier other) {
    nodes.addAll(other.nodes);
    links.addAll(other.links);
    notifyListeners();
  }

  //----------------

  Widget buildNodeWidget(BuildContext context, Node node) {
    final entry = typeRegistry[node.type];
    if (entry == null) return Text('Unknown type: ${node.type}');
    return entry.builder(context, node);
  }

  //----------------

  Node? getNodeById(String id) => nodes[id];

  void addNodes(List<Node> nodelist) {
    for (var node in nodelist) {
      for (int i = 0; i < node.ports.length; i++) {
        node.ports[i].index = i;
        node.ports[i].nodeId = node.id;
      }
      nodes[node.id] = node;
    }

    print("addNodes");
    notifyListeners();
  }

  void removeNodeById(String nodeId) {
    nodes.remove(nodeId);

    final affectedLinkIds = links.entries
        .where(
          (linkentry) =>
              linkentry.value.inputPort.nodeId == nodeId ||
              linkentry.value.outputPort.nodeId == nodeId,
        )
        .map((entry) => entry.key)
        .toList();

    for (final id in affectedLinkIds) {
      removeLinkById(id);
    }

    print("removeNodeById");
    notifyListeners();
  }

  void clear() {
    nodes.clear();
    links.clear();
    notifyListeners();
  }

  //----------------

  Link? getLinkById(String id) => links[id];

  List<Link> getLinksForPort(Port port) {
    return links.values.where((link) {
      return link.inputPort.id == port.id || link.outputPort.id == port.id;
    }).toList();
  }

  Port? getLinkedPort(Port port) {
    for (final link in getLinksForPort(port)) {
      if (link.inputPort.id == port.id) return link.outputPort;
      if (link.outputPort.id == port.id) return link.inputPort;
    }
    return null;
  }

  void addLinks(List<Link> linklist) {
    for (var link in linklist) {
      if (link.inputPort.nodeId == link.outputPort.nodeId ||
          link.inputPort.runtimeType != link.outputPort.runtimeType) {
        continue;
      }

      // Remove existing link to this input port if it exists
      for (final existing in getLinksForPort(link.inputPort)) {
        links.remove(existing.id);
      }

      links[link.id] = link;
    }

    // print("addLinks");
    // notifyListeners();
  }

  void addLinksByPort(
    List<
      ({String nodeId1, int index1, String nodeId2, int index2, dynamic value})
    >
    linklist,
  ) {
    List<Link> l = [];
    for (var e in linklist) {
      final n1 = getNodeById(e.nodeId1);
      final n2 = getNodeById(e.nodeId2);
      final p1 = n1?.getPortById(e.index1);
      final p2 = n2?.getPortById(e.index2);

      p1?.value = e.value;
      p2?.value = e.value;

      if (p1 != null && p2 != null) {
        l.add(
          Link(inputPort: p1.input ? p1 : p2, outputPort: p1.input ? p2 : p1),
        );
      }
    }
    addLinks(l);
  }

  void updateLinkValue(String linkId, dynamic value) {
    final link = links[linkId];
    if (link != null) {
      link.inputPort.value = value;
      link.outputPort.value = value;
      print("updateLinkValue");
      notifyListeners();
    }
  }

  void updatePortValue(Port port, dynamic value) {
    port.value = value;
    for (final link in getLinksForPort(port)) {
      link.inputPort.value = value;
      link.outputPort.value = value;

      print("updatePortValue");
    }
    notifyListeners();
  }

  void removeLinkById(String id) {
    links.remove(id);
  }

  //----------------

  void updateNodePosition(String id, Offset pos) {
    if (nodes.containsKey(id)) {
      nodes[id]!.position = pos;
    }
  }

  void updateNodeRotation(String id, double rot) {
    nodes[id]?.rotation = rot;
  }

  void updateNodeSize(String id, Size size) {
    if (nodes.containsKey(id)) {
      nodes[id]!.size = size;
    }
  }

  //----------------

  void updateInteractiveZoom(double z) {
    izoom = z;
  }

  void updateInteractiveOffset(Offset off) {
    ioffset = off;
  }

  void updateActiveNode(String? id) {
    activeNodeId = id;
  }

  void notifyEditor() {
    print("notifyEditor");
    notifyListeners();
  }

  void updateKeyboardKey(LogicalKeyboardKey? key) {
    activeKey = key;
  }

  void removeTempLink() {
    tempLinkStartPort = null;
    tempLinkEndPos = null;
    print("removeTempLink");
    notifyListeners();
  }

  void interactiveAnimateTo(Offset sceneTarget, BuildContext context) {
    final zoom = interactiveController.value.getMaxScaleOnAxis();

    final size = MediaQuery.of(context).size;
    final screenCenter = size.center(Offset.zero);
    final dx = screenCenter.dx - sceneTarget.dx * zoom;
    final dy = screenCenter.dy - sceneTarget.dy * zoom;

    interactiveController.value = Matrix4.identity()
      ..translate(dx, dy)
      ..scale(zoom);
  }

  //----------------

  Offset getPortOffset(Port port) {
    final node = getNodeById(port.nodeId!)!;
    return node.ratioToGlobal(port.offsetRatio, zoneRadius);
  }

  Offset localToCanvasOffset(Offset localPos, BuildContext context) {
    final renderBox = context.findRenderObject() as RenderBox;
    final global = renderBox.localToGlobal(localPos - editorOffset / izoom);
    final matrixInverse = interactiveController.value.clone()..invert();
    return MatrixUtils.transformPoint(matrixInverse, global);
  }

  Offset globalToCanvas(Offset global) {
    return (global - editorOffset - ioffset) / izoom;
  }

  bool checkIfNodeVisible(Node node, {double padding = 100}) {
    // Viewport in scene space

    final sceneTopLeft = (Offset.zero - ioffset) / izoom;
    final sceneBottomRight = (editorSize - ioffset) / izoom;

    // Expand viewport with padding (converted to scene scale)
    final scenePadding = padding; // izoom;
    final viewport = Rect.fromPoints(
      sceneTopLeft,
      sceneBottomRight,
    ).inflate(scenePadding);

    final nodeRect = Rect.fromLTWH(
      node.position.dx,
      node.position.dy,
      node.size.width,
      node.size.height,
    );

    return nodeRect.overlaps(viewport);
  }

  List<Widget> renderNodes(BuildContext context) {
    List<Widget> visibleNodes = [];

    for (final entry in nodes.entries) {
      final node = entry.value;
      final isVisible = checkIfNodeVisible(node);
      if (isVisible) {
        visibleNodes.add(
          CustomNode(
            key: ValueKey(node.id),
            node: node,
            innerWidget: buildNodeWidget(context, node),
          ),
        );
      }
    }
    print("visibility : ${100 * visibleNodes.length / nodes.entries.length}%");
    return visibleNodes;
  }

  //------------

  // bool isInRegion(Offset center, Offset globalPos) {
  //   return (globalPos - center).distance < zoneRadius;
  // }

  bool isInRegion(Offset center, Offset globalPos) {
    final left = center.dx - zoneRadius;
    final right = center.dx + zoneRadius;
    final top = center.dy - zoneRadius;
    final bottom = center.dy + zoneRadius;

    return globalPos.dx >= left &&
        globalPos.dx < right &&
        globalPos.dy >= top &&
        globalPos.dy < bottom;
  }

  bool isInPort(Node node, Port port, Offset globalPos) {
    return (globalPos - node.ratioToGlobal(port.offsetRatio, zoneRadius))
            .distance <
        zoneRadius;
  }

  Offset topright(Node node) =>
      node.ratioToGlobal(offsetTopRightRatio, zoneRadius);
  Offset topcenter(Node node) =>
      node.ratioToGlobal(offsetTopCenterRatio, zoneRadius);
  Offset bottomright(Node node) =>
      node.ratioToGlobal(offsetBottomRightRatio, zoneRadius);
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

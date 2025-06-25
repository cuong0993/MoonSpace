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

class TypeRegistryEntry<T> {
  final Widget Function(BuildContext context, Node node) builder;
  final T Function(dynamic state) deserialize;
  final dynamic Function(T state) serialize;

  TypeRegistryEntry({
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

  Offset get center =>
      Offset(position.dx + size.width / 2, position.dy + size.height / 2);

  Map<String, dynamic> toJson(Map<String, TypeRegistryEntry> registry) {
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
    Map<String, TypeRegistryEntry> typeRegistry,
  ) {
    final type = json['type'];
    final registry = typeRegistry[type];

    final dynamic value = registry?.deserialize(json['value']);

    return Node(
      id: json['id'],
      type: registry != null ? type : '__error__',
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

  final Map<String, TypeRegistryEntry> typeRegistry;

  String? activeNodeId;

  Port? tempLinkStartPort;
  Offset? tempLinkEndPos;

  String? activeLinkId;

  LogicalKeyboardKey? activeKey;

  double izoom;
  Offset ioffset;
  double iinterval;
  int idivisions;

  Offset editorOffset;
  Offset editorSize;

  final LinkStyle linkStyle;

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
    Map<String, TypeRegistryEntry> typeRegistry,
  ) {
    final editor = EditorChangeNotifier(typeRegistry: typeRegistry);

    editor.izoom = json['izoom'];
    editor.ioffset = Offset(json['ioffset']['dx'], json['offset']['dy']);
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

    print("addLinks");
    notifyListeners();
  }

  void addLinksByPort(
    List<({String nodeId1, int index1, String nodeId2, int index2})> linklist,
  ) {
    List<Link> l = [];
    for (var e in linklist) {
      final n1 = getNodeById(e.nodeId1);
      final n2 = getNodeById(e.nodeId2);
      final p1 = n1?.getPortById(e.index1);
      final p2 = n2?.getPortById(e.index2);
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
      // print("updateNodePosition");
      notifyListeners();
    }
  }

  void updateNodeRotation(String id, double rot) {
    nodes[id]?.rotation = rot;
    // print("updateNodeRotation");
    // notifyListeners();
  }

  void updateNodeSize(String id, Size size) {
    if (nodes.containsKey(id)) {
      nodes[id]!.size = size;
      // print("updateNodeSize");
      notifyListeners();
    }
  }

  //----------------

  void updateInteractiveZoom(double z) {
    izoom = z;
    // notifyListeners();
  }

  void updateInteractiveOffset(Offset off) {
    ioffset = off;
    // notifyListeners();
  }

  void updateActiveNode(String? id) {
    activeNodeId = id;
    notifyListeners();
  }

  void notifyEditor() {
    notifyListeners();
  }

  void updateKeyboardKey(LogicalKeyboardKey? key) {
    activeKey = key;
    print("updateKeyboardKey");
    notifyListeners();
  }

  void updateTempLinkPosition(Offset pos, BuildContext context) {
    tempLinkEndPos = localToCanvasOffset(pos, context);
    print("updateTempLinkPosition");
    notifyListeners();
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
    final iPos = getNodeById(port.nodeId!)!.position;
    final iSize = getNodeById(port.nodeId!)!.size;
    final iRot = getNodeById(port.nodeId!)!.rotation;
    final iCenter = iPos + iSize.center(Offset.zero);
    final isx = iSize.width * port.offsetRatio.dx;
    final isy = iSize.height * port.offsetRatio.dy;
    final iOffset = Offset(isx, isy) - iSize.center(Offset.zero);
    final loc = rotateAroundCenter(iCenter + iOffset, iCenter, iRot);
    // return loc;
    return Offset(loc.dx, loc.dy + (port.offsetRatio.dy > .5 ? -8 : 8));
  }

  Offset localToCanvasOffset(Offset localPos, BuildContext context) {
    final renderBox = context.findRenderObject() as RenderBox;
    final global = renderBox.localToGlobal(localPos - editorOffset / izoom);
    final matrixInverse = interactiveController.value.clone()..invert();
    return MatrixUtils.transformPoint(matrixInverse, global);
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
    // print("visibility : ${100 * visibleNodes.length / nodes.entries.length}%");
    return visibleNodes;
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

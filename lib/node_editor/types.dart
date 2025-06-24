import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moonspace/node_editor/helper.dart';
import 'package:moonspace/node_editor/links.dart';

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

enum ActiveFunction { move, rotate, resize }

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
    this.zoom = 1.0,
    this.offset = Offset.zero,
    this.interval = 500,
    this.divisions = 4,

    this.left = 0,
    this.top = 0,
    this.width = 500,
    this.height = 500,

    //
    this.linkStyle = const LinkStyle(),
  });

  /// nodeid → Node
  final Map<String, Node> nodes = {};

  /// linkId → Link
  final Map<String, Link> links = {};

  final Map<String, TypeRegistryEntry> typeRegistry;

  String? activeNodeId;
  ActiveFunction? activeFunction;

  Port? tempLinkStartPort;
  Offset? tempLinkEndPos;

  String? activeLinkId;

  LogicalKeyboardKey? activeKey;

  double zoom;
  Offset offset;
  double interval;
  int divisions;

  double left;
  double top;
  double width;
  double height;

  final LinkStyle linkStyle;

  final TransformationController interactiveController =
      TransformationController();

  //----------------

  Map<String, dynamic> toMap() => {
    'zoom': zoom,
    'offset': {'dx': offset.dx, 'dy': offset.dy},
    'interval': interval,
    'divisions': divisions,

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

    editor.zoom = json['zoom'];
    editor.offset = Offset(json['offset']['dx'], json['offset']['dy']);
    editor.interval = json['interval'];
    editor.divisions = json['divisions'];

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
      notifyListeners();
    }
  }

  void updatePortValue(Port port, dynamic value) {
    port.value = value;
    for (final link in getLinksForPort(port)) {
      link.inputPort.value = value;
      link.outputPort.value = value;
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

  //----------------

  void updateInteractiveZoom(double z) {
    zoom = z;
    notifyListeners();
  }

  void updateInteractiveOffset(Offset off) {
    offset = off;
    notifyListeners();
  }

  void updateActiveFunction(String? id, ActiveFunction? function) {
    activeNodeId = id;
    activeFunction = function;
    notifyListeners();
  }

  void updateKeyboardKey(LogicalKeyboardKey? key) {
    activeKey = key;
    notifyListeners();
  }

  void updateTempLinkPosition(Offset pos, BuildContext context) {
    tempLinkEndPos = globalToCanvasOffset(pos - Offset(left, top), context);
    notifyListeners();
  }

  void removeTempLink() {
    tempLinkStartPort = null;
    tempLinkEndPos = null;
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
    return Offset(loc.dx, loc.dy + 4);
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

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moonspace/node_editor/helper.dart';
import 'package:moonspace/node_editor/links.dart';
import 'package:moonspace/node_editor/node.dart';

class Port<T> {
  final int index;
  final String nodeId;
  String? linkId;
  bool origin;

  /// (x : 0 to 1, y : 0 to 1)
  final Offset offsetRatio;

  T? value;

  Port({
    required this.index,
    required this.nodeId,
    this.linkId,
    this.origin = false,
    required this.offsetRatio,
    required this.value,
  });

  Map<String, dynamic> toMap() => {
    'index': index,
    'nodeId': nodeId,
    'linkId': linkId,
    'origin': origin,
    'offsetRatio': {'dx': offsetRatio.dx, 'dy': offsetRatio.dy},
    'value': value,
  };

  String get id => '${nodeId}_$index';

  factory Port.fromMap(Map<String, dynamic> json) => Port(
    index: json['index'],
    nodeId: json['nodeId'],
    linkId: json['linkId'],
    origin: json['origin'],
    offsetRatio: Offset(json['offsetRatio']['dx'], json['offsetRatio']['dy']),
    value: json['value'],
  );
}

enum ActiveFunction { move, rotate, resize }

class Link<T> {
  final Port inputPort;
  final Port outputPort;
  T? value;

  String get id => inputPort.origin
      ? "${inputPort.id}_${outputPort.id}"
      : "${outputPort.id}_${inputPort.id}";

  Link({required this.inputPort, required this.outputPort, this.value});

  Map<String, dynamic> toMap() => {
    'inputPort': inputPort.toMap(),
    'outputPort': outputPort.toMap(),
    'value': value,
  };

  factory Link.fromMap(Map<String, dynamic> json) => Link(
    inputPort: Port.fromMap(json['inputPort']),
    outputPort: Port.fromMap(json['outputPort']),
    value: json['value'],
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
  T value;
  List<Port> ports;

  Node({
    required this.id,
    required this.type,
    required this.position,
    required this.rotation,
    required this.size,
    required this.value,
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
}

class EditorChangeNotifier extends ChangeNotifier {
  EditorChangeNotifier({
    required this.typeRegistry,
    this.linkStyle = const LinkStyle(),

    //
    this.zoom = 1.0,
    this.offset = Offset.zero,
    this.interval = 500,
    this.divisions = 4,
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

  Offset? mousePosition;

  LogicalKeyboardKey? activeKey;

  double zoom;
  Offset offset;
  double interval;
  int divisions;

  final LinkStyle linkStyle;

  final TransformationController interactiveController =
      TransformationController();

  //----------------

  Map<String, dynamic> toMap() => {
    'zoom': zoom,
    'offset': {'dx': offset.dx, 'dy': offset.dy},
    'interval': interval,
    'divisions': divisions,
    'nodes': nodes.map(
      (key, value) => MapEntry(key, value.toJson(typeRegistry)),
    ),
    'links': links.values.map((link) => link.toMap()).toList(),
  };

  factory EditorChangeNotifier.fromMap(
    Map<String, dynamic> json,
    Map<String, TypeRegistryEntry<dynamic>> typeRegistry,
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

  //----

  Node? getNode(String id) => nodes[id];

  Link? getLinkById(String id) {
    return links[id];
  }

  List<Link> getLinksForNode(String nodeId) {
    return links.values
        .where(
          (link) =>
              link.inputPort.nodeId == nodeId ||
              link.outputPort.nodeId == nodeId,
        )
        .toList();
  }

  //----

  void addNodes(List<Node> nodelist) {
    for (var node in nodelist) {
      nodes[node.id] = node;
    }

    final List<Link> newLinks = [];
    for (var newnode in nodelist) {
      for (var anode in nodes.entries) {
        for (final inputPort in newnode.ports) {
          for (final outputPort in anode.value.ports) {
            //
            final link = checkLink(inputPort, outputPort);
            if (link != null) {
              newLinks.add(link);
            }
          }
        }
      }
    }
    addLinks(newLinks);

    notifyListeners();
  }

  Link? checkLink(Port<dynamic> inputPort, Port<dynamic> outputPort) {
    if (inputPort.linkId != null &&
        //
        inputPort.linkId == outputPort.linkId &&
        //
        inputPort.nodeId != outputPort.nodeId &&
        //
        !links.containsKey(outputPort.linkId) &&
        //
        inputPort.origin != outputPort.origin
    //
    ) {
      return Link(
        inputPort: inputPort.origin ? inputPort : outputPort,
        outputPort: inputPort.origin ? outputPort : inputPort,
        value: inputPort.value,
      );
    }

    return null;
  }

  void addLinks(List<Link> linklist) {
    for (var link in linklist) {
      if (link.inputPort.nodeId == link.outputPort.nodeId ||
          link.inputPort.value.runtimeType !=
              link.outputPort.value.runtimeType) {
        continue;
      }
      final ilinkid = link.inputPort.linkId;
      if (ilinkid != null) {
        removeLinkById(ilinkid);
      }
      final olinkid = link.outputPort.linkId;
      if (olinkid != null) {
        removeLinkById(olinkid);
      }

      links[link.id] = link;
      link.inputPort.linkId = link.id;
      link.outputPort.linkId = link.id;
      link.inputPort.origin = true;
      link.outputPort.origin = false;
    }

    notifyListeners();
  }

  void removeNodeById(String nodeId) {
    nodes.remove(nodeId);

    final affectedLinkIds = links.entries
        .where(
          (entry) =>
              entry.value.inputPort.nodeId == nodeId ||
              entry.value.outputPort.nodeId == nodeId,
        )
        .map((entry) => entry.key)
        .toList();

    for (final id in affectedLinkIds) {
      removeLinkById(id);
    }

    notifyListeners();
  }

  void removeLinkById(String id) {
    final link = links.remove(id);
    if (link != null) {
      link.inputPort.linkId = null;
      link.outputPort.linkId = null;
      link.inputPort.origin = false;
      link.outputPort.origin = false;
    }
  }

  //----

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

  //----

  void updateLinkValue(String linkId, dynamic value) {
    final link = links[linkId];
    if (link != null) {
      link.value = value;
      link.inputPort.value = value;
      link.outputPort.value = value;
      notifyListeners();
    }
  }

  void updatePortValue(Port port, dynamic value) {
    port.value = value;
    final link = links[port.linkId];
    if (link != null) {
      link.value = value;
      link.inputPort.value = value;
      link.outputPort.value = value;
    }
    notifyListeners();
  }

  Port? getLinkedPort(Port port) {
    if (port.linkId != null) {
      final link = getLinkById(port.linkId!);
      if (link != null) {
        return link.inputPort == port ? link.outputPort : link.inputPort;
      }
    }
    return null;
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
    tempLinkEndPos = globalToCanvasOffset(pos, context);
    notifyListeners();
  }

  void updateMousePosition(Offset? pos, BuildContext context) {
    mousePosition = pos == null ? null : globalToCanvasOffset(pos, context);
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

  Offset getPortOffset(Port<dynamic> port) {
    final iPos = getNode(port.nodeId)!.position;
    final iSize = getNode(port.nodeId)!.size + PortWidget.size;
    final iRot = getNode(port.nodeId)!.rotation;
    final iCenter = iPos + iSize.center(Offset.zero);
    final isx = iSize.width * port.offsetRatio.dx;
    final isy = iSize.height * port.offsetRatio.dy;
    final iOffset = Offset(isx, isy) - iSize.center(Offset.zero);
    final loc = rotateAroundCenter(iCenter + iOffset, iCenter, iRot);
    return loc;
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

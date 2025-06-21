import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

enum ActiveFunction { move, rotate, resize }

class LinkData<T> {
  final String id;
  final String? inputId;
  final String? outputId;
  T? value;
  final Widget? innerWidget;
  final Offset inputOffset;
  final Offset outputOffset;

  LinkData({
    required this.id,
    this.inputId,
    this.outputId,
    this.value,
    this.innerWidget,
    this.inputOffset = Offset.zero,
    this.outputOffset = Offset.zero,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'inputId': inputId,
    'outputId': outputId,
    'value': value,
    'inputOffset': {'dx': inputOffset.dx, 'dy': inputOffset.dy},
    'outputOffset': {'dx': outputOffset.dx, 'dy': outputOffset.dy},
  };

  factory LinkData.fromJson(Map<String, dynamic> json) => LinkData(
    id: json['id'],
    inputId: json['inputId'],
    outputId: json['outputId'],
    value: json['value'],
    inputOffset: Offset(json['inputOffset']['dx'], json['inputOffset']['dy']),
    outputOffset: Offset(
      json['outputOffset']['dx'],
      json['outputOffset']['dy'],
    ),
    innerWidget: null,
  );
}

class TypeRegistryEntry<T> {
  final Widget Function(BuildContext context, NodeData node) builder;
  final T Function(dynamic json) fromJson;
  final dynamic Function(T value) toJson;

  TypeRegistryEntry({
    required this.builder,
    required this.fromJson,
    required this.toJson,
  });
}

class NodeData<T> {
  final String id;
  final String type;
  Offset position;
  double rotation;
  Size size;
  Color backgroundColor;
  double borderRadius;
  T value;

  NodeData({
    required this.id,
    required this.type,
    required this.position,
    required this.rotation,
    required this.size,
    this.backgroundColor = const Color(0xFFFFFFFF),
    this.borderRadius = 12.0,
    required this.value,
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
    };
  }

  factory NodeData.fromJson(
    Map<String, dynamic> json,
    Map<String, TypeRegistryEntry> typeRegistry,
  ) {
    final type = json['type'];
    final registry = typeRegistry[type];

    final dynamic value = registry?.fromJson(json['value']);

    return NodeData(
      id: json['id'],
      type: registry != null ? type : '__error__',
      position: Offset(json['position']['dx'], json['position']['dy']),
      rotation: json['rotation'],
      size: Size(json['size']['width'], json['size']['height']),
      backgroundColor: Color(json['backgroundColor']),
      borderRadius: json['borderRadius'],
      value: value,
    );
  }
}

class EditorChangeNotifier extends ChangeNotifier {
  EditorChangeNotifier({required this.typeRegistry});

  final Map<String, NodeData> nodes = {};

  final Map<String, Set<String>> nodeLinkMap = {}; // nodeId → Set of link IDs
  final Map<String, LinkData> linkMap = {}; // linkId → LinkData
  final List<LinkData> links = [];

  final Map<String, TypeRegistryEntry> typeRegistry;

  String? activeNodeId;
  ActiveFunction? activeFunction;

  LogicalKeyboardKey? activeKey;

  double zoom = 1.0;
  Offset offset = Offset.zero;

  void updateZoom(double z) {
    zoom = z;
    notifyListeners();
  }

  void updateOffset(Offset o) {
    offset = o;
    notifyListeners();
  }

  void addNodes(List<NodeData> nodelist) {
    for (var node in nodelist) {
      nodes[node.id] = node;
    }
    notifyListeners();
  }

  void addLinks(List<LinkData> linklist) {
    for (var link in linklist) {
      links.add(link);
      linkMap[link.id] = link;

      void mapNode(String? nodeId) {
        if (nodeId == null) return;
        nodeLinkMap.putIfAbsent(nodeId, () => {}).add(link.id);
      }

      mapNode(link.inputId);
      mapNode(link.outputId);
    }

    notifyListeners();
  }

  NodeData? getNode(String id) => nodes[id];

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

  List<LinkData> getLinksForNode(String nodeId) {
    final ids = nodeLinkMap[nodeId] ?? {};
    return ids.map((id) => linkMap[id]!).toList();
  }

  LinkData? getLinkById(String id) {
    return linkMap[id];
  }

  void removeNode(NodeData node) {
    nodes.remove(node.id);

    // Collect affected link IDs
    final affectedLinkIds = linkMap.entries
        .where(
          (entry) =>
              entry.value.inputId == node.id || entry.value.outputId == node.id,
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

      unmapNode(link.inputId);
      unmapNode(link.outputId);
    }

    notifyListeners();
  }

  Offset getNodePosition(String id) => nodes[id]?.position ?? Offset.zero;
  double getNodeRotation(String id) => nodes[id]?.rotation ?? 0;
  Size getNodeSize(String id) => nodes[id]?.size ?? const Size(150, 80);

  Widget buildNodeWidget(BuildContext context, NodeData node) {
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
      (key, nodedata) =>
          MapEntry(key, NodeData.fromJson(nodedata, typeRegistry)),
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

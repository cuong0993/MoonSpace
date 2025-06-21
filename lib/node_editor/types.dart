import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

enum ActiveFunction { move, rotate, resize }

class PortData<T> {
  final String id;
  T? value;
  final Widget? innerWidget;
  final Offset offset;

  PortData({
    required this.id,
    this.value,
    this.innerWidget,
    this.offset = Offset.zero,
  });

  Map<String, dynamic> toJson() => {'id': id, 'value': value};

  factory PortData.fromJson(Map<String, dynamic> json) =>
      PortData(id: json['id'], value: json['value'], innerWidget: null);
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
  List<PortData> ports;

  NodeData({
    required this.id,
    required this.type,
    required this.position,
    required this.rotation,
    required this.size,
    this.backgroundColor = const Color(0xFFFFFFFF),
    this.borderRadius = 12.0,
    required this.value,
    this.ports = const [],
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
      ports:
          (json['ports'] as List<dynamic>?)
              ?.map((p) => PortData.fromJson(p))
              .toList() ??
          [],
    );
  }
}

class EditorChangeNotifier extends ChangeNotifier {
  EditorChangeNotifier({required this.typeRegistry});

  final Map<String, NodeData> nodes = {};
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
    for (var n in nodelist) {
      nodes[n.id] = n;
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

  void deleteNode(NodeData node) {
    nodes.remove(node.id);
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

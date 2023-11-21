//Casting is important
// ignore: unnecessary_cast
T? cast<T>(x) => x is T ? (x as T) : null;

// ignore: unnecessary_cast
T casti<T>(x, T v) => x is T ? (x as T) : v;

int? ci(dynamic x) => int.tryParse(x.toString());
int cii(dynamic x, int i) => int.tryParse(x.toString()) ?? i;
double? cd(dynamic x) => double.tryParse(x.toString());
double cdi(dynamic x, double d) => double.tryParse(x.toString()) ?? d;
DateTime? cdate(dynamic x) => DateTime.tryParse(x.toString());

List<Map<String, dynamic>> clm(List<dynamic>? obj) {
  try {
    return obj?.map<Map<String, dynamic>>((e) => e.toMap()).toList() ?? [];
  } catch (e) {
    // lava(e.toString());
    return obj?.map<Map<String, dynamic>>((e) => cast<Map<String, dynamic>>(e) ?? {}).toList() ?? [];
    // return [];
  }
}

List<T> clo<T>(List<dynamic>? obj, T Function(Map<String, dynamic>) fromMap) {
  try {
    return obj?.map<T>((x) => fromMap(x)).toList() ?? [];
  } catch (e) {
    // lava(e.toString());
    return [];
  }
}

List<T?> clc<T>(List<dynamic>? obj) {
  try {
    return obj?.map<T?>((x) => cast<T>(x)).toList() ?? [];
  } catch (e) {
    // lava(e.toString());
    return [];
  }
}

List<T> clci<T>(List<dynamic>? obj, T empty) {
  try {
    return obj?.map<T>((x) => casti<T>(x, empty)).toList() ?? [];
  } catch (e) {
    // lava(e.toString());
    return [];
  }
}

Map<String, dynamic> maptoJson(
  Map map, {
  bool removeNull = false,
  bool stringify = false,
  bool printType = false,
}) {
  return Map.fromEntries(
    map.entries.where((e) => removeNull ? (e.value != null) : true).map(
      (e) {
        return MapEntry(
          e.key,
          objToJson(e.value, stringify: stringify, printType: printType, removeNull: removeNull),
        );
      },
    ),
  );
}

/// Object : toString()
/// Map Object : toMap()
/// Primitive : int, String, double
/// Map
/// List
dynamic objToJson(
  dynamic obj, {
  bool stringify = false,
  bool printType = false,
  bool removeNull = false,
}) {
  if (obj is Map) {
    return maptoJson(obj, stringify: stringify, printType: printType, removeNull: removeNull);
  }

  if (obj is List) {
    return obj.map((o) => objToJson(o, stringify: stringify, printType: printType, removeNull: removeNull)).toList();
  }

  if (obj is DateTime) {
    return obj.toUtc().toString();
  }

  if (obj is int || obj is double || obj is String || obj == null) {
    if (printType) {
      return obj.runtimeType;
    }
    if (stringify) {
      return obj.toString();
    }
    return obj;
  }

  try {
    return maptoJson(obj.toMap(), stringify: stringify, printType: printType, removeNull: removeNull);
  } catch (exception) {
    // lava(exception.toString());
    return obj.toString();
  }
}

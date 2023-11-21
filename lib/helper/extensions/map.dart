extension ReduceMap on Map<String, dynamic> {
  Map<String, dynamic> reduce(List<String> newKeys) {
    Map<String, dynamic> newMap = {};
    for (var e in newKeys) {
      newMap.addEntries([MapEntry(e, this[e])]);
    }
    return newMap;
  }

  Map<String, dynamic> nameReduce(Map<String, dynamic> map) {
    Map<String, dynamic> newMap = {};
    for (var e in map.entries) {
      newMap.addEntries([MapEntry(e.key, e.value)]);
    }
    return newMap;
  }

  Map<String, dynamic> removeNull() {
    Map<String, dynamic> newMap = {};
    for (var e in entries) {
      if (e.value != null) {
        newMap.addEntries([MapEntry(e.key, e.value)]);
      }
    }
    return newMap;
  }
}

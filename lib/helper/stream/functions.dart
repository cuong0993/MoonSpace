import 'dart:async';

import 'package:rxdart/rxdart.dart';

StreamController<T> createDebounceFunc<T>(int milli, void Function(T value) function) {
  return StreamController<T>.broadcast()
    ..stream.debounceTime(Duration(milliseconds: milli)).listen(
      (event) async {
        function(event);
      },
    );
}

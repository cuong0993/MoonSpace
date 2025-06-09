import 'dart:async';

StreamController<T> createDebounceFunc<T>(
  int milli,
  void Function(T value) function,
) {
  final controller = StreamController<T>.broadcast();
  Timer? debounceTimer;

  controller.stream.listen((event) {
    debounceTimer?.cancel();
    debounceTimer = Timer(Duration(milliseconds: milli), () {
      function(event);
    });
  });

  controller.onCancel = () {
    debounceTimer?.cancel();
  };

  return controller;
}

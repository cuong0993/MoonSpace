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

StreamController<T> createThrottleDebounceFunc<T>(
  int milli,
  void Function(T value) function, {
  bool leading = true,
}) {
  final controller = StreamController<T>.broadcast();
  Timer? throttleTimer;
  bool canCall = true;
  T? lastEvent;

  void scheduleCall() {
    if (canCall && leading) {
      canCall = false;
      function(lastEvent as T);

      throttleTimer = Timer(Duration(milliseconds: milli), () {
        canCall = true;
        if (!leading && lastEvent != null) {
          scheduleCall(); // trailing edge call
          lastEvent = null;
        }
      });
    } else if (!leading && canCall) {
      canCall = false;

      throttleTimer = Timer(Duration(milliseconds: milli), () {
        if (lastEvent != null) {
          function(lastEvent as T);
          lastEvent = null;
        }
        canCall = true;
      });
    }
  }

  controller.stream.listen((event) {
    lastEvent = event;
    scheduleCall();
  });

  controller.onCancel = () {
    throttleTimer?.cancel();
  };

  return controller;
}

import 'dart:math';

extension SuperList<T> on List<T> {
  T getHashOne(Object obj) {
    return this[obj.hashCode % length];
  }

  T getAnyOne() {
    return this[Random().nextInt(length)];
  }
}

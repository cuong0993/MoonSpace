import 'dart:ui';

import 'package:example/flutter_custom_carousel/views/views.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const CarouselApp());
}

class CarouselApp extends StatelessWidget {
  const CarouselApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Enable scrolling on desktop via mouse drag for the whole app.
      // This can be applied to specific carousels via `CustomCarousel.scrollBehavior`.
      scrollBehavior: AppScrollBehavior(),
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF151530),
      ),
      home: const HomeView(),
      // home: const HomeView(),
    );
  }
}

// Create a subclass of ScrollBehavior that enables scrolling via mouse drag.
class AppScrollBehavior extends ScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices {
    final devices = Set<PointerDeviceKind>.from(super.dragDevices);
    devices.add(PointerDeviceKind.mouse);
    return devices;
  }
}

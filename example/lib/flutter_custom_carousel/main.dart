import 'package:example/flutter_custom_carousel/views/views.dart';
import 'package:flutter/material.dart';
import 'package:moonspace/controller/app_scroll_behavior.dart';

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

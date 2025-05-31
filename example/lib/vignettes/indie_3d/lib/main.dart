import 'package:flutter/material.dart';
import 'package:example/vignettes/_shared/env.dart';
import 'package:moonspace/controller/app_scroll_behavior.dart';

import './demo.dart';

void main() => runApp(Indie3D());

class Indie3D extends StatelessWidget {
  static String _pkg = 'indie_3d';

  const Indie3D({super.key});
  static String? get pkg => Env.getPackage(_pkg);
  static String get bundle => Env.getBundle(_pkg);

  @override
  Widget build(context) {
    return MaterialApp(
      scrollBehavior: AppScrollBehavior(),
      debugShowCheckedModeBanner: false,
      home: Indie3dHome(),
    );
  }
}

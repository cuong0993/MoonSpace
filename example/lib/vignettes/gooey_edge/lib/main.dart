import 'package:flutter/material.dart';
import 'package:example/vignettes/_shared/env.dart';
import 'package:moonspace/controller/app_scroll_behavior.dart';
import 'demo.dart';

void main() => runApp(GooeyEdgeApp());

class GooeyEdgeApp extends StatelessWidget {
  static String _pkg = "gooey_edge";
  static String? get pkg => Env.getPackage(_pkg);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: AppScrollBehavior(),
      debugShowCheckedModeBanner: false,
      home: GooeyEdgeDemo(title: 'Gooey Edge Demo'),
    );
  }
}

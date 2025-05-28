import 'package:flutter/material.dart';
import 'package:example/vignettes/_shared/env.dart';
import 'package:example/vignettes/_shared/ui/app_scroll_behavior.dart';
import './demo.dart';

void main() => runApp(DarkInkTransition());

class DarkInkTransition extends StatelessWidget {
  static String _pkg = "dark_ink_transition";
  static String? get pkg => Env.getPackage(_pkg);

  @override
  Widget build(context) {
    return MaterialApp(
      scrollBehavior: AppScrollBehavior(),
      debugShowCheckedModeBanner: false,
      home: DarkInkDemo(),
    );
  }
}

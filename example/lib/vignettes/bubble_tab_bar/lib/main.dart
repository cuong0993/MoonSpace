import 'package:flutter/material.dart';
import 'package:example/vignettes/_shared/env.dart';
import 'package:example/vignettes/_shared/ui/app_scroll_behavior.dart';
import 'demo.dart';

void main() => runApp(BubbleTabBar());

class BubbleTabBar extends StatelessWidget {
  static String _pkg = "bubble_tab_bar";
  static String? get pkg => Env.getPackage(_pkg);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: AppScrollBehavior(),
      debugShowCheckedModeBanner: false,
      home: BubbleTabBarDemo(),
    );
  }
}

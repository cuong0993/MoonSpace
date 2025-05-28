import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:example/vignettes/_shared/env.dart';
import 'package:example/vignettes/_shared/ui/app_scroll_behavior.dart';

import 'demo.dart';

void main() => runApp(ParallaxTravelcardsHero());

class ParallaxTravelcardsHero extends StatelessWidget {
  static String _pkg = "parallax_travel_cards_hero";
  static String? get pkg => Env.getPackage(_pkg);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      scrollBehavior: AppScrollBehavior(),
      debugShowCheckedModeBanner: false,
      title: 'Hero Travel Card',
      theme: ThemeData(brightness: Brightness.light),
      home: HeroCardDemo(),
    );
  }
}

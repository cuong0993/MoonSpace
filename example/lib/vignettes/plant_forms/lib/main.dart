import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:example/vignettes/_shared/env.dart';
import 'package:example/vignettes/_shared/ui/app_scroll_behavior.dart';

import 'demo.dart';

void main() => runApp(PlantForms());

class PlantForms extends StatelessWidget {
  static String _pkg = "plant_forms";
  static String? get pkg => Env.getPackage(_pkg);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarBrightness: Brightness.light),
    );
    return MaterialApp(
      scrollBehavior: AppScrollBehavior(),
      debugShowCheckedModeBanner: false,
      title: 'Plant Forms',
      home: PlantFormsDemo(),
    );
  }
}

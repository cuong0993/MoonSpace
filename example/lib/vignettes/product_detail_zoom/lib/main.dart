import 'package:flutter/material.dart';
import 'package:example/vignettes/_shared/env.dart';
import 'package:moonspace/controller/app_scroll_behavior.dart';

import 'demo.dart';

void main() => runApp(ProductDetailZoom());

class ProductDetailZoom extends StatelessWidget {
  static String _pkg = "product_detail_zoom";

  static String? get pkg => Env.getPackage(_pkg);

  @override
  Widget build(BuildContext context) {
    const title = '3D Product Detail Zoom';
    return MaterialApp(
      scrollBehavior: AppScrollBehavior(),
      debugShowCheckedModeBanner: false,
      title: title,
      themeMode: ThemeMode.dark,
      home: ProductDetailZoomDemo(),
    );
  }
}

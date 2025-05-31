import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'styles/app_themes.dart';
import 'models/recipe.dart';
import 'models/recipes_data.dart';
import 'widgets/recipes_page.dart';

void main() {
  runApp(const ProviderScope(child: RecipesApp()));
}

class RecipesApp extends StatefulWidget {
  const RecipesApp({super.key});

  @override
  State<RecipesApp> createState() => _RecipesAppState();
}

class _RecipesAppState extends State<RecipesApp> {
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      for (Recipe menuItem in RecipesData.dessertMenu) {
        precacheImage(Image.asset(menuItem.image).image, context);
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    return MaterialApp(
      title: 'Recipes UI Demo',
      debugShowCheckedModeBanner: false,
      theme: AppThemes.main(),
      home: const RecipesPage(),
    );
  }
}

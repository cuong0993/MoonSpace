import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:example/vignettes/particle_swipe/lib/components/particle_app_bar.dart';
import 'package:example/vignettes/_shared/env.dart';

import 'demo.dart';
import 'package:moonspace/controller/app_scroll_behavior.dart';

class ParticleSwipe extends StatelessWidget {
  static String _pkg = "particle_swipe";

  const ParticleSwipe({super.key});

  static String? get pkg => Env.getPackage(_pkg);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
    );
    final theme = ThemeData(
      brightness: Brightness.dark,
      canvasColor: Color(0xFF161719),
      textTheme: Theme.of(
        context,
      ).textTheme.apply(bodyColor: Colors.white, fontFamily: 'OpenSans'),
      iconTheme: Theme.of(context).iconTheme.copyWith(color: Colors.white),
    );
    return MaterialApp(
      title: 'Particle Swipe',
      scrollBehavior: AppScrollBehavior(),
      debugShowCheckedModeBanner: false,
      theme: theme.copyWith(
        colorScheme: theme.colorScheme.copyWith(secondary: Color(0xffc932d9)),
      ),
      home: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              ParticleAppBar(),
              Flexible(child: ParticleSwipeDemo()),
            ],
          ),
        ),
      ),
    );
  }
}

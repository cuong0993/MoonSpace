import 'package:example/animated/animated_dialog.dart';
import 'package:example/animated/animated_list_scale.dart';
import 'package:example/animated/animated_stack_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(home: HomePage()));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Animated')),
      body: ListView(
        children: [
          PageTile(
            title: "AnimatedDialog",
            builder: (animation) => AnimatedDialog(animation: animation),
          ),
          PageTile(
            title: "Animated Stack Page",
            builder: (animation) => AnimatedLogoPage(animation: animation),
          ),
          PageTile(
            title: "AnimatedListScale",
            builder: (animation) => AnimatedListScale(),
          ),
        ],
      ),
    );
  }
}

class PageTile extends StatelessWidget {
  const PageTile({super.key, required this.title, required this.builder});

  final String title;
  final Widget Function(Animation<double> animation) builder;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      onTap: () {
        Navigator.of(context).push(
          PageRouteBuilder(
            transitionDuration: const Duration(seconds: 1),
            pageBuilder: (context, animation, secondaryAnimation) {
              return builder(animation);
            },
            transitionsBuilder: (context, animation, _, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        );
      },
    );
  }
}

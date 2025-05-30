import 'package:example/animated/animated_dialog.dart';
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
        children: [AnimatedDialogListTile(), AnimatedStackPageListTile()],
      ),
    );
  }
}

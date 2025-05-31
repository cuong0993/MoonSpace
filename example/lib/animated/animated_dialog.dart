import 'package:flutter/material.dart';

class AnimatedDialog extends StatelessWidget {
  final Animation<double> animation;

  const AnimatedDialog({super.key, required this.animation});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.white,
        elevation: 20,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 300,
          height: 300,
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RotationTransition(
                turns: Tween<double>(begin: 0.5, end: 1.0).animate(
                  CurvedAnimation(parent: animation, curve: Curves.easeOut),
                ),
                child: const FlutterLogo(size: 80),
              ),
              const SizedBox(height: 20),
              const Text("Animated Dialog with Rotating Logo"),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Close"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

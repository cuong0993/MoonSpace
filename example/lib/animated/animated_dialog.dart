import 'package:flutter/material.dart';

class AnimatedDialogListTile extends StatelessWidget {
  const AnimatedDialogListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text("Show Animated Dialog"),
      onTap: () {
        Navigator.of(context).push(
          PageRouteBuilder(
            opaque: false, // To allow background blur or transparency
            pageBuilder: (context, animation, secondaryAnimation) {
              return AnimatedDialog(animation: animation);
            },
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  // Fade and scale transition
                  return FadeTransition(
                    opacity: animation,
                    child: ScaleTransition(scale: animation, child: child),
                  );
                },
          ),
        );
      },
    );
  }
}

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

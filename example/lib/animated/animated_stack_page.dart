import 'package:flutter/material.dart';

class AnimatedLogoPage extends StatelessWidget {
  final Animation<double> animation;

  const AnimatedLogoPage({super.key, required this.animation});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          // Calculate dynamic position and scale
          final sizeTween = Tween<double>(begin: 100.0, end: 40.0);
          final topTween = Tween<double>(
            begin: MediaQuery.of(context).size.height / 2 - 50,
            end: 100.0,
          );
          final leftTween = Tween<double>(
            begin: MediaQuery.of(context).size.width / 2 - 50,
            end: 30.0,
          );

          final logoSize = sizeTween.evaluate(animation);
          final top = topTween.evaluate(animation);
          final left = leftTween.evaluate(animation);

          return Stack(
            children: [
              Positioned(
                top: top,
                left: left,
                child: Transform.scale(
                  scale: logoSize / 100,
                  child: const FlutterLogo(size: 100),
                ),
              ),
              Positioned.fill(
                top: top + logoSize + 20,
                child: Opacity(
                  opacity: animation.value,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const [
                      SizedBox(height: 140),
                      Text(
                        'Welcome!',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40),
                        child: Text(
                          'This is the animated transition page with a logo that moves into position above the title.',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 40,
                left: 10,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

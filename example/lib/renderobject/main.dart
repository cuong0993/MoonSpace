import 'package:flutter/material.dart';
import 'package:example/renderobject/animatedbox.dart';
import 'package:example/renderobject/mycolumn.dart';
import 'package:example/renderobject/myrow.dart';
import 'package:example/renderobject/redbox.dart';
import 'package:example/renderobject/rendercircle.dart';

class RenderHome extends StatelessWidget {
  const RenderHome({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            RedBox(),

            MyRow(
              children: [
                ColoredBox(
                  color: Color(0xFF2196F3),
                  child: SizedBox(width: 50, height: 50),
                ),
                CircleBox(color: Colors.orange, diameter: 40),
                ColoredBox(
                  color: Color(0xFF4CAF50),
                  child: SizedBox(width: 70, height: 30),
                ),
                ColoredBox(
                  color: Color(0xFFFF9800),
                  child: SizedBox(width: 40, height: 40),
                ),
              ],
            ),

            AnimatedBoxDemo(),

            Expanded(
              child: MyColumn(
                alignment: MyMainAxisAlignment.spaceAround,
                spacing: 20,
                children: [
                  ColoredBox(
                    color: Color(0xFF673AB7),
                    child: SizedBox(width: 100, height: 40),
                  ),
                  ColoredBox(
                    color: Color(0xFFE91E63),
                    child: SizedBox(width: 80, height: 60),
                  ),
                  ColoredBox(
                    color: Color(0xFF03A9F4),
                    child: SizedBox(width: 120, height: 30),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AnimatedBoxDemo extends StatefulWidget {
  const AnimatedBoxDemo({super.key});
  @override
  State<AnimatedBoxDemo> createState() => _AnimatedBoxDemoState();
}

class _AnimatedBoxDemoState extends State<AnimatedBoxDemo> {
  bool big = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() => big = !big);
      },
      child: Center(
        child: AnimatedBox(
          width: big ? 200 : 100,
          height: big ? 200 : 100,
          duration: Duration(seconds: 1),
          color: big ? Colors.red : Colors.blue,
        ),
      ),
    );
  }
}

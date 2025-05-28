import 'package:flutter/material.dart';
import '../data.dart';
import '../widgets/card_content.dart';
import '../src/widgets/cool_swiper.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: CoolSwiper(
            children: List.generate(
              Data.colors.length,
              (index) => CardContent(color: Data.colors[index]),
            ),
          ),
        ),
      ),
    );
  }
}

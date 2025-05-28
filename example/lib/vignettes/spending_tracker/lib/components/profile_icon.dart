import 'package:flutter/material.dart';
import 'package:example/vignettes/spending_tracker/lib/main.dart';

class ProfileIcon extends StatelessWidget {
  @override
  Widget build(context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Image.asset('images/headshot.png', package: SpendingTracker.pkg),
    );
  }
}

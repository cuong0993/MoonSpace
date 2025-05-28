import 'package:flutter/material.dart';
import 'package:example/vignettes/_shared/env.dart';
import 'demo.dart';
import 'package:example/vignettes/_shared/ui/app_scroll_behavior.dart';

void main() => runApp(DrinkRewardList());

class DrinkRewardList extends StatelessWidget {
  static String _pkg = "drink_rewards_list";
  static String? get pkg => Env.getPackage(_pkg);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: AppScrollBehavior(),
      debugShowCheckedModeBanner: false,
      home: SafeArea(child: DrinkRewardsListDemo()),
    );
  }
}

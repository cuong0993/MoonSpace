import 'dart:math';

import 'package:flutter/material.dart';
import 'package:example/vignettes/_shared/env.dart';
import 'package:moonspace/controller/app_scroll_behavior.dart';

import 'drink_card.dart';

void main() => runApp(DrinkRewardList());

class DrinkRewardList extends StatelessWidget {
  static final String _pkg = "drink_rewards_list";

  const DrinkRewardList({super.key});
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

class DrinkRewardsListDemo extends StatefulWidget {
  const DrinkRewardsListDemo({super.key});

  @override
  _DrinkRewardsListDemoState createState() => _DrinkRewardsListDemoState();
}

class _DrinkRewardsListDemoState extends State<DrinkRewardsListDemo> {
  static final _demoData = DemoData();
  final double _listPadding = 20;
  DrinkData? _selectedDrink;
  final ScrollController _scrollController = ScrollController();
  final List<DrinkData> _drinks = _demoData.drinks;
  final int _earnedPoints = _demoData.earnedPoints;

  void _handleDrinkTapped(DrinkData data) {
    setState(() {
      //If the same drink was tapped twice, un-select it
      if (_selectedDrink == data) {
        _selectedDrink = null;
      }
      //Open tapped drink card and scroll to it
      else {
        _selectedDrink = data;
        var selectedIndex = _drinks.indexOf(data);
        var closedHeight = DrinkListCard.nominalHeightClosed;
        //Calculate scrollTo offset, subtract a bit so we don't end up perfectly at the top
        var offset =
            selectedIndex * (closedHeight + _listPadding) - closedHeight * .35;
        _scrollController.animateTo(
          offset,
          duration: Duration(milliseconds: 700),
          curve: Curves.easeOutQuad,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff22222b),
      body: Theme(
        data: ThemeData(fontFamily: "Poppins", primarySwatch: Colors.orange),
        child: ListView.builder(
          itemCount: _drinks.length,
          scrollDirection: Axis.vertical,
          controller: _scrollController,
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.symmetric(
                vertical: _listPadding / 2,
                horizontal: _listPadding,
              ),
              child: DrinkListCard(
                earnedPoints: _earnedPoints,
                drinkData: _drinks[index],
                isOpen: _drinks[index] == _selectedDrink,
                onTap: _handleDrinkTapped,
              ),
            );
          },
        ),
      ),
    );
  }
}

class DrinkData {
  final String title;
  final int requiredPoints;
  final String iconImage;

  DrinkData(this.title, this.requiredPoints, this.iconImage);
}

class DemoData {
  int earnedPoints = 150;

  List<DrinkData> drinks = [
    DrinkData("Coffee", 100, "Coffee.png"),
    DrinkData("Tea", 150, "Tea.png"),
    DrinkData("Latte", 250, "Latte.png"),
    DrinkData("Frappuccino", 350, "Frappuccino.png"),
    DrinkData("Pressed Juice", 450, "Juice.png"),
  ];
}

class AppColors {
  static Color orangeAccent = Color(0xfff1a35d);
  static Color orangeAccentLight = Color(0xffff7f33);
  static Color redAccent = Color(0xfff1a35d);
  static Color grey = Color(0xff4d4d4d);
}

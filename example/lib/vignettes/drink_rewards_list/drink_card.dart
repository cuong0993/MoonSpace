import 'dart:math';
import 'package:flutter/material.dart';

import 'main.dart';
import 'liquid_painter.dart';

class DrinkListCard extends StatefulWidget {
  static double nominalHeightClosed = 96;
  static double nominalHeightOpen = 290;

  final void Function(DrinkData)? onTap;

  final bool isOpen;
  final DrinkData drinkData;
  final int earnedPoints;

  const DrinkListCard({
    super.key,
    required this.drinkData,
    this.onTap,
    this.isOpen = false,
    this.earnedPoints = 100,
  });

  @override
  _DrinkListCardState createState() => _DrinkListCardState();
}

class _DrinkListCardState extends State<DrinkListCard>
    with TickerProviderStateMixin {
  late bool _wasOpen;
  late Animation<double> _fillTween;
  late AnimationController _liquidSimController;

  //Create 2 simulations, that will be passed to the LiquidPainter to be drawn.
  final LiquidSimulation _liquidSim1 = LiquidSimulation();
  final LiquidSimulation _liquidSim2 = LiquidSimulation();

  @override
  void initState() {
    _wasOpen = widget.isOpen;
    //Create a controller to drive the "fill" animations
    _liquidSimController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 3000),
    );
    _liquidSimController.addListener(_rebuildIfOpen);
    //create tween to raise the fill level of the card
    _fillTween = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _liquidSimController,
        curve: Interval(.12, .45, curve: Curves.easeOut),
      ),
    );
    super.initState();
  }

  @override
  void dispose() {
    _liquidSimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //If our open state has changed...
    if (widget.isOpen != _wasOpen) {
      //Kickoff the fill animations if we're opening up
      if (widget.isOpen) {
        //Start both of the liquid simulations, they will initialize to random values
        _liquidSim1.start(_liquidSimController, true);
        _liquidSim2.start(_liquidSimController, false);
        //Run the animation controller, kicking off all tweens
        _liquidSimController.forward(from: 0);
      }
      _wasOpen = widget.isOpen;
    }

    //Determine the points required text value, using the _pointsTween
    //Determine current fill level, based on _fillTween
    double maxFillLevel = min(
      1,
      widget.earnedPoints / widget.drinkData.requiredPoints,
    );
    double fillLevel = maxFillLevel; //_maxFillLevel * _fillTween.value;
    double cardHeight = widget.isOpen
        ? DrinkListCard.nominalHeightOpen
        : DrinkListCard.nominalHeightClosed;

    return GestureDetector(
      onTap: _handleTap,
      //Use an animated container so we can easily animate our widget height
      child: AnimatedContainer(
        curve: !_wasOpen ? ElasticOutCurve(.9) : Curves.elasticOut,
        duration: Duration(milliseconds: !_wasOpen ? 1200 : 1500),
        height: cardHeight,
        //Wrap content in a rounded shadow widget, so it will be rounded on the corners but also have a drop shadow
        child: ClipRRect(
          child: Container(
            color: Color(0xff303238),
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                //Background liquid layer
                AnimatedOpacity(
                  opacity: widget.isOpen ? 1 : 0,
                  duration: Duration(milliseconds: 500),
                  child: Transform.translate(
                    offset: Offset(
                      0,
                      DrinkListCard.nominalHeightOpen * 1.2 -
                          DrinkListCard.nominalHeightOpen *
                              _fillTween.value *
                              maxFillLevel *
                              1.2,
                    ),
                    child: CustomPaint(
                      painter: LiquidPainter(
                        fillLevel,
                        _liquidSim1,
                        _liquidSim2,
                        waveHeight: 100,
                      ),
                    ),
                  ),
                ),

                //Card Content
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 24, vertical: 0),
                  //Wrap content in a ScrollView, so there's no errors on over scroll.
                  child: SingleChildScrollView(
                    //We don't actually want the scrollview to scroll, disable it.
                    physics: NeverScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        AnimatedOpacity(
                          duration: Duration(
                            milliseconds: widget.isOpen ? 1000 : 500,
                          ),
                          curve: Curves.easeOut,
                          opacity: widget.isOpen ? 1 : 0,
                          //Bottom Content
                          child: Text("Hello"),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleTap() {
    if (widget.onTap != null) {
      widget.onTap?.call(widget.drinkData);
    }
  }

  void _rebuildIfOpen() {
    if (widget.isOpen) {
      setState(() {});
    }
  }
}

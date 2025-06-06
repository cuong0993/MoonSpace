import 'dart:math';

import 'package:example/vignettes/_shared/ui/placeholder/placeholder_card_short.dart';
import 'package:example/vignettes/_shared/ui/placeholder/placeholder_card_tall.dart';
import 'package:example/vignettes/_shared/ui/placeholder/placeholder_image.dart';
import 'package:example/vignettes/_shared/ui/placeholder/placeholder_image_with_text.dart';
import 'package:example/vignettes/bubble_tab_bar/navbar.dart';
import 'package:flutter/material.dart';
import 'package:example/vignettes/_shared/env.dart';
import 'package:moonspace/controller/app_scroll_behavior.dart';

void main() => runApp(BubbleTabBar());

class BubbleTabBar extends StatelessWidget {
  static String _pkg = "bubble_tab_bar";

  const BubbleTabBar({super.key});
  static String? get pkg => Env.getPackage(_pkg);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: AppScrollBehavior(),
      debugShowCheckedModeBanner: false,
      home: BubbleTabBarDemo(),
    );
  }
}

class BubbleTabBarDemo extends StatefulWidget {
  const BubbleTabBarDemo({super.key});

  @override
  _BubbleTabBarDemoState createState() => _BubbleTabBarDemoState();
}

class _BubbleTabBarDemoState extends State<BubbleTabBarDemo> {
  List<NavBarItemData> _navBarItems = [];
  int _selectedNavIndex = 0;

  List<Widget> _viewsByIndex = [];

  @override
  void initState() {
    //Declare some buttons for our tab bar
    _navBarItems = [
      NavBarItemData("Home", Icons.home, 110, Color(0xff01b87d)),
      NavBarItemData("Gallery", Icons.image, 110, Color(0xff594ccf)),
      NavBarItemData("Likes", Icons.border_all, 100, Color(0xffcf4c7a)),
      NavBarItemData("Saved", Icons.save, 105, Color(0xfff2873f)),
    ];

    //Create the views which will be mapped to the indices for our nav btns
    _viewsByIndex = <Widget>[
      HomePage(),
      GalleryPage(),
      LikesPage(),
      SavePage(),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var accentColor = _navBarItems[_selectedNavIndex].selectedColor;

    //Create custom navBar, pass in a list of buttons, and listen for tap event
    var navBar = NavBar(
      items: _navBarItems,
      itemTapped: _handleNavBtnTapped,
      currentIndex: _selectedNavIndex,
    );

    //Display the correct child view for the current index
    var contentView =
        _viewsByIndex[min(_selectedNavIndex, _viewsByIndex.length - 1)];

    //Wrap our custom navbar + contentView with the app Scaffold
    return Scaffold(
      backgroundColor: Color(0xffE6E6E6),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          //Wrap the current page in an AnimatedSwitcher for an easy cross-fade effect
          child: AnimatedSwitcher(
            duration: Duration(milliseconds: 350),
            //Pass the current accent color down as a theme, so our overscroll indicator matches the btn color
            child: Theme(
              data: ThemeData(
                colorScheme: Theme.of(
                  context,
                ).colorScheme.copyWith(secondary: accentColor),
              ),
              child: contentView,
            ),
          ),
        ),
      ),
      bottomNavigationBar: navBar, //Pass our custom navBar into the scaffold
    );
  }

  void _handleNavBtnTapped(int index) {
    //Save the new index and trigger a rebuild
    setState(() {
      //This will be passed into the NavBar and change it's selected state, also controls the active content page
      _selectedNavIndex = index;
    });
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 9,
      itemBuilder: (content, index) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: PlaceholderCardTall(height: 200),
        );
      },
    );
  }
}

class GalleryPage extends StatelessWidget {
  const GalleryPage({super.key});

  @override
  Widget build(BuildContext context) {
    bool isLandscape = MediaQuery.of(context).size.aspectRatio > 1;
    var columnCount = isLandscape ? 4 : 2;

    return GridView.count(
      crossAxisCount: columnCount,
      children: List.generate(20, (index) {
        return PlaceholderImage();
      }),
    );
  }
}

class LikesPage extends StatelessWidget {
  const LikesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 9,
      itemBuilder: (content, index) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          child: PlaceholderCardShort(),
        );
      },
    );
  }
}

class SavePage extends StatelessWidget {
  const SavePage({super.key});

  @override
  Widget build(BuildContext context) {
    bool isLandscape = MediaQuery.of(context).size.aspectRatio > 1;
    var columnCount = isLandscape ? 3 : 2;

    return GridView.count(
      crossAxisCount: columnCount,
      children: List.generate(20, (index) {
        return PlaceholderImageWithText();
      }),
    );
  }
}

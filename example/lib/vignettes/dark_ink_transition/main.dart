import 'package:flutter/material.dart';
import 'package:example/vignettes/_shared/env.dart';
import 'package:moonspace/controller/app_scroll_behavior.dart';

import 'dark_ink_bar.dart';
import 'dark_ink_content.dart';
import 'dark_ink_controls.dart';
import 'package:moonspace/controller/sync_scroll_controller.dart';
import 'package:moonspace/ui/mask_transition_container.dart';

void main() => runApp(DarkInkTransition());

class DarkInkTransition extends StatelessWidget {
  static final String _pkg = "dark_ink_transition";

  const DarkInkTransition({super.key});
  static String? get pkg => Env.getPackage(_pkg);

  @override
  Widget build(context) {
    return MaterialApp(
      scrollBehavior: AppScrollBehavior(),
      debugShowCheckedModeBanner: false,
      home: DarkInkDemo(),
    );
  }
}

class DarkInkDemo extends StatefulWidget {
  const DarkInkDemo({super.key});

  @override
  State createState() => _DarkInkDemoState();
}

class _DarkInkDemoState extends State<DarkInkDemo> {
  final ValueNotifier<bool> _darkModeValue = ValueNotifier<bool>(false);
  final ScrollController _scrollController = SyncScrollController();

  @override
  void initState() {
    _darkModeValue.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _darkModeValue.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(context) {
    //Wrap the entire demo is a gestureDetector, just to more easily show off the darkMode transition.
    return GestureDetector(
      onTap: () {
        _darkModeValue.value = !_darkModeValue.value;
      },
      // Build a simple scaffold that shows the top bar and controls over the content
      child: Stack(
        children: [
          MaskTransitionContainer(
            maskimage: AssetImage(
              'assets/images/ink_mask.png',
              package: DarkInkTransition.pkg,
            ),
            frameWidth: 360,
            frameHeight: 720,
            child: DarkInkContent(
              darkMode: _darkModeValue.value,
              scrollController: _scrollController,
            ),
          ),

          DarkInkBar(darkModeValue: _darkModeValue),

          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: DarkInkControls(darkModeValue: _darkModeValue),
            ),
          ),
        ],
      ),
    );
  }
}

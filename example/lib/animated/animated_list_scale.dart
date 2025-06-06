import 'package:flutter/material.dart';

class AnimatedListScale extends StatelessWidget {
  const AnimatedListScale({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const Scaffold(
        body: SafeArea(bottom: false, child: AnimatedListView()),
      ),
    );
  }
}

class AnimatedListView extends StatelessWidget {
  const AnimatedListView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      cacheExtent: 0,
      padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 20),
      itemCount: 100,
      itemBuilder: (context, index) => AnimatedScrollViewItem(
        child: Container(
          margin: const EdgeInsets.only(bottom: 15),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.blue.shade100,
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }
}

class AnimatedScrollViewItem extends StatefulWidget {
  const AnimatedScrollViewItem({super.key, required this.child});

  final Widget child;

  @override
  State<AnimatedScrollViewItem> createState() => _AnimatedScrollViewItemState();
}

class _AnimatedScrollViewItemState extends State<AnimatedScrollViewItem>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late final AnimationController _animationController;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..forward();

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ScaleTransition(scale: _scaleAnimation, child: widget.child);
  }

  @override
  bool get wantKeepAlive => false;
}

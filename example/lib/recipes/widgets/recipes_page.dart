import 'dart:math' as math;

import 'package:example/recipes/styles/app_colors.dart';
import 'package:example/recipes/models/recipe.dart';
import 'package:example/recipes/widgets/recipe_page.dart';
import 'package:example/recipes/widgets/recipe_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../models/recipes_data.dart';
import '../styles/recipes_layout.dart';

class RecipesPage extends StatefulWidget {
  const RecipesPage({super.key});

  @override
  State<RecipesPage> createState() => _RecipesPageState();
}

class _RecipesPageState extends State<RecipesPage> {
  final ValueNotifier<ScrollDirection> scrollDirectionNotifier =
      ValueNotifier<ScrollDirection>(ScrollDirection.forward);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dessert Recipes')),
      body: NotificationListener<UserScrollNotification>(
        onNotification: (UserScrollNotification notification) {
          if (notification.direction == ScrollDirection.forward ||
              notification.direction == ScrollDirection.reverse) {
            scrollDirectionNotifier.value = notification.direction;
          }
          return true;
        },
        child: GridView.builder(
          padding: EdgeInsets.only(
            left: ScreenSize.of(context).isLarge ? 5 : 3.5,
            right: ScreenSize.of(context).isLarge ? 5 : 3.5,
            top: 10,
            bottom: MediaQuery.of(context).padding.bottom + 20,
          ),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: RecipesLayout.of(context).gridCrossAxisCount,
            childAspectRatio: RecipesLayout.of(context).gridChildAspectRatio,
          ),
          itemCount: RecipesData.dessertMenu.length,
          cacheExtent: 0,
          itemBuilder: (context, i) {
            return ValueListenableBuilder(
              valueListenable: scrollDirectionNotifier,
              child: RecipeListItem(RecipesData.dessertMenu[i]),
              builder: (context, ScrollDirection scrollDirection, child) {
                return RecipeListItemWrapper(
                  scrollDirection: scrollDirection,
                  child: child!,
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class RecipeListItemWrapper extends StatefulWidget {
  const RecipeListItemWrapper({
    super.key,
    required this.child,
    this.keepAlive = false,
    this.scrollDirection = ScrollDirection.forward,
  });

  final Widget child;
  final bool keepAlive;
  final ScrollDirection scrollDirection;

  @override
  State<RecipeListItemWrapper> createState() => _RecipeListItemWrapperState();
}

class _RecipeListItemWrapperState extends State<RecipeListItemWrapper>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late final AnimationController animationController;
  late final Animation<double> scaleAnimation;
  late final Animation<double> perspectiveAnimation;
  late final Animation<AlignmentGeometry> alignmentAnimation;

  static const double perspectiveValue = 0.004;

  @override
  void initState() {
    super.initState();
    final int perspectiveDirectionMultiplier =
        widget.scrollDirection == ScrollDirection.forward ? -1 : 1;

    final AlignmentGeometry directionAlignment =
        widget.scrollDirection == ScrollDirection.forward
        ? Alignment.bottomCenter
        : Alignment.topCenter;

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..forward();

    scaleAnimation = Tween<double>(begin: 0.7, end: 1).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0, 0.5, curve: Curves.easeOut),
      ),
    );

    perspectiveAnimation =
        Tween<double>(
          begin: perspectiveValue * perspectiveDirectionMultiplier,
          end: 0,
        ).animate(
          CurvedAnimation(
            parent: animationController,
            curve: const Interval(0, 1, curve: Curves.easeOut),
          ),
        );

    alignmentAnimation =
        Tween<AlignmentGeometry>(
          begin: directionAlignment,
          end: Alignment.center,
        ).animate(
          CurvedAnimation(
            parent: animationController,
            curve: const Interval(0, 1, curve: Curves.easeOut),
          ),
        );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return AnimatedBuilder(
      animation: animationController,
      child: widget.child,
      builder: (context, child) => Transform(
        transform: Matrix4.identity()
          ..setEntry(3, 1, perspectiveAnimation.value),
        alignment: alignmentAnimation.value,
        child: Transform.scale(scale: scaleAnimation.value, child: child),
      ),
    );
  }

  @override
  bool get wantKeepAlive => widget.keepAlive;
}

class RecipeListItem extends StatefulWidget {
  const RecipeListItem(this.recipe, {super.key});

  final Recipe recipe;

  @override
  State<RecipeListItem> createState() => _RecipeListItemState();
}

class _RecipeListItemState extends State<RecipeListItem> {
  double recipeImageRotationAngle = 0;

  @override
  Widget build(BuildContext context) {
    double imageSize = RecipesLayout.of(context).recipeImageSize;

    return RecipeListItemGestureDetector(
      onTap: () {
        Navigator.of(context)
            .push(
              PageRouteBuilder(
                transitionDuration: const Duration(milliseconds: 300),
                pageBuilder:
                    (BuildContext context, Animation<double> animation, _) {
                      return RecipePage(
                        widget.recipe,
                        initialImageRotationAngle: recipeImageRotationAngle,
                      );
                    },
                transitionsBuilder:
                    (
                      BuildContext context,
                      Animation<double> animation,
                      _,
                      Widget child,
                    ) {
                      return FadeTransition(opacity: animation, child: child);
                    },
              ),
            )
            .then((response) {
              if (response != null && response is double && mounted) {
                setState(() {
                  recipeImageRotationAngle = response;
                });
              }
            });
      },
      child: Padding(
        padding: EdgeInsets.all(ScreenSize.of(context).isLarge ? 15 : 12.5),
        child: Stack(
          children: [
            Positioned.fill(
              child: Hero(
                tag: '__recipe_${widget.recipe.id}_image_bg__',
                child: Container(
                  alignment: Alignment.bottomRight,
                  decoration: BoxDecoration(
                    color: widget.recipe.bgColor,
                    borderRadius: BorderRadius.circular(35),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.orangeDark.withAlpha(
                          AppColors.getBrightness(widget.recipe.bgColor) ==
                                  Brightness.dark
                              ? 125
                              : 40,
                        ),
                        blurRadius: 10,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  // child: RecipeListItemImage(recipe),
                ),
              ),
            ),
            Positioned.fill(
              child: Container(
                alignment: Alignment.bottomRight,
                child: RecipeListItemImageWrapper(
                  child: RecipeImage(
                    widget.recipe,
                    imageRotationAngle: recipeImageRotationAngle,
                    imageSize: imageSize,
                    alignment: Alignment.bottomRight,
                    hasShadow: false,
                  ),
                ),
              ),
            ),
            Row(
              children: [
                Expanded(flex: 3, child: RecipeListItemText(widget.recipe)),
                Expanded(flex: 2, child: Container()),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class RecipeListItemGestureDetector extends StatefulWidget {
  const RecipeListItemGestureDetector({
    super.key,
    required this.child,
    required this.onTap,
  });

  final Widget child;
  final VoidCallback onTap;

  @override
  State<RecipeListItemGestureDetector> createState() =>
      _RecipeListItemGestureDetectorState();
}

class _RecipeListItemGestureDetectorState
    extends State<RecipeListItemGestureDetector>
    with SingleTickerProviderStateMixin {
  late final AnimationController animationController;
  late final Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    scaleAnimation = Tween<double>(begin: 1, end: 0.9).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => animationController.animateTo(
        0.5,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      ),
      onExit: (_) => animationController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      ),
      child: GestureDetector(
        onTap: widget.onTap,
        onTapDown: (_) => animationController.forward(),
        onTapCancel: () =>
            animationController.reverse(from: animationController.value),
        onTapUp: (_) => animationController.reverse(),
        child: AnimatedBuilder(
          animation: animationController,
          builder: (context, child) {
            return Transform.scale(
              scale: scaleAnimation.value,
              child: widget.child,
            );
          },
          child: widget.child,
        ),
      ),
    );
  }
}

class RecipeListItemText extends StatelessWidget {
  const RecipeListItemText(this.menuItem, {super.key});

  final Recipe menuItem;

  @override
  Widget build(BuildContext context) {
    return RecipeListItemTextWrapper(
      child: Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: ScreenSize.of(context).isLarge ? 40 : 20,
          bottom: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: ScreenSize.of(context).isLarge
              ? MainAxisAlignment.start
              : MainAxisAlignment.end,
          children: [
            Hero(
              tag: '__recipe_${menuItem.id}_title__',
              child: Text(
                menuItem.title,
                style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                  color: AppColors.textColorFromBackground(menuItem.bgColor),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Flexible(
              child: Hero(
                tag: '__recipe_${menuItem.id}_description__',
                child: Text(
                  menuItem.description,
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    color: AppColors.textColorFromBackground(menuItem.bgColor),
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RecipeListItemTextWrapper extends StatefulWidget {
  const RecipeListItemTextWrapper({super.key, required this.child});

  final Widget child;

  @override
  State<RecipeListItemTextWrapper> createState() =>
      _RecipeListItemTextWrapperState();
}

class _RecipeListItemTextWrapperState extends State<RecipeListItemTextWrapper>
    with SingleTickerProviderStateMixin {
  late final AnimationController animationController;
  late final Animation<Offset> offsetAnimation;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();

    offsetAnimation =
        Tween<Offset>(begin: const Offset(0, -30), end: Offset.zero).animate(
          CurvedAnimation(
            parent: animationController,
            curve: const Interval(0.3, 1, curve: Curves.easeOutBack),
          ),
        );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      child: widget.child,
      builder: (context, child) {
        return Transform.translate(offset: offsetAnimation.value, child: child);
      },
    );
  }
}

class RecipeListItemImageWrapper extends StatefulWidget {
  const RecipeListItemImageWrapper({
    super.key,
    required this.child,
    this.playOnce = false,
  });

  final Widget child;
  final bool playOnce;

  @override
  State<RecipeListItemImageWrapper> createState() =>
      _RecipeListItemImageWrapperState();
}

class _RecipeListItemImageWrapperState extends State<RecipeListItemImageWrapper>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late final AnimationController animationController;
  late final Animation<double> scaleAnimation;
  late final Animation<double> rotationAnimation;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();

    scaleAnimation = Tween<double>(begin: 0.6, end: 1).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.3, 1, curve: Curves.easeOutBack),
      ),
    );

    rotationAnimation = Tween<double>(begin: 20 * math.pi / 180, end: 0)
        .animate(
          CurvedAnimation(
            parent: animationController,
            curve: const Interval(0.3, 1, curve: Curves.easeOutBack),
          ),
        );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Transform.translate(
      offset: const Offset(20, 20),
      child: AnimatedBuilder(
        animation: animationController,
        child: widget.child,
        builder: (context, child) {
          return Transform.scale(
            scale: scaleAnimation.value,
            alignment: Alignment.bottomRight,
            child: Transform.rotate(
              angle: rotationAnimation.value,
              alignment: Alignment.bottomRight,
              child: child,
            ),
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => widget.playOnce;
}

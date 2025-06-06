import 'dart:math' as math;
import 'dart:ui';

import 'package:example/recipes/styles/recipes_layout.dart';
import 'package:example/recipes/widgets/recipe_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import '../styles/app_colors.dart';
import '../models/recipe.dart';

class RecipePage extends StatefulWidget {
  const RecipePage(
    this.recipe, {
    super.key,
    this.initialImageRotationAngle = 0,
  });

  final Recipe recipe;
  final double initialImageRotationAngle;

  @override
  State<RecipePage> createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {
  final ScrollController scrollController = ScrollController();
  late final ValueNotifier<double> imageRotationAngleNotifier;

  void scrollListener() {
    ScrollDirection scrollDirection =
        scrollController.position.userScrollDirection;
    double scrollPosition = scrollController.position.pixels.abs();
    if (scrollDirection == ScrollDirection.forward) {
      imageRotationAngleNotifier.value +=
          (scrollPosition * math.pi / 180) * 0.01;
    } else if (scrollDirection == ScrollDirection.reverse) {
      imageRotationAngleNotifier.value -=
          (scrollPosition * math.pi / 180) * 0.01;
    }
  }

  @override
  void initState() {
    scrollController.addListener(scrollListener);
    imageRotationAngleNotifier = ValueNotifier<double>(
      widget.initialImageRotationAngle,
    );
    super.initState();
  }

  @override
  void dispose() {
    scrollController.removeListener(scrollListener);
    imageRotationAngleNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.recipe.bgColor == AppColors.sugar
          ? AppColors.yellow
          : null,
      body: Row(
        children: [
          if (ScreenSize.of(context).isLarge)
            Expanded(
              flex: 1,
              child: ValueListenableBuilder(
                valueListenable: imageRotationAngleNotifier,
                builder: (context, double imageRotationAngle, child) {
                  return RecipePageSidebar(
                    widget.recipe,
                    imageRotationAngle: imageRotationAngle,
                  );
                },
              ),
            ),
          Expanded(
            flex: 1,
            child: CustomScrollView(
              controller: scrollController,
              cacheExtent: 0,
              slivers: [
                if (!ScreenSize.of(context).isLarge)
                  ValueListenableBuilder(
                    valueListenable: imageRotationAngleNotifier,
                    builder: (context, double imageRotationAngle, child) {
                      return RecipePageSliverAppBar(
                        imageRotationAngle: imageRotationAngle,
                        recipe: widget.recipe,
                      );
                    },
                  ),

                SliverPadding(
                  padding: EdgeInsets.symmetric(
                    horizontal: ScreenSize.of(context).isLarge ? 70 : 17,
                    vertical: ScreenSize.of(context).isLarge ? 50 : 20,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      Hero(
                        tag: '__recipe_${widget.recipe.id}_title__',
                        child: Text(
                          widget.recipe.title,
                          style: Theme.of(context).textTheme.headlineLarge!,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Hero(
                        tag: '__recipe_${widget.recipe.id}_description__',
                        child: Text(
                          widget.recipe.description,
                          style: Theme.of(context).textTheme.headlineMedium!,
                        ),
                      ),

                      const SizedBox(height: 20),

                      FadeInEffect(
                        intervalStart: 0.5,
                        keepAlive: true,
                        child: Text(
                          'INGREDIENTS',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),
                      IngredientsSection(widget.recipe),

                      FadeInEffect(
                        keepAlive: true,
                        child: Text(
                          'STEPS',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),
                      InstructionsSection(widget.recipe),
                    ]),
                  ),
                ),

                SliverToBoxAdapter(
                  child: SizedBox(
                    height: MediaQuery.of(context).padding.bottom + 20,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RecipePageSidebar extends StatelessWidget {
  const RecipePageSidebar(
    this.recipe, {
    super.key,
    this.imageRotationAngle = 0,
  });

  final Recipe recipe;
  final double imageRotationAngle;

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return AdaptiveOffsetEffect.builder(
      width: screenSize.width / 2,
      height: screenSize.height,
      child: RecipePageImageBg(
        recipe,
        borderRadius: const BorderRadius.only(
          bottomRight: Radius.circular(35),
          topRight: Radius.circular(35),
        ),
      ),
      childBuilder: (context, offset, child) => Stack(
        children: [
          child!,
          if (recipe.bgImageName.isNotEmpty)
            FadeInEffect(
              intervalStart: 0.5,
              child: RecipeImagePatternMouse(
                recipe,
                offset: offset,
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(35),
                  topRight: Radius.circular(35),
                ),
              ),
            ),
          IgnorePointer(
            ignoring: true,
            child: Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.4,
                child: RecipeImage(
                  recipe,
                  imageRotationAngle: imageRotationAngle,
                  shadowOffset: offset * 0.5,
                ),
              ),
            ),
          ),
          Positioned(
            top: 20,
            left: 20,
            child: AppBarLeading(
              text: 'Back to Recipes',
              popValue: imageRotationAngle,
            ),
          ),
        ],
      ),
    );
  }
}

class RecipePageSliverAppBar extends StatelessWidget {
  const RecipePageSliverAppBar({
    super.key,
    required this.recipe,
    this.expandedHeight = 340,
    this.collapsedHeight = 200,
    this.imageRotationAngle = 0,
  });

  final Recipe recipe;
  final double expandedHeight;
  final double? collapsedHeight;
  final double imageRotationAngle;

  @override
  Widget build(BuildContext context) {
    double imageSize = MediaQuery.of(context).size.width * 0.7;

    return SliverAppBar(
      pinned: true,
      stretch: true,
      backgroundColor: Colors.transparent,
      collapsedHeight: collapsedHeight,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarBrightness: AppColors.getBrightness(recipe.bgColor),
      ),
      leading: AppBarLeading(
        popValue: imageRotationAngle,
        bgColor: AppColors.textColorFromBackground(recipe.bgColor),
      ),
      expandedHeight: expandedHeight + MediaQuery.of(context).padding.top,
      flexibleSpace: AdaptiveOffsetEffect.builder(
        width: MediaQuery.of(context).size.width,
        height: expandedHeight,
        child: RecipePageImageBg(
          recipe,
          borderRadius: const BorderRadius.only(
            bottomRight: Radius.circular(35),
            bottomLeft: Radius.circular(35),
          ),
        ),
        childBuilder: (BuildContext context, Offset offset, Widget? child) {
          return Stack(
            children: [
              child!,
              if (recipe.bgImage.isNotEmpty)
                FlexibleSpaceBar(
                  background: FadeInEffect(
                    intervalStart: 0.5,
                    child: Opacity(
                      opacity: 0.6,
                      child: RecipeImagePattern(
                        offset: offset,
                        recipe,
                        borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(35),
                          bottomLeft: Radius.circular(35),
                        ),
                      ),
                    ),
                  ),
                ),
              SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: RecipeImage(
                    recipe,
                    imageRotationAngle: imageRotationAngle,
                    imageSize: imageSize,
                    shadowOffset: offset * 0.6,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class RecipeImagePattern extends StatelessWidget {
  const RecipeImagePattern(
    this.recipe, {
    super.key,
    this.offset = Offset.zero,
    required this.borderRadius,
  });

  final Recipe recipe;
  final BorderRadius borderRadius;
  final Offset offset;

  @override
  Widget build(BuildContext context) {
    String bgImage = ScreenSize.of(context).isLarge
        ? recipe.bgImageLg
        : recipe.bgImage;
    AlignmentGeometry alignment = ScreenSize.of(context).isLarge
        ? Alignment.center
        : Alignment.bottomCenter;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        TweenAnimationBuilder<Offset>(
          tween: Tween<Offset>(begin: Offset.zero, end: offset * 1.5),
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutBack,
          builder: (context, Offset offset, child) =>
              Transform.translate(offset: offset, child: child!),
          child: Align(
            alignment: alignment,
            child: ClipRRect(
              borderRadius: borderRadius,
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaY: 3, sigmaX: 3),
                child: Image.asset(
                  bgImage,
                  color: AppColors.orangeDark.withAlpha(125),
                  alignment: alignment,
                ),
              ),
            ),
          ),
        ),
        TweenAnimationBuilder<Offset>(
          tween: Tween<Offset>(begin: Offset.zero, end: offset),
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutBack,
          builder: (context, Offset offset, child) =>
              Transform.translate(offset: offset, child: child!),
          child: ClipRRect(
            borderRadius: borderRadius,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(bgImage),
                  alignment: alignment,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class RecipeImagePatternMouse extends StatelessWidget {
  const RecipeImagePatternMouse(
    this.recipe, {
    super.key,
    required this.borderRadius,
    this.offset = Offset.zero,
  });

  final Recipe recipe;
  final BorderRadius borderRadius;
  final Offset offset;

  @override
  Widget build(BuildContext context) {
    String bgImage = ScreenSize.of(context).isLarge
        ? recipe.bgImageLg
        : recipe.bgImage;
    AlignmentGeometry alignment = ScreenSize.of(context).isLarge
        ? Alignment.center
        : Alignment.bottomCenter;

    return Opacity(
      opacity: 0.6,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          TweenAnimationBuilder(
            tween: Tween<Offset>(begin: Offset.zero, end: offset * 2),
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOutBack,
            builder: (context, Offset offset, child) =>
                Transform.translate(offset: offset, child: child),
            child: Align(
              alignment: alignment,
              child: ClipRRect(
                borderRadius: borderRadius,
                child: ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaY: 3, sigmaX: 3),
                  child: Image.asset(
                    bgImage,
                    color: AppColors.orangeDark.withAlpha(125),
                    alignment: alignment,
                  ),
                ),
              ),
            ),
          ),
          TweenAnimationBuilder(
            tween: Tween<Offset>(begin: Offset.zero, end: offset),
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOutBack,
            builder: (context, Offset offset, child) =>
                Transform.translate(offset: offset, child: child),
            child: ClipRRect(
              borderRadius: borderRadius,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(bgImage),
                    alignment: alignment,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RecipePageImageBg extends StatelessWidget {
  const RecipePageImageBg(this.recipe, {super.key, required this.borderRadius});

  final Recipe recipe;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: '__recipe_${recipe.id}_image_bg__',
      child: Container(
        decoration: BoxDecoration(
          color: recipe.bgColor,
          borderRadius: borderRadius,
          boxShadow: [
            BoxShadow(
              color: AppColors.orangeDark.withAlpha(
                AppColors.getBrightness(recipe.bgColor) == Brightness.dark
                    ? 125
                    : 40,
              ),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        alignment: Alignment.center,
      ),
    );
  }
}

class AppBarLeading extends StatefulWidget {
  const AppBarLeading({
    super.key,
    this.bgColor = AppColors.white,
    this.text,
    this.popValue,
  });

  final Color bgColor;
  final String? text;
  final dynamic popValue;

  @override
  State<AppBarLeading> createState() => _AppBarLeadingState();
}

class _AppBarLeadingState extends State<AppBarLeading>
    with SingleTickerProviderStateMixin {
  late final AnimationController animationController;
  late final Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();

    scaleAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.5, 1, curve: Curves.easeOutBack),
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
    return InkWell(
      onTap: () => Navigator.of(context).pop(widget.popValue),
      child: ScaleTransition(
        scale: scaleAnimation,
        child: Container(
          margin: const EdgeInsets.only(left: 17),
          padding: EdgeInsets.all(widget.text != null ? 10 : 0),
          decoration: widget.text == null
              ? BoxDecoration(color: widget.bgColor, shape: BoxShape.circle)
              : BoxDecoration(
                  color: widget.bgColor,
                  borderRadius: BorderRadius.circular(20),
                ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.arrow_back,
                color: AppColors.textColorFromBackground(widget.bgColor),
              ),
              if (widget.text != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    widget.text!,
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      color: AppColors.textColorFromBackground(widget.bgColor),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class FadeInEffect extends StatefulWidget {
  const FadeInEffect({
    super.key,
    required this.child,
    this.intervalStart = 0,
    this.keepAlive = false,
  });

  final Widget child;
  final double intervalStart;
  final bool keepAlive;

  @override
  State<FadeInEffect> createState() => _FadeInEffectState();
}

class _FadeInEffectState extends State<FadeInEffect>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late final AnimationController animationController;
  late final Animation<double> opacityAnimation;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();

    opacityAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Interval(widget.intervalStart, 1, curve: Curves.easeOut),
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
    return FadeTransition(opacity: opacityAnimation, child: widget.child);
  }

  @override
  bool get wantKeepAlive => widget.keepAlive;
}

class AnimateInEffect extends StatefulWidget {
  const AnimateInEffect({
    super.key,
    required this.child,
    this.intervalStart = 0,
    this.keepAlive = false,
  });

  final Widget child;
  final double intervalStart;
  final bool keepAlive;

  @override
  State<AnimateInEffect> createState() => _AnimateInEffectState();
}

class _AnimateInEffectState extends State<AnimateInEffect>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late final AnimationController animationController;
  late final Animation<Offset> offsetAnimation;
  late final Animation<double> fadeAnimation;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    Future.delayed(
      const Duration(milliseconds: 300),
      () => animationController.forward(),
    );

    Curve intervalCurve = Interval(
      widget.intervalStart,
      1,
      curve: Curves.easeOut,
    );

    offsetAnimation =
        Tween<Offset>(begin: const Offset(0, 30), end: Offset.zero).animate(
          CurvedAnimation(parent: animationController, curve: intervalCurve),
        );

    fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: animationController, curve: intervalCurve),
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
      builder: (context, child) =>
          Transform.translate(offset: offsetAnimation.value, child: child),
      child: FadeTransition(opacity: fadeAnimation, child: widget.child),
    );
  }

  @override
  bool get wantKeepAlive => widget.keepAlive;
}

typedef OffsetEffectBuilder =
    Widget Function(BuildContext context, Offset offset, Widget? child);

class AdaptiveOffsetEffect extends StatelessWidget {
  const AdaptiveOffsetEffect({
    super.key,
    required this.width,
    required this.height,
    required this.child,
    this.offsetMultiplier = 1,
    this.childBuilder,
    this.maxMovableDistance = 10,
  }) : assert(child != null);

  const AdaptiveOffsetEffect.builder({
    super.key,
    required this.width,
    required this.height,
    this.child,
    this.offsetMultiplier = 1,
    required this.childBuilder,
    this.maxMovableDistance = 10,
  }) : assert(childBuilder != null);

  final double width;
  final double height;

  /// Moving child widget
  final Widget? child;

  /// Maximum distance allowed for the child to move in
  final double maxMovableDistance;

  /// Value to multiply the movement offset to allow some widgets
  /// to move further than the other
  final double offsetMultiplier;

  /// A builder that provides necessary data to build a moving child
  /// with its child not rebuilding with the stream
  final OffsetEffectBuilder? childBuilder;

  @override
  Widget build(BuildContext context) {
    return childBuilder != null
        ? MouseRegionEffect.builder(
            width: width,
            height: height,
            maxMovableDistance: maxMovableDistance,
            offsetMultiplier: offsetMultiplier,
            childBuilder: childBuilder,
            child: child,
          )
        : MouseRegionEffect(
            width: width,
            height: height,
            maxMovableDistance: maxMovableDistance,
            offsetMultiplier: offsetMultiplier,
            child: child,
          );
  }
}

class MouseRegionEffect extends StatefulWidget {
  const MouseRegionEffect({
    super.key,
    required this.width,
    required this.height,
    required this.child,
    this.offsetMultiplier = 1,
    this.childBuilder,
    this.maxMovableDistance = 10,
  }) : assert(child != null && childBuilder == null);

  const MouseRegionEffect.builder({
    super.key,
    required this.width,
    required this.height,
    this.child,
    this.offsetMultiplier = 1,
    required this.childBuilder,
    this.maxMovableDistance = 10,
  }) : assert(childBuilder != null);

  final double width;
  final double height;
  final OffsetEffectBuilder? childBuilder;
  final Widget? child;
  final double offsetMultiplier;
  final double maxMovableDistance;

  @override
  State<MouseRegionEffect> createState() => _MouseRegionEffectState();
}

class _MouseRegionEffectState extends State<MouseRegionEffect> {
  Offset offset = const Offset(0, 0);
  Alignment mouseRegionAlignment = Alignment.bottomRight;

  Alignment alignmentFromOffset(Offset mousePosition) {
    if (mousePosition.dx > widget.width / 2) {
      return mousePosition.dy > widget.height / 2
          ? Alignment.bottomRight
          : Alignment.topRight;
    } else {
      return mousePosition.dy > widget.height / 2
          ? Alignment.bottomLeft
          : Alignment.topLeft;
    }
  }

  Offset offsetFromMousePosition(Offset mousePosition) {
    Alignment alignment = alignmentFromOffset(mousePosition);
    return Offset(
      widget.maxMovableDistance * alignment.x * -1,
      widget.maxMovableDistance * alignment.y * -1,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      hitTestBehavior: HitTestBehavior.translucent,
      onEnter: (PointerEnterEvent event) {
        setState(() {
          offset = offsetFromMousePosition(event.localPosition);
        });
      },
      onHover: (PointerHoverEvent event) {
        setState(() {
          offset = offsetFromMousePosition(event.localPosition);
        });
      },
      onExit: (PointerExitEvent event) {
        setState(() {
          offset = offsetFromMousePosition(event.localPosition);
        });
      },
      child: _buildChild(context, widget.child),
    );
  }

  Widget _buildChild(BuildContext context, Widget? child) {
    if (widget.childBuilder != null) {
      return widget.childBuilder!.call(context, offset, child);
    } else {
      return TweenAnimationBuilder(
        tween: Tween<Offset>(
          begin: Offset.zero,
          end: offset * widget.offsetMultiplier,
        ),
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOutBack,
        builder: (context, Offset offset, child) =>
            Transform.translate(offset: offset, child: child),
        child: child,
      );
    }
  }
}

class IngredientsSection extends StatelessWidget {
  const IngredientsSection(this.recipe, {super.key});

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 20),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: recipe.ingredients.length,
      shrinkWrap: true,
      itemBuilder: (context, i) {
        return AnimateInEffect(
          keepAlive: true,
          intervalStart: i / recipe.ingredients.length,
          child: IngredientItem(recipe, ingredient: recipe.ingredients[i]),
        );
      },
    );
  }
}

class IngredientItem extends StatelessWidget {
  const IngredientItem(this.recipe, {super.key, required this.ingredient});

  final Recipe recipe;
  final String ingredient;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(35),
        border: Border.all(color: recipe.bgColor, width: 2),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Transform.translate(
            offset: const Offset(0, -10),
            child: Container(
              width: 50,
              height: 50,
              padding: const EdgeInsets.all(13),
              margin: const EdgeInsets.only(right: 15),
              decoration: BoxDecoration(
                color: recipe.bgColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.orangeDark.withAlpha(
                      AppColors.getBrightness(recipe.bgColor) == Brightness.dark
                          ? 125
                          : 40,
                    ),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Transform.rotate(
                angle: -0.3,
                child: Image.asset(
                  'assets/images/chef.png',
                  color: AppColors.textColorFromBackground(recipe.bgColor),
                ),
              ),
            ),
          ),
          Expanded(
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 50),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    ingredient,
                    style: Theme.of(context).textTheme.headlineSmall!,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class InstructionsSection extends StatelessWidget {
  const InstructionsSection(this.recipe, {super.key});

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 20),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: recipe.instructions.length,
      shrinkWrap: true,
      itemBuilder: (context, i) {
        return AnimateInEffect(
          keepAlive: true,
          intervalStart: i / recipe.instructions.length,
          child: InstructionItem(recipe, index: i),
        );
      },
    );
  }
}

class InstructionItem extends StatelessWidget {
  const InstructionItem(this.recipe, {super.key, required this.index});

  final Recipe recipe;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(35),
        border: Border.all(color: recipe.bgColor, width: 2),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Transform.translate(
            offset: const Offset(0, -10),
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: recipe.bgColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.orangeDark.withAlpha(
                      AppColors.getBrightness(recipe.bgColor) == Brightness.dark
                          ? 125
                          : 40,
                    ),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: Transform.rotate(
                angle: -0.3,
                child: Text(
                  '${index + 1}',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                recipe.instructions[index],
                style: Theme.of(
                  context,
                ).textTheme.headlineSmall!.copyWith(height: 1.7),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

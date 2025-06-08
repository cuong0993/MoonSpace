import 'package:example/animated/animated_list_scale.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_custom_carousel/flutter_custom_carousel.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moonspace/form/async_text_field.dart';
import 'package:moonspace/helper/extensions/theme_ext.dart';
import 'package:moonspace/theme.dart';

class Quiz extends StatelessWidget {
  const Quiz({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                QuizHeader(),
                FriendHeader(),

                SizedBox(height: 8),

                Text(
                  "What is always in front of you but can't be seen?",
                  style: GoogleFonts.agbalumo(textStyle: context.h1),
                ),

                SizedBox(height: 24),

                AnswerTextFormField(),

                SizedBox(height: 16),

                Text("Let's continue a quiz!", style: context.h2.bold),

                SizedBox(height: 16),

                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(7, (i) {
                      return Container(
                        width: 40,
                        height: 12,
                        margin: EdgeInsets.fromLTRB(0, 8, 8, 0),
                        decoration: BoxDecoration(
                          color: i < 3 ? context.cs.tertiary : null,
                          borderRadius: 8.br,
                          border: Border.all(),
                        ),
                      );
                    }),
                  ),
                ),

                _buildCarouselRow("c", 6, height: 280),

                HexagonButtons(),

                DefaultTabController(
                  length: 3,
                  child: TabBar(
                    indicatorSize: TabBarIndicatorSize.tab,
                    dividerColor: Colors.transparent,
                    indicator: BoxDecoration(
                      borderRadius: 24.br,
                      color: context.cs.secondary,
                    ),
                    labelColor: context.cs.onSecondary,
                    tabs: const [
                      Tab(text: 'Video'),
                      Tab(text: 'Photos'),
                      Tab(text: 'Audio'),
                    ],
                  ),
                ),

                Container(height: 100),

                SizedBox(height: 16),

                Text(
                  "Welcome to the family! Unwind with me as we play through Zelda and cozy games together",
                  style: GoogleFonts.inter(textStyle: context.h3),
                ),

                SizedBox(height: 12),

                Text("Choose your answer", style: context.h6),

                SizedBox(height: 12),

                GridView.count(
                  crossAxisCount: AppTheme.isMobile ? 2 : 4,
                  childAspectRatio: ((3.5, 5).c, (1, 5).c, (1, 6).c).r,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: List.generate(4, (index) {
                    return ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: index == 0
                            ? context.cs.tertiary
                            : context.cs.primary,
                        elevation: 0,
                        shape: 1.bRound.r(32).c(context.cs.outline),
                      ),
                      child: Text(
                        'Button ${index + 1}',
                        style: context.h7.w5.c(
                          index == 0 ? context.cs.primary : context.cs.tertiary,
                        ),
                      ),
                    );
                  }),
                ),

                SizedBox(height: 8),

                CarouselCards(),

                SizedBox(height: 8),

                Text("My Level Progress", style: context.h6),

                SizedBox(height: 8),

                Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    LinearProgressIndicator(value: .5, minHeight: 40),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        "34%",
                        style: context.h6.c(context.cs.onSecondary),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 8),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("My Friends", style: context.h6),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        "See All",
                        style: context.h6.c(context.cs.primary),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 8),

                ConstrainedBox(
                  constraints: const BoxConstraints.tightFor(height: 50),
                  child: CarouselView(
                    itemSnapping: true,
                    onTap: (value) {},
                    padding: EdgeInsets.zero,
                    shrinkExtent: 50,
                    itemExtent: 50,
                    children: Colors.primaries.map((color) {
                      return Container(
                        width: 40,
                        height: 40,
                        margin: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(60),
                          color: color,
                        ),
                      );
                    }).toList(),
                  ),
                ),

                SizedBox(height: 8),

                Text("Category", style: context.h6),

                SizedBox(height: 8),

                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Wrap(
                    spacing: 8,
                    children: ["All", "Science", "Math"].asMap().entries.map((
                      item,
                    ) {
                      return Material(
                        shape: 1.bRound.r(20).c(context.cs.outline),
                        color: item.key == 0 ? context.cs.tertiary : null,
                        child: InkWell(
                          borderRadius: 20.br,
                          onTap: () {},
                          child: Container(
                            constraints: BoxConstraints(minWidth: 80),
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              item.value,
                              style: context.h7.c(context.cs.primary),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),

                SizedBox(height: 8),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Latest Quiz", style: context.h6),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        "See All",
                        style: context.h6.c(context.cs.primary),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 8),

                QuizTile(),

                SizedBox(height: 8),

                CatTile(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HexagonButtons extends StatelessWidget {
  const HexagonButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Wrap(
        spacing: 4,
        runAlignment: WrapAlignment.center,
        alignment: WrapAlignment.center,
        children: ["Super Star", "Quiz Champion", "Math", "Science"]
            .asMap()
            .entries
            .map((item) {
              return SizedBox(
                width: 70,
                child: Column(
                  children: [
                    Container(
                      height: 60,
                      width: 60,
                      decoration: ShapeDecoration(
                        shape: StarBorder.polygon(
                          side: 1.bs.c(context.cs.outline),
                          sides: 6.00,
                          rotation: 0.00,
                          pointRounding: 0.24,
                          squash: 0.00,
                        ),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(item.value, maxLines: 2, textAlign: TextAlign.center),
                  ],
                ),
              );
            })
            .toList(),
      ),
    );
  }
}

class AnswerTextFormField extends StatelessWidget {
  const AnswerTextFormField({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: context.cs.primary),
        borderRadius: 16.br,
      ),
      padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
      child: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 40),
            child: AsyncTextFormField(
              asyncValidator: (value) async {
                return null;
              },
              minLines: 9,
              maxLines: 9,
              textAlign: TextAlign.start,
              textAlignVertical: TextAlignVertical.bottom,
              decoration: (asyncText, textCon) => InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                ),
                floatingLabelAlignment: FloatingLabelAlignment.center,
                contentPadding: EdgeInsets.all(24),
                alignLabelWithHint: true,
                label: Text(
                  "Write your answer here...",
                  style: GoogleFonts.agbalumo(textStyle: context.h3),
                ),
              ),
            ),
          ),

          Container(
            width: 200,
            padding: const EdgeInsets.all(8.0),
            child: FilledButton(
              onPressed: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Submit"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class QuizTile extends StatelessWidget {
  const QuizTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: context.cs.surfaceContainerHighest,

      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          children: [
            Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                borderRadius: 16.br,
                color: context.cs.secondary,
              ),
            ),

            SizedBox(width: 16),

            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Math Quiz", style: context.h5),
                SizedBox(height: 4),
                Text("Practive your math skills!"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CatTile extends StatelessWidget {
  const CatTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: context.cs.surface,
      shape: 1.bRound.r(20).c(context.cs.primary),

      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                borderRadius: 16.br,
                color: context.cs.secondary,
              ),
            ),

            SizedBox(width: 16),

            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Cat", style: context.h5),
                SizedBox(height: 4),
                Text("9 streak"),
              ],
            ),

            Spacer(),

            Text("123 Point", style: context.h5.c(context.cs.secondary)),

            SizedBox(width: 16),
          ],
        ),
      ),
    );
  }
}

class CarouselCards extends StatelessWidget {
  const CarouselCards({super.key});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.tightFor(height: (160, 175).c),
      child: CarouselView(
        itemSnapping: true,
        onTap: (value) {},
        padding: EdgeInsets.zero,
        shrinkExtent: (300, 320).c,
        itemExtent: (300, 320).c,
        children: List<Widget>.generate(20, (index) {
          return NameCard(index: index);
        }),
      ),
    );
  }
}

class NameCard extends StatelessWidget {
  const NameCard({super.key, required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    final color = index % 2 == 0 ? context.cs.secondary : context.cs.tertiary;
    final onColor = index % 2 == 0
        ? context.cs.onSecondary
        : context.cs.onTertiary;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: color,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Animals Name", style: context.h5.c(onColor)),
                  SizedBox(height: 8),
                  Text("10 questions", style: context.h6.c(onColor)),
                  SizedBox(height: 8),
                  FilledButton(
                    style: FilledButton.styleFrom(backgroundColor: onColor),
                    onPressed: () {},
                    child: Text("Lets go!", style: context.h8.c(color)),
                  ),
                ],
              ),
              SizedBox(width: 90, height: 90),
            ],
          ),
        ),
      ),
    );
  }
}

class QuizHeader extends StatelessWidget {
  const QuizHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        InkWell(
          onTap: () {
            context.pop();
          },
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: context.cs.tertiary,
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Hi, Cat", style: context.h5),
                SizedBox(height: 8),
                LinearProgressIndicator(value: .5, minHeight: 10),
              ],
            ),
          ),
        ),
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color.fromARGB(255, 91, 91, 91)),
          ),
        ),
      ],
    );
  }
}

class FriendHeader extends StatelessWidget {
  const FriendHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        IconButton.filledTonal(
          onPressed: () {},
          icon: const Icon(CupertinoIcons.chevron_left),
        ),
        Spacer(),
        OutlinedButton.icon(
          onPressed: () {},
          icon: Icon(CupertinoIcons.timer),
          label: Text("03:03", style: context.h6),
        ),
      ],
    );
  }
}

class FriendCard extends StatelessWidget {
  const FriendCard(this.category, this.index, {super.key});

  final String category;
  final int index;

  @override
  Widget build(BuildContext context) {
    Widget content = Stack(
      alignment: AlignmentDirectional.center,
      children: [
        Hero(
          tag: 'food-$category-$index',
          child: Container(
            width: 190,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'assets/images/cover_slider/food-$category-$index.jpg',
                ),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(24),
            ),
          ),
        ),

        Hero(
          tag: 'food-$category-$index-title',
          child: Text(
            category,
            style: GoogleFonts.agbalumo(textStyle: context.h4),
          ),
        ),

        Align(
          alignment: Alignment(0, -0.68),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: context.cs.primary,
              borderRadius: BorderRadius.circular(32),
            ),
            child: Text(
              "quiz",
              style: GoogleFonts.agbalumo(textStyle: context.h4),
            ),
          ),
        ),
        Align(
          alignment: Alignment(0, -.9),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: context.cs.primary,
              borderRadius: BorderRadius.circular(32),
            ),
            child: Text(
              "FriendShip",
              style: GoogleFonts.agbalumo(textStyle: context.h4),
            ),
          ),
        ),
      ],
    );

    return GestureDetector(
      onTap: () => _showDetails(context, category, index),
      child: content,
    );
  }

  void _showDetails(BuildContext context, String category, int index) {
    PageRouteBuilder route = PageRouteBuilder(
      pageBuilder: (_, __, ___) {
        return DetailsView(category: category, index: index);
      },
      transitionDuration: 600.ms,
      transitionsBuilder: (_, a, __, c) => FadeTransition(opacity: a, child: c),
    );
    Navigator.push(context, route);
  }
}

class DetailsView extends StatefulWidget {
  final String category;
  final int index;

  const DetailsView({super.key, required this.category, required this.index});

  @override
  State<DetailsView> createState() => _DetailsViewState();
}

class _DetailsViewState extends State<DetailsView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final category = widget.category;
    final index = widget.index;

    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // Hero AppBar
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            stretch: true,
            leading: BackButton(),
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'food-$category-$index',
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        'assets/images/cover_slider/food-$category-$index.jpg',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              title: Hero(
                tag: 'food-$category-$index-title',
                child: Material(
                  type: MaterialType.transparency,

                  child: Text(
                    category,
                    style: GoogleFonts.agbalumo(textStyle: context.h4),
                  ),
                ),
              ),
            ),
          ),

          // Optional top content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                "Details about $category go here.",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ),

          // Sliver List with animated tiles
          SliverList(
            delegate: SliverChildBuilderDelegate(
              // (context, i) => _buildAnimatedTile(context, i),
              (context, i) => AnimatedScrollViewItem(
                index: i,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              childCount: 100,
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildCarouselRow(String category, int count, {double? height = 100}) {
  // Build a list of widgets for the carousel items:
  List<Widget> items = List.generate(count, (i) => FriendCard(category, i + 1));

  double rotationMultiplier = 0.2; // radians
  double scaleMin = 0.9; // minimum scale
  double opacityMin = 0.5; // minimum opacity

  Widget carousel = CustomCarousel(
    itemCountBefore: 2,
    itemCountAfter: 2,
    alignment: Alignment.center,
    scrollDirection: Axis.horizontal,
    loop: true,
    depthOrder: DepthOrder.selectedInFront,
    tapToSelect: false,
    effectsBuilder: (_, ratio, child) {
      double angle = ratio * rotationMultiplier;
      double distance = ratio.abs();

      double scale = (1 - distance).clamp(scaleMin, 1.0);
      double opacity = (1 - distance).clamp(opacityMin, 1.0);

      // Vertical offset increases with distance
      double yOffset = distance * 50; // Adjust 20 for how low it goes

      return Opacity(
        opacity: opacity,
        child: Transform.translate(
          offset: Offset(ratio * 170 * 3, yOffset),
          child: Transform.rotate(
            angle: angle,
            child: Transform.scale(scale: scale, child: child),
          ),
        ),
      );
    },
    // Pass in the list of widgets we created above:
    children: items,
  );

  return SizedBox(height: height, child: carousel);
}

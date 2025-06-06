import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moonspace/helper/extensions/color.dart';
import 'package:moonspace/helper/extensions/theme_ext.dart';

class Quiz extends StatelessWidget {
  const Quiz({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Header(),

                SizedBox(height: 8),

                Text("Let's continue a quiz!", style: context.h2),

                SizedBox(height: 8),

                CarouselCards(),

                SizedBox(height: 8),

                Text("My Level Progress", style: context.h3),

                SizedBox(height: 8),

                Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    LinearProgressIndicator(value: .5, minHeight: 40),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        "34%",
                        style: context.h4.c(context.cs.onSecondary),
                      ),
                    ),
                  ],
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("My Friends", style: context.h3),
                    TextButton(
                      onPressed: () {},
                      child: Text("See All", style: context.h3),
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
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                    shrinkExtent: 50,
                    itemExtent: 50,
                    children: List<Widget>.generate(20, (index) {
                      return Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(60),
                          color: HexColor.random(),
                        ),
                      );
                    }),
                  ),
                ),

                SizedBox(height: 8),

                Text("Category", style: context.h3),

                SizedBox(height: 8),

                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Wrap(
                    spacing: 8,
                    children: List.generate(8, (i) {
                      return ActionChip(label: Text("Science"));
                    }),
                  ),
                ),

                SizedBox(height: 8),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Latest Quiz", style: context.h3),
                    TextButton(
                      onPressed: () {},
                      child: Text("See All", style: context.h3),
                    ),
                  ],
                ),

                SizedBox(height: 8),

                QuizTile(),

                CatTile(),
              ],
            ),
          ),
        ),
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
                borderRadius: 24.br,
                color: context.cs.secondary,
              ),
            ),

            SizedBox(width: 16),

            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Math Quiz", style: context.h2),
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
      shape: 8.bRound.r(20).c(context.cs.primary),

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
                Text("Cat", style: context.h2),
                SizedBox(height: 4),
                Text("9 streak"),
              ],
            ),

            Spacer(),

            Text("123 Point", style: context.h3.c(context.cs.secondary)),

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
      constraints: const BoxConstraints.tightFor(height: 152),
      child: CarouselView(
        itemSnapping: true,
        onTap: (value) {},
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: Theme.of(context).colorScheme.outline),
        ),
        shrinkExtent: 270,
        itemExtent: 270,
        children: List<Widget>.generate(20, (index) {
          return NameCard();
        }),
      ),
    );
  }
}

class NameCard extends StatelessWidget {
  const NameCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: context.cs.secondary,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Animals Name",
                  style: context.h3.c(context.cs.onSecondary),
                ),
                SizedBox(height: 8),
                Text(
                  "10 questions",
                  style: context.h5.c(context.cs.onSecondary),
                ),
                SizedBox(height: 8),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: context.cs.tertiary,
                  ),
                  onPressed: () {},
                  child: Text(
                    "Lets go!",
                    style: context.h6.c(context.cs.onTertiary),
                  ),
                ),
              ],
            ),
            SizedBox(width: 90, height: 90),
          ],
        ),
      ),
    );
  }
}

class Header extends StatelessWidget {
  const Header({super.key});

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
                Text("Hi, Cat", style: context.h4),
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

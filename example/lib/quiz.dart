import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moonspace/helper/extensions/theme_ext.dart';

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
                Header(),

                SizedBox(height: 8),

                Text("Let's continue a quiz!", style: context.h2.bold),

                Row(
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

                Container(height: 100),

                SizedBox(height: 16),

                Text(
                  "Welcome to the family! Unwind with me as we play through Zelda and cozy games together",
                  style: context.h2,
                ),

                SizedBox(height: 12),

                Text("Choose your answer", style: context.h5),

                SizedBox(height: 12),

                GridView.count(
                  crossAxisCount: 2,
                  childAspectRatio: 2.7, // Width : Height ratio
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
                            : Colors.white,
                        elevation: 0,
                        shape: 1.bRound.r(32).c(context.cs.outline),
                      ),
                      child: Text('Button ${index + 1}', style: context.h3.w5),
                    );
                  }),
                ),

                SizedBox(height: 8),

                CarouselCards(),

                SizedBox(height: 8),

                Text("My Level Progress", style: context.h4),

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
                    Text("My Friends", style: context.h4),
                    TextButton(
                      onPressed: () {},
                      child: Text("See All", style: context.h4),
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

                Text("Category", style: context.h4),

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
                            child: Text(item.value, style: context.h5),
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
                    Text("Latest Quiz", style: context.h4),
                    TextButton(
                      onPressed: () {},
                      child: Text("See All", style: context.h4),
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
                Text("Math Quiz", style: context.h4),
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
                Text("Cat", style: context.h4),
                SizedBox(height: 4),
                Text("9 streak"),
              ],
            ),

            Spacer(),

            Text("123 Point", style: context.h4.c(context.cs.secondary)),

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
      constraints: const BoxConstraints.tightFor(height: 160),
      child: CarouselView(
        itemSnapping: true,
        onTap: (value) {},
        padding: EdgeInsets.zero,
        shrinkExtent: 270,
        itemExtent: 270,
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
                  Text("Animals Name", style: context.h4.c(onColor)),
                  SizedBox(height: 8),
                  Text("10 questions", style: context.h5.c(onColor)),
                  SizedBox(height: 8),
                  FilledButton(
                    style: FilledButton.styleFrom(backgroundColor: onColor),
                    onPressed: () {},
                    child: Text("Lets go!", style: context.h6.c(color)),
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

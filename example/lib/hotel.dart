import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moonspace/form/select.dart';
import 'package:moonspace/helper/extensions/theme_ext.dart';
import 'package:moonspace/widgets/ratings.dart';

class HotelApp extends StatelessWidget {
  const HotelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 360,
                pinned: true,
                stretch: true,
                titleSpacing: 0,
                centerTitle: true,
                title: Hero(
                  tag: 'food-c-1-title',
                  child: Material(
                    type: MaterialType.transparency,
                    child: Text(
                      "Mexico",
                      style: GoogleFonts.agbalumo(
                        textStyle: context.h4.c(context.cs.onSurface),
                      ),
                    ),
                  ),
                ),
                leading: IconButton(
                  onPressed: () {
                    context.pop();
                  },
                  icon: Icon(
                    CupertinoIcons.chevron_left,
                    color: context.cs.onSurface,
                  ),
                ),
                actions: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      CupertinoIcons.cloud_upload,
                      color: context.cs.onSurface,
                    ),
                  ),
                  SizedBox(width: 8),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      CupertinoIcons.heart,
                      color: context.cs.onSurface,
                    ),
                  ),
                  SizedBox(width: 8),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Hero(
                    tag: 'food-c-1',
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // Background image
                        Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                'assets/images/cover_slider/food-c-1.jpg',
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        // Gradient overlay
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withAlpha(100),
                                Colors.transparent,
                                Colors.black.withAlpha(100),
                              ],
                              stops: [0.0, 0.5, 1.0],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Location',
                        style: GoogleFonts.ibmPlexMono(
                          textStyle: context.h4.w5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Mayan, Mexico',
                        style: GoogleFonts.ibmPlexMono(textStyle: context.h8),
                      ),
                      const SizedBox(height: 16),

                      SizedBox(
                        width: 240,
                        child: GridView.count(
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          shrinkWrap: true,
                          childAspectRatio: 3,
                          children: List.generate(4, (index) {
                            return ListTile(
                              onTap: () {},
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 4,
                              ),
                              leading: Icon(CupertinoIcons.heart),
                              titleAlignment: ListTileTitleAlignment.top,
                              title: Text('Heart'),
                              dense: true,
                            );
                          }),
                        ),
                      ),
                      const SizedBox(height: 16),
                      GridView.count(
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 3,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        shrinkWrap: true,
                        children: List.generate(6, (index) {
                          return Container(
                            decoration: BoxDecoration(
                              color: context.cSur2,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.yard_outlined,
                                  size: 50,
                                  color: context.cSur10,
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Item ${index + 1}',
                                  style: context.h8.c(context.cSur10),
                                ),
                              ],
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Mayan, Mexico',
                        style: GoogleFonts.ibmPlexMono(textStyle: context.h8),
                      ),
                      const SizedBox(height: 8),
                      OptionBox(
                        options: [
                          Option(
                            value: "1",
                            title: Text("Home"),
                            secondary: Icon(CupertinoIcons.cloud_moon_rain),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Mayan, Mexico"),
                                Text("Mayan, Mexico"),
                              ],
                            ),
                          ),
                          Option(
                            value: "2",
                            title: Text("Home"),
                            secondary: Icon(CupertinoIcons.cloud_moon_rain),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Mayan, Mexico"),
                                Text("Mayan, Mexico"),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: context.cs.surface,
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 4),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '\$108.Day',
                        style: GoogleFonts.ibmPlexMono(
                          textStyle: context.h7.w5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      MaskedRatingBar(rating: 4.48),
                    ],
                  ),
                  FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: context.cs.secondary,
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 20,
                      ),
                    ),
                    onPressed: () {},
                    child: Text(
                      'Check Availability',
                      style: context.h8.c(context.cs.onSecondary),
                    ),
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

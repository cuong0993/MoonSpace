import 'package:example/pages/quiz.dart';
import 'package:example/pages/travel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moonspace/carousel/curved_carousel.dart';
import 'package:moonspace/helper/extensions/theme_ext.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:go_router/go_router.dart';

part 'compass.g.dart';

List<RouteBase> get compassRoutes => $appRoutes;

@TypedGoRoute<RootRoute>(
  path: '/compass',
  routes: [
    TypedGoRoute<CountriesRoute>(
      path: 'countries',
      routes: [
        TypedGoRoute<CountryRoute>(
          path: ':country',
          routes: [TypedGoRoute<ActivitiesRoute>(path: '/activities')],
        ),
      ],
    ),
    TypedGoRoute<DestinationListRoute>(path: 'destinations-list'),
    TypedGoRoute<ActivityListRoute>(path: 'activities-list'),
  ],
)
class RootRoute extends GoRouteData with _$RootRoute {
  const RootRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return Scaffold(
      appBar: CompassAppBar(),
      body: Column(
        children: [
          IconButton(
            onPressed: () {
              CountriesRoute().push(context);
            },
            icon: Icon(CupertinoIcons.cube),
          ),
        ],
      ),
    );
  }
}

class CountriesRoute extends GoRouteData with _$CountriesRoute {
  const CountriesRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return Consumer(
      builder: (context, ref, child) {
        final asyncContinents = ref.watch(continentsProvider);

        return Scaffold(
          appBar: CompassAppBar(),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(height: 80, child: Placeholder()),

                  const SizedBox(height: 16),

                  ClipRRect(
                    child: asyncContinents.when(
                      data: (countries) {
                        if (countries.isEmpty) return const SizedBox();

                        return CurvedCarousel(
                          height: 150,
                          // width: context.mq.w,
                          rotationMultiplier: 0,
                          xMultiplier: 2.2,
                          yMultiplier: 0,
                          opacityMin: 1,
                          scaleMin: 1,
                          alignment: Alignment.centerLeft,
                          count: countries.length,
                          staticBuilder: (index) {
                            return NewWidget(
                              index: index,
                              countries: countries,
                            );
                          },
                        );
                      },
                      loading: () => Placeholder(),
                      error: (error, stack) => Text('Error: $error'),
                    ),
                  ),

                  const SizedBox(height: 16),

                  ListTile(
                    onTap: () async {
                      final daterange = await showDateRangePicker(
                        context: context,
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now(),
                      );
                    },
                    title: Text("When"),
                  ),

                  ListTile(
                    onTap: () async {
                      final daterange = await showDateRangePicker(
                        context: context,
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now(),
                      );
                    },
                    title: Text("Who"),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class NewWidget extends StatelessWidget {
  const NewWidget({super.key, required this.index, required this.countries});

  final int index;
  final List<String> countries;

  @override
  Widget build(BuildContext context) {
    // return GestureDetector(
    //   onTap: () {
    //     print(countries[index]);
    //     CountryRoute(countries[index]).push(context);
    //   },

    //   child: Material(
    //     color: Colors.transparent,
    //     child: Stack(
    //       alignment: Alignment.center,
    //       children: [
    //         Container(
    //           height: 140,
    //           width: 140,
    //           foregroundDecoration: BoxDecoration(
    //             color: const Color(0x1A252525),
    //           ),
    //           child: CustomCacheImage(
    //             imageUrl: images[index % images.length],
    //             borderRadius: 24,
    //           ),
    //         ),
    //         Text(countries[index], style: context.h5),
    //       ],
    //     ),
    //   ),
    // );

    Widget content = Material(
      color: Colors.transparent,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            child: Container(
              height: 140,
              width: 140,
              foregroundDecoration: BoxDecoration(
                color: const Color(0x1A252525),
              ),
              child: CustomCacheImage(
                imageUrl: images[index % images.length],
                borderRadius: 24,
              ),
            ),
          ),
          Text(countries[index], style: context.h5),
        ],
      ),
    );

    // Widget content = Stack(
    //   alignment: AlignmentDirectional.center,
    //   children: [
    //     Hero(
    //       tag: 'food-c-$index',
    //       child: Container(
    //         width: 140,
    //         decoration: BoxDecoration(
    //           image: DecorationImage(
    //             image: AssetImage(
    //               'assets/images/cover_slider/food-c-$index.jpg',
    //             ),
    //             fit: BoxFit.cover,
    //           ),
    //           borderRadius: BorderRadius.circular(24),
    //         ),
    //       ),
    //     ),

    //     Hero(
    //       tag: 'food-c-$index-title',
    //       child: Text("c", style: GoogleFonts.agbalumo(textStyle: context.h4)),
    //     ),

    //     Align(
    //       alignment: Alignment(0, -.9),
    //       child: Container(
    //         padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    //         decoration: BoxDecoration(
    //           color: context.cs.secondary,
    //           borderRadius: BorderRadius.circular(32),
    //         ),
    //         child: Text(
    //           "FriendShip",
    //           style: GoogleFonts.agbalumo(
    //             textStyle: context.h4.c(context.cs.onSecondary),
    //           ),
    //         ),
    //       ),
    //     ),
    //   ],
    // );

    return GestureDetector(onTap: () => print(index), child: content);
  }
}

class CountryRoute extends GoRouteData with _$CountryRoute {
  const CountryRoute(this.country);

  final String country;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return Scaffold(appBar: CompassAppBar(), body: Placeholder());
  }
}

class DestinationListRoute extends GoRouteData with _$DestinationListRoute {
  const DestinationListRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const DestinationListScreen();
}

class ActivitiesRoute extends GoRouteData with _$ActivitiesRoute {
  const ActivitiesRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ActivityListScreen();
}

class ActivityListRoute extends GoRouteData with _$ActivityListRoute {
  const ActivityListRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ActivityListScreen();
}

class Destination {
  final String ref;
  final String name;
  final String country;
  final String continent;
  final String knownFor;
  final List<String> tags;
  final String imageUrl;

  Destination({
    required this.ref,
    required this.name,
    required this.country,
    required this.continent,
    required this.knownFor,
    required this.tags,
    required this.imageUrl,
  });

  factory Destination.fromJson(Map<String, dynamic> json) {
    return Destination(
      ref: json['ref'],
      name: json['name'],
      country: json['country'],
      continent: json['continent'],
      knownFor: json['knownFor'],
      tags: List<String>.from(json['tags']),
      imageUrl: json['imageUrl'],
    );
  }
}

@Riverpod(keepAlive: true)
class Destinations extends _$Destinations {
  @override
  FutureOr<List<Destination>> build() async {
    final String response = await rootBundle.loadString(
      'assets/destinations.json',
    );
    final List<dynamic> data = json.decode(response);
    return data.map((json) => Destination.fromJson(json)).toList();
  }
}

@Riverpod(keepAlive: true)
class Continents extends _$Continents {
  @override
  FutureOr<List<String>> build() async {
    final asyncDestinations = ref.watch(destinationsProvider);
    final destinations = asyncDestinations.asData?.value;
    final uniqueContinents = destinations
        ?.map((destination) => destination.continent)
        .toSet()
        .toList();

    return uniqueContinents ?? [];
  }
}

class DestinationListScreen extends ConsumerWidget {
  const DestinationListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncDestinations = ref.watch(destinationsProvider);

    return Scaffold(
      appBar: CompassAppBar(),
      body: asyncDestinations.when(
        data: (destinations) {
          return ListView.builder(
            itemCount: destinations.length,
            itemBuilder: (context, index) {
              final destination = destinations[index];
              return ListTile(
                title: Text(destination.name),
                subtitle: Text(destination.country),
                leading: Image.network(destination.imageUrl),
              );
            },
          );
        },
        loading: () => Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}

class Activity {
  final String name;
  final String description;
  final String locationName;
  final int duration; // in hours
  final String timeOfDay;
  final bool familyFriendly;
  final int price; // price level (1-5)
  final String destinationRef;
  final String ref;
  final String imageUrl;

  Activity({
    required this.name,
    required this.description,
    required this.locationName,
    required this.duration,
    required this.timeOfDay,
    required this.familyFriendly,
    required this.price,
    required this.destinationRef,
    required this.ref,
    required this.imageUrl,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      name: json['name'],
      description: json['description'],
      locationName: json['locationName'],
      duration: (json['duration'] as num).toInt(), // Convert to int
      timeOfDay: json['timeOfDay'],
      familyFriendly: json['familyFriendly'],
      price: (json['price'] as num).toInt(), // Convert to int
      destinationRef: json['destinationRef'],
      ref: json['ref'],
      imageUrl: json['imageUrl'],
    );
  }
}

@Riverpod(keepAlive: true)
FutureOr<List<Activity>> activities(Ref ref) async {
  final String response = await rootBundle.loadString('assets/activities.json');
  final List<dynamic> data = json.decode(response);
  return data.map((json) => Activity.fromJson(json)).toList();
}

class ActivityListScreen extends ConsumerWidget {
  const ActivityListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Consumer(
      builder: (context, ref, child) {
        final asyncActivities = ref.watch(activitiesProvider);
        return Scaffold(
          appBar: AppBar(title: Text('Activities')),
          body: asyncActivities.when(
            data: (activities) {
              return ListView.builder(
                itemCount: activities.length,
                itemBuilder: (context, index) {
                  final activity = activities[index];
                  return ListTile(
                    title: Text(activity.name),
                    subtitle: Text(activity.description),
                    leading: Image.network(activity.imageUrl),
                    onTap: () {
                      // Handle activity tap
                    },
                  );
                },
              );
            },
            loading: () => Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(child: Text('Error: $error')),
          ),
        );
      },
    );
  }
}

class CompassAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CompassAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        onPressed: () {
          context.pop();
        },
        icon: Icon(CupertinoIcons.arrow_left),
      ),
      title: Text(GoRouterState.of(context).uri.path),
      actions: [
        IconButton(
          onPressed: () {
            ActivityListRoute().push(context);
          },
          icon: Icon(CupertinoIcons.slowmo),
        ),
        IconButton(
          onPressed: () {
            DestinationListRoute().push(context);
          },
          icon: Icon(CupertinoIcons.cube),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

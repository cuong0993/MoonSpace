import 'package:flutter/material.dart';
import 'package:example/ariana/main.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:example/cool_card_swiper/main.dart';
import 'package:example/cover_carousel.dart';
import 'package:example/flutter_custom_carousel/main.dart';
import 'package:example/flutter_custom_carousel/views/hooa.dart';
import 'package:example/recipes/main.dart';
import 'package:example/renderobject/main.dart';
import 'package:example/vignettes/basketball_ptr/lib/main.dart';
import 'package:example/vignettes/bubble_tab_bar/lib/main.dart';
import 'package:example/vignettes/constellations_list/lib/main.dart';
import 'package:example/vignettes/dark_ink_transition/lib/main.dart';
import 'package:example/vignettes/drink_rewards_list/lib/main.dart';
import 'package:example/vignettes/fluid_nav_bar/lib/main.dart';
import 'package:example/vignettes/gooey_edge/lib/main.dart';
import 'package:example/vignettes/indie_3d/lib/main.dart';
import 'package:example/vignettes/parallax_travel_cards_hero/lib/main.dart';
import 'package:example/vignettes/parallax_travel_cards_list/lib/main.dart';
import 'package:example/vignettes/particle_swipe/lib/main.dart';
import 'package:example/vignettes/plant_forms/lib/main.dart';
import 'package:example/vignettes/product_detail_zoom/lib/main.dart';
import 'package:example/vignettes/sparkle_party/lib/main.dart';
import 'package:example/vignettes/spending_tracker/lib/main.dart';
import 'package:example/vignettes/ticket_fold/lib/main.dart';

part 'main.g.dart';

void main() {
  // runApp(BasketballPtr());
  // runApp(BubbleTabBar());
  // runApp(ConstellationsList());
  // runApp(DarkInkTransition());
  // runApp(DrinkRewardList());
  // runApp(DarkInkTransition());
  // runApp(FluidNavBarApp());
  // runApp(GooeyEdgeApp());
  // runApp(Indie3D());
  // runApp(ParallaxTravelcardsHero());
  // runApp(ParallaxTravelCardsList());
  // runApp(ParticleSwipe());
  // runApp(PlantForms());
  // runApp(ProductDetailZoom());
  // runApp(SparklePartyApp());
  // runApp(SpendingTracker());
  // runApp(TicketFoldApp());

  // Compassmain();
  // CoolCardSwipermain();
  Recipesmain();
  // runApp(CoverCarouselPage());
  // runApp(CarouselApp());
  // runApp(Ariana());
  // runApp(RenderHome());
  // runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const Home(),
    );
  }
}

@riverpod
class Counter extends _$Counter {
  @override
  int build() {
    return 0;
  }

  void increment() => state++;
}

class Home extends ConsumerWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Counter example')),
      body: Column(
        children: [Center(child: Text('${ref.watch(counterProvider)}'))],
      ),
      floatingActionButton: FloatingActionButton(
        // The read method is a utility to read a provider without listening to it
        onPressed: () => ref.read(counterProvider.notifier).increment(),
        child: const Icon(Icons.add),
      ),
    );
  }
}

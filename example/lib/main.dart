import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:example/ariana/main.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import 'package:intl/intl.dart' as intl;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moonspace/electrify.dart';
import 'package:moonspace/form/async_text_field.dart';
import 'package:moonspace/helper/extensions/theme_ext.dart';
import 'package:moonspace/provider/global_theme.dart';
import 'package:moonspace/theme.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:example/cool_card_swiper/main.dart';
import 'package:example/cover_carousel.dart';
import 'package:example/flutter_custom_carousel/main.dart';
import 'package:example/flutter_custom_carousel/views/hooa.dart';
import 'package:example/recipes/main.dart';
import 'package:example/renderobject/main.dart';
import 'package:example/vignettes/basketball_ptr/lib/main.dart';
import 'package:example/vignettes/bubble_tab_bar/main.dart';
import 'package:example/vignettes/constellations_list/lib/main.dart';
import 'package:example/vignettes/dark_ink_transition/main.dart';
import 'package:example/vignettes/drink_rewards_list/main.dart';
import 'package:example/vignettes/gooey_edge/lib/main.dart';
import 'package:example/vignettes/parallax_travel_cards_hero/lib/main.dart';
import 'package:example/vignettes/parallax_travel_cards_list/lib/main.dart';
import 'package:example/vignettes/particle_swipe/lib/main.dart';
import 'package:example/vignettes/product_detail_zoom/lib/main.dart';
import 'package:example/vignettes/sparkle_party/lib/main.dart';
import 'package:example/vignettes/spending_tracker/lib/main.dart';
import 'package:example/vignettes/ticket_fold/lib/main.dart';

part 'main.g.dart';

void main() {
  // runApp(BubbleTabBar());
  // runApp(DarkInkTransition());
  // runApp(DrinkRewardList());
  // runApp(ParallaxTravelCardsList());

  // runApp(BasketballPtr());
  // runApp(ConstellationsList());
  // runApp(GooeyEdgeApp());
  // runApp(ParallaxTravelcardsHero());
  // runApp(ParticleSwipe());
  // runApp(ProductDetailZoom());
  // runApp(SparklePartyApp());
  // runApp(SpendingTracker());
  // runApp(TicketFoldApp());

  // Compassmain();
  // CoolCardSwipermain();
  // runApp(const ProviderScope(child: RecipesApp()));
  // runApp(CoverCarouselPage());
  // runApp(CarouselApp());
  // runApp(Ariana());
  // runApp(RenderHome());

  electrify(
    title: "Home",
    before: (widgetsBinding) {},
    after: () {},
    electricKey: GlobalKey<NavigatorState>(),
    router: GoRouter(
      routes: [
        GoRoute(
          path: "/",
          builder: (context, state) {
            return Home();
          },
        ),
        GoRoute(
          path: "/typography",
          builder: (context, state) {
            return TypographyScreen();
          },
        ),
      ],
    ),
    init: () async {},
    errorChild: Text("error"),
    recordFlutterFatalError: (details) {},
    recordError: (error, stack) {},
    providerInit: (providerContainer) {},
    debugUi: false,
  );
}

@riverpod
class Counter extends _$Counter {
  @override
  int build() {
    return 0;
  }

  void increment() => state++;
}

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  final _formKey = GlobalKey<FormState>();

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(title: const Text('Counter example')),

      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: AutofillGroup(
            child: Column(
              children: [
                ...[
                  TextButton(
                    onPressed: () {
                      context.push("/typography");
                    },
                    child: Text("typography"),
                  ),

                  Text('${ref.watch(counterProvider)}'),

                  AsyncTextFormField(
                    key: ValueKey('Nick'),
                    initialValue: "user?.nick",
                    autocorrect: false,
                    enableSuggestions: false,
                    enabled: true,
                    maxLines: 1,
                    asyncValidator: (value) async {
                      return null;
                    },
                    textInputAction: TextInputAction.done,
                    decoration: (asyncText, textCon) => InputDecoration(
                      errorText: 'error text',
                      helperText: 'helper',
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Buttons(isDisabled: false, hasIcon: false),
                      Buttons(isDisabled: false, hasIcon: true),
                      Buttons(isDisabled: true, hasIcon: false),
                    ],
                  ),

                  Row(
                    children: [
                      Switch(
                        thumbIcon: thumbIcon,
                        value: false,
                        onChanged: (value) {},
                      ),
                      Switch(
                        thumbIcon: thumbIcon,
                        value: true,
                        onChanged: (value) {},
                      ),
                    ],
                  ),

                  Slider(
                    max: 100,
                    divisions: 5,
                    value: 30,
                    label: "30",
                    onChanged: (value) {},
                  ),

                  Column(
                    children: [
                      const SizedBox(
                        height: 520,
                        child: NavigationDrawerSection(),
                      ),
                      TextButton(
                        child: const Text(
                          'Show modal navigation drawer',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          scaffoldKey.currentState!.openEndDrawer();
                        },
                      ),
                    ],
                  ),

                  Row(
                    children: [
                      IconButton.filled(
                        isSelected: true,
                        icon: const Icon(Icons.settings_outlined),
                        selectedIcon: const Icon(Icons.settings),
                        onPressed: () {},
                      ),
                      IconButton.filledTonal(
                        isSelected: true,
                        icon: const Icon(Icons.settings_outlined),
                        selectedIcon: const Icon(Icons.settings),
                        onPressed: () {},
                      ),
                      IconButton.outlined(
                        isSelected: true,
                        icon: const Icon(Icons.settings_outlined),
                        selectedIcon: const Icon(Icons.settings),
                        onPressed: () {},
                      ),
                      IconButton(
                        isSelected: true,
                        icon: const Icon(Icons.settings_outlined),
                        selectedIcon: const Icon(Icons.settings),
                        onPressed: () {},
                      ),

                      ActionChip(
                        label: const Text('Assist'),
                        avatar: const Icon(Icons.event),
                        onPressed: () {},
                      ),
                      FilterChip(
                        label: const Text('Filter'),
                        selected: true,
                        onSelected: (selected) {},
                      ),
                      InputChip(
                        label: const Text('Input'),
                        onPressed: () {},
                        onDeleted: () {},
                      ),
                    ],
                  ),

                  DefaultTabController(
                    length: 3,
                    child: TabBar(
                      tabs: const <Widget>[
                        Tab(
                          icon: Icon(Icons.videocam_outlined),
                          text: 'Video',
                          iconMargin: EdgeInsets.only(bottom: 0.0),
                        ),
                        Tab(
                          icon: Icon(Icons.photo_outlined),
                          text: 'Photos',
                          iconMargin: EdgeInsets.only(bottom: 0.0),
                        ),
                        Tab(
                          icon: Icon(Icons.audiotrack_sharp),
                          text: 'Audio',
                          iconMargin: EdgeInsets.only(bottom: 0.0),
                        ),
                      ],
                    ),
                  ),

                  IntrinsicWidth(
                    child: SizedBox(
                      height: 420,
                      child: NavigationRailSection(),
                    ),
                  ),

                  IconButtonAnchorExample(),

                  ConstrainedBox(
                    constraints: const BoxConstraints.tightFor(height: 150),
                    child: CarouselView(
                      itemSnapping: true,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                      ),
                      shrinkExtent: 100,
                      itemExtent: 180,
                      children: List<Widget>.generate(20, (index) {
                        return Center(child: Text('Item $index'));
                      }),
                    ),
                  ),

                  Card(
                    color: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest,
                    elevation: 0,
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(10, 5, 5, 10),
                    ),
                  ),

                  Menus(),

                  Wrap(
                    alignment: WrapAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        child: const Text(
                          'Show modal bottom sheet',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          showModalBottomSheet<void>(
                            showDragHandle: true,
                            context: context,
                            // TODO: Remove when this is in the framework https://github.com/flutter/flutter/issues/118619
                            constraints: const BoxConstraints(maxWidth: 640),
                            builder: (context) {
                              return SizedBox(
                                height: 150,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 32.0,
                                  ),
                                  child: ListView(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    children: [Text("Hello")],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                      TextButton(
                        child: Text(
                          'Show bottom sheet',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          showBottomSheet(
                            elevation: 8.0,
                            context: context,
                            // TODO: Remove when this is in the framework https://github.com/flutter/flutter/issues/118619
                            constraints: const BoxConstraints(maxWidth: 640),
                            builder: (context) {
                              return SizedBox(
                                height: 150,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 32.0,
                                  ),
                                  child: ListView(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    children: [Text("Hello")],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),

                  SegmentedButton(
                    segments: const <ButtonSegment>[
                      ButtonSegment(
                        value: "Sizes.extraSmall",
                        label: Text('XS'),
                      ),
                      ButtonSegment(value: "Sizes.small", label: Text('S')),
                      ButtonSegment(value: "Sizes.medium", label: Text('M')),
                      ButtonSegment(value: "Sizes.large", label: Text('L')),
                      ButtonSegment(
                        value: "Sizes.extraLarge",
                        label: Text('XL'),
                      ),
                    ],
                    selected: {"Sizes.small"},
                    onSelectionChanged: (newSelection) {},
                    multiSelectionEnabled: true,
                  ),

                  AlertDialog(
                    title: const Text('What is a dialog?'),
                    content: const Text(
                      'A dialog is a type of modal window that appears in front of app content to provide critical information, or prompt for a decision to be made.',
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('Dismiss'),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      FilledButton(
                        child: const Text('Okay'),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),

                  // NavigationBar(
                  //   selectedIndex: selectedIndex,
                  //   onDestinationSelected: (index) {
                  //     setState(() {
                  //       selectedIndex = index;
                  //     });
                  //     if (!widget.isExampleBar) widget.onSelectItem!(index);
                  //   },
                  //   destinations: widget.isExampleBar && widget.isBadgeExample
                  //       ? barWithBadgeDestinations
                  //       : widget.isExampleBar
                  //       ? exampleBarDestinations
                  //       : appBarDestinations,
                  // ),
                  CupertinoFormSection.insetGrouped(
                    margin: EdgeInsetsGeometry.zero,
                    children: [
                      ThemeBrightnessButton(),
                      ThemePopupButton(),
                      ThemeColorSelector(),
                    ],
                  ),
                ].expand((widget) => [widget, const SizedBox(height: 24)]),
              ],
            ),
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        // The read method is a utility to read a provider without listening to it
        onPressed: () => ref.read(counterProvider.notifier).increment(),
        child: const Icon(Icons.add),
      ),

      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: <Widget>[
            const IconButtonAnchorExample(),
            IconButton(
              tooltip: 'Search',
              icon: const Icon(Icons.search),
              onPressed: () {},
            ),
            IconButton(
              tooltip: 'Favorite',
              icon: const Icon(Icons.favorite),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class TypographyScreen extends StatelessWidget {
  const TypographyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(
      context,
    ).textTheme.apply(displayColor: Theme.of(context).colorScheme.onSurface);
    return Scaffold(
      appBar: AppBar(leading: BackButton()),
      body: Expanded(
        child: ListView(
          children: <Widget>[
            const SizedBox(height: 8),
            Text('Display Large', style: textTheme.displayLarge!),
            Text('Display Medium', style: textTheme.displayMedium!),
            Text('Display Small', style: textTheme.displaySmall!),
            Text('Headline Large', style: textTheme.headlineLarge!),
            Text('Headline Medium', style: textTheme.headlineMedium!),
            Text('Headline Small', style: textTheme.headlineSmall!),
            Text('Title Large', style: textTheme.titleLarge!),
            Text('Title Medium', style: textTheme.titleMedium!),
            Text('Title Small', style: textTheme.titleSmall!),
            Text('Label Large', style: textTheme.labelLarge!),
            Text('Label Medium', style: textTheme.labelMedium!),
            Text('Label Small', style: textTheme.labelSmall!),
            Text('Body Large', style: textTheme.bodyLarge!),
            Text('Body Medium', style: textTheme.bodyMedium!),
            Text('Body Small', style: textTheme.bodySmall!),
          ],
        ),
      ),
    );
  }
}

class Buttons extends StatelessWidget {
  final bool isDisabled;
  final bool hasIcon;

  const Buttons({super.key, required this.isDisabled, required this.hasIcon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: IntrinsicWidth(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            hasIcon
                ? ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.add),
                    label: const Text('Icon'),
                  )
                : ElevatedButton(
                    onPressed: isDisabled ? null : () {},
                    child: const Text('Elevated'),
                  ),
            hasIcon
                ? FilledButton.icon(
                    onPressed: () {},
                    label: const Text('Icon'),
                    icon: const Icon(Icons.add),
                  )
                : FilledButton(
                    onPressed: isDisabled ? null : () {},
                    child: const Text('Filled'),
                  ),
            hasIcon
                ? FilledButton.tonalIcon(
                    onPressed: () {},
                    label: const Text('Icon'),
                    icon: const Icon(Icons.add),
                  )
                : FilledButton.tonal(
                    onPressed: isDisabled ? null : () {},
                    child: const Text('Filled tonal'),
                  ),
            hasIcon
                ? OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.add),
                    label: const Text('Icon'),
                  )
                : OutlinedButton(
                    onPressed: isDisabled ? null : () {},
                    child: const Text('Outlined'),
                  ),
            hasIcon
                ? TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.add),
                    label: const Text('Icon'),
                  )
                : TextButton(
                    onPressed: isDisabled ? null : () {},
                    child: const Text('Text'),
                  ),
          ],
        ),
      ),
    );
  }
}

final WidgetStateProperty<Icon?> thumbIcon =
    WidgetStateProperty.resolveWith<Icon?>((states) {
      if (states.contains(WidgetState.selected)) {
        return const Icon(Icons.check);
      }
      return const Icon(Icons.close);
    });

class NavigationDrawerSection extends StatefulWidget {
  const NavigationDrawerSection({super.key});

  @override
  State<NavigationDrawerSection> createState() =>
      _NavigationDrawerSectionState();
}

class _NavigationDrawerSectionState extends State<NavigationDrawerSection> {
  int navDrawerIndex = 0;

  @override
  Widget build(BuildContext context) {
    return NavigationDrawer(
      onDestinationSelected: (selectedIndex) {
        setState(() {
          navDrawerIndex = selectedIndex;
        });
      },
      selectedIndex: navDrawerIndex,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(28, 16, 16, 10),
          child: Text('Mail', style: Theme.of(context).textTheme.titleSmall),
        ),
        ...destinations.map((destination) {
          return NavigationDrawerDestination(
            label: Text(destination.label),
            icon: destination.icon,
            selectedIcon: destination.selectedIcon,
          );
        }),
        const Divider(indent: 28, endIndent: 28),
        Padding(
          padding: const EdgeInsets.fromLTRB(28, 16, 16, 10),
          child: Text('Labels', style: Theme.of(context).textTheme.titleSmall),
        ),
        ...labelDestinations.map((destination) {
          return NavigationDrawerDestination(
            label: Text(destination.label),
            icon: destination.icon,
            selectedIcon: destination.selectedIcon,
          );
        }),
      ],
    );
  }
}

class ExampleDestination {
  const ExampleDestination(this.label, this.icon, this.selectedIcon);

  final String label;
  final Widget icon;
  final Widget selectedIcon;
}

const List<ExampleDestination> destinations = <ExampleDestination>[
  ExampleDestination('Inbox', Icon(Icons.inbox_outlined), Icon(Icons.inbox)),
  ExampleDestination('Outbox', Icon(Icons.send_outlined), Icon(Icons.send)),
  ExampleDestination(
    'Favorites',
    Icon(Icons.favorite_outline),
    Icon(Icons.favorite),
  ),
  ExampleDestination('Trash', Icon(Icons.delete_outline), Icon(Icons.delete)),
];

const List<ExampleDestination> labelDestinations = <ExampleDestination>[
  ExampleDestination(
    'Family',
    Icon(Icons.bookmark_border),
    Icon(Icons.bookmark),
  ),
  ExampleDestination(
    'School',
    Icon(Icons.bookmark_border),
    Icon(Icons.bookmark),
  ),
  ExampleDestination('Work', Icon(Icons.bookmark_border), Icon(Icons.bookmark)),
];

class NavigationRailSection extends StatefulWidget {
  const NavigationRailSection({super.key});

  @override
  State<NavigationRailSection> createState() => _NavigationRailSectionState();
}

class _NavigationRailSectionState extends State<NavigationRailSection> {
  int navRailIndex = 0;

  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      onDestinationSelected: (selectedIndex) {
        setState(() {
          navRailIndex = selectedIndex;
        });
      },
      elevation: 4,
      leading: FloatingActionButton(
        child: const Icon(Icons.create),
        onPressed: () {},
      ),
      groupAlignment: 0.0,
      selectedIndex: navRailIndex,
      labelType: NavigationRailLabelType.selected,
      destinations: <NavigationRailDestination>[
        ...destinations.map((destination) {
          return NavigationRailDestination(
            label: Text(destination.label),
            icon: destination.icon,
            selectedIcon: destination.selectedIcon,
          );
        }),
      ],
    );
  }
}

class IconButtonAnchorExample extends StatelessWidget {
  const IconButtonAnchorExample({super.key});

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      builder: (context, controller, child) {
        return IconButton(
          onPressed: () {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
          icon: const Icon(Icons.more_vert),
        );
      },
      menuChildren: [
        MenuItemButton(child: const Text('Menu 1'), onPressed: () {}),
        MenuItemButton(child: const Text('Menu 2'), onPressed: () {}),
        SubmenuButton(
          menuChildren: <Widget>[
            MenuItemButton(onPressed: () {}, child: const Text('Menu 3.1')),
            MenuItemButton(onPressed: () {}, child: const Text('Menu 3.2')),
            MenuItemButton(onPressed: () {}, child: const Text('Menu 3.3')),
          ],
          child: const Text('Menu 3'),
        ),
      ],
    );
  }
}

class Menus extends StatefulWidget {
  const Menus({super.key});

  @override
  State<Menus> createState() => _MenusState();
}

class _MenusState extends State<Menus> {
  final TextEditingController colorController = TextEditingController();
  final TextEditingController iconController = TextEditingController();
  IconLabel? selectedIcon = IconLabel.smile;
  ColorLabel? selectedColor;

  @override
  Widget build(BuildContext context) {
    final List<DropdownMenuEntry<ColorLabel>> colorEntries =
        <DropdownMenuEntry<ColorLabel>>[];
    for (final ColorLabel color in ColorLabel.values) {
      colorEntries.add(
        DropdownMenuEntry<ColorLabel>(
          value: color,
          label: color.label,
          enabled: color.label != 'Grey',
        ),
      );
    }

    final List<DropdownMenuEntry<IconLabel>> iconEntries =
        <DropdownMenuEntry<IconLabel>>[];
    for (final IconLabel icon in IconLabel.values) {
      iconEntries.add(
        DropdownMenuEntry<IconLabel>(value: icon, label: icon.label),
      );
    }

    return Wrap(
      alignment: WrapAlignment.spaceAround,
      runAlignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 4,
      runSpacing: 4,
      children: [
        DropdownMenu<ColorLabel>(
          controller: colorController,
          label: const Text('Color'),
          enableFilter: true,
          dropdownMenuEntries: colorEntries,
          inputDecorationTheme: const InputDecorationTheme(filled: true),
          onSelected: (color) {
            setState(() {
              selectedColor = color;
            });
          },
        ),
        DropdownMenu<IconLabel>(
          initialSelection: IconLabel.smile,
          controller: iconController,
          leadingIcon: const Icon(Icons.search),
          label: const Text('Icon'),
          dropdownMenuEntries: iconEntries,
          onSelected: (icon) {
            setState(() {
              selectedIcon = icon;
            });
          },
        ),
        Icon(
          selectedIcon?.icon,
          color: selectedColor?.color ?? Colors.grey.withAlpha(128),
        ),
      ],
    );
  }
}

enum ColorLabel {
  blue('Blue', Colors.blue),
  pink('Pink', Colors.pink),
  green('Green', Colors.green),
  yellow('Yellow', Colors.yellow),
  grey('Grey', Colors.grey);

  const ColorLabel(this.label, this.color);
  final String label;
  final Color color;
}

enum IconLabel {
  smile('Smile', Icons.sentiment_satisfied_outlined),
  cloud('Cloud', Icons.cloud_outlined),
  brush('Brush', Icons.brush_outlined),
  heart('Heart', Icons.favorite);

  const IconLabel(this.label, this.icon);
  final String label;
  final IconData icon;
}

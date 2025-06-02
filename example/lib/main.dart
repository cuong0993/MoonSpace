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
import 'package:moonspace/form/form.dart';
import 'package:moonspace/form/select.dart';
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

  // runApp(ColorSchemeExample());

  electrify(
    title: "Home",
    before: (widgetsBinding) {},
    after: () {},
    router: () => GoRouter(
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
    init: (c) async {},
    errorChild: Text("error"),
    recordFlutterFatalError: (details) {},
    recordError: (error, stack) {},
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

      endDrawer: IntrinsicWidth(
        child: SizedBox(height: 420, child: NavigationRailSection()),
      ),

      // endDrawer: SizedBox(height: 520, child: NavigationDrawerSection()),
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
                    children: [
                      Flexible(
                        child: OptionBox(
                          options: [
                            Option(value: "Witch", selected: true),
                            Option(value: "Wizard"),
                            Option(value: "Sorceror"),
                          ],
                        ),
                      ),
                      Flexible(
                        child: OptionBox(
                          options: [
                            Option(value: "Witch", selected: true),
                            Option(value: "Wizard"),
                            Option(value: "Sorceror"),
                          ],
                          multi: true,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: OptionBox(
                          options: [
                            Option(value: "Witch", selected: true),
                            Option(value: "Wizard"),
                            Option(value: "Sorceror"),
                          ],
                          multi: false,
                          display: OptionDisplay.switchTile,
                        ),
                      ),

                      Flexible(
                        child: OptionBox(
                          options: [
                            Option(value: "Witch", selected: true),
                            Option(value: "Wizard"),
                            Option(value: "Sorceror"),
                          ],
                          display: OptionDisplay.chip,
                        ),
                      ),
                    ],
                  ),

                  Row(
                    children: [
                      Card(
                        color: context.cs.surface,
                        // elevation: 0,
                        child: Container(
                          width: 100,
                          height: 100,
                          alignment: Alignment.center,
                          child: Text("surface"),
                        ),
                      ),
                      Card(
                        // elevation: 0,
                        child: Container(
                          width: 100,
                          height: 100,
                          alignment: Alignment.center,
                          child: Text("none"),
                        ),
                      ),
                      Card(
                        color: context.cs.surfaceContainer,
                        // elevation: 0,
                        child: Container(
                          width: 100,
                          height: 100,
                          alignment: Alignment.center,
                          child: Text("surcon"),
                        ),
                      ),
                      Card(
                        color: context.cs.surfaceContainerHighest,
                        // elevation: 0,
                        child: Container(
                          width: 100,
                          height: 100,
                          alignment: Alignment.center,
                          child: Text("surconh"),
                        ),
                      ),
                    ],
                  ),

                  Box(
                    title: Text("Title"),
                    children: (context) => [Text("Hello"), Text("Hello")],
                    actions: (context) {
                      return Row(
                        children: [
                          TextButton(onPressed: () {}, child: Text("Dismiss")),
                          FilledButton(onPressed: () {}, child: Text("ok")),
                        ],
                      );
                    },
                  ),

                  Menus(),

                  SegmentedButton<String>(
                    segments: const <ButtonSegment<String>>[
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

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Buttons(isDisabled: false, hasIcon: false),
                      Buttons(isDisabled: false, hasIcon: true),
                      Buttons(isDisabled: true, hasIcon: false),
                    ],
                  ),

                  IconButtonAnchorExample(),

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

                  const SizedBox(
                    height: 520,
                    child: Row(
                      children: [
                        NavigationDrawerSection(),

                        IntrinsicWidth(child: NavigationRailSection()),
                      ],
                    ),
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

                  NavigationBar(
                    labelBehavior:
                        NavigationDestinationLabelBehavior.onlyShowSelected,
                    selectedIndex: 1,
                    onDestinationSelected: (int index) {},
                    destinations: const <Widget>[
                      NavigationDestination(
                        icon: Icon(Icons.explore),
                        label: 'Explore',
                      ),
                      NavigationDestination(
                        icon: Icon(Icons.commute),
                        label: 'Commute',
                      ),
                      NavigationDestination(
                        selectedIcon: Icon(Icons.bookmark),
                        icon: Icon(Icons.bookmark_border),
                        label: 'Saved',
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

                  MaterialBanner(
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

                  CupertinoFormSection.insetGrouped(
                    margin: EdgeInsetsGeometry.zero,
                    backgroundColor: Colors.transparent,
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
    return Scaffold(
      appBar: AppBar(leading: BackButton()),
      body: Row(
        children: [
          Expanded(
            child: ListView(
              children: <Widget>[
                const SizedBox(height: 8),
                Text('Display Large', style: context.dl),
                Text('Display Medium', style: context.dm),
                Text('Display Small', style: context.ds),
                Text('Headline Large', style: context.hl),
                Text('Headline Medium', style: context.hm),
                Text('Headline Small', style: context.hs),
                Text('Title Large', style: context.tl),
                Text('Title Medium', style: context.tm),
                Text('Title Small', style: context.ts),
                Text('Body Large', style: context.bl),
                Text('Body Medium', style: context.bm),
                Text('Body Small', style: context.bs),
                Text('Label Large', style: context.ll),
                Text('Label Medium', style: context.lm),
                Text('Label Small', style: context.ls),
              ],
            ),
          ),
          Expanded(
            child: Theme(
              data: ThemeData(brightness: context.brightness),
              child: Builder(
                builder: (context) {
                  return ListView(
                    children: <Widget>[
                      const SizedBox(height: 8),
                      Text('Display Large', style: context.dl),
                      Text('Display Medium', style: context.dm),
                      Text('Display Small', style: context.ds),
                      Text('Headline Large', style: context.hl),
                      Text('Headline Medium', style: context.hm),
                      Text('Headline Small', style: context.hs),
                      Text('Title Large', style: context.tl),
                      Text('Title Medium', style: context.tm),
                      Text('Title Small', style: context.ts),
                      Text('Body Large', style: context.bl),
                      Text('Body Medium', style: context.bm),
                      Text('Body Small', style: context.bs),
                      Text('Label Large', style: context.ll),
                      Text('Label Medium', style: context.lm),
                      Text('Label Small', style: context.ls),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
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
            CupertinoButton.filled(
              onPressed: () {},
              child: const Text('Enabled'),
            ),
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
        DrawerHeader(child: Text("Header")),
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
        heroTag: "railnav",
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
        DropdownButton(
          hint: Text("Color"),
          items: colorEntries
              .map((e) => DropdownMenuItem(value: e, child: Text(e.label)))
              .toList(),
          onChanged: (value) {},
        ),
        SizedBox(
          width: 150,
          child: DropdownButtonFormField(
            hint: Text("Color"),
            items: colorEntries
                .map((e) => DropdownMenuItem(value: e, child: Text(e.label)))
                .toList(),
            onChanged: (value) {},
          ),
        ),
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

//------------
//------------
//------------

const Widget divider = SizedBox(height: 10);

class ColorSchemeExample extends StatefulWidget {
  const ColorSchemeExample({super.key});

  @override
  State<ColorSchemeExample> createState() => _ColorSchemeExampleState();
}

class _ColorSchemeExampleState extends State<ColorSchemeExample> {
  Color selectedColor = ColorSeed.baseColor.color;
  Brightness selectedBrightness = Brightness.light;
  double selectedContrast = 0.0;
  static const List<DynamicSchemeVariant> schemeVariants =
      DynamicSchemeVariant.values;

  void updateTheme(Brightness brightness, Color color, double contrastLevel) {
    setState(() {
      selectedBrightness = brightness;
      selectedColor = color;
      selectedContrast = contrastLevel;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: selectedColor,
          brightness: selectedBrightness,
          contrastLevel: selectedContrast,
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('ColorScheme'),
          actions: <Widget>[
            SettingsButton(
              selectedColor: selectedColor,
              selectedBrightness: selectedBrightness,
              selectedContrast: selectedContrast,
              updateTheme: updateTheme,
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List<Widget>.generate(schemeVariants.length, (
                      int index,
                    ) {
                      return ColorSchemeVariantColumn(
                        selectedColor: selectedColor,
                        brightness: selectedBrightness,
                        schemeVariant: schemeVariants[index],
                        contrastLevel: selectedContrast,
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Settings extends StatefulWidget {
  const Settings({
    super.key,
    required this.updateTheme,
    required this.selectedBrightness,
    required this.selectedContrast,
    required this.selectedColor,
  });

  final Brightness selectedBrightness;
  final double selectedContrast;
  final Color selectedColor;

  final void Function(Brightness, Color, double) updateTheme;

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  late Brightness selectedBrightness = widget.selectedBrightness;
  late Color selectedColor = widget.selectedColor;
  late double selectedContrast = widget.selectedContrast;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: selectedColor,
          contrastLevel: selectedContrast,
          brightness: selectedBrightness,
        ),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 200),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: <Widget>[
              Center(
                child: Text(
                  'Settings',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              Row(
                children: <Widget>[
                  const Text('Brightness: '),
                  Switch(
                    value: selectedBrightness == Brightness.light,
                    onChanged: (bool value) {
                      setState(() {
                        selectedBrightness = value
                            ? Brightness.light
                            : Brightness.dark;
                      });
                      widget.updateTheme(
                        selectedBrightness,
                        selectedColor,
                        selectedContrast,
                      );
                    },
                  ),
                ],
              ),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: <Widget>[
                  const Text('Seed color: '),
                  ...List<Widget>.generate(ColorSeed.values.length, (
                    int index,
                  ) {
                    final Color itemColor = ColorSeed.values[index].color;
                    return IconButton(
                      icon: selectedColor == ColorSeed.values[index].color
                          ? Icon(Icons.circle, color: itemColor)
                          : Icon(Icons.circle_outlined, color: itemColor),
                      onPressed: () {
                        setState(() {
                          selectedColor = itemColor;
                        });
                        widget.updateTheme(
                          selectedBrightness,
                          selectedColor,
                          selectedContrast,
                        );
                      },
                    );
                  }),
                ],
              ),
              Row(
                children: <Widget>[
                  const Text('Contrast level: '),
                  Expanded(
                    child: Slider(
                      divisions: 4,
                      label: selectedContrast.toString(),
                      min: -1,
                      value: selectedContrast,
                      onChanged: (double value) {
                        setState(() {
                          selectedContrast = value;
                        });
                        widget.updateTheme(
                          selectedBrightness,
                          selectedColor,
                          selectedContrast,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ColorSchemeVariantColumn extends StatelessWidget {
  const ColorSchemeVariantColumn({
    super.key,
    this.schemeVariant = DynamicSchemeVariant.tonalSpot,
    this.brightness = Brightness.light,
    this.contrastLevel = 0.0,
    required this.selectedColor,
  });

  final DynamicSchemeVariant schemeVariant;
  final Brightness brightness;
  final double contrastLevel;
  final Color selectedColor;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints.tightFor(width: 250),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Text(
              schemeVariant.name == 'tonalSpot'
                  ? '${schemeVariant.name} (Default)'
                  : schemeVariant.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: ColorSchemeView(
              colorScheme: ColorScheme.fromSeed(
                seedColor: selectedColor,
                brightness: brightness,
                contrastLevel: contrastLevel,
                dynamicSchemeVariant: schemeVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ColorSchemeView extends StatelessWidget {
  const ColorSchemeView({super.key, required this.colorScheme});

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ColorGroup(
          children: <ColorChip>[
            ColorChip('primary', colorScheme.primary, colorScheme.onPrimary),
            ColorChip('onPrimary', colorScheme.onPrimary, colorScheme.primary),
            ColorChip(
              'primaryContainer',
              colorScheme.primaryContainer,
              colorScheme.onPrimaryContainer,
            ),
            ColorChip(
              'onPrimaryContainer',
              colorScheme.onPrimaryContainer,
              colorScheme.primaryContainer,
            ),
          ],
        ),
        divider,
        ColorGroup(
          children: <ColorChip>[
            ColorChip(
              'primaryFixed',
              colorScheme.primaryFixed,
              colorScheme.onPrimaryFixed,
            ),
            ColorChip(
              'onPrimaryFixed',
              colorScheme.onPrimaryFixed,
              colorScheme.primaryFixed,
            ),
            ColorChip(
              'primaryFixedDim',
              colorScheme.primaryFixedDim,
              colorScheme.onPrimaryFixedVariant,
            ),
            ColorChip(
              'onPrimaryFixedVariant',
              colorScheme.onPrimaryFixedVariant,
              colorScheme.primaryFixedDim,
            ),
          ],
        ),
        divider,
        ColorGroup(
          children: <ColorChip>[
            ColorChip(
              'secondary',
              colorScheme.secondary,
              colorScheme.onSecondary,
            ),
            ColorChip(
              'onSecondary',
              colorScheme.onSecondary,
              colorScheme.secondary,
            ),
            ColorChip(
              'secondaryContainer',
              colorScheme.secondaryContainer,
              colorScheme.onSecondaryContainer,
            ),
            ColorChip(
              'onSecondaryContainer',
              colorScheme.onSecondaryContainer,
              colorScheme.secondaryContainer,
            ),
          ],
        ),
        divider,
        ColorGroup(
          children: <ColorChip>[
            ColorChip(
              'secondaryFixed',
              colorScheme.secondaryFixed,
              colorScheme.onSecondaryFixed,
            ),
            ColorChip(
              'onSecondaryFixed',
              colorScheme.onSecondaryFixed,
              colorScheme.secondaryFixed,
            ),
            ColorChip(
              'secondaryFixedDim',
              colorScheme.secondaryFixedDim,
              colorScheme.onSecondaryFixedVariant,
            ),
            ColorChip(
              'onSecondaryFixedVariant',
              colorScheme.onSecondaryFixedVariant,
              colorScheme.secondaryFixedDim,
            ),
          ],
        ),
        divider,
        ColorGroup(
          children: <ColorChip>[
            ColorChip('tertiary', colorScheme.tertiary, colorScheme.onTertiary),
            ColorChip(
              'onTertiary',
              colorScheme.onTertiary,
              colorScheme.tertiary,
            ),
            ColorChip(
              'tertiaryContainer',
              colorScheme.tertiaryContainer,
              colorScheme.onTertiaryContainer,
            ),
            ColorChip(
              'onTertiaryContainer',
              colorScheme.onTertiaryContainer,
              colorScheme.tertiaryContainer,
            ),
          ],
        ),
        divider,
        ColorGroup(
          children: <ColorChip>[
            ColorChip(
              'tertiaryFixed',
              colorScheme.tertiaryFixed,
              colorScheme.onTertiaryFixed,
            ),
            ColorChip(
              'onTertiaryFixed',
              colorScheme.onTertiaryFixed,
              colorScheme.tertiaryFixed,
            ),
            ColorChip(
              'tertiaryFixedDim',
              colorScheme.tertiaryFixedDim,
              colorScheme.onTertiaryFixedVariant,
            ),
            ColorChip(
              'onTertiaryFixedVariant',
              colorScheme.onTertiaryFixedVariant,
              colorScheme.tertiaryFixedDim,
            ),
          ],
        ),
        divider,
        ColorGroup(
          children: <ColorChip>[
            ColorChip('error', colorScheme.error, colorScheme.onError),
            ColorChip('onError', colorScheme.onError, colorScheme.error),
            ColorChip(
              'errorContainer',
              colorScheme.errorContainer,
              colorScheme.onErrorContainer,
            ),
            ColorChip(
              'onErrorContainer',
              colorScheme.onErrorContainer,
              colorScheme.errorContainer,
            ),
          ],
        ),
        divider,
        ColorGroup(
          children: <ColorChip>[
            ColorChip(
              'surfaceDim',
              colorScheme.surfaceDim,
              colorScheme.onSurface,
            ),
            ColorChip('surface', colorScheme.surface, colorScheme.onSurface),
            ColorChip(
              'surfaceBright',
              colorScheme.surfaceBright,
              colorScheme.onSurface,
            ),
            ColorChip(
              'surfaceContainerLowest',
              colorScheme.surfaceContainerLowest,
              colorScheme.onSurface,
            ),
            ColorChip(
              'surfaceContainerLow',
              colorScheme.surfaceContainerLow,
              colorScheme.onSurface,
            ),
            ColorChip(
              'surfaceContainer',
              colorScheme.surfaceContainer,
              colorScheme.onSurface,
            ),
            ColorChip(
              'surfaceContainerHigh',
              colorScheme.surfaceContainerHigh,
              colorScheme.onSurface,
            ),
            ColorChip(
              'surfaceContainerHighest',
              colorScheme.surfaceContainerHighest,
              colorScheme.onSurface,
            ),
            ColorChip('onSurface', colorScheme.onSurface, colorScheme.surface),
            ColorChip(
              'onSurfaceVariant',
              colorScheme.onSurfaceVariant,
              colorScheme.surfaceContainerHighest,
            ),
          ],
        ),
        divider,
        ColorGroup(
          children: <ColorChip>[
            ColorChip('outline', colorScheme.outline, null),
            ColorChip('shadow', colorScheme.shadow, null),
            ColorChip(
              'inverseSurface',
              colorScheme.inverseSurface,
              colorScheme.onInverseSurface,
            ),
            ColorChip(
              'onInverseSurface',
              colorScheme.onInverseSurface,
              colorScheme.inverseSurface,
            ),
            ColorChip(
              'inversePrimary',
              colorScheme.inversePrimary,
              colorScheme.primary,
            ),
          ],
        ),
      ],
    );
  }
}

class ColorGroup extends StatelessWidget {
  const ColorGroup({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(children: children),
      ),
    );
  }
}

class ColorChip extends StatelessWidget {
  const ColorChip(this.label, this.color, this.onColor, {super.key});

  final Color color;
  final Color? onColor;
  final String label;

  static Color contrastColor(Color color) {
    final Brightness brightness = ThemeData.estimateBrightnessForColor(color);
    return brightness == Brightness.dark ? Colors.white : Colors.black;
  }

  @override
  Widget build(BuildContext context) {
    final Color labelColor = onColor ?? contrastColor(color);
    return ColoredBox(
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: <Expanded>[
            Expanded(
              child: Text(label, style: TextStyle(color: labelColor)),
            ),
          ],
        ),
      ),
    );
  }
}

enum ColorSeed {
  baseColor('M3 Baseline', Color(0xff6750a4)),
  indigo('Indigo', Colors.indigo),
  blue('Blue', Colors.blue),
  teal('Teal', Colors.teal),
  green('Green', Colors.green),
  yellow('Yellow', Colors.yellow),
  orange('Orange', Colors.orange),
  deepOrange('Deep Orange', Colors.deepOrange),
  pink('Pink', Colors.pink),
  brightBlue('Bright Blue', Color(0xFF0000FF)),
  brightGreen('Bright Green', Color(0xFF00FF00)),
  brightRed('Bright Red', Color(0xFFFF0000));

  const ColorSeed(this.label, this.color);
  final String label;
  final Color color;
}

class SettingsButton extends StatelessWidget {
  const SettingsButton({
    super.key,
    required this.updateTheme,
    required this.selectedBrightness,
    required this.selectedContrast,
    required this.selectedColor,
  });

  final Brightness selectedBrightness;
  final double selectedContrast;
  final Color selectedColor;

  final void Function(Brightness, Color, double) updateTheme;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.settings),
      onPressed: () {
        showModalBottomSheet<void>(
          barrierColor: Colors.transparent,
          context: context,
          builder: (BuildContext context) {
            return Settings(
              selectedColor: selectedColor,
              selectedBrightness: selectedBrightness,
              selectedContrast: selectedContrast,
              updateTheme: updateTheme,
            );
          },
        );
      },
    );
  }
}

import 'package:example/carousel/carouselmain.dart';
import 'package:example/manager.dart';
import 'package:example/quiz.dart';
import 'package:example/hotel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:example/ariana/main.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moonspace/electrify.dart';
import 'package:moonspace/form/async_text_field.dart';
import 'package:moonspace/form/select.dart';
import 'package:moonspace/helper/extensions/theme_ext.dart';
import 'package:moonspace/provider/global_theme.dart';
import 'package:moonspace/theme.dart';
import 'package:moonspace/widgets/functions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
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

import 'package:moonspace/widgets/animated/neon_button.dart';
import 'package:moonspace/widgets/loader.dart';

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
  // runApp(Ariana());
  // runApp(RenderHome());

  electrify(
    title: "Home",
    before: (widgetsBinding) {},
    after: () {},
    themes: [
      AppTheme(
        name: "quiz",
        icon: CupertinoIcons.sun_min,

        dark: false,

        size: const Size(360, 780),
        maxSize: const Size(1366, 1024),
        designSize: const Size(360, 780),

        borderRadius: (24, 30),
        padding: (16, 18),

        primary: const Color(0xff717171),
        secondary: Color(0xFF787bce),
        tertiary: Color(0xFFEFD24F),

        baseunit: 1.0,
      ),
      AppTheme(
        name: "manager",
        icon: CupertinoIcons.sun_min,

        dark: false,

        size: const Size(360, 780),
        maxSize: const Size(1366, 1024),
        designSize: const Size(360, 780),

        borderRadius: (0, 0),
        padding: (20, 25),

        primary: const Color.fromARGB(255, 34, 34, 34),
        secondary: const Color.fromARGB(255, 247, 51, 51),
        tertiary: Color(0xFFEFD24F),

        baseunit: 1.0,
      ),
    ],
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
        GoRoute(
          path: "/colors",
          builder: (context, state) {
            return ColorSchemeExample();
          },
        ),
        GoRoute(
          path: "/render",
          builder: (context, state) {
            return RenderHome();
          },
        ),
        GoRoute(
          path: "/carousel",
          builder: (context, state) {
            return Carouselmain();
          },
        ),
        GoRoute(
          path: "/quiz",
          builder: (context, state) {
            return Quiz();
          },
        ),
        GoRoute(
          path: "/hotel",
          builder: (context, state) {
            return HotelApp();
          },
        ),
        GoRoute(
          path: "/manager",
          builder: (context, state) {
            return ManagerApp();
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
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(
          '${AppTheme.currentTheme.size.width} Counter example ${ref.watch(counterProvider)}',
        ),
        actions: [
          ThemeBrightnessButton(),
          if (!AppTheme.isDesktop)
            IconButton(
              onPressed: () {
                context.showFormDialog(
                  builder: (context) {
                    return ThemeSettings();
                  },
                );
              },
              icon: Icon(Icons.settings),
            ),
        ],
      ),

      endDrawer: IntrinsicWidth(
        child: SizedBox(height: 420, child: NavigationRailSection()),
      ),

      // endDrawer: SizedBox(height: 520, child: NavigationDrawerSection()),
      body: AppTheme.isDesktop
          ? Row(
              children: [
                ThemeSettings(),
                Expanded(child: ListView(children: first(context))),
                Expanded(child: ListView(children: second(context))),
                Expanded(child: ListView(children: third(context))),
              ],
            )
          : ListView(
              children: [
                ...first(context),
                ...second(context),
                ...third(context),
              ],
            ),

      floatingActionButton: FloatingActionButton(
        // The read method is a utility to read a provider without listening to it
        onPressed: () => ref.read(counterProvider.notifier).increment(),
        child: const Icon(Icons.add),
      ),
    );
  }

  List<Widget> first(BuildContext context) => [
    AsyncTextFormField(
      key: ValueKey('Nick'),
      initialValue: "Witch",
      autocorrect: false,
      enableSuggestions: false,
      enabled: true,
      maxLines: 1,
      asyncValidator: (value) async {
        return null;
      },
      textInputAction: TextInputAction.done,
      decoration: (asyncText, textCon) =>
          InputDecoration(errorText: 'error text', helperText: 'helper'),
    ),

    Wrap(
      children: [
        Card(
          color: context.cs.surface,
          elevation: 0,
          child: Container(
            width: 100,
            height: 100,
            alignment: Alignment.center,
            child: Text("surface"),
          ),
        ),
        Card(
          elevation: 0,
          child: Container(
            width: 100,
            height: 100,
            alignment: Alignment.center,
            child: Text("none"),
          ),
        ),
        Card(
          color: context.cs.surfaceContainer,
          elevation: 0,
          child: Container(
            width: 100,
            height: 100,
            alignment: Alignment.center,
            child: Text("surcon"),
          ),
        ),
        Card(
          color: context.cs.surfaceContainerHighest,
          elevation: 0,
          child: Container(
            width: 100,
            height: 100,
            alignment: Alignment.center,
            child: Text("surconh"),
          ),
        ),
        Card(
          color: context.cs.secondary,
          elevation: 0,
          child: Container(
            width: 100,
            height: 100,
            alignment: Alignment.center,
            child: Text(
              "secondary",
              style: context.bm?.copyWith(color: context.cs.onSecondary),
            ),
          ),
        ),
        Card(
          color: context.cs.tertiary,
          elevation: 0,
          child: Container(
            width: 100,
            height: 100,
            alignment: Alignment.center,
            child: Text(
              "tertiary",
              style: context.bm?.copyWith(color: context.cs.onTertiary),
            ),
          ),
        ),
      ],
    ),

    Wrap(
      children: <Widget>[
        Buttons(isDisabled: false, hasIcon: false),
        Buttons(isDisabled: false, hasIcon: true),
        Buttons(isDisabled: true, hasIcon: false),
      ],
    ),

    Wrap(
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
      ],
    ),
    Wrap(
      children: [
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
  ];

  List<Widget> second(BuildContext context) => [
    Row(
      children: [
        Flexible(
          child: OptionBox(
            options: [
              Option(value: "Witch", subtitle: Text("witch"), selected: true),
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

    Slider(
      max: 100,
      divisions: 5,
      value: 30,
      label: "30",
      onChanged: (value) {},
    ),
    SizedBox(height: 8),
    LinearProgressIndicator(
      value: .5,
      minHeight: 10,
      // color: purple,
      borderRadius: BorderRadius.circular(8),
    ),

    NavigationBar(
      labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
      selectedIndex: 1,
      onDestinationSelected: (int index) {},
      destinations: const <Widget>[
        NavigationDestination(icon: Icon(Icons.explore), label: 'Explore'),
        NavigationDestination(icon: Icon(Icons.commute), label: 'Commute'),
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
  ];

  List<Widget> third(BuildContext context) => [
    Dropdown(),

    SegmentedButton<String>(
      segments: const <ButtonSegment<String>>[
        ButtonSegment(value: "Sizes.extraSmall", label: Text('XS')),
        ButtonSegment(value: "Sizes.small", label: Text('S')),
        ButtonSegment(value: "Sizes.medium", label: Text('M')),
        ButtonSegment(value: "Sizes.large", label: Text('L')),
        ButtonSegment(value: "Sizes.extraLarge", label: Text('XL')),
      ],
      selected: {"Sizes.small"},
      onSelectionChanged: (newSelection) {},
      multiSelectionEnabled: true,
    ),

    Wrap(
      children: [
        SizedBox(height: 320, child: NavigationDrawerSection()),

        SizedBox(
          height: 320,
          child: IntrinsicWidth(child: NavigationRailSection()),
        ),
      ],
    ),

    BottomAppBar(
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

    ExpansionPanelList(
      materialGapSize: 0,
      children: [
        ExpansionPanel(
          canTapOnHeader: true,
          isExpanded: true,
          headerBuilder: (context, isExpanded) => Text("Header"),
          body: Text("Body"),
        ),
        ExpansionPanel(
          canTapOnHeader: true,
          headerBuilder: (context, isExpanded) => Text("Header"),
          body: Text("Body"),
        ),
      ],
    ),

    GradientLoader(),

    CircularProgress(
      size: 50,
      secondaryColor: Colors.red,
      primaryColor: Colors.yellow,
    ),

    NeonButton(
      color: context.cs.secondary,
      child: Text(
        "Hello",
        style: GoogleFonts.agbalumo(
          textStyle: context.h6.c(context.cs.onSecondary),
        ),
      ),
    ),

    DataTable(
      columns: const <DataColumn>[
        DataColumn(
          label: Expanded(
            child: Text('Name', style: TextStyle(fontStyle: FontStyle.italic)),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text('Age', style: TextStyle(fontStyle: FontStyle.italic)),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text('Role', style: TextStyle(fontStyle: FontStyle.italic)),
          ),
        ),
      ],
      rows: const <DataRow>[
        DataRow(
          cells: <DataCell>[
            DataCell(Text('Sarah')),
            DataCell(Text('19')),
            DataCell(Text('Student')),
          ],
        ),
        DataRow(
          cells: <DataCell>[
            DataCell(Text('Janine')),
            DataCell(Text('43')),
            DataCell(Text('Professor')),
          ],
        ),
        DataRow(
          cells: <DataCell>[
            DataCell(Text('William')),
            DataCell(Text('27')),
            DataCell(Text('Associate Professor')),
          ],
        ),
      ],
    ),

    Wrap(
      alignment: WrapAlignment.spaceEvenly,
      children: [
        TextButton(
          child: const Text('Show modal navigation drawer'),
          onPressed: () {
            scaffoldKey.currentState!.openEndDrawer();
          },
        ),
        TextButton(
          child: const Text('Show modal bottom sheet'),
          onPressed: () {
            showModalBottomSheet<void>(
              showDragHandle: true,
              context: context,
              constraints: const BoxConstraints(maxWidth: 640),
              builder: (context) {
                return SizedBox(
                  height: 150,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
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
          child: Text('Show bottom sheet'),
          onPressed: () {
            showBottomSheet(
              elevation: 8.0,
              context: context,
              constraints: const BoxConstraints(maxWidth: 640),
              builder: (context) {
                return SizedBox(
                  height: 150,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
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
  ];
}

//------------

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

//------------

class ThemeSettings extends StatelessWidget {
  const ThemeSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: SingleChildScrollView(
        child: Column(
          children: [
            ThemeSelector(),
            ListTile(
              onTap: () {
                context.push("/typography");
              },
              title: Text("Typography"),
            ),
            ListTile(
              onTap: () {
                context.push("/colors");
              },
              title: Text("Colors"),
            ),
            ListTile(
              onTap: () {
                context.push("/render");
              },
              title: Text("Render"),
            ),
            ListTile(
              onTap: () {
                context.push("/carousel");
              },
              title: Text("Carousel"),
            ),
            ListTile(
              onTap: () {
                context.push("/quiz");
              },
              title: Text("Quiz"),
            ),
            ListTile(
              onTap: () {
                context.push("/hotel");
              },
              title: Text("Hotel"),
            ),
            ListTile(
              onTap: () {
                context.push("/manager");
              },
              title: Text("Manager"),
            ),
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
        ...destinations.map((destination) {
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

//------------

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

class Dropdown extends StatefulWidget {
  const Dropdown({super.key});

  @override
  State<Dropdown> createState() => _DropdownState();
}

class _DropdownState extends State<Dropdown> {
  final TextEditingController colorController = TextEditingController();
  final TextEditingController iconController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final List<String> entries = ["Smile", "Cloud", "Heart"];

    return Wrap(
      alignment: WrapAlignment.spaceAround,
      runAlignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 4,
      runSpacing: 4,
      children: [
        DropdownButton(
          hint: Text("Color"),
          // selectedItemBuilder: (context) {
          //   return [Text("Hello"), Text("Hi")];
          // },
          value: "Smile",
          items: entries
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (value) {},
        ),
        SizedBox(
          width: 150,
          child: DropdownButtonFormField(
            hint: Text("Color"),
            items: entries
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (value) {},
          ),
        ),
        DropdownMenu(
          controller: colorController,
          label: const Text('Color'),
          enableFilter: true,
          dropdownMenuEntries: entries
              .map(
                (e) => DropdownMenuEntry<String>(
                  value: e,
                  label: e,
                  enabled: e != 'Grey',
                ),
              )
              .toList(),
          inputDecorationTheme: const InputDecorationTheme(filled: true),
          onSelected: (color) {},
        ),
        DropdownMenu(
          initialSelection: "Smile",
          controller: iconController,
          leadingIcon: const Icon(Icons.search),
          label: const Text('Icon'),
          dropdownMenuEntries: entries
              .map(
                (e) => DropdownMenuEntry<String>(
                  value: e,
                  label: e,
                  enabled: e != 'Grey',
                ),
              )
              .toList(),
          onSelected: (icon) {},
        ),
      ],
    );
  }
}

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
    return Theme(
      data: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: selectedColor,
          brightness: selectedBrightness,
          contrastLevel: selectedContrast,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(),
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
                    children: [
                      ColorSchemeVariantColumn(
                        colorScheme: context.cs,
                        selectedColor: selectedColor,
                        brightness: selectedBrightness,
                        schemeVariant: schemeVariants[0],
                        contrastLevel: selectedContrast,
                      ),
                      ...List<Widget>.generate(schemeVariants.length, (
                        int index,
                      ) {
                        return ColorSchemeVariantColumn(
                          selectedColor: selectedColor,
                          brightness: selectedBrightness,
                          schemeVariant: schemeVariants[index],
                          contrastLevel: selectedContrast,
                        );
                      }),
                    ],
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
    this.colorScheme,
  });

  final DynamicSchemeVariant schemeVariant;
  final Brightness brightness;
  final double contrastLevel;
  final Color selectedColor;

  final ColorScheme? colorScheme;

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
              colorScheme:
                  colorScheme ??
                  ColorScheme.fromSeed(
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
            ColorChip(
              'surfaceDim',
              colorScheme.surfaceDim,
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

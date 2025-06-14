import 'package:example/vignettes/_shared/ui/rotation_3d.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:example/vignettes/_shared/env.dart';
import 'package:moonspace/controller/app_scroll_behavior.dart';

void main() => runApp(ParallaxTravelCardsList());

class ParallaxTravelCardsList extends StatelessWidget {
  static final String _pkg = "parallax_travel_cards_list";

  const ParallaxTravelCardsList({super.key});
  static String? get pkg => Env.getPackage(_pkg);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      scrollBehavior: AppScrollBehavior(),
      debugShowCheckedModeBanner: false,
      home: TravelCardDemo(),
    );
  }
}

class TravelCardDemo extends StatefulWidget {
  const TravelCardDemo({super.key});

  @override
  State<TravelCardDemo> createState() => _TravelCardDemoState();
}

class _TravelCardDemoState extends State<TravelCardDemo> {
  static final data = DemoData();
  static final _cityList = data.getCities();
  City _currentCity = _cityList[1];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Styles.hzScreenPadding,
                ),
                child: Text(
                  'Where are you going next?',
                  overflow: TextOverflow.ellipsis,
                  style: Styles.appHeader,
                  maxLines: 2,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: TravelCardList(
                  cities: _cityList,
                  onCityChange: (City city) {
                    setState(() {
                      _currentCity = city;
                    });
                  },
                ),
              ),
              HotelList(_currentCity.hotels),
            ],
          ),
        ),
      ),
    );
  }
}

class TravelCardList extends StatefulWidget {
  final List<City> cities;
  final Function onCityChange;

  const TravelCardList({
    super.key,
    required this.cities,
    required this.onCityChange,
  });

  @override
  TravelCardListState createState() => TravelCardListState();
}

class TravelCardListState extends State<TravelCardList>
    with SingleTickerProviderStateMixin {
  final double _maxRotation = 20;

  PageController? _pageController;

  double _cardWidth = 160;
  double _cardHeight = 200;
  double _normalizedOffset = 0;
  double _prevScrollX = 0;
  bool _isScrolling = false;
  //int _focusedIndex = 0;

  //Create Controller, which starts/stops the tween, and rebuilds this widget while it's running
  late final AnimationController _tweenController = AnimationController(
    vsync: this,
    duration: Duration(milliseconds: 1000),
  );
  //Create Tween, which defines our begin + end values
  final Tween<double> _tween = Tween<double>(begin: -1, end: 0);
  //Create Animation, which allows us to access the current tween value and the onUpdate() callback.
  late final Animation<double> _tweenAnim = _tween.animate(
    CurvedAnimation(parent: _tweenController, curve: Curves.elasticOut),
  );
  @override
  void initState() {
    //Set our offset each time the tween updates
    _tweenAnim.addListener(() => _setOffset(_tweenAnim.value));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    _cardHeight = (size.height * .48).clamp(300.0, 400.0);
    _cardWidth = _cardHeight * .8;
    //Calculate the viewPort fraction for this aspect ratio, since PageController does not accept pixel based size values
    _pageController = PageController(
      initialPage: 1,
      viewportFraction: _cardWidth / size.width,
    );

    //Create our main list
    Widget listContent = SizedBox(
      //Wrap list in a container to control height and padding
      height: _cardHeight,
      //Use a ListView.builder, calls buildItemRenderer() lazily, whenever it need to display a listItem
      child: PageView.builder(
        //Use bounce-style scroll physics, feels better with this demo
        physics: BouncingScrollPhysics(),
        controller: _pageController,
        itemCount: 8,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, i) => _buildRotatedTravelCard(i),
      ),
    );

    //Wrap our list content in a Listener to detect PointerUp events, and a NotificationListener to detect ScrollStart and ScrollUpdate
    //We have to use both, because NotificationListener does not inform us when the user has lifted their finger.
    //We can not use GestureDetector like we normally would, ListView suppresses it while scrolling.
    return Listener(
      onPointerUp: (PointerUpEvent event) {
        if (_isScrolling) {
          _isScrolling = false;
          //Restart the tweenController and inject a new start value into the tween
          _tween.begin = _normalizedOffset;
          _tweenController.reset();
          _tween.end = 0;
          _tweenController.forward();
        }
      },
      child: NotificationListener(
        onNotification: _handleScrollNotifications,
        child: listContent,
      ),
    );
  }

  //Create a renderer for each list item
  Widget _buildRotatedTravelCard(int itemIndex) {
    return Rotation3d(
      rotationY: _normalizedOffset * _maxRotation,
      //Create the actual content renderer for our list
      child: TravelCardRenderer(
        //Pass in the offset, renderer can update it's own view from there
        _normalizedOffset,
        //Pass in city path for the image asset links
        city: widget.cities[itemIndex % widget.cities.length],
        cardWidth: _cardWidth,
        cardHeight: _cardHeight - 50,
      ),
    );
  }

  //Check the notifications bubbling up from the ListView, use them to update our currentOffset and isScrolling state
  bool _handleScrollNotifications(Notification notification) {
    //Scroll Update, add to our current offset, but clamp to -1 and 1
    if (notification is ScrollUpdateNotification) {
      if (_isScrolling) {
        double dx = notification.metrics.pixels - _prevScrollX;
        double scrollFactor = .01;
        double newOffset = (_normalizedOffset + dx * scrollFactor);
        _setOffset(newOffset.clamp(-1.0, 1.0));
      }
      _prevScrollX = notification.metrics.pixels;
      //Calculate the index closest to middle
      //_focusedIndex = (_prevScrollX / (_itemWidth + _listItemPadding)).round();
      final currentPage = _pageController?.page?.round();
      if (currentPage != null) {
        widget.onCityChange(
          widget.cities.elementAt(currentPage % widget.cities.length),
        );
      }
    }
    //Scroll Start
    else if (notification is ScrollStartNotification) {
      _isScrolling = true;
      _prevScrollX = notification.metrics.pixels;
      _tweenController.stop();
    }
    return true;
  }

  //Helper function, any time we change the offset, we want to rebuild the widget tree, so all the renderers get the new value.
  void _setOffset(double value) {
    setState(() {
      _normalizedOffset = value;
    });
  }
}

class TravelCardRenderer extends StatelessWidget {
  final double offset;
  final double cardWidth;
  final double cardHeight;
  final City city;

  const TravelCardRenderer(
    this.offset, {
    super.key,
    this.cardWidth = 250,
    required this.city,
    required this.cardHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: cardWidth,
      margin: EdgeInsets.only(top: 8),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: <Widget>[
          /// Card background color & decoration
          Container(
            margin: EdgeInsets.only(top: 30, left: 12, right: 12, bottom: 12),
            decoration: BoxDecoration(
              color: city.color,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(color: Colors.black12, blurRadius: 4 * offset.abs()),
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10 + 6 * offset.abs(),
                ),
              ],
            ),
          ),

          /// City image, overflows the card a bit on the top
          Positioned(top: -15, child: _buildCityImageStack()),

          /// City information
          _buildCityInfo(),
        ],
      ),
    );
  }

  Widget _buildCityImageStack() {
    Widget offsetLayer(
      String path,
      double width,
      double maxOffset,
      double globalOffset,
    ) {
      double cardPadding = 24;
      double layerWidth = cardWidth - cardPadding;
      return Positioned(
        left:
            ((layerWidth * .5) - (width / 2) - offset * maxOffset) +
            globalOffset,
        bottom: cardHeight * .45,
        child: Image.asset(
          path,
          width: width,
          package: ParallaxTravelCardsList.pkg,
        ),
      );
    }

    double maxParallax = 30;
    double globalOffset = offset * maxParallax * 2;
    double cardPadding = 28;
    double containerWidth = cardWidth - cardPadding;
    return SizedBox(
      height: cardHeight,
      width: containerWidth,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          offsetLayer(
            "images/${city.name}/${city.name}-Back.png",
            containerWidth * .8,
            maxParallax * .1,
            globalOffset,
          ),
          offsetLayer(
            "images/${city.name}/${city.name}-Middle.png",
            containerWidth * .9,
            maxParallax * .6,
            globalOffset,
          ),
          offsetLayer(
            "images/${city.name}/${city.name}-Front.png",
            containerWidth * .9,
            maxParallax,
            globalOffset,
          ),
        ],
      ),
    );
  }

  Widget _buildCityInfo() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        // The sized box mock the space of the city image
        SizedBox(width: double.infinity, height: cardHeight * .57),

        /// Title
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Text(
            city.title,
            style: Styles.cardTitle,
            textAlign: TextAlign.center,
          ),
        ),

        /// Desc
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Text(
            city.description,
            style: Styles.cardSubtitle,
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(child: SizedBox()),

        /// Bottom btn
        TextButton(
          onPressed: null,
          child: Text('Learn More'.toUpperCase(), style: Styles.cardAction),
        ),
        SizedBox(height: 8),
      ],
    );
  }
}

class HotelList extends StatefulWidget {
  final List<Hotel> hotels;

  const HotelList(this.hotels, {super.key});

  @override
  State<HotelList> createState() => _HotelListViewState();
}

class _HotelListViewState extends State<HotelList>
    with SingleTickerProviderStateMixin {
  late final AnimationController _anim = AnimationController(
    vsync: this,
    duration: Duration(milliseconds: 700),
  );

  @override
  void initState() {
    _anim.forward(from: 0);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant HotelList oldWidget) {
    if (oldWidget.hotels != widget.hotels) {
      _anim.forward(from: 0);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _anim,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[for (Hotel hotel in widget.hotels) Text(hotel.name)],
      ),
    );
  }
}

class City {
  final String name;
  final String title;
  final String description;
  final Color color;
  final List<Hotel> hotels;

  City({
    required this.title,
    required this.name,
    required this.description,
    required this.color,
    required this.hotels,
  });
}

class Hotel {
  final String name;
  final double rating;
  final int reviews;
  final int price;

  Hotel(
    this.name, {
    required this.reviews,
    required this.price,
    required this.rating,
  });
}

class DemoData {
  final List<City> _cities = [
    City(
      name: 'Pisa',
      title: 'Pisa, Italy',
      description: 'Discover a beautiful city where ancient and modern meet',
      color: Color(0xffdee5cf),
      hotels: [
        Hotel('Hotel Bologna', reviews: 201, price: 120, rating: 4),
        Hotel('Tree House', reviews: 85, price: 98, rating: 5),
        Hotel(
          'Allegroitalia Pisa Tower Plaza',
          reviews: 128,
          price: 119,
          rating: 4,
        ),
      ],
    ),
    City(
      name: 'Budapest',
      title: 'Budapest, Hungary',
      description: 'Meet the city with rich history and indescribable culture',
      color: Color(0xffdaf3f7),
      hotels: [
        Hotel('Hotel Estilo Budapest', reviews: 762, price: 87, rating: 5),
        Hotel('Danubius Hotel', reviews: 3122, price: 196, rating: 3),
        Hotel(
          'Golden Budapest Condominium',
          reviews: 213,
          price: 217,
          rating: 5,
        ),
      ],
    ),
    City(
      name: 'London',
      title: 'London, England',
      description:
          'A diverse and exciting city with the world’s best sights and attractions!',
      color: Color(0xfff9d9e2),
      hotels: [
        Hotel(
          'InterContinental London Hotel',
          reviews: 1624,
          price: 418,
          rating: 3,
        ),
        Hotel('Brick Lane Hotel', reviews: 101, price: 101, rating: 4),
        Hotel('Park Villa Boutique House', reviews: 161, price: 128, rating: 5),
      ],
    ),
  ];

  List<City> getCities() => _cities;
  List<Hotel> getHotels(City city) => city.hotels;
}

class Styles {
  static const double hzScreenPadding = 18;

  static final TextStyle baseTitle = TextStyle(
    fontSize: 11,
    fontFamily: 'DMSerifDisplay',
    package: ParallaxTravelCardsList.pkg,
  );
  static final TextStyle baseBody = TextStyle(
    fontSize: 11,
    fontFamily: 'OpenSans',
    package: ParallaxTravelCardsList.pkg,
  );

  static final TextStyle appHeader = baseTitle.copyWith(
    color: Color(0xFF0e0e0e),
    fontSize: 36,
    height: 1,
  );

  static final TextStyle cardTitle = baseTitle.copyWith(
    height: 1,
    color: Color(0xFF1a1a1a),
    fontSize: 25,
  );
  static final TextStyle cardSubtitle = baseBody.copyWith(
    color: Color(0xFF666666),
    height: 1.5,
    fontSize: 12,
  );
  static final TextStyle cardAction = baseBody.copyWith(
    color: Color(0xFFa6998b),
    fontSize: 10,
    height: 1,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
  );

  static final TextStyle hotelsTitleSection = baseBody.copyWith(
    color: Colors.black,
    fontSize: 14,
    fontWeight: FontWeight.bold,
    height: 2,
  );
  static final TextStyle hotelTitle = baseBody.copyWith(
    color: Colors.black,
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );
  static final TextStyle hotelPrice = baseBody.copyWith(
    color: Color(0xff4d4d4d),
    fontSize: 13,
  );
  static final TextStyle hotelScore = baseBody.copyWith(
    color: Color(0xff0e0e0e),
  );
  static final TextStyle hotelData = baseBody.copyWith(color: Colors.grey[700]);
}

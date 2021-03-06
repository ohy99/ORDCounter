import 'package:flutter/material.dart';
import 'package:ord_counter_app/riveanima.dart';

import 'homepage.dart';
import 'package:dots_indicator/dots_indicator.dart';
import '../upcomingpage.dart';
import 'mybgscroller.dart';
import 'friendspage.dart';
import 'package:lottie/lottie.dart';

class Imagest extends StatelessWidget {
  PageController pageController;
  double offset;
  int numberOfPages;
  Imagest({this.pageController, this.offset, this.numberOfPages});

  @override
  Widget build(BuildContext context) {
    //return Consumer<PageOffsetNotifier>(
    //  builder: (context, notifier, child) {
    // return Align(
    //   alignment: Alignment(-1.0 + (offset / (numberOfPages - 1)) * 2, 0),
    //   widthFactor: 2,
    //   // widthFactor: -1.0 + (offset / (numberOfPages - 1)) * 2,
    //   heightFactor: MediaQuery.of(context).size.height,
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: FittedBox(
        alignment: Alignment(-1.0 + (offset / (numberOfPages - 1)) * 2, -1),
        fit: BoxFit.none,
        child: IgnorePointer(
          child: Container(
            child: MyBgAnimation(),
            width: MediaQuery.of(context).size.width * numberOfPages,
            height: MediaQuery.of(context).size.height,
            alignment: Alignment.center,
          ),
        ),
      ),
    );
  }
}

class MainPageView extends StatefulWidget {
  MainPageView({Key key, this.title}) : super(key: key);

  final String title;

  @override
  MainPageViewState createState() => MainPageViewState();
}

class MainPageViewState extends State<MainPageView> {
  final PageController controller = PageController(initialPage: 0);
  //to show the no. of pages for pageview
  List<Widget> pageList = [
    FriendsPage(),
    HomePage(),
    // HomePage(),
    UpcomingPage(),
  ];
  // for the snapping of pageview
  double _currentPosition = 0.0;
  double _validPosition(double position) {
    if (position >= pageList.length) return 0;
    if (position < 0) return pageList.length - 1.0;
    return position;
  }

  Widget _buildRow(List<Widget> widgets) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: widgets,
      ),
    );
  }

// cont of above
  void _updatePosition(double position) {
    setState(() {
      _currentPosition = _validPosition(position);
      //print(_currentPosition);
    });
  }

  var scaffoldKey = GlobalKey<ScaffoldState>();
  DotsDecorator decorator = DotsDecorator(
    size: const Size.square(9.0),
    activeSize: const Size(18.0, 9.0),
    activeShape: RoundedRectangleBorder(
      side: BorderSide.none,
      borderRadius: BorderRadius.circular(5.0),
    ),
    activeColor: Colors.white70,
  );

  @override
  void initState() {
    super.initState();

    //bgScroller.bgImageString = "assets/images/testbg.jpg";
    //bgScroller.numOfPage = pageList.length;

    _updatePosition(controller.initialPage.toDouble());
    controller.addListener(() {
      setState(() {
        _updatePosition(controller.page);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: Stack(
        children: [
          Imagest(
              pageController: this.controller,
              offset: _currentPosition,
              numberOfPages: pageList.length),
          PageView(
            scrollDirection: Axis.horizontal,
            controller: controller,
            children: pageList,
            onPageChanged: (int p) {
              _updatePosition(p.toDouble());
            },
          ),
          Positioned(
            left: 10,
            top: 20,
            child: IconButton(
              icon: Icon(Icons.menu),
              onPressed: () => scaffoldKey.currentState.openDrawer(),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.only(bottom: 30),
              child: _buildRow([
                DotsIndicator(
                  dotsCount: pageList.length,
                  position: _currentPosition,
                  decorator: decorator,
                ),
              ]),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: Icon(Icons.face),
                    title: Text('Header name'),
                    subtitle: Text('Im gona ord'),
                    onTap: () {
                      // Update the state of the app
                      // ...
                      // Then close the drawer
                      Navigator.pop(context);
                    },
                  ),
                  Text(
                    'Badges',
                    textAlign: TextAlign.left,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Row(
                      children: [Icon(Icons.circle), Icon(Icons.stairs)],
                    ),
                  ),
                ],
              ),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.attach_money),
              title: Text('Donate'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

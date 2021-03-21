import 'package:flutter/material.dart';

import 'homepage.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'achievementpage.dart';
import 'mybgscroller.dart';
import 'shoppage.dart';

class MainPageView extends StatefulWidget {
  MainPageView({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  MainPageViewState createState() => MainPageViewState();
}


class MainPageViewState extends State<MainPageView> {

  final PageController controller = PageController(initialPage: 1);
  List<Widget> pageList = [
    
              HomePage(),
              //HomePage(),
              AchievementPage(),
              ShopPage(),
            ];
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
  void _updatePosition(double position) {
    setState(() => _currentPosition = _validPosition(position));
  }

  var scaffoldKey = GlobalKey<ScaffoldState>();
  DotsDecorator decorator = DotsDecorator(
        size: const Size.square(9.0),
        activeSize: const Size(18.0, 9.0),
        activeShape: RoundedRectangleBorder(
          side: BorderSide.none,
          borderRadius: BorderRadius.circular(5.0),
          ),
      );


  @override
  void initState() {
    super.initState();

    //bgScroller.bgImageString = "assets/images/testbg.jpg";
    //bgScroller.numOfPage = pageList.length;

    _updatePosition(controller.initialPage.toDouble());

  }

  @override
  Widget build(BuildContext context) {
    

    return Scaffold(
      key: scaffoldKey,
      body: Stack(
        children: [

          PageView(
            scrollDirection: Axis.horizontal,
            controller: controller,
            children: pageList,
            onPageChanged: (int p) { _updatePosition(p.toDouble()); },
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
              margin: EdgeInsets.only(bottom: 80),
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
                  padding: EdgeInsets.only(top:10),
                  child: Row(
                    children: [
                      Icon(Icons.circle),
                      Icon(Icons.stairs)
                    ],
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

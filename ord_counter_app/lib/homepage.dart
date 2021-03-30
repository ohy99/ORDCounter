import 'package:flutter/material.dart';
import 'package:ord_counter_app/mainpageview.dart';
import 'package:ord_counter_app/riveanima.dart';
import 'mybgscroller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'mystrings.dart';
import 'package:snapping_sheet/snapping_sheet.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> with TickerProviderStateMixin {
  double ordValue = 0.0;
  int daysLeft = 0;
  String name = '';

  @override
  void initState() {
    super.initState();
    ord_value().whenComplete(() => setState(() {}));
  }

  Widget sheet_behind() {
    return Stack(children: [
      Imagest(),
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
              child: Container(
            margin: EdgeInsets.only(bottom: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  '$daysLeft',
                  style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'days to ORD',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          )),
          Expanded(
            child: Container(),
          ),
        ],
      ),
      //gauges
    ]);
  }

  SnappingPosition closed = SnappingPosition.pixels(
    positionPixels: 300,
    snappingCurve: Curves.easeOutExpo,
    snappingDuration: Duration(seconds: 1),
    grabbingContentOffset: GrabbingContentOffset.top,
  );
  SnappingPosition opened = SnappingPosition.factor(
    positionFactor: 0.8,
    snappingCurve: Curves.easeOutExpo,
    snappingDuration: Duration(seconds: 1),
    grabbingContentOffset: GrabbingContentOffset.bottom,
  );
  double invisBoxH = 300;
  bool isOpened = false;
  SnappingSheetController sheetController = SnappingSheetController();
  ScrollPhysics badgePageScrollPhysics = NeverScrollableScrollPhysics();

  @override
  Widget build(BuildContext context) {
    //print( (MediaQuery. of(context). size. width * 2.0).toString() + " " + (MediaQuery. of(context). size. height).toString());

    return Stack(children: [
      SnappingSheet(
        controller: sheetController,
        onSheetMoved: (sheetPosition) {
          //print("Current position $sheetPosition");

          setState(() {
            double minPosition = 320.0; //300 + 40/2
            double maxPosition = MediaQuery.of(context).size.height * 0.8;
            double diff = maxPosition - minPosition;
            double ratio = (sheetPosition - minPosition) / diff;
            invisBoxH = (1.0 - ratio) * 300.0;
          });
        },
        onSnapStart: (sheetPosition, snappingPosition) {
          if (snappingPosition == closed) {
            //gona close
            //invisBoxH = 300;
            setState(() {
              isOpened = false;
              badgePageScrollPhysics = NeverScrollableScrollPhysics();
            });
            return;
          }
          //invisBoxH = 0;
          setState(() {
            isOpened = true;
            badgePageScrollPhysics = ScrollPhysics();
          });
        },
        lockOverflowDrag: true,
        child: sheet_behind(),
        grabbingHeight: 40,
        grabbing: Container(
          decoration: BoxDecoration(
            color: Colors.blue[300],
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: Column(
            children: [
              Icon(
                Icons.arrow_drop_up_rounded,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
        sheetBelow: SnappingSheetContent(
          draggable: true,
          child: badge_page(1.0),
        ),
        snappingPositions: [closed, opened],
      ),
      Align(
          alignment: FractionalOffset.bottomCenter,
          child: IgnorePointer(
              child: Container(
            //margin: const EdgeInsets.only(top: 300),
            height: MediaQuery.of(context).size.height * 0.5,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              SizedBox(
                height: 30,
              ),
              SizedBox(
                width: 250,
                height: 250,
                child: Image.asset(
                  'assets/images/standing-23.png',
                  fit: BoxFit.contain,
                ),
              ),
              Text(
                name,
                style: TextStyle(fontSize: 25, color: Colors.black54),
              ),
            ]),
          ))),
    ]);
  }

  Widget badge_page(double d) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue[300],
      ),
      child: SingleChildScrollView(
        physics: badgePageScrollPhysics,
        child: IntrinsicWidth(
          child: Column(
            children: [
              AnimatedContainer(
                height: invisBoxH,
                duration: Duration(seconds: 1),
                curve: Curves.easeOutExpo,
              ),
              Container(
                  margin: EdgeInsets.all(20),
                  child: Column(children: [
                    Text(
                      'Badges',
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Coming soon!',
                      style: TextStyle(
                        fontSize: 30,
                      ),
                    ),
                  ]))
            ],
          ),
        ),
      ),
    );
  }

  Future<double> ord_value() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    name = prefs.getString(MyStrings.sp_name);
    String enlistDate = prefs.getString(MyStrings.sp_enlistmentdate);
    String ordDate = prefs.getString(MyStrings.sp_orddate);
    //DateTime eD = DateFormat(MyStrings.sp_date_format).parse('$enlistDate');
    int serviceTerm = prefs.getInt(MyStrings.sp_serviceterm);
    DateTime oD = DateFormat(MyStrings.sp_date_format).parse('$ordDate');

    DateTime eD = DateTime(oD.year, oD.month - serviceTerm, oD.day + 1);
    print(oD.toString() + " " + eD.toString());

    int total = oD.difference(eD).inDays;
    int d = oD.difference(DateTime.now()).inDays;
    daysLeft = d;
    ordValue = 1.0 - (d.toDouble() / total.toDouble());
    return ordValue;
  }
}

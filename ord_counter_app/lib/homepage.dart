import 'package:flutter/material.dart';
import 'mybgscroller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'mystrings.dart';

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


class HomePageState extends State<HomePage> {

  double ordValue = 0.0;
  int daysLeft = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ord_value().whenComplete(() => setState((){}));
  }

  @override
  Widget build(BuildContext context)
  {
    print( (MediaQuery. of(context). size. width * 2.0).toString() + " " + (MediaQuery. of(context). size. height).toString());

    return Stack(

      children: [
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                '$daysLeft Days to ORD',
              ),
              
            ],
          ),
        ),
        Center(
          child: SizedBox(
            width: 100,
            height: 100,
            child: CircularProgressIndicator(
              value: ordValue,
            ),
          ),
        )
      ],
    );
  }

  Future<double> ord_value() async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String enlistDate = prefs.getString(MyStrings.sp_enlistmentdate);
    String ordDate = prefs.getString(MyStrings.sp_orddate);
    DateTime eD = DateFormat(MyStrings.sp_date_format).parse('$enlistDate');
    DateTime oD = DateFormat(MyStrings.sp_date_format).parse('$ordDate');

    int total = oD.difference(eD).inDays;
    int d = oD.difference(DateTime.now()).inDays;
    daysLeft = d;
    ordValue = 1.0 - (d.toDouble()/total.toDouble());
    return ordValue;
  }
}

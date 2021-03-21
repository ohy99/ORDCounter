import 'package:flutter/material.dart';
import 'mybgscroller.dart';

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

  @override
  Widget build(BuildContext context)
  {
    print( (MediaQuery. of(context). size. width * 2.0).toString() + " " + (MediaQuery. of(context). size. height).toString());

    return Stack(

      children: [
        // Container(
        //   height: MediaQuery. of(context). size. height,
        //     child: ClipRect( 
              
        //       child : bgScroller.getPage(context, 0),
        //     ),
          
        // ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'xx Days to ORD',
              ),
              
            ],
          ),
        ),
        Center(
          child: CircularProgressIndicator(
              value: 0.8,
            ),
        )
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'mybgscroller.dart';

class AchievementPage extends StatefulWidget {
  AchievementPage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  AchievementPageState createState() => AchievementPageState();
}

class AchievementPageState extends State<AchievementPage>{

  
  @override
  Widget build(BuildContext context)
  {
    return Stack(

      children: [
        // Container(
        //   height: MediaQuery. of(context). size. height,
        //     child: ClipRect( 
              
        //       child : bgScroller.getPage(context, 1)
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
        )
      ],
    );
  }
}
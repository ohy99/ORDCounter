import 'package:flutter/material.dart';
//import 'package:image/image.dart';
import 'dart:io';
import 'dart:async';

import 'mainpageview.dart';

import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'pages/Mainpage.dart';
import 'setuppage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'signup.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ORD Counter',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.green,
        textTheme: GoogleFonts.indieFlowerTextTheme(
           Theme.of(context).textTheme,
        ),
      ),
      home: SplashPage(title: 'ORD Counter'),
    );
  }
}

class SplashPage extends StatefulWidget {
  SplashPage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  SplashPageState createState() => SplashPageState();
}

class SplashPageState extends State<SplashPage> with SingleTickerProviderStateMixin  {

  //var gif;
  AnimationController _animationController;
  Timer changeScreenTimer;

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 5900));
    super.initState();
    _animationController.forward();

    changeScreenTimer = Timer(Duration(seconds: _animationController.duration.inSeconds), () { 
      nextScreen();
    });
  }

  void nextScreen()
  {
    Navigator.pushReplacement(context , MaterialPageRoute(builder: (BuildContext context) => SignUp2()));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: <Widget>[
              SplashIcon(animationController: _animationController),
              TextandImage(animationController: _animationController),
              GestureDetector(
                onTap: () { 
                  changeScreenTimer.cancel();
                  nextScreen();
                }
              )
            ],
          ),
        );
  }
}


class TextandImage extends StatelessWidget {
  final AnimationController animationController;

  TextandImage({
    @required this.animationController,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FadeTransition(
        opacity: animationController,
        child: Text("OWADIO",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            )),
      ),
    );
  }
}

class SplashIcon extends StatelessWidget {
  final AnimationController animationController;

  SplashIcon({
    @required this.animationController,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FadeTransition(
        opacity: animationController,
        child: Container(
          clipBehavior: Clip.antiAlias,
          width: MediaQuery.of(context).size.width / 2,
          height: MediaQuery.of(context).size.height / 4 - 17,
          alignment: Alignment.center,
          child: Lottie.asset("assets/images/NSman.json"),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.lightBlue,
              borderRadius: BorderRadius.circular(60)),
        ),
      ),
    );
  }
}
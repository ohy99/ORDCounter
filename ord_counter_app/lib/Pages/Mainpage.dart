import 'package:flutter/material.dart';
import 'dart:async';

import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';


class PageOffsetNotifier with ChangeNotifier {
  double _offset;
  double _page;

  PageOffsetNotifier(PageController pageController) {
    pageController.addListener(() {
      _offset = pageController.offset;
      _page = pageController.page;
      notifyListeners();
    });
  }

  double get offset => _offset;
  double get page => _page;
}


class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  AnimationController _animationController;
  AnimationController _mapAnimationController;
  final PageController _pageController = PageController();

  int _currentpage = 0;
  PageController _pageController1 =
      PageController(initialPage: 0, keepPage: false);

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 5), (Timer timer) {
      if (_currentpage < 2) {
        _currentpage++;
      } else {
        _currentpage = 0;
      }

      _pageController1.animateToPage(
        _currentpage,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeIn,
      );
    });
  }

  // double get maxHeight => mainSquareSize(context) + 32 + 24;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PageOffsetNotifier(_pageController),
      child: Scaffold(
        body: Stack(
          children: [
            Imagest(),
            PageView(
              controller: _pageController,
              physics: ClampingScrollPhysics(),
              children: <Widget>[
                Image1(),
                Image2(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Imagest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<PageOffsetNotifier>(
      builder: (context, notifier, child) {
        return Positioned(
          top: 200,
          left: 0.8 * -notifier.offset,
          height: 500,
          width: MediaQuery.of(context).size.width * 2,
          child: child,
        );
      },
      child: IgnorePointer(
        child: Lottie.asset("assets/images/landscapes2.json"),
      ),
    );
  }
}

class Image1 extends StatefulWidget {
  @override
  _Image1State createState() => _Image1State();
}

class _Image1State extends State<Image1> {
  bool moveRight = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(

    );
    //return Image.asset("assets/Humaaans/standing-9.png");
  }
}

class Image2 extends StatefulWidget {
  @override
  _Image2State createState() => _Image2State();
}

class _Image2State extends State<Image2> {
  bool moveRight2 = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          moveRight2 = !moveRight2;
        });
      },
      child: Stack(
        children: [
          Positioned(
            bottom: 200,
            width: MediaQuery.of(context).size.width,
            child: Lottie.asset("assets/images/trails.json"),
          ),
          AnimatedPositioned(
            left: moveRight2 ? 200 : -200,
            bottom: 200,
            width: MediaQuery.of(context).size.width,
            child: Lottie.asset("assets/images/movingcar.json"),
            duration: Duration(seconds: 3),
          ),
        ],
      ),
    );
  }
}
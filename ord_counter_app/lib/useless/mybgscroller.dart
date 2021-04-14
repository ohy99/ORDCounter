import 'package:flutter/material.dart';


abstract class PageViewScrollerPage extends StatefulWidget {

  final int pageNumber;
  PageViewScrollerPage({Key key, this.pageNumber}) : super(key: key);

}

abstract class PageViewScrollerState<T extends StatefulWidget> extends State<T> {
  int pageNumber;
  PageViewScrollerState({this.pageNumber});

}

MyBGScroller bgScroller = MyBGScroller();

class MyBGScroller
{
  String bgImageString = '';
  int numOfPage = 0;

  Widget getPage(BuildContext context, int pageNum)
  {
    return FittedBox(
              
              alignment: Alignment(-1.0 + (pageNum / (numOfPage - 1)) * 2.0,0),
              fit: BoxFit.none,
                child:Image.asset(
                  bgImageString,
                  width: MediaQuery. of(context). size. width * numOfPage,
                  height: MediaQuery. of(context). size. height,
                ),
              );
  }

}
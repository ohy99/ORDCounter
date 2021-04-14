import 'package:intl/intl.dart';
import 'package:ord_counter_app/EventBroadcast.dart';
import 'package:ord_counter_app/addeventinfopage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vector_math/vector_math.dart' as vmath;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'mystrings.dart';
import 'addeventpage.dart';
import 'myevent.dart';
import 'EventManager.dart';
import 'addeventinfopage.dart';

class MainPageV2 extends StatefulWidget {
  @override
  MainPageV2State createState() => MainPageV2State();
}

class MainPageV2State extends State<MainPageV2> {

  //List<MyEvent> eventList = [];
  PageNotifier pageNotifier;
  PageController pageController;
  double viewportFraction = 0.6;
  static String refreshPage = 'MP_REFRESH';

  @override
  void initState(){

    pageController = PageController(viewportFraction: viewportFraction);
    pageNotifier = PageNotifier(value: 0.0);
    pageController.addListener(() {
      pageNotifier.setValue(pageController.page);
    });

    //TODO: create events list and sort by date
    EventManager.instance.initEvents().then((value) => setState(()=>{}));

    EventBroadcast.addEvent(refreshPage, (o) { setState(() { 
      //if (pageController.page
      //print('p' + pageController.page.toString());
      if (pageController.page >= EventManager.instance.eventList.length) pageController.animateToPage(EventManager.instance.eventList.length - 1, duration: Duration(milliseconds: 500), curve: Curves.ease);
      if (pageController.page < 0.0) pageController.animateToPage(0, duration: Duration(milliseconds: 500), curve: Curves.ease);
      
    } ); return null; });

    super.initState();
  }
  @override
  void dispose(){
    super.dispose();
    //eventList.clear();
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.blue,
                    Colors.white,
                  ],
                ),
              ),
              child: Center(
                //child: AspectRatio(
                //  aspectRatio: 1.5,
                  child: ChangeNotifierProvider.value(
                    value: pageNotifier,
                    child: PageView.builder(
                      controller: pageController,
                      itemCount: EventManager.instance.eventList.length,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return EventCard(pageIndex: index.toDouble(),
                         myEvent: EventManager.instance.eventList[index],);
                    }),
                  ),
              //  ),
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: TextButton(
                // onPressed: (){
                //   popupAddevent();
                // }, 
                onPressed: null,
                child: Icon(Icons.calendar_today))
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            popupAddevent();
          },
          child: Icon(Icons.add),
        ),
        //floatingActionButtonLocation: FloatingActionButtonLocation.,
        // bottomNavigationBar: BottomAppBar(
        //   shape: CircularNotchedRectangle(),
        //   child: BottomNavigationBar(
        //     iconSize: 30,
        //     items: [
        //       BottomNavigationBarItem(
        //           icon: Icon(Icons.add),
        //           label: 'wad',
        //         ),
        //       BottomNavigationBarItem(
        //           icon: Icon(Icons.add),
        //           label: 'add',
        //         ),
        //     ],
        //   ),
          
        // ),
      ),
    );
  }

  void popupAddevent()
  {
    Navigator.of(context).push(_createRoute());
  }
  
  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => AddEventInfoPage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}

class EventCard extends StatelessWidget{

  double pageIndex = 0.0;
  MyEvent myEvent;

  EventCard({this.pageIndex, this.myEvent});

  @override
  Widget build(BuildContext context){

    double currPage = Provider.of<PageNotifier>(context).value;
    double diff = pageIndex - currPage;
    //- = left
    //0 = curr
    //+ = right
    // Matrix4 pvMatrix = Matrix4.identity()
    // ..setEntry(3, 3, 1)
    // ..setEntry(1, 1, 1)
    // ..setEntry(3, 0, 0.004 * -diff);
    Matrix4 pvMatrix = Matrix4.identity();
    //vmath.setPerspectiveMatrix(perspectiveMatrix, fovYRadians, aspectRatio, zNear, zFar)
    pvMatrix.setEntry(3, 2, 0.001);

    pvMatrix.rotateY(-diff * vmath.radians(60));
    pvMatrix.translate(diff * 20.0);
    

    return Align(
      child: AspectRatio(
      //height: MediaQuery.of(context).size.width,
      aspectRatio: 1,
      child: 
      Transform(
        transform: pvMatrix,
        alignment: diff > 0 ? FractionalOffset.centerLeft : FractionalOffset.centerRight,
        child: Card(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                child: Text(
                  myEvent.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
              ),
              Expanded(
                child: Center(
                  child: Text.rich(
                    TextSpan(
                      
                      text: (myEvent.value.length < 2 ? '0' : ''), //'01' instead of 1
                      style: TextStyle(
                        fontSize: 50, 
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        
                      ),
                      
                      
                      children: <InlineSpan>[
                        TextSpan(
                          text: myEvent.value,
                          style: TextStyle(color: Colors.black)
                        ),
                        TextSpan(
                          text: ' days',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight:  FontWeight.w200,
                            color: Colors.black
                          ),
                        ),
                        TextSpan(
                          text: '\n' + (myEvent.numOfDates > 1 
                            ? (myEvent.isCompleted 
                              ? myEvent.secondayValue
                              : 'to ' + myEvent.secondayValue + ' of total')
                            : ''),
                          style: TextStyle(
                            fontSize: 8,
                            fontWeight:  FontWeight.w200,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.zero,
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    width: 30,
                    height: 30,
                    child: Container(
                      child: TextButton(
                        onPressed: EventManager.instance.eventList.length > 1 ?
                        (){
                          EventManager.instance.deleteEvent(myEvent.key).then((value)   {
                              EventBroadcast.triggerEvent(MainPageV2State
                          .refreshPage, null);
                              
                            }
                          );
                        } :
                        null,
                        child: Center(
                          child: FittedBox( 
                            fit: BoxFit.cover, 
                            child: EventManager.instance.eventList.length > 1 ? Icon(Icons.delete_outline, color: Colors.grey,) :
                            Icon(Icons.not_interested, color: Colors.grey,)
                          )
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    )
    );
    
  }
}

class PageNotifier extends ChangeNotifier
{
  double value = 0.0;

  PageNotifier({this.value});

  void setValue(newValue){
    this.value = newValue;
    notifyListeners();
  }
}
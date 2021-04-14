import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'mystrings.dart';
import 'package:intl/intl.dart';
import 'addeventpage.dart';
import 'myevent.dart';

class UpcomingPage extends StatefulWidget {
  UpcomingPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  UpcomingPageState createState() => UpcomingPageState();
}

class UpcomingPageState extends State<UpcomingPage>{

  List<MyEvent> eventList = [];

  @override
  void initState() {
    super.initState();

    //get all the events
    
    //clear_event_data().then((value) => init_events());
    init_events();
  }
  @override
  void dispose(){
    super.dispose();
    eventList.clear();
  }

  Future<void> init_events() async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String ordDate = prefs.getString(MyStrings.sp_orddate);
    //int serviceTerm =  prefs.getInt(MyStrings.sp_serviceterm);
    DateTime oD = DateFormat(MyStrings.sp_date_format).parse('$ordDate');

    // DateTime eD = DateTime (oD.year, oD.month - serviceTerm, oD.day + 1);

    // int total = oD.difference(eD).inDays;
    // int daysLeft = oD.difference(DateTime.now()).inDays;
    //ordValue = 1.0 - (d.toDouble()/total.toDouble());
    
    int count = prefs.getInt(MyStrings.sp_eventscount);
    print(count);
    if (count == null)
    {
      //add default event
      prefs.setInt(MyStrings.sp_eventscount, 1);
      prefs.setStringList(MyStrings.sp_eventskey+'0', [
        MyStrings.eventtype_date,
        'ORD',
        DateFormat(MyStrings.sp_date_format).format(oD),
      ]);
      count = 1;
    }
    for(int i = 0; i < count; ++i)
    {
      List<String> slist = prefs.getStringList(MyStrings.sp_eventskey+i.toString());
      switch (slist[0]) {
        case MyStrings.eventtype_date:
          DateTime d = DateFormat(MyStrings.sp_date_format).parse(slist[2]);
          int v = d.difference(DateTime.now()).inDays;
          if (v<0)
          break;
          eventList.add(UpcomingEvent(name: slist[1], date: oD, value: v.toString()));
          break;
        case MyStrings.eventtype_multipledates:
        if (slist.length < 3)
        break;
        int closestday = DateFormat(MyStrings.sp_date_format).parse(slist[2]).difference(DateTime.now()).inDays;
        int datescount = slist.length - 2;
        for(int i = 3; i < slist.length;++i)
        {
          String s = slist[i];
          DateTime d = DateFormat(MyStrings.sp_date_format).parse(s);
          if (d.isBefore(DateTime.now()))
            continue;
          int diff = d.difference(DateTime.now()).inDays;
          if (diff < closestday)
            closestday = diff;
        }
        eventList.add(UpcomingEvent(name: slist[1], value: closestday.toString() + ' /'+datescount.toString()));
        break;
        case MyStrings.eventtype_range:
        DateTime mind = DateFormat(MyStrings.sp_date_format).parse(slist[2]);
        DateTime maxd = DateFormat(MyStrings.sp_date_format).parse(slist[3]);
        List<Duration> dlist = [];
        for(int i = 4; i < slist.length;++i)
        {
          String s = slist[i];
          DateTime d = DateFormat(MyStrings.sp_date_format).parse(s);
          dlist.add(d.difference(mind));
        }
        DateTime curr = mind;
        DateTime currmin = mind;
        int range = maxd.difference(mind).inDays;
        int numOfdates = 0;
        while (curr.isBefore(oD))
        {
          for (Duration dura in dlist)
          {
            curr = currmin.add(dura);
            if (curr.isBefore(DateTime.now()))
            continue;
            print(DateFormat(MyStrings.sp_date_format).format(curr));
            if (curr.isAfter(oD))
            break;
            ++numOfdates;
          }
          currmin = currmin.add(Duration(days: range + 1));
        }
        eventList.add(UpcomingEvent(name: slist[1], value: numOfdates.toString()));

        break;
        default:
          eventList.add(UpcomingEvent(name: slist[1], date: oD, value: slist[2]));
      }
      

    }
  

    setState(() {
      
    });

    //show left/total? show percent?
    //do patterns add also
  }

  @override
  Widget build(BuildContext context)
  {
    TextStyle card_ts = TextStyle(fontSize: 25);

    return RefreshIndicator(
      onRefresh: () {
        eventList.clear();
        return init_events();
      },
      child: Scaffold(
      body: 
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.all(30),
            child: Text(
              'Upcoming\nEvents',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
                
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0),
              child: ListView.builder(
                
                shrinkWrap: true,
                itemCount: eventList.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Text(
                              eventList[index].name,
                              style: card_ts,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              eventList[index].value,
                              style: card_ts)
                          ),
                      ],),
                    ),
                  );
                },
              ),
            ),
          ),
          ElevatedButton(
            onPressed: clear_event_data,
            child: Icon(Icons.delete)
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: popup_addevent,
        child: const Icon(Icons.add),
      ),
    ),
    );
    
  }
  Future<Null> clear_event_data() async
  {
    SharedPreferences pref = await SharedPreferences.getInstance();
              int count = pref.getInt(MyStrings.sp_eventscount);
              if (count != null)
              {
                for(int i =0 ;i< count; ++i)
                {
                  pref.remove(MyStrings.sp_eventskey+i.toString());
                }
              }
              pref.remove(MyStrings.sp_eventscount);
    setState(() {
      
    });
  }

  void popup_addevent()
  {
    Navigator.of(context).push(_createRoute());
  }
  
  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => AddEventPage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0);
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

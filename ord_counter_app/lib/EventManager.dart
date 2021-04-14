import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'myevent.dart';
import 'mystrings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';


class EventManager
{
  EventManager._privateConstructor();
  static final EventManager _instance = EventManager._privateConstructor();

  static EventManager get instance => _instance;

  List<MyEvent> eventList = [];
  DateTime tempDateTimeCache;
  
  Future<List<String>> saveInfo(String name, int repeatcount, List<DateTime> list, {DateTime minDate, DateTime maxDate, DateTime last}) async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int count = prefs.getInt(MyStrings.sp_eventscount);
    prefs.setInt(MyStrings.sp_eventscount, count + 1);

    List<String> ret = [];
    ret.add(name);
    ret.add(repeatcount.toString());
    ret.add(last != null ? DateFormat(MyStrings.sp_date_format).format(last) : '');
    ret.add(minDate != null ? DateFormat(MyStrings.sp_date_format).format(minDate) : '');
    ret.add(maxDate != null ? DateFormat(MyStrings.sp_date_format).format(maxDate) : '');
    ret.add(list.length.toString());

    //sort date before save
    mergeSort<DateTime>(list, compare: (DateTime l, DateTime r) { return l.compareTo(r);});
    
    for(DateTime dt in list)
    {
      ret.add(DateFormat(MyStrings.sp_date_format).format(dt));
    }

    await prefs.setStringList(MyStrings.sp_eventskey + '$count', ret);

    eventList.add(loadInfo(ret, count));

    return ret;
  }
  
  MyEvent loadInfo(List<String> info, int key) 
  {
    MyEvent ev = MyEvent(name: info[0]);
    //0: name
    //1: repeat count - min '0'
    //2: lastdate - default to ''
    //3: min - default to ''
    //4: max - default to ''
    //5: date count - min '1'
    //6: date...
    
    ev.repeatCount = int.parse(info[1]);
    if (info[2] != '')
      ev.lastRepeatingDate = DateFormat(MyStrings.sp_date_format).parse(info[2]);
    if (info[3] != '')
      ev.minDate = DateFormat(MyStrings.sp_date_format).parse(info[3]);
    if (info[4] != '')
      ev.maxDate = DateFormat(MyStrings.sp_date_format).parse(info[4]);
    int datecount = int.parse(info[5]);

    for(int i = 6; i < 6 + datecount; ++i)
    {
      DateTime d = DateFormat(MyStrings.sp_date_format).parse(info[i]);
      ev.dates.add(d); //literal data
    }

    bool isRepeating = ev.repeatCount > 0 || ev.lastRepeatingDate != null;

    if (isRepeating)
    {
      List<Duration> diffFromMinList = [];
      for (int i = 0; i < ev.dates.length; ++i)
      {
        diffFromMinList.add(Duration(days: ev.dates[i].difference( ev.minDate).inDays));
      }
      
      int rangeLen = ev.maxDate.difference(ev.minDate).inDays;

      if (ev.repeatCount > 0)
      {
        DateTime currMin = ev.minDate;

        for (int r = 0; r < ev.repeatCount; ++r) //if got repeat
        {
          for (int i = 0; i < diffFromMinList.length; ++i)
          {
            ev.allDates.add(currMin.add(diffFromMinList[i]));
          }
          currMin = currMin.add(Duration(days: rangeLen + 1));

        }
      }
      else
      {
        //repeat until last date
        DateTime currMin = ev.minDate;
        
        DateTime curr = currMin.add(diffFromMinList[0]);
        //first date confirm before last date coz input error checked
        
        do {
          for (int i = 0; i < ev.dates.length; ++i)
          {
            if (curr.isBefore(ev.lastRepeatingDate)) //check first date if should go
            {
              curr = currMin.add(diffFromMinList[i]);
              ev.allDates.add(curr);
            }
            else 
              break;
          }
          currMin = currMin.add(Duration(days: rangeLen + 1));
          curr = currMin.add(diffFromMinList[0]);

        } while (curr.isBefore(ev.lastRepeatingDate));
        
      }

    }
    else
    {
      //not repeating
      //just store all literal dates to alldates
      ev.allDates.addAll(ev.dates);
    }
    
    
    DateTime cleanNow = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    DateTime closest = getClosestDate(ev.allDates, cleanNow);
    ev.value = closest.difference(cleanNow).inDays.toString();
    if (ev.allDates.length > 1)// multiple dates
    {
      if (closest.isAfter(cleanNow))
      {
        int index = ev.allDates.indexOf(closest);
        ev.secondayValue = (index + 1).toString() + '/' + ev.allDates.length.toString();
      }
      else
      {
        //last day past alr
        ev.secondayValue = 'completed';
      }
      
    }
    if (closest.isBefore(cleanNow))
    {
      ev.isCompleted = true;
    }

    ev.key = key;

    return ev;
  }

  DateTime getClosestDate(List<DateTime> l, DateTime ref)
  {
    DateTime c ;
    for(int i = 0 ; i < l.length; ++i)
    {
      c = l[i];
      if (c.isAfter(ref)) //its sorted. the soonest after will be the closest
        return c;
    }
    return c;// all dates are before ref. return last.
  }

  Future<void> initEvents() async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String ordDate = prefs.getString(MyStrings.sp_orddate);
    DateTime oD = DateFormat(MyStrings.sp_date_format).parse('$ordDate');

    int count = prefs.getInt(MyStrings.sp_eventscount);
    print(count);
    if (count == null)
    {
      //add default event
      prefs.setInt(MyStrings.sp_eventscount, 0);//initialize 0
      await saveInfo('ORD', 0, [oD]);
      count = 1;
    }
    for(int i = 0; i < count; ++i)
    {
      List<String> info = prefs.getStringList(MyStrings.sp_eventskey + '$i');
      MyEvent e = loadInfo(info, i);
      eventList.add(e);
    }
  }

  Future<void> deleteEvent(int key) async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int count = prefs.getInt(MyStrings.sp_eventscount);

    if (key >= count)
    return; 

    //override
    for(int i = key; i < count - 1; ++i)
    {
      int next = i+1;
      List<String> info = prefs.getStringList(MyStrings.sp_eventskey + '$next');
      await prefs.setStringList(MyStrings.sp_eventskey + '$i', info);
    }
    int last = count - 1;

    prefs.setInt(MyStrings.sp_eventscount, count - 1);
    prefs.remove(MyStrings.sp_eventskey + '$last');

    eventList.removeWhere((element) => element.key == key);

    // for(var a in eventList)
    // print('k' + a.key.toString());
  }


}
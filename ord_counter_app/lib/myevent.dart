

class MyEvent{
  MyEvent({this.name, this.value});
  int key;
  String name;
  String value;
  String secondayValue = ''; //e.g. 15days to 3/5(next) of total dates
  DateTime minDate;
  DateTime maxDate;
  int repeatCount;
  DateTime lastRepeatingDate;
  List<DateTime> dates = [];

  List<DateTime> allDates = [];
  bool isCompleted = false;

  int get numOfDates { return allDates.length; }
}
class UpcomingEvent extends MyEvent
{
  UpcomingEvent({String name, this.date, String value, DateTime initialDate}) :
   super(name : name, value: value);
  DateTime date;
  //days to this date

  bool isBefore(MyEvent right, DateTime now)
  {
    if (right is UpcomingEvent)
    {
      return this.date.isBefore(right.date);
    }
    else if (right is CounterEvent)
    {
      int d = now.difference(this.date).inDays;
      return d < right.count;
    }
    else if (right is DatesLeftEvent)
    {
      return this.date.isBefore(right.getNearestDate(now));
    }
    return null;
  }
}
class CounterEvent extends MyEvent
{
  CounterEvent({String name, this.count, String value, DateTime initialDate}) : 
   super(name : name, value: value);
  int count;

  bool isBefore(MyEvent right, DateTime now)
  {
    if (right is UpcomingEvent)
    {
      int d = now.difference(right.date).inDays;
      return count < d;
    }
    else if (right is CounterEvent)
    {
      return this.count < right.count;
    }
    else if (right is DatesLeftEvent)
    {
      int d = now.difference(right.getNearestDate(now)).inDays;
      return count < d;
    }
    return null;
  }
}
class DatesLeftEvent extends MyEvent
{
  DatesLeftEvent({String name, this.dates, String value, DateTime initialDate}) :
   super(name : name, value: value);
  List<DateTime> dates = [];
  int getNumberOfDatesleft(DateTime now)
  {
    int i = 0;
    for(DateTime dt in dates)
    {
      if (now.isBefore(dt))
        ++i;
    }
    return i;
  }

  DateTime getNearestDate(DateTime now)
  {
    for(DateTime dt in dates)
    {
      if (now.isBefore(dt))
        return dt;
    }
    return dates.last;
  }

  double getPercentageLeft(DateTime now)
  {
    return (getNumberOfDatesleft(now).toDouble() / dates.length.toDouble());
  }
  //counter of dates left before ord

  bool isBefore(MyEvent right, DateTime now)
  {
    if (right is UpcomingEvent)
    {
      return this.getNearestDate(now).isBefore(right.date);
    }
    else if (right is CounterEvent)
    {
      int d = now.difference(this.getNearestDate(now)).inDays;
      return d < right.count;
    }
    else if (right is DatesLeftEvent)
    {
      return this.getNearestDate(now).isBefore(right.getNearestDate(now));
    }
    return null;
  }
}


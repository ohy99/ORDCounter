import 'package:flutter/material.dart';
import 'package:intl/date_time_patterns.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'mydatepicker.dart';
import 'mystrings.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';

class AddEventPage extends StatefulWidget {
  
  static AddEventPageState of(BuildContext context) => context.findAncestorStateOfType<AddEventPageState>();
  AddEventPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  AddEventPageState createState() => AddEventPageState();
}

class MyEvent{
  MyEvent({this.name, this.value});
  String name;
  String value;
}
class MyUpcomingEvent extends MyEvent
{
  MyUpcomingEvent({String name, this.date, String value}) :
   super(name : name, value: value);
  DateTime date;
  //days to this date
}
class MyEventCounter extends MyEvent
{
  MyEventCounter({String name, this.count, String value}) : 
   super(name : name, value: value);
  int count;
}
class DatesLeftEvent extends MyEvent
{
  DatesLeftEvent({String name, this.dates, String value}) :
   super(name : name, value: value);
  List<DateTime> dates;
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

  double getPercentageLeft(DateTime now)
  {
    return (getNumberOfDatesleft(now).toDouble() / dates.length.toDouble());
  }
  //counter of dates left before ord
}


double inputWidth = 200;
class AddEventPageState extends State<AddEventPage>{

  TextStyle ts = TextStyle(fontSize: 15);
  String choice = 'Counter';
  List<String> addoptions = ['Counter', 'Date', 'Multiple Dates', 'Range'];
  String nameOfEvent = "";
  TextEditingController name_tec = TextEditingController();
  //double inputWidth = 200;
  CounterEventAdd counterEventAdd = CounterEventAdd();
  DateEventAdd dateEventAdd = DateEventAdd();
  DaysEventAdd daysEventAdd = DaysEventAdd();
  MultipleDaysEventAdd multipleDaysEventAdd = MultipleDaysEventAdd();

  @override
  void initState()
  {
    super.initState();
    dateEventAdd.attach(this);
    daysEventAdd.attach(this);
    multipleDaysEventAdd.attach(this);
  }

  @override
  Widget build(BuildContext context)
  {
     return Scaffold(
       appBar: AppBar(
         //iconTheme: IconThemeData(color: Colors.black),
         title: Text('Add Event', style: TextStyle(),textAlign: TextAlign.center,),
       ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child:  Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // CupertinoButton(
            //   onPressed: () {
            //     showCupertinoModalPopup(
            //       context: context,
            //       builder: (BuildContext context) => CupertinoActionSheet(
            //         title: const Text('Event Type'),
            //         message: const Text('Choose add event type'),
            //         actions: cupertino_addoptions(),
            //       ),
            //     );
            //   },
            //   child: Container(
            //     width: inputWidth,
            //     decoration: BoxDecoration(border: Border.all()),
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //         children: [
            //           Text(choice),
            //           Icon(Icons.arrow_drop_down_rounded),
            //         ]
            //       ),
            //   ),
            // ),
            DropdownButton<String>(
              value: choice,
              icon: const Icon(Icons.arrow_drop_down_rounded),
              iconSize: 24,
              elevation: 16,
              //style: ts,
              underline: Container(
                height: 2,
                color: Colors.greenAccent,
              ),
              onChanged: (String newValue) {
                setState(() {
                  choice = newValue;
                });
              },
              items: addoptions
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            Container(
              width: inputWidth,
                child: TextField(
            
                controller: name_tec,
                //keyboardType: TextInputType.text,
                decoration: InputDecoration(labelText: 'Name Of Event'),
              ),
            ),
            add_option_inputs(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(onPressed: () {
                  Navigator.of(context).pop();
                }, child: Text('Cancel')),
                TextButton(onPressed: () {
                  save_option_inputs().then((value) { Navigator.of(context).pop(); });
                }, child: Text('Save')),
              ],
            )
          ],
        ),
      )
     
    );
  }

  List<Widget> cupertino_addoptions()
  {
    List<Widget> list = [];
    for(int i = 0; i < addoptions.length; ++i)
    {
      list.add(CupertinoActionSheetAction(
                        child: Text(addoptions[i]),
                        onPressed: () {
                          choice = addoptions[i];
                          Navigator.pop(context);
                        },
                      )
                    );
    }
    return list;
  }

  Widget add_option_inputs()
  {
    switch (choice) {
      case 'Date':
        return dateEventAdd.build(context);
      break;
      case 'Range':
        return daysEventAdd.build(context);
      break;
      case 'Multiple Dates':
        return multipleDaysEventAdd.build(context);
      break;
      default: //counter
        return counterEventAdd.build(context);
    }
  }
  Future<Null> save_option_inputs() async
  {
    switch (choice) {
      case 'Date':
        dateEventAdd.save(name_tec.text);
      break;
      case 'Range':
        daysEventAdd.save(name_tec.text);
      break;
      case 'Multiple Dates':
        multipleDaysEventAdd.save(name_tec.text);
      break;
      default: //counter
        counterEventAdd.save(name_tec.text);
    }
  }

  void setMyState(Function() fn) async
  {
    setState(fn);
  }
  
}


abstract class EventAdder{

  //EventAdder({this.eState});
  //AddEventPageState eState;
  String displayValue = '';
  Widget build(BuildContext context);
  void save(String name) async {}
}

class CounterEventAdd extends EventAdder
{
  TextEditingController counter_tec = TextEditingController();

  @override
  Widget build(BuildContext context)
  {
    return Column(
      children: [
        Container(
          width: inputWidth,
          child: TextField(
            
            controller: counter_tec,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Count'),
          ),
        ),
        
      ],
    );
  }

  @override
  void save(String name) async
  {
    List<String> savelist = [];
    savelist.add(MyStrings.eventtype_counter);
    savelist.add(name);
    savelist.add(counter_tec.text);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int count = prefs.getInt(MyStrings.sp_eventscount);
    prefs.setStringList(MyStrings.sp_eventskey + count.toString(), savelist);
    prefs.setInt(MyStrings.sp_eventscount, count + 1);

  }
}

class DateEventAdd extends EventAdder
{
  //DateEventAdd({AddEventPageState eState}) : super(eState: eState);
  
  //TextEditingController counter_tec = TextEditingController();
  DateTime selectedDate;
  AddEventPageState eState;
  void attach(AddEventPageState e)
  {
    eState = e;
  }

  @override
  Widget build(BuildContext context)
  {
    return Column(
      children: [
        Container(
          width: inputWidth,
          child: Row(
            children: [
              Expanded ( child: Text(displayValue)),
              OutlinedButton.icon(
                onPressed: (){ 
                  // MyDateTimePicker.selectDate(context, MyStrings.sp_date_format, 3).then((value) {
                  //   eState.setMyState(() {
                  //     displayValue = value;
                  //   });
                  // });
                  showDialog(context: context, builder: (BuildContext context) {
                      
                      return show_dialog(context);
                    });
                }, 
                icon: Icon(Icons.calendar_today_rounded),
                label: Text(''),
                )
            ],
          ),
        ),
        
      ],
    );
  }
  
  AlertDialog show_dialog(BuildContext context)
  {
    return AlertDialog(
      title: Text('Select Date'),
      content: Container(
        height: 300,
        width: 300,
        //child:  Text("WAD"),
        
        child: SfDateRangePicker(
          onSelectionChanged: _onSelectionChanged,
        ),
      ),
      actions: [
        TextButton(
          child: Text('Next'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    eState.setMyState(() {
      if (args.value is DateTime) {
        selectedDate = args.value;
        displayValue = DateFormat(MyStrings.sp_date_format).format(selectedDate);
        //counter_tec
      }
    });
  }


  @override
  void save(String name) async
  {
    List<String> savelist = [];
    savelist.add(MyStrings.eventtype_date);
    savelist.add(name);
    savelist.add(displayValue);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int count = prefs.getInt(MyStrings.sp_eventscount);
    prefs.setStringList(MyStrings.sp_eventskey + count.toString(), savelist);
    prefs.setInt(MyStrings.sp_eventscount, count + 1);
  }
}

class DaysEventAdd extends EventAdder
{
  //DateEventAdd({AddEventPageState eState}) : super(eState: eState);
  
  //TextEditingController counter_tec = TextEditingController();
  
  AddEventPageState eState;
  String _selectedDate;
  String _dateCount;
  String _range;
  String _rangeCount;
  DateTime startDateRange = DateTime.now().subtract(const Duration(days: 2));
  DateTime endDateRange = DateTime.now().add(const Duration(days: 2));
  DateTime minDate = null;
  DateTime maxDate = null;
  List<DateTime> multipleSelect = [];
  DateRangePickerSelectionMode mode = DateRangePickerSelectionMode.range;
  List<String> s = [];

  void attach(AddEventPageState e)
  {
    eState = e;
  }

  @override
  Widget build(BuildContext context)
  {
    return Column(
      children: [
        Container(
          width: inputWidth,
          child: Row(
            children: [
              Expanded ( child: Text(displayValue)),
              OutlinedButton.icon(
                onPressed: (){ 
                  showDialog(
                    context: context,
                    
                    builder: (BuildContext context) {
                      
                      return show_dialog(context);
                    }
                  );
                }, 
                icon: Icon(Icons.calendar_today_rounded),
                label: Text(''),
                )
            ],
          ),
        ),
        
      ],
    );
  }

  AlertDialog show_dialog(BuildContext context)
  {
    return AlertDialog(
      title: Text('Select range'),
      content: Container(
        height: 300,
        width: 300,
        //child:  Text("WAD"),
        
        child: SfDateRangePicker(
          onSelectionChanged: _onSelectionChanged,
          selectionMode: mode,
          initialSelectedRange: PickerDateRange(
              startDateRange,
              endDateRange),
          // minDate: minDate,
          // maxDate: maxDate,
        ),
      ),
      actions: [
        TextButton(
          child: Text('Next'),
          onPressed: () { 
            print('_selectedDate ' + (_selectedDate==null ? 'null' : _selectedDate));
            print('_dateCount ' + (_dateCount==null ? 'null' : _dateCount));
            print('_range ' + (_range==null ? 'null' : _range));
            print('_rangeCount ' + (_rangeCount==null ? 'null' : _rangeCount));

            if (mode == DateRangePickerSelectionMode.range)
            {
              minDate = startDateRange;
              maxDate = endDateRange;
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Select dates'),
                    content: Container(
                      height: 300,
                      width: 300,
                      child: SfDateRangePicker(
                        onSelectionChanged: _onSelectionChanged,
                        selectionMode: DateRangePickerSelectionMode.multiple,
                        minDate: minDate,
                        maxDate: maxDate,
                      ),
                    ),
                    actions: [
                      TextButton(
                        child: Text('Ok'),
                        onPressed: () { 
                          for(DateTime dt in multipleSelect)
                          {
                            String d = DateFormat(MyStrings.sp_date_format).format(dt);
                            s.add(d);
                          }
                          displayValue = 'selected ' + s.length.toString() + ' from range';
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  );
                }
              );
              eState.setMyState(() {
              //mode = DateRangePickerSelectionMode.multiple;
              });
            }
           
          },
        ),
      ],
    );
  }


  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    /// The argument value will return the changed date as [DateTime] when the
    /// widget [SfDateRangeSelectionMode] set as single.
    ///
    /// The argument value will return the changed dates as [List<DateTime>]
    /// when the widget [SfDateRangeSelectionMode] set as multiple.
    ///
    /// The argument value will return the changed range as [PickerDateRange]
    /// when the widget [SfDateRangeSelectionMode] set as range.
    ///
    /// The argument value will return the changed ranges as
    /// [List<PickerDateRange] when the widget [SfDateRangeSelectionMode] set as
    /// multi range.
    eState.setMyState(() {
      if (args.value is PickerDateRange) {
        _range = DateFormat('dd/MM/yyyy').format(args.value.startDate).toString() +
                ' - ' +
                DateFormat('dd/MM/yyyy')
                    .format(args.value.endDate ?? args.value.startDate)
                    .toString();
        startDateRange = args.value.startDate;
        endDateRange = args.value.endDate;
      } else if (args.value is DateTime) {
        _selectedDate = args.value;
      } else if (args.value is List<DateTime>) {
        //_dateCount = args.value.length.toString();
        multipleSelect = args.value;
      } else {
        //_rangeCount = args.value.length.toString();
      }
    });
  }

  @override
  void save(String name) async
  {
    //mindate - maxdate
    //duplicate pattern until ord date
    // List<Duration> dlist = [];
    // for(DateTime dt in multipleSelect)
    // {
    //   dlist.add(dt.difference(minDate));
    // }
    List<String> savelist = [];
    savelist.add(MyStrings.eventtype_range);
    savelist.add(name);
    savelist.add(DateFormat(MyStrings.sp_date_format).format(minDate));
    savelist.add(DateFormat(MyStrings.sp_date_format).format(maxDate));
    savelist.addAll(s);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int count = prefs.getInt(MyStrings.sp_eventscount);
    prefs.setStringList(MyStrings.sp_eventskey + count.toString(), savelist);
    prefs.setInt(MyStrings.sp_eventscount, count + 1);

  }
}


class MultipleDaysEventAdd extends EventAdder
{
  //DateEventAdd({AddEventPageState eState}) : super(eState: eState);
  
  //TextEditingController counter_tec = TextEditingController();
  
  AddEventPageState eState;
  String _selectedDate;
  String _dateCount;
  String _range;
  String _rangeCount;
  List<DateTime> multipleSelect = [];
  DateRangePickerSelectionMode mode = DateRangePickerSelectionMode.multiple;
  List<String> s = [];

  void attach(AddEventPageState e)
  {
    eState = e;
  }

  @override
  Widget build(BuildContext context)
  {
    return Column(
      children: [
        Container(
          width: inputWidth,
          child: Row(
            children: [
              Expanded ( child: Text(displayValue)),
              OutlinedButton.icon(
                onPressed: (){ 
                  showDialog(
                    context: context,
                    
                    builder: (BuildContext context) {
                      
                      return show_dialog(context);
                    }
                  );
                }, 
                icon: Icon(Icons.calendar_today_rounded),
                label: Text(''),
                )
            ],
          ),
        ),
        
      ],
    );
  }

  AlertDialog show_dialog(BuildContext context)
  {
    return AlertDialog(
      title: Text('Select Dates'),
      content: Container(
        height: 300,
        width: 300,
        //child:  Text("WAD"),
        
        child: SfDateRangePicker(
          onSelectionChanged: _onSelectionChanged,
          selectionMode: mode,
        ),
      ),
      actions: [
        TextButton(
          child: Text('Next'),
          onPressed: () { 
            print('_selectedDate ' + (_selectedDate==null ? 'null' : _selectedDate));
            print('_dateCount ' + (_dateCount==null ? 'null' : _dateCount));
            print('_range ' + (_range==null ? 'null' : _range));
            print('_rangeCount ' + (_rangeCount==null ? 'null' : _rangeCount));

            for(DateTime dt in multipleSelect)
            {
              s.add(DateFormat(MyStrings.sp_date_format).format(dt));
            }

            displayValue = 'selected ' + s.length.toString();
            Navigator.pop(context);
            eState.setMyState(() {
              //mode = DateRangePickerSelectionMode.multiple;
            });
          },
        ),
      ],
    );
  }


  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    eState.setMyState(() {
      if (args.value is PickerDateRange) {
        _range = DateFormat('dd/MM/yyyy').format(args.value.startDate).toString() +
                ' - ' +
                DateFormat('dd/MM/yyyy')
                    .format(args.value.endDate ?? args.value.startDate)
                    .toString();
        // startDateRange = args.value.startDate;
        // endDateRange = args.value.endDate;
      } else if (args.value is DateTime) {
        _selectedDate = args.value;
      } else if (args.value is List<DateTime>) {
        _dateCount = args.value.length.toString();
        multipleSelect = args.value;
      } else {
        _rangeCount = args.value.length.toString();
      }
    });
  }

  @override
  void save(String name) async
  {
    //mindate - maxdate
    //duplicate pattern until ord date
    // List<Duration> dlist = [];

    List<String> savelist = [];
    savelist.add(MyStrings.eventtype_multipledates);
    savelist.add(name);
    savelist.addAll(s);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int count = prefs.getInt(MyStrings.sp_eventscount);
    prefs.setStringList(MyStrings.sp_eventskey + count.toString(), savelist);
    prefs.setInt(MyStrings.sp_eventscount, count + 1);

  }
}
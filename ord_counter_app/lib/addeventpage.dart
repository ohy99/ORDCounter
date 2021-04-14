import 'package:flutter/material.dart';
import 'package:intl/date_time_patterns.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'mydatepicker.dart';
import 'mystrings.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'myevent.dart';


import 'EventTypes/CounterEvent.dart';
import 'EventTypes/DateEvent.dart';
import 'EventTypes/EventAdder.dart';
import 'EventBroadcast.dart';
import 'addeventinfopage.dart';
import 'EventManager.dart';

class AddEventPage extends StatefulWidget {
  
  static AddEventPageState of(BuildContext context) => context.findAncestorStateOfType<AddEventPageState>();
  AddEventPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  AddEventPageState createState() => AddEventPageState();
}


class AddEventPageState extends State<AddEventPage>{

  TextStyle ts = TextStyle(fontSize: 15);
  String choice = 'Date';
  List<String> addoptions = [ 'Date', 'Counter', 'Multiple Dates', 'Range'];
  String nameOfEvent = "";
  TextEditingController name_tec = TextEditingController();
  //double inputWidth = 200;
  // CounterEventAdd counterEventAdd = CounterEventAdd();
  // DateEventAdd dateEventAdd = DateEventAdd();
  // DaysEventAdd daysEventAdd = DaysEventAdd();
  // MultipleDaysEventAdd multipleDaysEventAdd = MultipleDaysEventAdd();
  DateRangePickerController datePickerController = DateRangePickerController();
  DateTime selectedDate;

  @override
  void initState()
  {
    super.initState();
    // dateEventAdd.attach(this);
    // daysEventAdd.attach(this);
    // multipleDaysEventAdd.attach(this);
    selectedDate = DateTime.now();
  }

  @override
  void dispose()
  {
    datePickerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context)
  {
    DateTime todayDate = DateTime.now();

     return Scaffold(
       appBar: AppBar(
         //backgroundColor: Colors.white,
         //iconTheme: IconThemeData(color: Colors.black),
         title: Text('Calendar',),
       ),
      body: Container(
        padding: EdgeInsets.only(top:MediaQuery.of(context).viewPadding.top),
        width: MediaQuery.of(context).size.width,
        child:  Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.only(top: 10),
              child: SfDateRangePicker(
                //cellBuilder: cellBuilder,
                selectionShape: DateRangePickerSelectionShape.circle,
                controller: datePickerController,
                initialSelectedDate: selectedDate,
                onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                  if (args.value is PickerDateRange) {
                    final DateTime rangeStartDate = args.value.startDate;
                    final DateTime rangeEndDate = args.value.endDate;
                  } else if (args.value is DateTime) {
                    selectedDate = args.value;
                    //print(selectedDate);
                  } else if (args.value is List<DateTime>) {
                    final List<DateTime> selectedDates = args.value;
                  } else {
                    final List<PickerDateRange> selectedRanges = args.value;
                  }
                },
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(onPressed: () {
                  Navigator.of(context).pop();
                }, child: Text('Cancel')),
                TextButton(onPressed: () {
                  showDialog(context: context, builder: addEventDialog);
                  //save_option_inputs().then((value) { Navigator.of(context).pop(); });
                }, child: Text('Next')),
              ],
            )
          ],
        ),
      )
     
    );
  }


  bool isSameDate(DateTime l, DateTime r)
  {
    DateTime a = DateTime(l.year, l.month, l.day);
    DateTime b = DateTime(r.year, r.month, r.day);
    return a.isAtSameMomentAs(b);
  }

  Widget cellBuilder(BuildContext context, DateRangePickerCellDetails cellDetails) {

    BoxDecoration cellDecoration =  new BoxDecoration(
        //color: Colors.orange,
        shape: BoxShape.circle,
    );

    final bool isToday = isSameDate(cellDetails.date, DateTime.now());
    // final bool isBlackOut = isBlackedDate(cellDetails.date.day);
    // final bool isSpecialDate = isSpecialDay(cellDetails.date.day);
    return Container(
        margin: EdgeInsets.all(2),
        //padding: EdgeInsets.only(top: kIsWeb ? 5 : 10),
        decoration: BoxDecoration(
            //color: Colors.blueAccent,
            border: isToday
                ? Border.all(color: Colors.black, width: 2)
                : null,
            shape: BoxShape.circle
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Text(
                cellDetails.date.day.toString(),
                style: TextStyle(
                  //fontSize: kIsWeb ? 11 : 15,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
            ),
           
            
            // isBlackOut
            //     ? Icon(
            //         Icons.block_sharp,
            //         size: 13,
            //       )
            //     : isSpecialDate
            //         ? Row(
            //             mainAxisAlignment: MainAxisAlignment.center,
            //             children: [
            //               Icon(
            //                 Icons.cake,
            //                 size: 13,
            //               ),
            //               Icon(
            //                 Icons.celebration,
            //                 size: 13,
            //               ),
            //               Icon(
            //                 Icons.audiotrack,
            //                 size: 13,
            //               )
            //             ],
            //           )
            //         : Container()
          ],
        ),
      
    );



    // if (datePickerController.view == DateRangePickerView.month) {
    //   return Container(
    //     //decoration: cellDecoration,
    //     width: cellDetails.bounds.width,
    //     height: cellDetails.bounds.height,
    //     alignment: Alignment.center,
    //     // child: TextButton(
    //     //   onPressed: () {
    //     //     // showDialog(context: context, builder: (BuildContext context) { 
    //     //     //   return AlertDialog(
    //     //     //     title: Text('Select Date'),
    //     //     //     content: Text('hello'),
    //     //     //     actions: [
    //     //     //       TextButton(
    //     //     //         child: Text('Next'),
    //     //     //         onPressed: () {
    //     //     //           Navigator.pop(context);
    //     //     //         },
    //     //     //       ),
    //     //     //     ],
    //     //     //   ); 
    //     //     // } );
    //     //     print('hello');
    //     //    },
    //       child: Text(cellDetails.date.day.toString()),
    //     //),
    //   );
    // } else if (datePickerController.view == DateRangePickerView.year) {
    //   return Container(
    //     decoration: cellDecoration,
    //     width: cellDetails.bounds.width,
    //     height: cellDetails.bounds.height,
    //     alignment: Alignment.center,
    //     child: Text(DateFormat('MMM').format(cellDetails.date)),
    //   );
    // } else if (datePickerController.view == DateRangePickerView.decade) {
    //   return Container(
    //     width: cellDetails.bounds.width,
    //     height: cellDetails.bounds.height,
    //     alignment: Alignment.center,
    //     child: Text(cellDetails.date.year.toString()),
    //   );
    // } else {
    //   final int yearValue = (cellDetails.date.year ~/ 10) * 10;
    //   return Container(
    //     width: cellDetails.bounds.width,
    //     height: cellDetails.bounds.height,
    //     alignment: Alignment.center,
    //     child: Text(
    //       yearValue.toString() + ' - ' + (yearValue + 9).toString()),
    //   );
    // }

  }

  Widget addEventDialog(BuildContext context)
  {
    EventManager.instance.tempDateTimeCache = selectedDate;
    return AlertDialog(
      titlePadding: EdgeInsets.only(left: 15),
      title: Row(
        
        children: [
          Text(DateFormat(MyStrings.addevent_displaydate_format).format(selectedDate)),
          Spacer(),
          TextButton(
            onPressed: (){
              popupAddevent();
            }, 
            child: Icon(Icons.add)
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              
            ),
          ],
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

  void setMyState(Function() fn) async
  {
    setState(fn);
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

// class DaysEventAdd extends EventAdder
// {
//   //DateEventAdd({AddEventPageState eState}) : super(eState: eState);
  
//   //TextEditingController counter_tec = TextEditingController();
  
//   AddEventPageState eState;
//   String _selectedDate;
//   String _dateCount;
//   String _range;
//   String _rangeCount;
//   DateTime startDateRange = DateTime.now().subtract(const Duration(days: 2));
//   DateTime endDateRange = DateTime.now().add(const Duration(days: 2));
//   DateTime minDate = null;
//   DateTime maxDate = null;
//   List<DateTime> multipleSelect = [];
//   DateRangePickerSelectionMode mode = DateRangePickerSelectionMode.range;
//   List<String> s = [];

//   void attach(AddEventPageState e)
//   {
//     eState = e;
//   }

//   @override
//   Widget build(BuildContext context)
//   {
//     return Column(
//       children: [
//         Container(
//           width: inputWidth,
//           child: Row(
//             children: [
//               Expanded ( child: Text(displayValue)),
//               OutlinedButton.icon(
//                 onPressed: (){ 
//                   showDialog(
//                     context: context,
                    
//                     builder: (BuildContext context) {
                      
//                       return show_dialog(context);
//                     }
//                   );
//                 }, 
//                 icon: Icon(Icons.calendar_today_rounded),
//                 label: Text(''),
//                 )
//             ],
//           ),
//         ),
        
//       ],
//     );
//   }

//   AlertDialog show_dialog(BuildContext context)
//   {
//     return AlertDialog(
//       title: Text('Select range'),
//       content: Container(
//         height: 300,
//         width: 300,
//         //child:  Text("WAD"),
        
//         child: SfDateRangePicker(
//           onSelectionChanged: _onSelectionChanged,
//           selectionMode: mode,
//           initialSelectedRange: PickerDateRange(
//               startDateRange,
//               endDateRange),
//           // minDate: minDate,
//           // maxDate: maxDate,
//         ),
//       ),
//       actions: [
//         TextButton(
//           child: Text('Next'),
//           onPressed: () { 
//             print('_selectedDate ' + (_selectedDate==null ? 'null' : _selectedDate));
//             print('_dateCount ' + (_dateCount==null ? 'null' : _dateCount));
//             print('_range ' + (_range==null ? 'null' : _range));
//             print('_rangeCount ' + (_rangeCount==null ? 'null' : _rangeCount));

//             if (mode == DateRangePickerSelectionMode.range)
//             {
//               minDate = startDateRange;
//               maxDate = endDateRange;
//               showDialog(
//                 context: context,
//                 builder: (BuildContext context) {
//                   return AlertDialog(
//                     title: Text('Select dates'),
//                     content: Container(
//                       height: 300,
//                       width: 300,
//                       child: SfDateRangePicker(
//                         onSelectionChanged: _onSelectionChanged,
//                         selectionMode: DateRangePickerSelectionMode.multiple,
//                         minDate: minDate,
//                         maxDate: maxDate,
//                       ),
//                     ),
//                     actions: [
//                       TextButton(
//                         child: Text('Ok'),
//                         onPressed: () { 
//                           for(DateTime dt in multipleSelect)
//                           {
//                             String d = DateFormat(MyStrings.sp_date_format).format(dt);
//                             s.add(d);
//                           }
//                           displayValue = 'selected ' + s.length.toString() + ' from range';
//                           Navigator.pop(context);
//                           Navigator.pop(context);
//                         },
//                       ),
//                     ],
//                   );
//                 }
//               );
//               eState.setMyState(() {
//               //mode = DateRangePickerSelectionMode.multiple;
//               });
//             }
           
//           },
//         ),
//       ],
//     );
//   }


//   void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
//     /// The argument value will return the changed date as [DateTime] when the
//     /// widget [SfDateRangeSelectionMode] set as single.
//     ///
//     /// The argument value will return the changed dates as [List<DateTime>]
//     /// when the widget [SfDateRangeSelectionMode] set as multiple.
//     ///
//     /// The argument value will return the changed range as [PickerDateRange]
//     /// when the widget [SfDateRangeSelectionMode] set as range.
//     ///
//     /// The argument value will return the changed ranges as
//     /// [List<PickerDateRange] when the widget [SfDateRangeSelectionMode] set as
//     /// multi range.
//     eState.setMyState(() {
//       if (args.value is PickerDateRange) {
//         _range = DateFormat('dd/MM/yyyy').format(args.value.startDate).toString() +
//                 ' - ' +
//                 DateFormat('dd/MM/yyyy')
//                     .format(args.value.endDate ?? args.value.startDate)
//                     .toString();
//         startDateRange = args.value.startDate;
//         endDateRange = args.value.endDate;
//       } else if (args.value is DateTime) {
//         _selectedDate = args.value;
//       } else if (args.value is List<DateTime>) {
//         //_dateCount = args.value.length.toString();
//         multipleSelect = args.value;
//       } else {
//         //_rangeCount = args.value.length.toString();
//       }
//     });
//   }

//   @override
//   void save(String name) async
//   {
//     //mindate - maxdate
//     //duplicate pattern until ord date
//     // List<Duration> dlist = [];
//     // for(DateTime dt in multipleSelect)
//     // {
//     //   dlist.add(dt.difference(minDate));
//     // }
//     List<String> savelist = [];
//     savelist.add(MyStrings.eventtype_range);
//     savelist.add(name);
//     savelist.add(DateFormat(MyStrings.sp_date_format).format(minDate));
//     savelist.add(DateFormat(MyStrings.sp_date_format).format(maxDate));
//     savelist.addAll(s);
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     int count = prefs.getInt(MyStrings.sp_eventscount);
//     prefs.setStringList(MyStrings.sp_eventskey + count.toString(), savelist);
//     prefs.setInt(MyStrings.sp_eventscount, count + 1);

//   }
// }


// class MultipleDaysEventAdd extends EventAdder
// {
//   //DateEventAdd({AddEventPageState eState}) : super(eState: eState);
  
//   //TextEditingController counter_tec = TextEditingController();
  
//   AddEventPageState eState;
//   String _selectedDate;
//   String _dateCount;
//   String _range;
//   String _rangeCount;
//   List<DateTime> multipleSelect = [];
//   DateRangePickerSelectionMode mode = DateRangePickerSelectionMode.multiple;
//   List<String> s = [];

//   void attach(AddEventPageState e)
//   {
//     eState = e;
//   }

//   @override
//   Widget build(BuildContext context)
//   {
//     return Column(
//       children: [
//         Container(
//           width: inputWidth,
//           child: Row(
//             children: [
//               Expanded ( child: Text(displayValue)),
//               OutlinedButton.icon(
//                 onPressed: (){ 
//                   showDialog(
//                     context: context,
                    
//                     builder: (BuildContext context) {
                      
//                       return show_dialog(context);
//                     }
//                   );
//                 }, 
//                 icon: Icon(Icons.calendar_today_rounded),
//                 label: Text(''),
//                 )
//             ],
//           ),
//         ),
        
//       ],
//     );
//   }

//   AlertDialog show_dialog(BuildContext context)
//   {
//     return AlertDialog(
//       title: Text('Select Dates'),
//       content: Container(
//         height: 300,
//         width: 300,
//         //child:  Text("WAD"),
        
//         child: SfDateRangePicker(
//           onSelectionChanged: _onSelectionChanged,
//           selectionMode: mode,
//         ),
//       ),
//       actions: [
//         TextButton(
//           child: Text('Next'),
//           onPressed: () { 
//             print('_selectedDate ' + (_selectedDate==null ? 'null' : _selectedDate));
//             print('_dateCount ' + (_dateCount==null ? 'null' : _dateCount));
//             print('_range ' + (_range==null ? 'null' : _range));
//             print('_rangeCount ' + (_rangeCount==null ? 'null' : _rangeCount));

//             for(DateTime dt in multipleSelect)
//             {
//               s.add(DateFormat(MyStrings.sp_date_format).format(dt));
//             }

//             displayValue = 'selected ' + s.length.toString();
//             Navigator.pop(context);
//             eState.setMyState(() {
//               //mode = DateRangePickerSelectionMode.multiple;
//             });
//           },
//         ),
//       ],
//     );
//   }


//   void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
//     eState.setMyState(() {
//       if (args.value is PickerDateRange) {
//         _range = DateFormat('dd/MM/yyyy').format(args.value.startDate).toString() +
//                 ' - ' +
//                 DateFormat('dd/MM/yyyy')
//                     .format(args.value.endDate ?? args.value.startDate)
//                     .toString();
//         // startDateRange = args.value.startDate;
//         // endDateRange = args.value.endDate;
//       } else if (args.value is DateTime) {
//         _selectedDate = args.value;
//       } else if (args.value is List<DateTime>) {
//         _dateCount = args.value.length.toString();
//         multipleSelect = args.value;
//       } else {
//         _rangeCount = args.value.length.toString();
//       }
//     });
//   }

//   @override
//   void save(String name) async
//   {
//     //mindate - maxdate
//     //duplicate pattern until ord date
//     // List<Duration> dlist = [];

//     List<String> savelist = [];
//     savelist.add(MyStrings.eventtype_multipledates);
//     savelist.add(name);
//     savelist.addAll(s);
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     int count = prefs.getInt(MyStrings.sp_eventscount);
//     prefs.setStringList(MyStrings.sp_eventskey + count.toString(), savelist);
//     prefs.setInt(MyStrings.sp_eventscount, count + 1);

//   }
// }
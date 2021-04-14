import 'package:flutter/material.dart';
import 'EventAdder.dart';

import 'package:ord_counter_app/EventBroadcast.dart';
import 'package:ord_counter_app/mystrings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DateEventAdd extends EventAdder
{
  //DateEventAdd({AddEventPageState eState}) : super(eState: eState);
  
  //TextEditingController counter_tec = TextEditingController();
  DateTime selectedDate;

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
                      
                      //return show_dialog(context);
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
  
  // AlertDialog show_dialog(BuildContext context)
  // {
  //   return AlertDialog(
  //     title: Text('Select Date'),
  //     content: Container(
  //       height: 300,
  //       width: 300,
  //       //child:  Text("WAD"),
        
  //       child: SfDateRangePicker(
  //         onSelectionChanged: _onSelectionChanged,
  //       ),
  //     ),
  //     actions: [
  //       TextButton(
  //         child: Text('Next'),
  //         onPressed: () {
  //           Navigator.pop(context);
  //         },
  //       ),
  //     ],
  //   );
  // }

  // void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
  //   eState.setMyState(() {
  //     if (args.value is DateTime) {
  //       selectedDate = args.value;
  //       displayValue = DateFormat(MyStrings.sp_date_format).format(selectedDate);
  //       //counter_tec
  //     }
  //   });
  // }


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
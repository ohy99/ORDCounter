import 'package:flutter/material.dart';
import 'package:ord_counter_app/EventBroadcast.dart';
import 'package:ord_counter_app/EventManager.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'mystrings.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'mydatepicker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'mainpage_v2.dart';

class AddEventInfoPage extends StatefulWidget {
  
  AddEventInfoPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  AddEventInfoState createState() => AddEventInfoState();
}

enum RepeatType{
  lastDay, numOfTimes
}

class AddEventInfoState extends State<AddEventInfoPage>{

  TextEditingController name_tec = TextEditingController();
  TextEditingController repeatTimes_tec = TextEditingController();
  String choice = 'Single Date';
  List<String> addoptions = [ 'Single Date', 'Multiple Dates', 'Repeating', 'Counter'];
  
  DateRangePickerController datePickerController = DateRangePickerController();
  DateRangePickerController datePickerController2 = DateRangePickerController();
  DateTime selectedDate;
  DateRangePickerSelectionMode get dateRangePickerSelectionMode {

    if(choice == addoptions[1])
      return DateRangePickerSelectionMode.multiple;
    if(choice == addoptions[2])
      return DateRangePickerSelectionMode.multiple;
    
    return DateRangePickerSelectionMode.multiple;
  }
  List<DateTime> multipleDates = [];
  DateTime endDate;
  DateTime startDate;
  DateTime lastDate;
  bool isRepeating = false;
  RepeatType repeatType = RepeatType.lastDay;
  int repeatTimes = 0;

  @override
  void initState()
  {
    super.initState();

    selectedDate = EventManager.instance.tempDateTimeCache;
    if (selectedDate == null)
      selectedDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    repeatTimes_tec.text = '1';

    
    if (endDate == null)
    endDate = selectedDate;
    if (startDate == null)
    startDate = selectedDate;
    if (lastDate == null)
    lastDate = selectedDate.add(Duration(days: 30));
  }
  
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        actions: [
            TextButton(
              onPressed: () async {
                //ADD EVENT
                if (multipleDates.length == 0)
                {
                  Fluttertoast.showToast(
                    msg: "You have not selected any dates!",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    //backgroundColor: Colors.red,
                    //textColor: Colors.white,
                    fontSize: 16.0
                  );
                  return;
                }

                if (name_tec.text == '')
                {
                  Fluttertoast.showToast(
                    msg: "Please name your event!",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    fontSize: 16.0
                  );
                  return;
                }

                if (isRepeating)
                {
                  if (repeatType == RepeatType.numOfTimes)
                    await EventManager.instance.saveInfo(name_tec.text, repeatTimes, multipleDates);
                  else
                  {
                    //check if last date is after min
                    if (lastDate.isBefore(multipleDates[0])) //if last date is before first selected date, complain!
                    {
                      Fluttertoast.showToast(
                        msg: "Your end date must be after your first date!",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        fontSize: 16.0
                      );
                      return;
                    }


                    await EventManager.instance.saveInfo(name_tec.text, 0, multipleDates, minDate: startDate, maxDate: endDate, last: lastDate);
                  }
                    
                }
                else 
                  await EventManager.instance.saveInfo(name_tec.text, 0, multipleDates);
                
                EventBroadcast.triggerEvent(MainPageV2State.refreshPage, null);
                Navigator.of(context).pop();
              }, 
              child: Icon(Icons.check_rounded, color: Colors.white,)
            ),
          
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: TextField(
                controller: name_tec,
                decoration: InputDecoration(labelText: 'Name Of Event')
              ),
            ),

            Container(
              padding: EdgeInsets.only(top: 10),
              child: SfDateRangePicker(
                //cellBuilder: cellBuilder,
                selectionMode: dateRangePickerSelectionMode,
                selectionShape: DateRangePickerSelectionShape.circle,
                controller: datePickerController,
                initialSelectedDate: selectedDate,
                
                onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                  if (args.value is PickerDateRange) {
                    final DateTime rangeStartDate = args.value.startDate;
                    final DateTime rangeEndDate = args.value.endDate;
                    selectedDate = rangeStartDate;
                    endDate = rangeEndDate;
                    print('start ' + selectedDate.toString() + '  end ' + endDate.toString());
                    if (endDate == null)
                    {
                      endDate = rangeStartDate;
                    }
                    multipleDates.removeWhere((element) =>
                        !(element.isAfter(rangeStartDate) && element.isBefore(endDate))
                      );
                      print('mdates len ' + multipleDates.length.toString());
                    setState(() {
                      //check if multiple date selection falls within range
                      
                    });

                    print('dp2 ' + datePickerController2.selectedDates.length.toString());
                    
                  } else if (args.value is DateTime) {
                    selectedDate = args.value;
                    //print(selectedDate);
                  } else if (args.value is List<DateTime>) {
                    final List<DateTime> selectedDates = args.value;
                    if (selectedDates.length > 0)
                      selectedDate = selectedDates.first;
                    multipleDates = selectedDates;
                    setState(() {
                      
                    });
                  }
                  // else {
                  //   final List<PickerDateRange> selectedRanges = args.value;
                  // }
                },
              ),
            ),
            Text('selected ' + multipleDates.length.toString() + ' days', textAlign: TextAlign.center, style: TextStyle(fontSize: 10),),
            TextButton(
              onPressed: () {
                showDialog(context: context, builder: (BuildContext context){
                  return StatefulBuilder(
                    builder: (context, setState) {
                      return AlertDialog(
                        title: Text('Repeating range'),
                        content: Container(
                          //height: 200,
                          child: Column(
                              children: [
                                ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  leading: Icon(Icons.chevron_left),
                                  title: Text(DateFormat(
                                    MyStrings.addevent_displaydate_format).format(startDate),
                                    //style: TextStyle(fontSize: 12),
                                  ),
                                  trailing: Container(
                                    width: 48,
                                    child: TextButton(
                                        onPressed: (){
                                          MyDateTimePicker.selectDateTime(context, startDate, 10).then((value) {
                                            setState(() => startDate = value);
                                          });
                                        }, 
                                        child: Icon(Icons.calendar_today_rounded),
                                      ),
                                  ),
                                ),
                                ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  leading: Icon(Icons.chevron_right),
                                  title: Text(
                                    DateFormat(MyStrings.addevent_displaydate_format).format(endDate),
                                  ),
                                  trailing: Container(
                                    width: 48,
                                    child: TextButton(
                                        onPressed: (){
                                          MyDateTimePicker.selectDateTime(context, startDate, 10).then((value) {
                                            setState(() => endDate = value);
                                          });
                                        }, 
                                        child: Icon(Icons.calendar_today_rounded),
                                      ),
                                  ),
                                ),

                              //SETTING REPEAT TYPES
                              Divider(
                                height: 3,
                                indent: 10.0,
                                endIndent: 10.0,
                              ),
                                SwitchListTile(
                                  contentPadding: EdgeInsets.zero,
                                  secondary: Container(
                                    width: 30,
                                    height: 30,
                                    child: FittedBox(
                                      fit: BoxFit.fitHeight,
                                      alignment: Alignment.center,
                                      child: TextButton(
                                        
                                        onPressed: (){
                                          MyDateTimePicker.selectDateTime(context, startDate, 10).then((value) {
                                            setState(() => lastDate = value);
                                          });
                                        }, 
                                        child: Icon(Icons.calendar_today_rounded),
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    DateFormat(MyStrings.addevent_displaydate_format).format(lastDate) + ' is the last day',
                                    style: TextStyle(fontSize: 10),
                                  ),
                                  value: repeatType == RepeatType.lastDay,
                                  onChanged: (newValue) { setState(()=> repeatType = RepeatType.lastDay); },
                                ),
                                SwitchListTile(
                                  contentPadding: EdgeInsets.zero,
                                  secondary: Container(
                                    width: 30,
                                    height: 30,
                                    
                                    child: TextField(
                                      controller: repeatTimes_tec,
                                      keyboardType: TextInputType.number,
                                      onChanged: (value) {
                                        setState(()=>repeatTimes = int.parse(value));
                                      },
                                      textAlign: TextAlign.center,
                                    )
                                  ),
                                  title: Text(
                                    'Event range will repeat ' + repeatTimes.toString() + ' times',
                                    style: TextStyle(fontSize: 10),
                                  ),
                                  value: repeatType == RepeatType.numOfTimes,
                                  onChanged: (newValue) { setState(()=> repeatType = RepeatType.numOfTimes); },
                                ),
                              ],
                            ),
                        ),
                        actions: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                child: Text('OK'),
                                onPressed: () {
                                  setState(()=>Navigator.pop(context)); 
                                },
                              ),
                            ],
                          ),
                          
                        ],
                      );
                    }
                  );
                });
              },
              child: ListTile(
                leading: Icon(Icons.repeat_rounded, color: isRepeating ? Colors.green : Colors.grey,),
                title: isRepeating ? 
                 repeatType == RepeatType.lastDay ? 
                    Text('Repeat until ' + DateFormat(MyStrings.addevent_displaydate_format).format(lastDate)) : 
                    Text('Repeat for ' + repeatTimes.toString() + ' times')
                : Text('Not Repeating'),
                trailing: Switch(
                  value: isRepeating,
                  onChanged: (bool newValue) {
                    setState(() => isRepeating = newValue);
                  },
                ),
                
              ),
          )

          ],
        ),
      ),
    );
  }
}
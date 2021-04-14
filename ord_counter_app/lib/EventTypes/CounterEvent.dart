import 'package:flutter/material.dart';
import 'EventAdder.dart';
import 'package:ord_counter_app/mystrings.dart';
import 'package:shared_preferences/shared_preferences.dart';


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

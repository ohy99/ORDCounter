import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'mystrings.dart';
import 'mainpageview.dart';

class SetupPage extends StatefulWidget {
  @override
  SetupPageState createState() => SetupPageState();
}

class SetupPageState extends State<SetupPage> {  

  Map<String, TextEditingController> controllerList = Map<String, TextEditingController>();
  int numOfControllers = 2;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    
    controllerList[MyStrings.sp_enlistmentdate] = TextEditingController();
    controllerList[MyStrings.sp_orddate] = TextEditingController();
    controllerList[MyStrings.sp_birthdate] = TextEditingController();
  }

  Future<Null> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));
    if (picked != null)
      setState(() {
        //selectedDate = picked;
        controller.text = DateFormat(MyStrings.sp_date_format).format(picked);
      });
  }

  String _default_validator(String s) {
    if (s.isEmpty) {
      return 'Required field';
    }
    return null;
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    for(var tec in controllerList.values)
      tec.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            // Add TextFormFields and ElevatedButton here.
            Text('Enlistment Date'),
            TextFormField(
              controller: controllerList[MyStrings.sp_enlistmentdate],
              enabled: false,
              validator: _default_validator,
            ),
            TextButton(
              onPressed: ()=>_selectDate(context, controllerList[MyStrings.sp_enlistmentdate]), child: Text('Select Date')
            ),
            Text('ORD Date'),
            TextFormField(
              controller: controllerList[MyStrings.sp_orddate],
              enabled: false,
              validator: _default_validator,
            ),
            TextButton(
              onPressed: ()=>_selectDate(context, controllerList[MyStrings.sp_orddate]), child: Text('Select Date')
            ),
            TextButton(
              onPressed: () { 
                if (_formKey.currentState.validate())
                {
                  submit_info();
                }
              }, 
              child: Text('Submit')
            ),
          ]
        )
        
      )
    );
  }

  void submit_info() async
  {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    //prefs.setBool('first_time?', false);
    prefs.setString(MyStrings.sp_enlistmentdate, controllerList[MyStrings.sp_enlistmentdate].value.text);
    prefs.setString(MyStrings.sp_orddate, controllerList[MyStrings.sp_orddate].value.text);

    Navigator.pushReplacement(context,  MaterialPageRoute(builder: (BuildContext context) => MainPageView()));
  }
}
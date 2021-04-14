import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../mystrings.dart';
import 'mainpageview.dart';

class SetupPage extends StatefulWidget {
  @override
  SetupPageState createState() => SetupPageState();
}

enum EnlistmentType { 
  m22, m24
}

class SetupPageState extends State<SetupPage> {  

  Map<String, TextEditingController> controllerList = Map<String, TextEditingController>();
  int numOfControllers = 2;
  final _formKey = GlobalKey<FormState>();
  EnlistmentType enlistmentType = EnlistmentType.m22;

  
  final PageController controller = PageController(initialPage: 0);

  List<Widget> pageList = [
    
  ];

  @override
  void initState() {
    super.initState();

    
    controllerList[MyStrings.sp_enlistmentdate] = TextEditingController();
    controllerList[MyStrings.sp_orddate] = TextEditingController();
    controllerList[MyStrings.sp_birthdate] = TextEditingController();
    controllerList[MyStrings.sp_name] = TextEditingController();
    controllerList[MyStrings.sp_popdate] = TextEditingController();
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
      body: Column(
        children: [
          Container(

          ),
          Form(
            key: _formKey,
            child: Column(
              children: [
                Text('Name'),
                TextFormField(
                  controller: controllerList[MyStrings.sp_name],
                ),
                Text('ORD Date'),
                TextFormField(
                  controller: controllerList[MyStrings.sp_orddate],
                ),
                TextButton(
                  child: Text('Select date'),
                  onPressed: () =>_selectDate(context, controllerList[MyStrings.sp_orddate]),
                ),
                Text('POP Date'),
                TextFormField(
                  controller: controllerList[MyStrings.sp_popdate],
                  
                ),
                TextButton(
                  child: Text('Select date'),
                  onPressed: () =>_selectDate(context, controllerList[MyStrings.sp_popdate]),
                ),
                Text('Service Term'),
                enlistmentRadios(),
              ],
            ),
            
          ),
          TextButton(
            child: Text('NEXT'),
            onPressed: () { 
              submit_info();
              //Navigator.pushReplacement(context,  MaterialPageRoute(builder: (BuildContext context) => MainPageView())); 
            },
          ),
          TextButton(
            child: Text('SKIP'),
            onPressed: () { 
              //submit_info();
              Navigator.pushReplacement(context,  MaterialPageRoute(builder: (BuildContext context) => MainPageView())); 
            },
          ),
        ],
      ),
    );
  }

  void submit_info() async
  {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    //prefs.setBool('first_time?', false);
    prefs.setString(MyStrings.sp_enlistmentdate, controllerList[MyStrings.sp_enlistmentdate].value.text);
    prefs.setString(MyStrings.sp_orddate, controllerList[MyStrings.sp_orddate].value.text);
    prefs.setString(MyStrings.sp_name, controllerList[MyStrings.sp_name].value.text);
    //prefs.setInt(MyStrings.sp_name, controllerList[MyStrings.sp_serviceterm].value.text);
    prefs.setInt(MyStrings.sp_serviceterm, enlistmentType == EnlistmentType.m22 ? 22 : 24);

    Navigator.pushReplacement(context,  MaterialPageRoute(builder: (BuildContext context) => MainPageView()));
  }

  Widget enlistmentRadios()
  {
    return IntrinsicHeight(
      child: Row(
        children: [
          Expanded(
            child: RadioListTile<EnlistmentType>(
            title: const Text('22 Months'),
            value: EnlistmentType.m22,
            groupValue: enlistmentType,
            onChanged: (EnlistmentType value) {
              setState(() {
                enlistmentType = value;
              });
            },
          ),
          ),
          VerticalDivider(
            width: 10,
            thickness: 2,
            indent: 15,
            endIndent: 15,
            color: Colors.grey,
          ),
          
          Expanded(
            child : RadioListTile<EnlistmentType>(
            title: const Text('24 Months'),
            value: EnlistmentType.m24,
            groupValue: enlistmentType,
            onChanged: (EnlistmentType value) {
              setState(() {
                enlistmentType = value;
              });
            },
          ),
          ),
          
          
        ],
      ),
    );
    
  }

  Widget page_name() {
    return Column(
      children: [
        TextField(
          controller: controllerList[MyStrings.sp_name],
        )
      ],
    );
  }
  Widget page_ord() {

  }
  Widget page_pop() {

  }
  Widget page_serviceterm(){

  }

}
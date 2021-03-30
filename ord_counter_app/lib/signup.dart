import 'dart:async';
//import 'package:attendance_app/screens/ORDdate.dart';
import "package:flutter/material.dart";
import 'package:intl/intl.dart';
import "package:lottie/lottie.dart";
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:ord_counter_app/setuppage.dart';
import 'mainpageview.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'mystrings.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignUp2 extends StatefulWidget {
  const SignUp2({Key key}) : super(key: key);
  @override
  _SignUp2State createState() => _SignUp2State();
}

class _SignUp2State extends State<SignUp2> with SingleTickerProviderStateMixin {
  //final formkey = GlobalKey<FormState>();
  //TextEditingController _nameEditingController = new TextEditingController();
  AnimationController _animationController;
  Animation _animation;
  final PageController _pageController = PageController();
  
  TextEditingController _nameEditingController = TextEditingController();
  final formkey = GlobalKey<FormState>();
  Map<String, DateTime> selectedDates = Map();
  List<String> keys = ['ord', 'pop'];
  List<String> etype = ['22 MTHS', '24 MTHS'];
  String etypeselected = '';

  int _currentpage = 0;

  bool nextEnabled = false;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 5000));
    _animationController.repeat(reverse: true);
    _animation = Tween(begin: 0.0, end: 1.0).animate(_animationController)
      ..addListener(() {
        setState(() {
          if (allvaluesfilled())
            nextEnabled = true;
          else
            nextEnabled = false;
        });
      });

    selectedDates[keys[0]] = DateTime.now();
    selectedDates[keys[1]] = DateTime.now();

  }

  bool allvaluesfilled()
  {
    return (etypeselected == etype[0] || etypeselected == etype[1]) &&
    (_nameEditingController.text != null);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.6,
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: 500,
                height: 500,
                child: Lottie.asset("assets/Humaaans/wizard.json"),
              ),
            ),
            Container(
              height: 120,
              //width: 300,
              child: PageView(
                controller: _pageController,
                physics: ClampingScrollPhysics(),
                children: [
                  Container(
                      //margin: const EdgeInsets.symmetric(horizontal: 100),
                      alignment: Alignment.center,
                      child: build_name_field(context)),
                  build_cupertino_datepicker("POP Date", keys[1]),
                  build_cupertino_datepicker("ORD Date", keys[0]),
                  serviceType(context),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: ElevatedButton.icon(
                label: Text("Next"),
                icon: Icon(Icons.input),
                onPressed: nextEnabled == false ? null : () {
                  if (checkinfo())
                    submit_info();
                },

              ),
            ),
          ],
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(_animation.value, _animation.value),
            end: Alignment(_animation.value, _animation.value - 1),
            colors: [
              Colors.blue[100],
              Colors.blue[400],
            ],
          ),
        ),
      ),
    );
  }

  bool checkinfo()
  {
    bool ret = selectedDates[keys[0]].isAfter(selectedDates[keys[1]]);
    //print(keys[0] + ' is ' + (ret?'after ':'before ') + keys[1]);
    if (ret == false)
    {
      Fluttertoast.showToast(
        msg: "Are you sure you ORD before you POP?",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        //backgroundColor: Colors.,
        //textColor: Colors.white,
        fontSize: 16.0
      );
    }
    return ret;
  }

  void submit_info() async
  {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    //prefs.setBool('first_time?', false);
    //prefs.setString(MyStrings.sp_enlistmentdate, controllerList[MyStrings.sp_enlistmentdate].value.text);
    prefs.setString(MyStrings.sp_orddate, DateFormat(MyStrings.sp_date_format).format(selectedDates[keys[0]]));
    prefs.setString(MyStrings.sp_popdate, DateFormat(MyStrings.sp_date_format).format(selectedDates[keys[1]]));
    prefs.setString(MyStrings.sp_name, _nameEditingController.text);
    //prefs.setInt(MyStrings.sp_name, controllerList[MyStrings.sp_serviceterm].value.text);
    prefs.setInt(MyStrings.sp_serviceterm, etypeselected == etype[0] ? 22 : 24);

    Navigator.pushReplacement(context,  MaterialPageRoute(builder: (BuildContext context) => MainPageView()));
  }


  Widget build_name_field(BuildContext context) {
    return Form(
      key: formkey,
      child: TextFormField(
          validator: (val) {
            return val.isEmpty ? "Please provide a name" : null;
          },
          controller: _nameEditingController,
          decoration: InputDecoration(
            hintText: 'Your Name',
            //hintStyle: nameTextstyle,
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.white,
                ),
                borderRadius: BorderRadius.all(Radius.circular(40))),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.white,
              ),
            ),
          ),
          textAlign: TextAlign.center,
          //style: nameTextstyle
      ),
    );
  }

  Widget build_cupertino_datepicker(String date, String key) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0),
      child: Column(
        children: [
          Expanded(
              child: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
              date, 
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold
              ),
            ),
          )),
          Container(
            height: 80,
            child: CupertinoDatePicker(
              backgroundColor: Colors.transparent,
              initialDateTime: selectedDates[key],
              mode: CupertinoDatePickerMode.date,
              onDateTimeChanged: (DateTime newdate) {
                selectedDates[key]= newdate;
              },
              minimumYear: DateTime.now().year - 5,
              maximumYear: DateTime.now().year + 10,
              
            ),
          ),
        ],
      ),
    );
  }
  
  Widget serviceType(context) {
    return CupertinoPageScaffold(
      backgroundColor: Colors.transparent,
      child: Center(
        child: CupertinoButton(
          onPressed: () {
            showCupertinoModalPopup(
              context: context,
              builder: (BuildContext context) => CupertinoActionSheet(
                title: Text('Service Term\n' + etypeselected),
                message: const Text('Please select your length of service'),
                actions: [
                  CupertinoActionSheetAction(
                    child: Text(
                      etype[0],
                      //style: nameTextstyle,
                    ),
                    onPressed: () {
                      etypeselected = etype[0];
                      Navigator.pop(context);
                    },
                  ),
                  CupertinoActionSheetAction(
                    child: Text(
                      etype[1],
                      //style: nameTextstyle,
                    ),
                    onPressed: () {
                      etypeselected = etype[1];
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            );
          },
          child: Text(
            'ServiceTerm\n' + etypeselected,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 36,
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: Theme.of(context).textTheme.bodyText1.fontFamily,
              ),
          ),
          
        ),
      ),
    );
  }

}

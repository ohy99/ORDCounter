import 'dart:async';
//import 'package:attendance_app/screens/ORDdate.dart';
import "package:flutter/material.dart";
import 'package:intl/intl.dart';
import "package:lottie/lottie.dart";
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:ord_counter_app/riveanima.dart';
import 'package:ord_counter_app/setuppage.dart';
import 'mainpageview.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'mystrings.dart';

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

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 5000));
    _animationController.repeat(reverse: true);
    _animation = Tween(begin: 0.0, end: 1.0).animate(_animationController)
      ..addListener(() {
        setState(() {});
      });
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
                    width: 500, height: 500, child: MyRiveAnimation())),
            Container(
              height: 120,
              //width: 300,
              child: PageView(
                controller: _pageController,
                physics: ClampingScrollPhysics(),
                children: [
                  Container(
                      margin: const EdgeInsets.symmetric(horizontal: 100),
                      alignment: Alignment.center,
                      child: build_name_field(context)),
                  build_cupertino_datepicker("POP Date", keys[0]),
                  build_cupertino_datepicker("ORD Date", keys[1]),
                  serviceType(context),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: ElevatedButton.icon(
                label: Text("Next"),
                icon: Icon(Icons.input),
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => MainPageView()));
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
              Colors.brown[600],
              Colors.brown[400],
            ],
          ),
        ),
      ),
    );
  }

  void submit_info() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    //prefs.setBool('first_time?', false);
    //prefs.setString(MyStrings.sp_enlistmentdate, controllerList[MyStrings.sp_enlistmentdate].value.text);
    prefs.setString(MyStrings.sp_orddate,
        DateFormat(MyStrings.sp_date_format).format(selectedDates[keys[0]]));
    prefs.setString(MyStrings.sp_name, _nameEditingController.text);
    //prefs.setInt(MyStrings.sp_name, controllerList[MyStrings.sp_serviceterm].value.text);
    prefs.setInt(MyStrings.sp_serviceterm, etypeselected == etype[0] ? 22 : 24);

    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => MainPageView()));
  }

  Widget build_name_field(BuildContext context) {
    return Form(
      key: formkey,
      child: TextFormField(
          validator: (val) {
            return val.isEmpty ? "Please provide a name" : null;
          },
          controller: _nameEditingController,
          decoration: textFieldInputDecoration("Your Name"),
          textAlign: TextAlign.center,
          style: nameTextstyle),
    );
  }

  Widget build_cupertino_datepicker(String date, String key) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 80),
      child: Column(
        children: [
          Expanded(
              child: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(date, style: nameTextstyle),
          )),
          Container(
            height: 80,
            child: CupertinoDatePicker(
              backgroundColor: Colors.transparent,
              initialDateTime: DateTime.now(),
              mode: CupertinoDatePickerMode.date,
              onDateTimeChanged: (DateTime newdate) {
                selectedDates[key] = newdate;
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
                title: const Text('Service Term'),
                message: const Text('Please select your length of service'),
                actions: [
                  CupertinoActionSheetAction(
                    child: Text(
                      etype[0],
                      style: nameTextstyle,
                    ),
                    onPressed: () {
                      etypeselected = etype[0];
                      Navigator.pop(context);
                    },
                  ),
                  CupertinoActionSheetAction(
                    child: Text(
                      etype[1],
                      style: nameTextstyle,
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
            'ServiceTerm',
            style: GoogleFonts.gloriaHallelujah(
              fontSize: 36,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

var nameTextstyle =
    GoogleFonts.gloriaHallelujah(fontSize: 16, fontWeight: FontWeight.w600);

InputDecoration textFieldInputDecoration(String hintText) {
  return InputDecoration(
    hintText: hintText,
    hintStyle: nameTextstyle,
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
  );
}
